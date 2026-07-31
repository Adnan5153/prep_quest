import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/gamification/domain/enums/mission_enums.dart';
import '../../features/gamification/domain/entities/mission_summary_entity.dart';
import '../../features/gamification/presentation/providers/mission_provider.dart';
import '../../features/gamification/presentation/providers/streak_state_provider.dart';
import '../../features/playground/presentation/providers/playground_provider.dart'
    show PlaygroundProgress;
import '../../features/playground/presentation/providers/playground_providers.dart'
    show PlaygroundNotifier, playgroundProgressProvider;
import '../../features/profile/domain/entities/coin_transaction.dart';
import '../../features/profile/domain/entities/user_profile.dart';
import '../../features/profile/presentation/providers/coin_providers.dart';
import '../../features/profile/presentation/providers/profile_providers.dart';
import '../../features/quiz_engine/domain/entities/quiz_result_entity.dart';
import '../../features/quiz_engine/domain/entities/question_progress_entity.dart';
import '../../features/quiz_engine/domain/entities/quiz_session_entity.dart';
import '../../features/statistics/domain/entities/user_statistics_entity.dart';
import '../../features/statistics/presentation/providers/statistics_provider.dart';
import '../../shared/typedefs/result.dart';
import '../config/firebase_config.dart';
import '../constants/firestore_keys.dart';
import '../errors/failures.dart';
import 'coin_service.dart';
import 'level_curve.dart';
import 'level_up_event_bus.dart';
import 'progress_write_retry_queue.dart';
import 'leaderboard_service.dart';
import 'statistics_service.dart';

/// Single source of truth for the side-effects that fire when a quiz
/// is submitted.
///
/// The funnel mutates six pieces of state in one place:
/// 1. The user's profile (XP / coins / energy / level / rank).
/// 2. The user's study stats (accuracy / streak / total questions).
/// 3. The user's daily streak counter (via the streak provider).
/// 4. The user's category progress (best score per category).
/// 5. The playground's local progress so the world-map UI reflects the
///    new state instantly.
/// 6. The user's quiz history (one document per submitted session).
///
/// When Firebase is configured the service persists the resulting
/// state to Firestore via transactions or merge writes:
/// * `users/{uid}/progression/current` — atomic transaction so
///   concurrent submissions from multiple devices never double-credit
///   XP / coins / level.
/// * `users/{uid}/study_stats/current` — merge update.
/// * `users/{uid}/statistics/current` — statistics mirror used by
///   dashboard widgets.
/// * `users/{uid}/streak/current` — merge update.
/// * `users/{uid}/category_progress/{categoryId}` — merge update.
/// * `users/{uid}/playground/current` — playground snapshot.
/// * `users/{uid}/quiz_sessions/{sessionId}` — full session history.
///
/// Best-effort writes that throw are appended to
/// [ProgressWriteRetryQueue] for later retry when connectivity is
/// restored.
class UserProgressService {
  UserProgressService(this._ref, {ProgressWriteRetryQueue? retryQueue})
      : _retryQueue = retryQueue ?? ProgressWriteRetryQueue();

  final Ref _ref;
  final ProgressWriteRetryQueue _retryQueue;

  Future<void> applyQuizCompletion({
    required QuizSessionEntity session,
    required QuizResultEntity result,
    String? categoryId,
  }) async {
    final auth = _ref.read(authStateProvider);
    final uid = auth.user?.id;
    if (uid == null || uid.isEmpty) return;

    final profileState = _ref.read(profileControllerProvider);
    final profile = profileState.profile;
    UserProfile? updated;
    if (profile != null) {
      final CoinTransactionEntity coinDelta = await _creditQuizCoins(
        session: session,
        result: result,
      );
      updated = _nextProfile(profile, result, coinBalanceAfter: coinDelta.balanceAfter);
      _ref
          .read(profileControllerProvider.notifier)
          .replaceLocalProfile(updated);
    }

    await _updateStreak(uid, result);

    final playground = _ref.read(playgroundProgressProvider.notifier);
    if (categoryId != null) {
      playground.markCompleted(categoryId);
    }
    playground.grantRewardChest(session.quizId);
    if (updated != null) {
      _pushProgressionIntoPlayground(playground, updated);
    }

    if (updated != null) {
      await _commitProfileProgress(uid, session, result, updated, categoryId);
    } else {
      await _persistQuizSessionNoProfile(uid, session, result, categoryId);
    }

    // 7. Mission progress — funnels the quiz result into
    //    `users/{uid}/mission_progress/{missionId}` via
    //    [MissionProgressService]. The funnel increments every
    //    matching mission in the catalog (filtered by
    //    [MissionCategory]), updates the realtime summary stream,
    //    and rolls stars / best score / completion status without
    //    ever double-counting the same `sessionId`.
    unawaited(_propagateQuizToMissions(session, result, categoryId));

    // 8. Statistics — funnels the quiz result into
    //    `users/{uid}/statistics/current` +
    //    `users/{uid}/category_statistics/{categoryId}` via
    //    [StatisticsService]. Atomic Firestore transaction
    //    updates the lifetime totals (correct / wrong /
    //    answered / accuracy / averageTime / xp / coins) and
    //    the per-category EMA, deduped by `sessionId`.
    unawaited(_recordQuizCompletionStats(session, result, categoryId));

    // 9. Leaderboard — rebuilds the user's per-scope ranking row at
    //    `users/{uid}/leaderboard_entries/{scope}__{seasonId}` from
    //    the canonical profile + statistics + mission summaries.
    //    The realtime controller stream surfaces the fresh values
    //    inside the leaderboard screen without an explicit refresh.
    unawaited(_refreshLeaderboardEntries(uid, updated));
  }

