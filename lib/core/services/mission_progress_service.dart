import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/gamification/data/datasources/mission_progress_remote_datasource.dart';
import '../../features/gamification/domain/entities/mission_entity.dart';
import '../../features/gamification/domain/entities/mission_summary_entity.dart';
import '../../features/gamification/domain/repositories/mission_progress_repository.dart';
import '../../shared/typedefs/result.dart';
import '../config/firebase_config.dart';
import '../errors/error_handler.dart';
import '../errors/failures.dart';
import 'mission_progress_attempt.dart';

/// Single writer for `users/{uid}/mission_progress/{missionId}`.
///
/// Responsibilities:
/// * Guest detection — never writes to Firestore for unauthenticated
///   users, but the in-memory profile still reflects the new state.
/// * Dedup via `sessionId` — replays and offline retries cannot
///   double-credit stars or completions.
/// * Monotonic stars + best-score protection (`newBestScore =
///   max(prevBestScore, attempt.score)`).
/// * Completion-status transitions (`unlocked` → `started` →
///   `completed` → `perfect`).
/// * Realtime listener for the controller layer.
///
/// Best-effort failures fall through to the local mirror update so
/// the UI never goes stale; the repository returns the canonical
/// post-write summary so callers can `copyWith` it onto their state.
class MissionProgressService {
  MissionProgressService({
    MissionProgressRemoteDataSource? remote,
  }) : _remote = remote ?? _defaultRemote();

  final MissionProgressRemoteDataSource _remote;

