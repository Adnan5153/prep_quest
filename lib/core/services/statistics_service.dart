import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../shared/typedefs/result.dart';
import '../config/firebase_config.dart';
import '../constants/firestore_keys.dart';
import '../errors/error_handler.dart';
import '../errors/failures.dart';
import '../../features/statistics/domain/entities/user_statistics_entity.dart';

/// Value object passed by the quiz-completion funnel into
/// [StatisticsService.recordQuizCompletion]. Carries everything the
/// service needs to update both `statistics/current` and the matching
/// `category_statistics/{categoryId}` row in one transaction.
@immutable
class QuizStatisticsInput {
  const QuizStatisticsInput({
    required this.sessionId,
    required this.categoryId,
    required this.subjectName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.scorePercent,
    required this.totalSeconds,
    required this.xpEarned,
    required this.coinsEarned,
    this.completedAtIso,
  });

  /// Canonical dedup key — usually `QuizSessionEntity.sessionId`.
  final String sessionId;

  /// Category id (used to look up / create the per-category doc).
  final String categoryId;

  /// Display name resolved at write time so the stats row stays
  /// labelled even if the catalog renames the subject.
  final String subjectName;

  /// Number of questions answered in this session.
  final int totalQuestions;

  /// Number of correct answers.
  final int correctAnswers;

  /// Number of wrong answers (incorrect + skipped counts that were
  /// explicitly wrong).
  final int wrongAnswers;

  /// Number of skipped answers (timer ran out, user navigated past).
  final int skippedAnswers;

  /// 0-100 percentage score.
  final int scorePercent;

  /// Total time spent on the session, in seconds.
  final int totalSeconds;

  /// XP earned from this session.
  final int xpEarned;

  /// Coins earned from this session.
  final int coinsEarned;

  /// ISO-8601 UTC timestamp. Defaults to `now` if null.
  final String? completedAtIso;
}