  /// Hands the freshly completed quiz to the mission progress
  /// service. Failures are logged but never surface to the user —
  /// the canonical mission / quiz path already succeeded; mission
  /// progress is a best-effort side-effect.
  Future<void> _propagateQuizToMissions(
    QuizSessionEntity session,
    QuizResultEntity result,
    String? categoryId,
  ) async {
    try {
      final MissionsController controller =
          _ref.read(missionsControllerProvider.notifier);
      await controller.recordQuizAttempt(
        sessionId: session.sessionId,
        score: result.scorePercent,
        category: _categoryFromId(categoryId),
        quizId: session.quizId,
        completedAtIso: (result.completedAt ?? DateTime.now()).toUtc(),
      );
    } catch (error, stack) {
      _logFailure('mission progress', error, stack);
    }
  }

  /// Maps a category id (string) onto the mission catalog's
  /// category enum. Unknown ids map to [MissionCategory.mixed] so the
  /// funnel never silently drops a quiz.
  MissionCategory _categoryFromId(String? id) {
    if (id == null || id.isEmpty) return MissionCategory.mixed;
    for (final MissionCategory c in MissionCategory.values) {
      if (c.name == id) return c;
    }
    return MissionCategory.mixed;
  }

  /// Hands the freshly completed quiz to [StatisticsService]. Runs
  /// best-effort — failures are logged but never surface to the user
  /// because the canonical quiz completion has already succeeded.
  Future<void> _recordQuizCompletionStats(
    QuizSessionEntity session,
    QuizResultEntity result,
    String? categoryId,
  ) async {
    final auth = _ref.read(authStateProvider);
    final String? uid = auth.user?.id;
    if (uid == null || uid.isEmpty) return;
    if (categoryId == null || categoryId.isEmpty) return;

    final QuizStatisticsInput input = QuizStatisticsInput(
      sessionId: session.sessionId,
      categoryId: categoryId,
      subjectName: _resolveSubjectName(categoryId),
      totalQuestions: result.questionResults.length,
      correctAnswers: result.correctCount,
      wrongAnswers: result.incorrectCount,
      skippedAnswers: result.skippedCount,
      scorePercent: result.scorePercent,
      totalSeconds: result.timeSpentSeconds,
      xpEarned: result.rewardXp,
      coinsEarned: result.rewardCoins,
      completedAtIso:
          (result.completedAt ?? DateTime.now()).toUtc().toIso8601String(),
    );

    try {
      await _ref.read(statisticsServiceProvider).recordQuizCompletion(
            uid: uid,
            input: input,
          );
    } catch (error, stack) {
      _logFailure('statistics', error, stack);
    }
  }