  /// Selects the right datasource based on whether Firebase is
  /// bootstrapped. The fallback is always the in-memory implementation
  /// so unit tests and the offline path stay deterministic.
  static MissionProgressRemoteDataSource _defaultRemote() {
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore != null) {
      return FirestoreMissionProgressRemoteDataSource(firestore);
    }
    return InMemoryMissionProgressRemoteDataSource();
  }

  /// Reads the live stream for [uid]. Returns an empty stream when
  /// the user is a guest (callers can fall back to a local mirror).
  Stream<List<MissionSummaryEntity>> watch(String uid) {
    if (uid.isEmpty) {
      return Stream<List<MissionSummaryEntity>>.value(
        const <MissionSummaryEntity>[],
      );
    }
    return _remote.watch(uid);
  }

  Future<List<MissionSummaryEntity>> list(String uid) async {
    if (uid.isEmpty) {
      return Future<List<MissionSummaryEntity>>.value(
        const <MissionSummaryEntity>[],
      );
    }
    return _remote.list(uid);
  }

  Future<MissionSummaryEntity> summary({
    required String uid,
    required String missionId,
  }) async {
    if (uid.isEmpty) {
      return MissionSummaryEntity(
        uid: '',
        missionId: missionId,
        stars: 0,
        bestScore: 0,
        completionStatus: MissionCompletionStatus.unlocked,
        completionTimestampsIso: const <String>[],
        totalCompleted: 0,
      );
    }
    return (await _remote.read(uid: uid, missionId: missionId)) ??
        MissionSummaryEntity(
          uid: uid,
          missionId: missionId,
          stars: 0,
          bestScore: 0,
          completionStatus: MissionCompletionStatus.unlocked,
          completionTimestampsIso: const <String>[],
          totalCompleted: 0,
        );
  }

  /// Applies an attempt to the user's mission summary.
  ///
  /// Returns a [Result] so the funnel can react to dedup hits
  /// without an exception: a duplicate `sessionId` resolves to
  /// [DuplicateMissionAttemptFailure] but never throws.
  Future<Result<MissionSummaryEntity>> recordAttempt({
    required String uid,
    required MissionEntity mission,
    required MissionProgressAttempt attempt,
  }) async {
    if (uid.isEmpty) {
      return Result.failure(
        const GuestMissionWriteFailure(
          'Mission progress cannot persist without an authenticated user.',
        ),
      );
    }
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    try {
      if (firestore == null) {
        // Non-Firebase environment — fall back to a direct write on
        // the in-memory datasource. Dedup still applies.
        return _writeDirectly(uid: uid, mission: mission, attempt: attempt);
      }
      return await _writeTransactionally(
        firestore: firestore,
        uid: uid,
        mission: mission,
        attempt: attempt,
      );
    } catch (error, stack) {
      debugPrint(
        '[MissionProgressService] recordAttempt failed: $error\n$stack',
      );
      return Result.failure(ErrorHandler.map(error, stack));
    }
  }

  /// Marks the rewards for a mission as claimed. Idempotent.
  Future<Result<MissionSummaryEntity>> markRewardsClaimed({
    required String uid,
    required String missionId,
  }) async {
    if (uid.isEmpty) {
      return Result.failure(
        const GuestMissionWriteFailure(
          'Mission claim cannot persist without an authenticated user.',
        ),
      );
    }
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) {
      final MissionSummaryEntity current =
          await summary(uid: uid, missionId: missionId);
      final MissionSummaryEntity updated = current.copyWith(
        rewardsClaimed: true,
        lastUpdatedAtIso: _nowIso(),
      );
      await _remote.write(updated);
      return Result.success(updated);
    }
    final DocumentReference<Map<String, dynamic>> ref = _remote.referenceFor(
      uid: uid,
      missionId: missionId,
    );
    return firestore.runTransaction((Transaction tx) async {
      final DocumentSnapshot<Map<String, dynamic>> snap = await tx.get(ref);
      final MissionSummaryEntity existing = snap.exists
          ? MissionSummaryEntity.fromMap(<String, dynamic>{
              ...(snap.data() ?? <String, dynamic>{}),
              'uid': uid,
              'missionId': missionId,
            })
          : MissionSummaryEntity(
              uid: uid,
              missionId: missionId,
              stars: 0,
              bestScore: 0,
              completionStatus: MissionCompletionStatus.unlocked,
              completionTimestampsIso: const <String>[],
              totalCompleted: 0,
            );
      final MissionSummaryEntity updated = existing.copyWith(
        rewardsClaimed: true,
        lastUpdatedAtIso: _nowIso(),
      );
      tx.set(ref, updated.toMap(), SetOptions(merge: true));
      return Result<MissionSummaryEntity>.success(updated);
    }).catchError((Object error, StackTrace stack) {
      return Result<MissionSummaryEntity>.failure(
        ErrorHandler.map(error, stack),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  Future<Result<MissionSummaryEntity>> _writeTransactionally({
    required FirebaseFirestore firestore,
    required String uid,
    required MissionEntity mission,
    required MissionProgressAttempt attempt,
  }) async {
    final DocumentReference<Map<String, dynamic>> ref = _remote.referenceFor(
      uid: uid,
      missionId: mission.id,
    );
    return firestore.runTransaction((Transaction tx) async {
      final DocumentSnapshot<Map<String, dynamic>> snap = await tx.get(ref);
      final MissionSummaryEntity existing = snap.exists
          ? MissionSummaryEntity.fromMap(<String, dynamic>{
              ...(snap.data() ?? <String, dynamic>{}),
              'uid': uid,
              'missionId': mission.id,
            })
          : MissionSummaryEntity(
              uid: uid,
              missionId: mission.id,
              stars: 0,
              bestScore: 0,
              completionStatus: MissionCompletionStatus.unlocked,
              completionTimestampsIso: const <String>[],
              totalCompleted: 0,
            );
      if (existing.completionTimestampsIso.contains(attempt.sessionId)) {
        return Result<MissionSummaryEntity>.failure(
          DuplicateMissionAttemptFailure(
            'Mission ${mission.id} already recorded session ${attempt.sessionId}.',
            sessionKey: '$uid:${mission.id}:${attempt.sessionId}',
          ),
        );
      }
      final MissionSummaryEntity updated = _mergeAttempt(
        previous: existing,
        mission: mission,
        attempt: attempt,
      );
      tx.set(ref, updated.toMap(), SetOptions(merge: true));
      return Result<MissionSummaryEntity>.success(updated);
    }).catchError((Object error, StackTrace stack) {
      return Result<MissionSummaryEntity>.failure(
        ErrorHandler.map(error, stack),
      );
    });
  }

  Future<Result<MissionSummaryEntity>> _writeDirectly({
    required String uid,
    required MissionEntity mission,
    required MissionProgressAttempt attempt,
  }) async {
    final MissionSummaryEntity existing =
        await summary(uid: uid, missionId: mission.id);
    if (existing.completionTimestampsIso.contains(attempt.sessionId)) {
      return Result.failure(
        DuplicateMissionAttemptFailure(
          'Mission ${mission.id} already recorded session ${attempt.sessionId}.',
          sessionKey: '$uid:${mission.id}:${attempt.sessionId}',
        ),
      );
    }
    final MissionSummaryEntity updated = _mergeAttempt(
      previous: existing,
      mission: mission,
      attempt: attempt,
    );
    await _remote.write(updated);
    return Result.success(updated);
  }

  /// Pure function — merges a previous summary with a new attempt.
  /// Exposed as a static so unit tests can exercise the transitions
  /// without the Firestore runtime.
  static MissionSummaryEntity _mergeAttempt({
    required MissionSummaryEntity previous,
    required MissionEntity mission,
    required MissionProgressAttempt attempt,
  }) {
    final int deltaStars = _starsForAttempt(mission: mission, attempt: attempt);
    final int newStars = previous.stars + deltaStars;
    final int newBestScore =
        attempt.score > previous.bestScore ? attempt.score : previous.bestScore;
    final MissionCompletionStatus nextStatus = _statusForAttempt(
      previous: previous.completionStatus,
      attempt: attempt,
    );
    final DateTime stamp = attempt.completedAtIso != null
        ? DateTime.parse(attempt.completedAtIso!).toUtc()
        : DateTime.now().toUtc();
    final List<String> history = <String>[
      stamp.toIso8601String(),
      ...previous.completionTimestampsIso,
    ].take(50).toList(growable: false);
    final int totalCompleted = attempt.achievedGoal
        ? previous.totalCompleted + 1
        : previous.totalCompleted;
    return previous.copyWith(
      stars: newStars,
      bestScore: newBestScore,
      completionStatus: nextStatus,
      completionTimestampsIso: history,
      totalCompleted: totalCompleted,
      lastUpdatedAtIso: stamp.toIso8601String(),
    );
  }

  /// Awards stars based on the attempt's quality. Perfect score
  /// grants the most stars; partial credit grants a smaller bonus.
  static int _starsForAttempt({
    required MissionEntity mission,
    required MissionProgressAttempt attempt,
  }) {
    if (!attempt.achievedGoal) return 0;
    if (attempt.score >= 100) return 3;
    if (attempt.score >= 80) return 2;
    return 1;
  }

  /// Walks the lifecycle: any prior non-locked state is preserved
  /// unless the new attempt upgrades it. `perfect` is sticky.
  static MissionCompletionStatus _statusForAttempt({
    required MissionCompletionStatus previous,
    required MissionProgressAttempt attempt,
  }) {
    if (!attempt.achievedGoal) {
      if (previous == MissionCompletionStatus.locked) {
        return MissionCompletionStatus.unlocked;
      }
      return previous == MissionCompletionStatus.locked
          ? MissionCompletionStatus.started
          : previous;
    }
    if (attempt.score >= 100) return MissionCompletionStatus.perfect;
    if (previous == MissionCompletionStatus.perfect) {
      return MissionCompletionStatus.perfect;
    }
    return MissionCompletionStatus.completed;
  }

  String _nowIso() => DateTime.now().toUtc().toIso8601String();
}

/// Provider used by Riverpod. Selects the Firestore datasource when
/// available, otherwise the in-memory fallback.
final missionProgressServiceProvider = Provider<MissionProgressService>(
  (ref) => MissionProgressService(),
);

/// Convenience: stream provider that surfaces the live
/// `MissionProgressBundle` for the currently authenticated user. The
/// stream re-emits whenever the auth state changes (sign-in /
/// sign-out / guest switch).
final missionProgressBundleProvider =
    StreamProvider.autoDispose<MissionProgressBundle>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<MissionProgressBundle>.value(MissionProgressBundle.empty);
  }
  final MissionProgressService service =
      ref.watch(missionProgressServiceProvider);
  return service.watch(uid).map(_bundleFrom);
});

MissionProgressBundle _bundleFrom(List<MissionSummaryEntity> rows) {
  if (rows.isEmpty) return MissionProgressBundle.empty;
  int totalCompleted = 0;
  int totalStars = 0;
  int bestScoreOverall = 0;
  for (final MissionSummaryEntity s in rows) {
    totalCompleted += s.totalCompleted;
    totalStars += s.stars;
    if (s.bestScore > bestScoreOverall) bestScoreOverall = s.bestScore;
  }
  return MissionProgressBundle(
    summaries: List<MissionSummaryEntity>.unmodifiable(rows),
    totalCompleted: totalCompleted,
    totalStars: totalStars,
    bestScoreOverall: bestScoreOverall,
  );
}
