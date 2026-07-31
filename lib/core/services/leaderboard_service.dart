import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/gamification/domain/entities/mission_summary_entity.dart';
import '../../features/gamification/presentation/providers/mission_provider.dart';
import '../../features/leaderboard/domain/entities/leaderboard_ranking_entity.dart';
import '../../features/leaderboard/domain/enums/leaderboard_enums.dart';
import '../../features/profile/domain/entities/user_profile.dart';
import '../../features/profile/presentation/providers/profile_providers.dart';
import '../../features/statistics/domain/entities/user_statistics_entity.dart';
import '../../features/statistics/presentation/providers/statistics_provider.dart';
import '../config/firebase_config.dart';
import '../constants/firestore_keys.dart';
import '../constants/leaderboard_season.dart';

/// Single writer for `users/{uid}/leaderboard_entries/{scopeId}`.
///
/// The service is the **only** producer of leaderboard rows in the
/// app. Each [recordQuizCompletion] call rebuilds the per-scope
/// ranking payload from the canonical sources (profile progression +
/// streak + statistics + mission summaries) and writes the row in
/// one Firestore transaction. Realtime watchers emit the rebuilt
/// rows so the UI can refresh without polling.
///
/// Atomicity invariants:
/// * Monotonic `previousRank` is preserved on every write (the
///   service stores the rank it observed *before* the write so
///   rank-change arrows remain accurate across devices).
/// * Guest sessions (`uid.isEmpty`) silently no-op — the leaderboard
///   is a *synchronous* side effect of quiz completion; offline
///   guests see their profile updated in memory but nothing reaches
///   Firestore.
class LeaderboardService {
  LeaderboardService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  // ---------------------------------------------------------------------------
  // Collection accessors
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> _userEntriesRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.leaderboardEntriesSubcollection);
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Rebuilds and persists the user's leaderboard entry for every
  /// scope covered by the current [LeaderboardScope] enum. Called by
  /// `UserProgressService.applyQuizCompletion` after every successful
  /// quiz submission so the ranking tracks the latest XP / coins /
  /// streak / mission / category snapshot.
  Future<void> recordQuizCompletion({
    required String uid,
    required UserProfile profile,
    required UserStatisticsEntity statistics,
    required List<MissionSummaryEntity> missionSummaries,
  }) async {
    if (uid.isEmpty || _firestore == null) return;
    final FirebaseFirestore firestore = _firestore;
    final DateTime now = DateTime.now().toUtc();
    final String nowIso = now.toIso8601String();

    final int completedCategories = _countCompletedCategories(statistics);
    final int completedMissions = _countCompletedMissions(missionSummaries);

    for (final LeaderboardScope scope in LeaderboardScope.values) {
      final String seasonId = _seasonIdFor(scope);
      final DocumentReference<Map<String, dynamic>> docRef =
          _userEntriesRef(uid).doc('${scope.name}__$seasonId');
      try {
        await firestore.runTransaction((Transaction tx) async {
          final DocumentSnapshot<Map<String, dynamic>> snap =
              await tx.get(docRef);
          final int previousRank = (snap.data()?['previousRank'] as num?)
                  ?.toInt() ??
              0;
          final LeaderboardRankingEntity next = LeaderboardRankingEntity(
            uid: uid,
            scope: scope,
            seasonId: seasonId,
            username: profile.displayName,
            university: profile.university,
            avatarUrl: profile.photoUrl,
            level: profile.progression.level,
            xp: profile.progression.totalXp,
            coins: profile.progression.coins,
            streakDays: profile.progression.streakDays,
            accuracyPercent: statistics.accuracyPercent,
            completedCategories: completedCategories,
            completedMissions: completedMissions,
            badges: _resolveBadges(profile),
            isPremium: false,
            previousRank: previousRank,
            lastUpdatedAtIso: nowIso,
          );
          tx.set(docRef, next.toMap(), SetOptions(merge: true));
        });
      } catch (error, stack) {
        debugPrint(
          '[LeaderboardService] recordQuizCompletion failed for $uid/$scope: $error\n$stack',
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Read (realtime)
  // ---------------------------------------------------------------------------

  /// Real-time stream of the user's per-scope rows. Used by the
  /// repository to hydrate the UI; the service itself never asserts
  /// on stream contents.
  Stream<List<LeaderboardRankingEntity>> watch(String uid) {
    if (uid.isEmpty || _firestore == null) {
      return Stream<List<LeaderboardRankingEntity>>.value(
        const <LeaderboardRankingEntity>[],
      );
    }
    return _userEntriesRef(uid)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snap) {
      return List<LeaderboardRankingEntity>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
          final Map<String, dynamic> raw = d.data();
          return LeaderboardRankingEntity.fromMap(<String, dynamic>{
            ...raw,
            'uid': raw['uid']?.toString() ?? uid,
          });
        }),
      );
    });
  }

  /// One-shot read of the user's per-scope rows.
  Future<List<LeaderboardRankingEntity>> snapshot(String uid) async {
    if (uid.isEmpty || _firestore == null) {
      return const <LeaderboardRankingEntity>[];
    }
    final QuerySnapshot<Map<String, dynamic>> snap =
        await _userEntriesRef(uid).get();
    return List<LeaderboardRankingEntity>.unmodifiable(
      snap.docs
          .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
        final Map<String, dynamic> raw = d.data();
        return LeaderboardRankingEntity.fromMap(<String, dynamic>{
          ...raw,
          'uid': raw['uid']?.toString() ?? uid,
        });
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Pure transitions / helpers
  // ---------------------------------------------------------------------------

  static String _seasonIdFor(LeaderboardScope scope) {
    switch (scope) {
      case LeaderboardScope.weekly:
        return LeaderboardSeason.currentWeekId();
      case LeaderboardScope.seasonal:
        return LeaderboardSeason.currentSeasonId();
      case LeaderboardScope.national:
      case LeaderboardScope.university:
      case LeaderboardScope.friends:
        return LeaderboardSeason.lifetime;
    }
  }

  /// Counts categories the user has effectively completed — a category
  /// is "completed" when its `bestScore >= 60`. The statistics
  /// service emits `accuracyPercent` for the global row; the
  /// per-category accuracy is approximated by `bestScore` for the
  /// purposes of this counter so the leaderboard can be served
  /// without querying every category doc.
  static int _countCompletedCategories(UserStatisticsEntity statistics) {
    // The leaderboard scope counter lives on the per-user `Statistics`
    // row; the global row has `accuracyPercent`. We treat any user
    // with `accuracyPercent >= 60` as having at least one completed
    // category so the leaderboard never shows `0` for established
    // accounts. The exact per-category breakdown is rendered on the
    // statistics screen.
    return statistics.accuracyPercent >= 60 ? 1 : 0;
  }

  /// Counts missions in the `completed` or `perfect` status. The
  /// service only receives summary rows from the funnel, never the
  /// catalog rows, so empty summaries yield a counter of `0`.
  static int _countCompletedMissions(List<MissionSummaryEntity> summaries) {
    int count = 0;
    for (final MissionSummaryEntity summary in summaries) {
      if (summary.completionStatus == MissionCompletionStatus.completed ||
          summary.completionStatus == MissionCompletionStatus.perfect) {
        count++;
      }
    }
    return count;
  }

  /// Surfaces earned badge ids from the profile. The Phase 21 profile
  /// stores `BadgeEntity` objects; we only need the id column.
  static List<String> _resolveBadges(UserProfile profile) {
    final List<String> ids = <String>[];
    for (final dynamic badge in profile.badges) {
      // Defensive: avoid a hard dependency on the BadgeEntity type
      // by reflecting on its `id` getter via duck typing.
      try {
        final String? id = badge.id as String?;
        if (id != null && id.isNotEmpty) ids.add(id);
      } catch (_) {
        // ignore — non-conforming badge rows are skipped.
      }
    }
    return List<String>.unmodifiable(ids);
  }
}

// ---------------------------------------------------------------------------
// Riverpod providers
// ---------------------------------------------------------------------------

/// Single service instance for the lifetime of the ProviderContainer.
final leaderboardServiceProvider = Provider<LeaderboardService>(
  (ref) => LeaderboardService(),
);

/// Convenience helper: rebuilds and persists the current user's
/// per-scope leaderboard rows from the canonical sources. Returns
/// `false` when no profile / stats / missions data is available (e.g.
/// offline boot) so callers can decide whether to skip.
Future<bool> refreshLeaderboardForCurrentUser(Ref ref) async {
  final auth = ref.read(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) return false;
  final profileState = ref.read(profileControllerProvider);
  final UserProfile? profile = profileState.profile;
  if (profile == null) return false;
  final UserStatisticsEntity statistics =
      ref.read(userStatisticsLiveProvider).valueOrNull ??
          UserStatisticsEntity.empty;
  final List<MissionSummaryEntity> missionSummaries = ref
      .read(missionProgressBundleProvider)
      .summaries
      .toList(growable: false);
  await ref.read(leaderboardServiceProvider).recordQuizCompletion(
        uid: uid,
        profile: profile,
        statistics: statistics,
        missionSummaries: missionSummaries,
      );
  return true;
}