  /// Resolves a human-readable subject name for the statistics row.
  /// Falls back to the category id itself so the row is always
  /// labelled even when the catalog rename logic hasn't run yet.
  String _resolveSubjectName(String categoryId) {
    final String pretty = categoryId
        .split(RegExp(r'[_\-\s]+'))
        .where((String part) => part.isNotEmpty)
        .map((String part) =>
            part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join(' ');
    return pretty.isEmpty ? categoryId : pretty;
  }

  /// Phase 44 — rebuilds the user's leaderboard rows from the
  /// canonical sources (profile progression + statistics + mission
  /// summaries). Runs best-effort; failures are logged but never
  /// surface to the user because the canonical quiz completion has
  /// already succeeded.
  Future<void> _refreshLeaderboardEntries(
    String uid,
    UserProfile? updatedProfile,
  ) async {
    if (updatedProfile == null) return;
    try {
      final UserStatisticsEntity statistics =
          _ref.read(userStatisticsLiveProvider).valueOrNull ??
              UserStatisticsEntity.empty;
      final List<MissionSummaryEntity> missionSummaries =
          _ref.read(missionProgressBundleProvider).summaries.toList(
                growable: false,
              );
      await _ref.read(leaderboardServiceProvider).recordQuizCompletion(
            uid: uid,
            profile: updatedProfile,
            statistics: statistics,
            missionSummaries: missionSummaries,
          );
    } catch (error, stack) {
      _logFailure('leaderboard', error, stack);
    }
  }

  /// Credits the coins earned by a quiz completion through the
  /// canonical [CoinService] so the user's `progression.coins` and the
  /// `coin_ledger` doc commit atomically. Returns the final
  /// [CoinTransactionEntity] — if the grant hits a duplicate (the
  /// sessionId was already credited from a replay), the existing
  /// balance is returned unchanged so the rest of the funnel can
  /// still apply the XP / level / streak deltas.
  Future<CoinTransactionEntity> _creditQuizCoins({
    required QuizSessionEntity session,
    required QuizResultEntity result,
  }) async {
    final CoinService coinService = _ref.read(coinServiceProvider);
    final int earnedCoins = result.rewardCoins.clamp(0, 1 << 20);
    if (earnedCoins <= 0) {
      return CoinTransactionEntity(
        id: '',
        uid: '',
        type: CoinTransactionType.reward,
        source: CoinTransactionSource.quiz,
        sourceId: session.sessionId,
        amount: 0,
        balanceAfter: _ref.read(profileControllerProvider).profile?.progression.coins ?? 0,
        reason: 'Quiz completed',
        metadata: const <String, dynamic>{},
        createdAt: DateTime.now().toUtc(),
      );
    }
    final Result<CoinTransactionEntity> outcome = await coinService.grant(
      source: CoinTransactionSource.quiz,
      sourceId: session.sessionId,
      amount: earnedCoins,
      reason: 'Quiz completed',
      metadata: <String, dynamic>{
        'quizId': session.quizId,
        'score': result.scorePercent,
        'correctCount': result.correctCount,
        'totalQuestions': result.questionResults.length,
      },
      type: CoinTransactionType.reward,
    );
    return outcome.fold(
      onFailure: (Failure _) => CoinTransactionEntity(
        id: '',
        uid: '',
        type: CoinTransactionType.reward,
        source: CoinTransactionSource.quiz,
        sourceId: session.sessionId,
        amount: earnedCoins,
        balanceAfter: _ref.read(profileControllerProvider).profile?.progression.coins ?? 0,
        reason: 'Quiz completed',
        metadata: const <String, dynamic>{},
        createdAt: DateTime.now().toUtc(),
      ),
      onSuccess: (CoinTransactionEntity entity) => entity,
    );
  }

  /// Returns the retry queue so bootstrap / connectivity services can
  /// flush pending writes when the device comes back online.
  ProgressWriteRetryQueue get retryQueue => _retryQueue;

  /// Re-applies every queued write. Called from
  /// `ConnectivityService` / `bootstrap.dart` after the network
  /// reconnects.
  Future<int> flushPendingWrites() async {
    if (!FirebaseConfig.isPlatformConfigured) return 0;
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) return 0;
    return _retryQueue.flush(firestore);
  }

  /// Pushes the freshly-updated profile's progression into the
  /// playground state so the world-map UI's totalXp / coins / level
  /// mirror [UserProfile.progression] exactly. Preserves the unlock
  /// and completion lists already updated by [markCompleted] /
  /// [grantRewardChest].
  void _pushProgressionIntoPlayground(
    PlaygroundNotifier playground,
    UserProfile updated,
  ) {
    final PlaygroundProgress current = playground.progress;
    playground.replace(
      current.copyWith(
        totalXp: updated.progression.totalXp,
        userLevel: updated.progression.level,
        xpInLevel: updated.progression.xpInLevel,
        xpForNextLevel: updated.progression.xpForNextLevel,
        coins: updated.progression.coins,
        streakDays: updated.progression.streakDays,
      ),
    );
  }