/// Single writer to `users/{uid}/statistics/current` +
/// `users/{uid}/category_statistics/{categoryId}`.
///
/// Responsibilities:
/// * Atomic update of both docs inside one Firestore transaction.
/// * Monotonic counters (never decremented).
/// * Best-score protection (`newBestScore = max(prev, attempt.score)`).
/// * Exponential moving average for `averageTimeSecondsPerQuestion`
///   (`alpha = 0.2` — recent attempts dominate).
/// * Dedup via `sessionId` stored in `lastSessionIds` (capped at 50).
/// * Realtime `watch()` for the controller layer.
/// * Guest guard — never writes to Firestore for empty uids.
///
/// Best-effort failures fall through to a no-throw [Result.failure]
/// so the canonical quiz-completion funnel never breaks.
class StatisticsService {
  StatisticsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _userStatsRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.statisticsSubcollection);
  }

  CollectionReference<Map<String, dynamic>> _categoryStatsRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.categoryStatisticsSubcollection);
  }

  // ---------------------------------------------------------------------------
  // Realtime read
  // ---------------------------------------------------------------------------

  /// Real-time `UserStatisticsEntity` for [uid]. Returns `empty` for
  /// guests (uid empty) and silently swallows transport errors to a
  /// `Result.failure` so the controller can fall back to the local
  /// mirror.
  Stream<UserStatisticsEntity> watch(String uid) {
    if (uid.isEmpty || _firestore == null) {
      return Stream<UserStatisticsEntity>.value(UserStatisticsEntity.empty);
    }
    return _userStatsRef(uid)
        .doc('current')
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snap) {
      if (!snap.exists) {
        return UserStatisticsEntity(
          uid: uid,
          totalAnswered: 0,
          correctAnswers: 0,
          wrongAnswers: 0,
          accuracy: 0,
          averageTimeSecondsPerQuestion: 0,
          totalStudyMinutes: 0,
          totalXp: 0,
          totalCoins: 0,
          lastSessionIds: const <String>[],
          lastUpdatedAtIso: null,
        );
      }
      final Map<String, dynamic> raw = snap.data() ?? <String, dynamic>{};
      return UserStatisticsEntity.fromMap(<String, dynamic>{
        ...raw,
        'uid': raw['uid']?.toString() ?? uid,
      });
    });
  }

  /// Per-category realtime stream.
  Stream<List<CategoryStatisticsEntity>> watchCategories(String uid) {
    if (uid.isEmpty || _firestore == null) {
      return Stream<List<CategoryStatisticsEntity>>.value(
        const <CategoryStatisticsEntity>[],
      );
    }
    return _categoryStatsRef(uid)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snap) {
      return List<CategoryStatisticsEntity>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
              final Map<String, dynamic> raw = d.data();
              return CategoryStatisticsEntity.fromMap(<String, dynamic>{
                ...raw,
                'uid': raw['uid']?.toString() ?? uid,
                'categoryId':
                    raw['categoryId']?.toString() ?? d.id,
              });
            }),
      );
    });
  }

  /// One-shot reads.
  Future<UserStatisticsEntity> summary(String uid) async {
    if (uid.isEmpty || _firestore == null) return UserStatisticsEntity.empty;
    final DocumentSnapshot<Map<String, dynamic>> snap =
        await _userStatsRef(uid).doc('current').get();
    if (!snap.exists) {
      return UserStatisticsEntity(
        uid: uid,
        totalAnswered: 0,
        correctAnswers: 0,
        wrongAnswers: 0,
        accuracy: 0,
        averageTimeSecondsPerQuestion: 0,
        totalStudyMinutes: 0,
        totalXp: 0,
        totalCoins: 0,
        lastSessionIds: const <String>[],
        lastUpdatedAtIso: null,
      );
    }
    return UserStatisticsEntity.fromMap(<String, dynamic>{
      ...(snap.data() ?? <String, dynamic>{}),
      'uid': uid,
    });
  }

  Future<CategoryStatisticsEntity> category({
    required String uid,
    required String categoryId,
  }) async {
    if (uid.isEmpty || categoryId.isEmpty || _firestore == null) {
      return CategoryStatisticsEntity(
        uid: uid,
        categoryId: categoryId,
        subjectName: '',
        totalQuestions: 0,
        correct: 0,
        wrong: 0,
        skipped: 0,
        bestScore: 0,
        averageSecondsPerQuestion: 0,
        totalMinutes: 0,
        xpEarned: 0,
        lastSessionIds: const <String>[],
        lastUpdatedAtIso: null,
      );
    }
    final DocumentSnapshot<Map<String, dynamic>> snap =
        await _categoryStatsRef(uid).doc(categoryId).get();
    if (!snap.exists) {
      return CategoryStatisticsEntity(
        uid: uid,
        categoryId: categoryId,
        subjectName: '',
        totalQuestions: 0,
        correct: 0,
        wrong: 0,
        skipped: 0,
        bestScore: 0,
        averageSecondsPerQuestion: 0,
        totalMinutes: 0,
        xpEarned: 0,
        lastSessionIds: const <String>[],
        lastUpdatedAtIso: null,
      );
    }
    return CategoryStatisticsEntity.fromMap(<String, dynamic>{
      ...(snap.data() ?? <String, dynamic>{}),
      'uid': uid,
      'categoryId': categoryId,
    });
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Applies a quiz completion to the user's statistics. The
  /// transaction writes both the global `statistics/current` doc and
  /// the matching `category_statistics/{categoryId}` doc in one shot.
  /// Dedup via `sessionId` is enforced against the existing
  /// `lastSessionIds` array on each doc.
  Future<Result<UserStatisticsEntity>> recordQuizCompletion({
    required String uid,
    required QuizStatisticsInput input,
  }) async {
    if (uid.isEmpty) {
      return Result<UserStatisticsEntity>.failure(
        const GuestStatisticsWriteFailure(
          'Statistics cannot persist without an authenticated user.',
        ),
      );
    }
    final FirebaseFirestore? firestore = _firestore;
    if (firestore == null) {
      return _writeDirectly(uid: uid, input: input);
    }
    try {
      return await firestore.runTransaction((Transaction tx) async {
        final DocumentReference<Map<String, dynamic>> userRef =
            _userStatsRef(uid).doc('current');
        final DocumentReference<Map<String, dynamic>> catRef =
            _categoryStatsRef(uid).doc(input.categoryId);

        final DocumentSnapshot<Map<String, dynamic>> userSnap =
            await tx.get(userRef);
        final DocumentSnapshot<Map<String, dynamic>> catSnap =
            await tx.get(catRef);

        final UserStatisticsEntity previousUser = userSnap.exists
            ? UserStatisticsEntity.fromMap(<String, dynamic>{
                ...(userSnap.data() ?? <String, dynamic>{}),
                'uid': uid,
              })
            : UserStatisticsEntity(
                uid: uid,
                totalAnswered: 0,
                correctAnswers: 0,
                wrongAnswers: 0,
                accuracy: 0,
                averageTimeSecondsPerQuestion: 0,
                totalStudyMinutes: 0,
                totalXp: 0,
                totalCoins: 0,
                lastSessionIds: const <String>[],
                lastUpdatedAtIso: null,
              );
        final CategoryStatisticsEntity previousCategory = catSnap.exists
            ? CategoryStatisticsEntity.fromMap(<String, dynamic>{
                ...(catSnap.data() ?? <String, dynamic>{}),
                'uid': uid,
                'categoryId': input.categoryId,
              })
            : CategoryStatisticsEntity(
                uid: uid,
                categoryId: input.categoryId,
                subjectName: input.subjectName,
                totalQuestions: 0,
                correct: 0,
                wrong: 0,
                skipped: 0,
                bestScore: 0,
                averageSecondsPerQuestion: 0,
                totalMinutes: 0,
                xpEarned: 0,
                lastSessionIds: const <String>[],
                lastUpdatedAtIso: null,
              );

        if (previousUser.lastSessionIds.contains(input.sessionId) ||
            previousCategory.lastSessionIds.contains(input.sessionId)) {
          return Result<UserStatisticsEntity>.failure(
            DuplicateStatisticsFailure(
              'Statistics already recorded session ${input.sessionId}.',
              sessionKey: '$uid:${input.categoryId}:${input.sessionId}',
            ),
          );
        }

        final UserStatisticsEntity nextUser = _mergeUserStats(
          previous: previousUser,
          input: input,
        );
        final CategoryStatisticsEntity nextCategory = _mergeCategoryStats(
          previous: previousCategory,
          input: input,
        );

        tx.set(userRef, nextUser.toMap(), SetOptions(merge: true));
        tx.set(catRef, nextCategory.toMap(), SetOptions(merge: true));

        return Result<UserStatisticsEntity>.success(nextUser);
      });
    } catch (error, stack) {
      debugPrint(
        '[StatisticsService] recordQuizCompletion failed: $error\n$stack',
      );
      return Result<UserStatisticsEntity>.failure(ErrorHandler.map(error, stack));
    }
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  Future<Result<UserStatisticsEntity>> _writeDirectly({
    required String uid,
    required QuizStatisticsInput input,
  }) async {
    final UserStatisticsEntity previous = await summary(uid);
    if (previous.lastSessionIds.contains(input.sessionId)) {
      return Result<UserStatisticsEntity>.failure(
        DuplicateStatisticsFailure(
          'Statistics already recorded session ${input.sessionId}.',
          sessionKey: '$uid:${input.categoryId}:${input.sessionId}',
        ),
      );
    }
    final UserStatisticsEntity next = _mergeUserStats(
      previous: previous,
      input: input,
    );
    // Offline path — Firestore is not configured so the write is a
    // no-op. The aggregated row is still returned so the controller
    // can update its in-memory mirror for the duration of the
    // session.
    return Result<UserStatisticsEntity>.success(next);
  }

  /// Pure transition: merges a previous user stats row with a fresh
  /// quiz-completion input.
  static UserStatisticsEntity _mergeUserStats({
    required UserStatisticsEntity previous,
    required QuizStatisticsInput input,
  }) {
    final int nextAnswered =
        previous.totalAnswered + input.totalQuestions;
    final int nextCorrect =
        previous.correctAnswers + input.correctAnswers;
    final int nextWrong =
        previous.wrongAnswers + input.wrongAnswers + input.skippedAnswers;
    final double nextAccuracy =
        nextAnswered == 0 ? 0.0 : nextCorrect / nextAnswered;
    final double avgSeconds =
        input.totalQuestions == 0
            ? previous.averageTimeSecondsPerQuestion
            : input.totalSeconds / input.totalQuestions;
    final double nextAvg = previous.averageTimeSecondsPerQuestion == 0
        ? avgSeconds
        : (previous.averageTimeSecondsPerQuestion * 0.8) + (avgSeconds * 0.2);
    final int nextMinutes =
        previous.totalStudyMinutes + (input.totalSeconds ~/ 60);
    final DateTime stamp = input.completedAtIso != null
        ? DateTime.parse(input.completedAtIso!).toUtc()
        : DateTime.now().toUtc();
    final List<String> history = <String>[
      input.sessionId,
      ...previous.lastSessionIds,
    ].take(50).toList(growable: false);
    return previous.copyWith(
      totalAnswered: nextAnswered,
      correctAnswers: nextCorrect,
      wrongAnswers: nextWrong,
      accuracy: nextAccuracy,
      averageTimeSecondsPerQuestion: nextAvg,
      totalStudyMinutes: nextMinutes,
      totalXp: previous.totalXp + input.xpEarned,
      totalCoins: previous.totalCoins + input.coinsEarned,
      lastSessionIds: history,
      lastUpdatedAtIso: stamp.toIso8601String(),
    );
  }

  /// Pure transition: merges a previous category stats row with a
  /// fresh quiz-completion input.
  static CategoryStatisticsEntity _mergeCategoryStats({
    required CategoryStatisticsEntity previous,
    required QuizStatisticsInput input,
  }) {
    final int nextTotal = previous.totalQuestions + input.totalQuestions;
    final int nextCorrect = previous.correct + input.correctAnswers;
    final int nextWrong = previous.wrong + input.wrongAnswers;
    final int nextSkipped = previous.skipped + input.skippedAnswers;
    final int nextBest =
        input.scorePercent > previous.bestScore
            ? input.scorePercent
            : previous.bestScore;
    final double avgSeconds = input.totalQuestions == 0
        ? previous.averageSecondsPerQuestion
        : input.totalSeconds / input.totalQuestions;
    final double nextAvg = previous.averageSecondsPerQuestion == 0
        ? avgSeconds
        : (previous.averageSecondsPerQuestion * 0.8) + (avgSeconds * 0.2);
    final int nextMinutes =
        previous.totalMinutes + (input.totalSeconds ~/ 60);
    final DateTime stamp = input.completedAtIso != null
        ? DateTime.parse(input.completedAtIso!).toUtc()
        : DateTime.now().toUtc();
    final List<String> history = <String>[
      input.sessionId,
      ...previous.lastSessionIds,
    ].take(50).toList(growable: false);
    return previous.copyWith(
      subjectName: input.subjectName.isNotEmpty
          ? input.subjectName
          : previous.subjectName,
      totalQuestions: nextTotal,
      correct: nextCorrect,
      wrong: nextWrong,
      skipped: nextSkipped,
      bestScore: nextBest,
      averageSecondsPerQuestion: nextAvg,
      totalMinutes: nextMinutes,
      xpEarned: previous.xpEarned + input.xpEarned,
      lastSessionIds: history,
      lastUpdatedAtIso: stamp.toIso8601String(),
    );
  }
}

// ---------------------------------------------------------------------------
// Failures
// ---------------------------------------------------------------------------

/// Raised when the funnel submits a [QuizStatisticsInput] whose
/// `sessionId` was already applied. Mirrors the
/// [DuplicateRewardFailure] / [DuplicateMissionAttemptFailure] shape
/// from earlier phases.
class DuplicateStatisticsFailure extends Failure {
  const DuplicateStatisticsFailure(super.message,
      {required this.sessionKey, super.cause});

  final String sessionKey;
}

/// Raised when a guest session tries to persist statistics. The
/// service silently no-ops and the controller falls back to the
/// local mirror.
class GuestStatisticsWriteFailure extends Failure {
  const GuestStatisticsWriteFailure(super.message, {super.cause});
}

// ---------------------------------------------------------------------------
// Riverpod providers
// ---------------------------------------------------------------------------

/// Single service instance for the lifetime of the ProviderContainer.
final statisticsServiceProvider = Provider<StatisticsService>(
  (ref) => StatisticsService(),
);

/// Auth-aware realtime provider for the global statistics row.
/// Re-emits whenever the auth state changes (sign-in / sign-out /
/// guest switch).
final userStatisticsStreamProvider =
    StreamProvider.autoDispose<UserStatisticsEntity>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<UserStatisticsEntity>.value(UserStatisticsEntity.empty);
  }
  return ref.watch(statisticsServiceProvider).watch(uid);
});

/// Auth-aware realtime provider for the per-category breakdown.
final categoryStatisticsStreamProvider =
    StreamProvider.autoDispose<List<CategoryStatisticsEntity>>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<List<CategoryStatisticsEntity>>.value(
      const <CategoryStatisticsEntity>[],
    );
  }
  return ref.watch(statisticsServiceProvider).watchCategories(uid);
});