  UserProfile _nextProfile(
    UserProfile profile,
    QuizResultEntity result, {
    required int coinBalanceAfter,
  }) {
    final progression = profile.progression;
    final stats = profile.studyStats;
    final earnedXp = result.rewardXp.clamp(0, 1 << 20);
    final int previousTotalXp = progression.totalXp;
    final int newTotalXp = previousTotalXp + earnedXp;
    final LevelSnapshot previousSnapshot =
        LevelCurve.defaultCurve.compute(previousTotalXp);
    final LevelSnapshot nextSnapshot =
        LevelCurve.defaultCurve.compute(newTotalXp);
    final int levelDelta = nextSnapshot.level - previousSnapshot.level;
    final List<PendingLevelReward> newRewards = levelDelta > 0
        ? List<PendingLevelReward>.generate(
            levelDelta,
            (int i) => _buildPendingLevelReward(
              crossedLevel: previousSnapshot.level + i + 1,
            ),
          )
        : const <PendingLevelReward>[];
    final DateTime now = DateTime.now().toUtc();
    final newStreak = stats.currentStreakDays > 0
        ? stats.currentStreakDays
        : (progression.streakDays > 0 ? progression.streakDays : 0);

    final int totalQuestions =
        stats.totalQuestionsAnswered + result.questionResults.length;
    final int totalCorrect =
        stats.totalCorrectAnswers + result.correctCount;
    final double newAverage =
        totalQuestions == 0 ? 0.0 : totalCorrect / totalQuestions;
    final int totalStudyMinutes =
        stats.totalStudyMinutes + (result.timeSpentSeconds ~/ 60);

    final ProgressionEntity nextProgression = progression.copyWith(
      totalXp: newTotalXp,
      level: nextSnapshot.level,
      xpInLevel: newTotalXp - nextSnapshot.cumulativeXpAtLevel,
      xpForNextLevel: nextSnapshot.xpForNext,
      coins: coinBalanceAfter,
      streakDays: newStreak,
      previousLevelThreshold: nextSnapshot.previousLevelThreshold,
      nextLevelThreshold: nextSnapshot.nextLevelThreshold,
      totalLevelUpsCompleted:
          progression.totalLevelUpsCompleted + levelDelta,
      lastLevelUpAt: levelDelta > 0 ? now : null,
      clearLastLevelUpAt: levelDelta == 0,
      pendingLevelRewards: <PendingLevelReward>[
        ...progression.pendingLevelRewards,
        ...newRewards,
      ],
    );

    final UserProfile updated = profile.copyWith(
      progression: nextProgression,
      studyStats: stats.copyWith(
        totalQuizzesTaken: stats.totalQuizzesTaken + 1,
        totalQuestionsAnswered: totalQuestions,
        totalCorrectAnswers: totalCorrect,
        totalStudyMinutes: totalStudyMinutes,
        averageAccuracy: newAverage,
        lastActiveAt: DateTime.now(),
      ),
    );

    if (levelDelta > 0) {
      for (final PendingLevelReward reward in newRewards) {
        _ref.read(levelUpEventBusProvider.notifier).publish(
              LevelUpEvent(
                fromLevel: previousSnapshot.level,
                toLevel: reward.level,
                totalXp: newTotalXp,
                reward: reward,
              ),
            );
      }
    }

    return updated;
  }

  /// Builds a [PendingLevelReward] for the level the user just
  /// crossed. Reward magnitudes scale with the level's XP cost so
  /// higher levels give proportionally larger bonuses, while the
  /// per-reward values are frozen at queue time — later curve
  /// tuning does not retroactively change already-queued rewards.
  PendingLevelReward _buildPendingLevelReward({required int crossedLevel}) {
    final int xpCost =
        LevelCurve.defaultCurve.xpRequiredForLevel(crossedLevel);
    final int xpBonus = (xpCost / 4).round();
    final int coinBonus = (xpCost / 10).round();
    return PendingLevelReward(
      level: crossedLevel,
      xpBonus: xpBonus,
      coinBonus: coinBonus,
      badgeId: crossedLevel % 5 == 0 ? 'level_${crossedLevel}_clear' : null,
      unlockedTitles: crossedLevel % 10 == 0
          ? <String>['Legendary Scholar']
          : const <String>[],
      queuedAt: DateTime.now().toUtc(),
    );
  }

  /// Marks a queued level-up reward as claimed, credits the
  /// `coinBonus` through [CoinService], and updates the
  /// `pendingLevelRewards` array atomically in one Firestore
  /// transaction. The local profile is updated immediately so the UI
  /// can drain the queue while the transaction runs. If Firestore is
  /// not configured the coin credit still happens through the
  /// in-memory path so the user sees the reward; the queue-persisted
  /// claim is skipped.
  Future<void> claimLevelReward(PendingLevelReward reward) async {
    final profileState = _ref.read(profileControllerProvider);
    final profile = profileState.profile;
    if (profile == null) return;
    final ProgressionEntity current = profile.progression;
    final List<PendingLevelReward> updatedList = current.pendingLevelRewards
        .map((PendingLevelReward existing) =>
            existing.level == reward.level &&
                    existing.queuedAt == reward.queuedAt &&
                    !existing.claimed
                ? existing.copyWith(claimed: true)
                : existing)
        .toList(growable: false);
    final auth = _ref.read(authStateProvider);
    final String? uid = auth.user?.id;
    final bool isGuest =
        uid == null || uid.isEmpty || (auth.user?.email ?? '').isEmpty;

    int nextBalance = current.coins + reward.coinBonus;
    if (!isGuest && reward.coinBonus > 0) {
      final Result<CoinTransactionEntity> outcome =
          await _ref.read(coinServiceProvider).grant(
        source: CoinTransactionSource.levelReward,
        sourceId: '${reward.level}@${reward.queuedAt.toIso8601String()}',
        amount: reward.coinBonus,
        reason: 'Level ${reward.level} reward',
        metadata: <String, dynamic>{
          'level': reward.level,
          'queuedAt': reward.queuedAt.toIso8601String(),
        },
        type: CoinTransactionType.reward,
      );
      nextBalance = outcome.fold(
        onFailure: (Failure _) => nextBalance,
        onSuccess: (CoinTransactionEntity entity) => entity.balanceAfter,
      );
    } else if (reward.coinBonus > 0) {
      nextBalance = (current.coins + reward.coinBonus).clamp(0, 1 << 31);
    }

    final ProgressionEntity next = current.copyWith(
      pendingLevelRewards: updatedList,
      coins: nextBalance,
      totalXp: current.totalXp + reward.xpBonus,
    );
    final UserProfile updated = profile.copyWith(progression: next);
    _ref
        .read(profileControllerProvider.notifier)
        .replaceLocalProfile(updated);

    if (uid == null || uid.isEmpty) return;
    if (isGuest) return;
    if (!FirebaseConfig.isPlatformConfigured) return;
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) return;
    try {
      await firestore
          .collection(FirestoreKeys.users)
          .doc(uid)
          .collection(FirestoreKeys.progressionSubcollection)
          .doc(FirestoreKeys.currentDocId)
          .set(<String, dynamic>{
        'pendingLevelRewards': updatedList
            .map((PendingLevelReward r) => <String, dynamic>{
                  'level': r.level,
                  'xpBonus': r.xpBonus,
                  'coinBonus': r.coinBonus,
                  'badgeId': r.badgeId,
                  'unlockedTitles': r.unlockedTitles,
                  'queuedAt': r.queuedAt.toUtc().toIso8601String(),
                  'claimed': r.claimed,
                })
            .toList(growable: false),
        'coins': nextBalance,
        'totalXp': current.totalXp + reward.xpBonus,
        'lastUpdatedAt': DateTime.now().toUtc().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (error, stack) {
      _logFailure('claim level reward', error, stack);
      _retryQueue.enqueue(PendingWrite(
        collection: '${FirestoreKeys.users}/$uid'
            '/${FirestoreKeys.progressionSubcollection}',
        documentId: FirestoreKeys.currentDocId,
        payload: <String, dynamic>{
          'pendingLevelRewards': updatedList
              .map((PendingLevelReward r) => <String, dynamic>{
                    'level': r.level,
                    'xpBonus': r.xpBonus,
                    'coinBonus': r.coinBonus,
                    'badgeId': r.badgeId,
                    'unlockedTitles': r.unlockedTitles,
                    'queuedAt': r.queuedAt.toUtc().toIso8601String(),
                    'claimed': r.claimed,
                  })
              .toList(growable: false),
          'coins': nextBalance,
          'totalXp': current.totalXp + reward.xpBonus,
        },
      ));
    }
  }

  Future<void> _commitProfileProgress(
    String uid,
    QuizSessionEntity session,
    QuizResultEntity result,
    UserProfile updated,
    String? categoryId,
  ) async {
    if (!FirebaseConfig.isPlatformConfigured) return;
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) return;

    // 1. Atomic XP / Level write via transaction. The coin balance
    //    was committed by [CoinService.grant] in
    //    `applyQuizCompletion`; we pass the post-grant balance here so
    //    the rest of the progression fields stay consistent with the
    //    ledger.
    await _transactionalProgression(
      uid,
      firestore,
      result,
      coinBalanceAfter: updated.progression.coins,
    ).catchError((Object error, StackTrace stack) {
      _logFailure('progression transaction', error, stack);
      _retryQueue.enqueue(PendingWrite(
        collection: '${FirestoreKeys.users}/$uid'
            '/${FirestoreKeys.progressionSubcollection}',
        documentId: FirestoreKeys.currentDocId,
        payload: _progressionPayload(updated),
      ));
    });

    // 2. Study stats — merge update.
    await _persistStudyStats(uid, firestore, updated).catchError(
      (Object error, StackTrace stack) {
        _logFailure('study stats', error, stack);
        _retryQueue.enqueue(PendingWrite(
          collection: '${FirestoreKeys.users}/$uid'
              '/${FirestoreKeys.studyStatsSubcollection}',
          documentId: FirestoreKeys.currentDocId,
          payload: _studyStatsPayload(updated),
        ));
      },
    );

    // 3. Statistics mirror — same payload, different collection.
    //    Dashboard / admin widgets read from here.
    await _persistStatisticsMirror(uid, firestore, updated).catchError(
      (Object error, StackTrace stack) {
        _logFailure('statistics mirror', error, stack);
        _retryQueue.enqueue(PendingWrite(
          collection: '${FirestoreKeys.users}/$uid'
              '/${FirestoreKeys.statisticsSubcollection}',
          documentId: FirestoreKeys.currentDocId,
          payload: _studyStatsPayload(updated),
        ));
      },
    );

    // 4. Category progress — best score per category.
    if (categoryId != null) {
      await _persistCategoryProgress(
        uid,
        firestore,
        categoryId,
        session,
        result,
      ).catchError((Object error, StackTrace stack) {
        _logFailure('category progress', error, stack);
        _retryQueue.enqueue(PendingWrite(
          collection: '${FirestoreKeys.users}/$uid'
              '/${FirestoreKeys.categoryProgressSubcollection}',
          documentId: categoryId,
          payload: _categoryProgressPayload(categoryId, session, result),
        ));
      });
    }

    // 5. Playground snapshot — single merge doc the Playground screen
    //    can hydrate from on cold start.
    await _persistPlaygroundSnapshot(uid, firestore).catchError(
      (Object error, StackTrace stack) {
        _logFailure('playground snapshot', error, stack);
        _retryQueue.enqueue(PendingWrite(
          collection: '${FirestoreKeys.users}/$uid'
              '/${FirestoreKeys.playgroundSubcollection}',
          documentId: FirestoreKeys.currentDocId,
          payload: _playgroundPayload(),
        ));
      },
    );

    // 6. Quiz session history — one doc per submission.
    await _persistQuizSession(
      uid,
      firestore,
      session,
      result,
      categoryId,
    ).catchError((Object error, StackTrace stack) {
      _logFailure('quiz session', error, stack);
    });
  }

  /// Atomic update of `users/{uid}/progression/current` so concurrent
  /// submissions from another device cannot double-credit XP /
  /// level. The [coinBalanceAfter] is supplied by the caller —
  /// `applyQuizCompletion` has already routed the coin delta through
  /// [CoinService.grant] which wrote the new `coins` value and the
  /// matching ledger doc atomically. We only re-read the document to
  /// pick up the new `coins` so we can write the rest of the
  /// progression fields in the same transaction; overwriting `coins`
  /// here would clobber the value [CoinService] just committed.
  /// Level-up rewards queued locally are merged into the existing
  /// `pendingLevelRewards` list (claimed entries from the doc are
  /// preserved).
  Future<void> _transactionalProgression(
    String uid,
    FirebaseFirestore firestore,
    QuizResultEntity result, {
    required int coinBalanceAfter,
  }) async {
    final DocumentReference<Map<String, dynamic>> ref = firestore
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.progressionSubcollection)
        .doc(FirestoreKeys.currentDocId);
    final int earnedXp = result.rewardXp.clamp(0, 1 << 20);
    final DateTime now = DateTime.now().toUtc();
    await firestore.runTransaction((Transaction tx) async {
      final DocumentSnapshot<Map<String, dynamic>> snap =
          await tx.get(ref);
      final Map<String, dynamic> data = snap.data() ?? <String, dynamic>{};
      final int existingXp = (data['totalXp'] as num?)?.toInt() ?? 0;
      final int existingLevelUps =
          (data['totalLevelUpsCompleted'] as num?)?.toInt() ?? 0;
      final int newTotalXp = existingXp + earnedXp;
      final LevelSnapshot previousSnapshot =
          LevelCurve.defaultCurve.compute(existingXp);
      final LevelSnapshot nextSnapshot =
          LevelCurve.defaultCurve.compute(newTotalXp);
      final int levelDelta = nextSnapshot.level - previousSnapshot.level;
      final List<PendingLevelReward> mergedRewards =
          _mergePendingRewards(
        existing: (data['pendingLevelRewards'] as List<dynamic>?) ??
            const <dynamic>[],
        additions: levelDelta > 0
            ? List<PendingLevelReward>.generate(
                levelDelta,
                (int i) => _buildPendingLevelReward(
                  crossedLevel: previousSnapshot.level + i + 1,
                ),
              )
            : const <PendingLevelReward>[],
      );
      tx.set(
        ref,
        <String, dynamic>{
          'totalXp': newTotalXp,
          'level': nextSnapshot.level,
          'xpInLevel': newTotalXp - nextSnapshot.cumulativeXpAtLevel,
          'xpForNextLevel': nextSnapshot.xpForNext,
          'coins': coinBalanceAfter,
          'previousLevelThreshold': nextSnapshot.previousLevelThreshold,
          'nextLevelThreshold': nextSnapshot.nextLevelThreshold,
          'totalLevelUpsCompleted': existingLevelUps + levelDelta,
          'lastLevelUpAt': levelDelta > 0 ? now.toIso8601String() : null,
          'pendingLevelRewards': mergedRewards
              .map((PendingLevelReward r) => <String, dynamic>{
                    'level': r.level,
                    'xpBonus': r.xpBonus,
                    'coinBonus': r.coinBonus,
                    'badgeId': r.badgeId,
                    'unlockedTitles': r.unlockedTitles,
                    'queuedAt': r.queuedAt.toUtc().toIso8601String(),
                    'claimed': r.claimed,
                  })
              .toList(growable: false),
          'lastUpdatedAt': now.toIso8601String(),
        },
        SetOptions(merge: true),
      );
    });
  }

  /// Merges Firestore-stored pending rewards with locally-queued
  /// additions. Claimed entries from the doc are preserved (the queue
  /// does not drop them on the floor); new additions are appended.
  List<PendingLevelReward> _mergePendingRewards({
    required List<dynamic> existing,
    required List<PendingLevelReward> additions,
  }) {
    final List<PendingLevelReward> persisted = existing
        .whereType<Map<String, dynamic>>()
        .map(PendingLevelReward.fromMap)
        .toList(growable: true);
    final Set<String> keys = persisted
        .map((PendingLevelReward r) => '${r.level}@${r.queuedAt.toIso8601String()}')
        .toSet();
    for (final PendingLevelReward reward in additions) {
      final String key =
          '${reward.level}@${reward.queuedAt.toIso8601String()}';
      if (keys.add(key)) {
        persisted.add(reward);
      }
    }
    return List<PendingLevelReward>.unmodifiable(persisted);
  }

  Future<void> _persistStudyStats(
    String uid,
    FirebaseFirestore firestore,
    UserProfile profile,
  ) async {
    await firestore
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.studyStatsSubcollection)
        .doc(FirestoreKeys.currentDocId)
        .set(_studyStatsPayload(profile), SetOptions(merge: true));
  }

  Future<void> _persistStatisticsMirror(
    String uid,
    FirebaseFirestore firestore,
    UserProfile profile,
  ) async {
    await firestore
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.statisticsSubcollection)
        .doc(FirestoreKeys.currentDocId)
        .set(_studyStatsPayload(profile), SetOptions(merge: true));
  }

  Future<void> _updateStreak(String uid, QuizResultEntity result) async {
    final streak = _ref.read(streakStateProvider);
    final String isoNow = DateTime.now().toUtc().toIso8601String();
    final int nextDays = streak.currentDays + (result.passed ? 1 : 0);
    final next = streak.copyWith(
      currentDays: nextDays,
      bestDays: nextDays > streak.bestDays ? nextDays : streak.bestDays,
      lastClaimedAtIso: isoNow,
    );
    _ref.read(streakStateProvider.notifier).replaceLocal(next);
    if (!FirebaseConfig.isPlatformConfigured) return;
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) return;
    try {
      await firestore
          .collection(FirestoreKeys.users)
          .doc(uid)
          .collection(FirestoreKeys.streakSubcollection)
          .doc(FirestoreKeys.currentDocId)
          .set(<String, dynamic>{
        'currentDays': next.currentDays,
        'bestDays': next.bestDays,
        'lastCompletedAt': isoNow,
      }, SetOptions(merge: true));
    } catch (error, stack) {
      _logFailure('streak', error, stack);
      _retryQueue.enqueue(PendingWrite(
        collection: '${FirestoreKeys.users}/$uid'
            '/${FirestoreKeys.streakSubcollection}',
        documentId: FirestoreKeys.currentDocId,
        payload: <String, dynamic>{
          'currentDays': next.currentDays,
          'bestDays': next.bestDays,
          'lastCompletedAt': isoNow,
        },
      ));
    }
  }

  Future<void> _persistCategoryProgress(
    String uid,
    FirebaseFirestore firestore,
    String categoryId,
    QuizSessionEntity session,
    QuizResultEntity result,
  ) async {
    await firestore
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.categoryProgressSubcollection)
        .doc(categoryId)
        .set(_categoryProgressPayload(categoryId, session, result),
            SetOptions(merge: true));
  }

  Future<void> _persistPlaygroundSnapshot(
    String uid,
    FirebaseFirestore firestore,
  ) async {
    final PlaygroundProgress playground = _ref.read(playgroundProgressProvider);
    await firestore
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.playgroundSubcollection)
        .doc(FirestoreKeys.currentDocId)
        .set(_playgroundPayloadFromState(playground), SetOptions(merge: true));
  }

  Future<void> _persistQuizSession(
    String uid,
    FirebaseFirestore firestore,
    QuizSessionEntity session,
    QuizResultEntity result,
    String? categoryId,
  ) async {
    final Map<String, dynamic> perQuestion = <String, dynamic>{};
    session.progress.forEach((String qid, QuestionProgressEntity p) {
      perQuestion[qid] = <String, dynamic>{
        'selectedAnswerIds': List<String>.of(p.selectedAnswerIds),
        'status': p.status.name,
        'timeSpentSeconds': p.timeSpentSeconds,
        'attemptCount': p.attemptCount,
        'hintIdsRevealed': List<String>.of(p.hintIdsRevealed),
        'isBookmarked': p.isBookmarked,
        'wasCorrect': result.questionResults[qid] ?? false,
      };
    });
    final Map<String, dynamic> payload = <String, dynamic>{
      'sessionId': session.sessionId,
      'quizId': session.quizId,
      'categoryId': categoryId,
      'scorePercent': result.scorePercent,
      'earnedPoints': result.earnedPoints,
      'totalPoints': result.totalPoints,
      'correctCount': result.correctCount,
      'incorrectCount': result.incorrectCount,
      'skippedCount': result.skippedCount,
      'timeSpentSeconds': result.timeSpentSeconds,
      'passed': result.passed,
      'rewardXp': result.rewardXp,
      'rewardCoins': result.rewardCoins,
      'difficulty': result.difficulty.name,
      'startedAt': session.startedAt.toUtc().toIso8601String(),
      'completedAt':
          (result.completedAt ?? DateTime.now()).toUtc().toIso8601String(),
      'flagged': session.flags.toList(growable: false),
      'perQuestion': perQuestion,
    };
    await firestore
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.quizSessionsSubcollection)
        .doc(session.sessionId)
        .set(payload, SetOptions(merge: true));
    await firestore
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.quizHistorySubcollection)
        .doc(session.sessionId)
        .set(payload, SetOptions(merge: true));
  }

  /// Variant used when the local profile is unavailable. Persists
  /// only the quiz session — progression writes are skipped.
  Future<void> _persistQuizSessionNoProfile(
    String uid,
    QuizSessionEntity session,
    QuizResultEntity result,
    String? categoryId,
  ) async {
    if (!FirebaseConfig.isPlatformConfigured) return;
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) return;
    await _persistQuizSession(uid, firestore, session, result, categoryId)
        .catchError((Object error, StackTrace stack) {
      _logFailure('quiz session (no profile)', error, stack);
    });
  }

  Map<String, dynamic> _progressionPayload(UserProfile profile) {
    return <String, dynamic>{
      'totalXp': profile.progression.totalXp,
      'level': profile.progression.level,
      'xpInLevel': profile.progression.xpInLevel,
      'xpForNextLevel': profile.progression.xpForNextLevel,
      'coins': profile.progression.coins,
      'streakDays': profile.progression.streakDays,
      'energy': profile.progression.energy,
      'maxEnergy': profile.progression.maxEnergy,
      'rankId': profile.progression.rank.id,
      'previousLevelThreshold': profile.progression.previousLevelThreshold,
      'nextLevelThreshold': profile.progression.nextLevelThreshold,
      'totalLevelUpsCompleted': profile.progression.totalLevelUpsCompleted,
      'lastLevelUpAt':
          profile.progression.lastLevelUpAt?.toUtc().toIso8601String(),
      'pendingLevelRewards': profile.progression.pendingLevelRewards
          .map((PendingLevelReward r) => <String, dynamic>{
                'level': r.level,
                'xpBonus': r.xpBonus,
                'coinBonus': r.coinBonus,
                'badgeId': r.badgeId,
                'unlockedTitles': r.unlockedTitles,
                'queuedAt': r.queuedAt.toUtc().toIso8601String(),
                'claimed': r.claimed,
              })
          .toList(growable: false),
      'lastUpdatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> _studyStatsPayload(UserProfile profile) {
    return <String, dynamic>{
      'totalQuizzesTaken': profile.studyStats.totalQuizzesTaken,
      'totalQuestionsAnswered': profile.studyStats.totalQuestionsAnswered,
      'totalCorrectAnswers': profile.studyStats.totalCorrectAnswers,
      'totalStudyMinutes': profile.studyStats.totalStudyMinutes,
      'averageAccuracy': profile.studyStats.averageAccuracy,
      'longestStreakDays': profile.studyStats.longestStreakDays,
      'lastActiveAt':
          profile.studyStats.lastActiveAt.toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> _categoryProgressPayload(
    String categoryId,
    QuizSessionEntity session,
    QuizResultEntity result,
  ) {
    return <String, dynamic>{
      'quizId': session.quizId,
      'categoryId': categoryId,
      'bestScore': result.scorePercent,
      'bestEarnedPoints': result.earnedPoints,
      'completedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> _playgroundPayload() => _playgroundPayloadFromState(
        _ref.read(playgroundProgressProvider),
      );

  Map<String, dynamic> _playgroundPayloadFromState(PlaygroundProgress progress) {
    return <String, dynamic>{
      'totalXp': progress.totalXp,
      'userLevel': progress.userLevel,
      'xpInLevel': progress.xpInLevel,
      'xpForNextLevel': progress.xpForNextLevel,
      'coins': progress.coins,
      'energy': progress.energy,
      'maxEnergy': progress.maxEnergy,
      'streakDays': progress.streakDays,
      'completedLevelIds': List<String>.from(progress.completedLevelIds),
      'unlockedLevelIds': List<String>.from(progress.unlockedLevelIds),
      'activeLevelId': progress.activeLevelId,
      'lastUpdatedAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  void _logFailure(String surface, Object error, StackTrace stack) {
    if (!kDebugMode) return;
    debugPrint('[UserProgressService] $surface write failed: $error\n$stack');
  }
}

/// Lightweight level curve used by [UserProgressService].
///
/// XP required per level grows by 25 % each step, starting at 100 for
/// level 1 → 2. The shared implementation lives at
/// `lib/core/services/level_curve.dart` and is the single source of
/// truth consumed by the canonical funnel, the gamification reward
/// engine, and every UI surface.

/// Provider for the [UserProgressService] singleton.
final userProgressServiceProvider = Provider<UserProgressService>((ref) {
  return UserProgressService(ref);
});

/// Provider exposing the in-memory [ProgressWriteRetryQueue]. The
/// connectivity service can watch this provider and call
/// [ProgressWriteRetryQueue.flush] when the network reconnects.
final progressWriteRetryQueueProvider = Provider<ProgressWriteRetryQueue>(
  (ref) {
    final UserProgressService service = ref.watch(userProgressServiceProvider);
    return service.retryQueue;
  },
);