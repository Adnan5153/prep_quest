import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/coin_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../../profile/domain/entities/coin_transaction.dart';
import '../../../profile/presentation/providers/coin_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/datasources/rewards_local_datasource.dart';
import '../../data/repositories/rewards_repository_impl.dart';
import '../../domain/entities/level_progress.dart';
import '../../domain/entities/reward.dart';
import '../../domain/entities/reward_event.dart';
import '../../domain/entities/reward_history_entry.dart';
import '../../domain/entities/reward_outcome.dart';
import '../../domain/entities/user_rewards_state.dart';
import '../../domain/enums/reward_enums.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../../domain/services/reward_rule_catalog.dart';
import '../../domain/usecases/claim_daily_reward.dart';
import '../../domain/usecases/grant_rewards.dart';
import '../../domain/usecases/load_reward_history.dart';
import '../../domain/usecases/load_rewards_state.dart';
import '../../domain/usecases/open_reward_chest.dart';
import '../../domain/usecases/toggle_badge_favorite.dart';

/// Provides the in-memory datasource. Overridden in tests.
final rewardsLocalDataSourceProvider = Provider<RewardsLocalDataSource>(
  (ref) => RewardsLocalDataSource(),
);

/// Single repository the entire feature consumes.
final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => RewardsRepositoryImpl(
    datasource: ref.watch(rewardsLocalDataSourceProvider),
  ),
);

final grantRewardsUseCaseProvider = Provider<GrantRewards>(
  (ref) => GrantRewards(ref.watch(rewardsRepositoryProvider)),
);

final openRewardChestUseCaseProvider = Provider<OpenRewardChest>(
  (ref) => OpenRewardChest(ref.watch(rewardsRepositoryProvider)),
);

final claimDailyRewardUseCaseProvider = Provider<ClaimDailyReward>(
  (ref) => ClaimDailyReward(ref.watch(rewardsRepositoryProvider)),
);

final loadRewardsStateUseCaseProvider = Provider<LoadRewardsState>(
  (ref) => LoadRewardsState(ref.watch(rewardsRepositoryProvider)),
);

final loadRewardHistoryUseCaseProvider = Provider<LoadRewardHistory>(
  (ref) => LoadRewardHistory(ref.watch(rewardsRepositoryProvider)),
);

final toggleBadgeFavoriteUseCaseProvider = Provider<ToggleBadgeFavorite>(
  (ref) => ToggleBadgeFavorite(ref.watch(rewardsRepositoryProvider)),
);

/// Preview-only provider — useful for the level badge widget.
final previewLevelProvider =
    Provider.family<LevelProgress, int>((ref, xp) {
  return const RewardRuleCatalog().levelFor(xp);
});

/// Top-level snapshot surfaced by the controller.
@immutable
class RewardsViewState {
  const RewardsViewState({
    required this.status,
    required this.snapshot,
    this.lastOutcome,
    this.history = const <RewardHistoryEntry>[],
    this.errorMessage,
  });

  final RewardsStatus status;
  final UserRewardsState snapshot;
  final RewardOutcome? lastOutcome;
  final List<RewardHistoryEntry> history;
  final String? errorMessage;

  bool get isLoading => status == RewardsStatus.loading;
  bool get isReady => status == RewardsStatus.ready;

  RewardsViewState copyWith({
    RewardsStatus? status,
    UserRewardsState? snapshot,
    RewardOutcome? lastOutcome,
    bool clearOutcome = false,
    List<RewardHistoryEntry>? history,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RewardsViewState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      lastOutcome: clearOutcome ? null : (lastOutcome ?? this.lastOutcome),
      history: history ?? this.history,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static final RewardsViewState initial = RewardsViewState(
    status: RewardsStatus.initial,
    snapshot: UserRewardsState.initial(),
    history: <RewardHistoryEntry>[],
  );
}

enum RewardsStatus { initial, loading, ready, error }

/// State notifier for the rewards feature.
///
/// Widgets subscribe to [rewardsControllerProvider] for the live
/// snapshot; they call methods on the notifier to mutate state. The
/// controller is the only place that talks to the use cases.
class RewardsController extends StateNotifier<RewardsViewState> {
  RewardsController({
    required Ref ref,
    required GrantRewards grantRewards,
    required OpenRewardChest openChest,
    required ClaimDailyReward claimDaily,
    required LoadRewardsState loadState,
    required LoadRewardHistory loadHistory,
    required ToggleBadgeFavorite toggleFavorite,
  })  : _ref = ref,
        _grantRewards = grantRewards,
        _openChest = openChest,
        _claimDaily = claimDaily,
        _loadState = loadState,
        _loadHistory = loadHistory,
        _toggleFavorite = toggleFavorite,
        super(RewardsViewState.initial);

  final Ref _ref;
  final GrantRewards _grantRewards;
  final OpenRewardChest _openChest;
  final ClaimDailyReward _claimDaily;
  final LoadRewardsState _loadState;
  final LoadRewardHistory _loadHistory;
  final ToggleBadgeFavorite _toggleFavorite;

  Future<void> load() async {
    state = state.copyWith(status: RewardsStatus.loading, clearError: true);
    final Result<UserRewardsState> stateResult = await _loadState();
    final Result<List<RewardHistoryEntry>> historyResult = await _loadHistory();
    if (!mounted) return;
    stateResult.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: RewardsStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (snapshot) {
        final List<RewardHistoryEntry> history = historyResult.fold(
          onFailure: (_) => <RewardHistoryEntry>[],
          onSuccess: (rows) => rows,
        );
        state = state.copyWith(
          status: RewardsStatus.ready,
          snapshot: _mirrorCanonicalBalance(snapshot),
          history: history,
          clearError: true,
        );
      },
    );
  }

  Future<RewardOutcome?> grantFromEvent({
    required RewardTrigger trigger,
    required RewardTriggerData data,
  }) async {
    final Result<RewardOutcome> result = await _grantRewards(
      trigger: trigger,
      data: data,
      currentState: state.snapshot,
    );
    if (!mounted) return null;
    return result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return null;
      },
      onSuccess: (outcome) {
        state = state.copyWith(
          status: RewardsStatus.ready,
          snapshot: outcome.stateAfter,
          lastOutcome: outcome,
          history: <RewardHistoryEntry>[
            ...outcome.stateAfter.history,
          ],
          clearError: true,
        );
        unawaited(_creditCoinsFromOutcome(trigger, data, outcome));
        return outcome;
      },
    );
  }

  Future<RewardOutcome?> openChest(String chestId) async {
    final Result<RewardOutcome> result = await _openChest(
      chestId: chestId,
      currentState: state.snapshot,
    );
    if (!mounted) return null;
    return result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return null;
      },
      onSuccess: (outcome) {
        state = state.copyWith(
          status: RewardsStatus.ready,
          snapshot: outcome.stateAfter,
          lastOutcome: outcome,
          clearError: true,
        );
        unawaited(_creditCoinsFromOutcome(
          RewardTrigger.chestOpened,
          ChestOpenedData(chestId: chestId),
          outcome,
        ));
        return outcome;
      },
    );
  }

  Future<RewardOutcome?> claimDailyReward(int day) async {
    final Result<RewardOutcome> result = await _claimDaily(
      day: day,
      currentState: state.snapshot,
    );
    if (!mounted) return null;
    return result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return null;
      },
      onSuccess: (outcome) {
        state = state.copyWith(
          status: RewardsStatus.ready,
          snapshot: outcome.stateAfter,
          lastOutcome: outcome,
          clearError: true,
        );
        unawaited(_creditCoinsFromOutcome(
          RewardTrigger.dailyLogin,
          DailyLoginData(day: day, streakDays: state.snapshot.streak.currentDays),
          outcome,
        ));
        return outcome;
      },
    );
  }

  Future<void> toggleFavorite(String badgeId) async {
    final Result<bool> result = await _toggleFavorite(badgeId);
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      onSuccess: (_) {
        final UserRewardsState refreshed = state.snapshot.copyWith(
          badges: state.snapshot.badges
              .map((badge) => badge.id == badgeId
                  ? badge.copyWith(
                      isFavorite: !badge.isFavorite,
                    )
                  : badge)
              .toList(growable: false),
        );
        state = state.copyWith(snapshot: refreshed);
      },
    );
  }

  void clearOutcome() {
    if (state.lastOutcome == null && state.errorMessage == null) return;
    state = state.copyWith(clearOutcome: true, clearError: true);
  }

  UserRewardsState _mirrorCanonicalBalance(UserRewardsState snapshot) {
    final int canonicalCoins =
        _ref.read(profileControllerProvider).profile?.progression.coins ?? 0;
    return snapshot.copyWith(totalCoins: canonicalCoins);
  }

  Future<void> _creditCoinsFromOutcome(
    RewardTrigger trigger,
    RewardTriggerData data,
    RewardOutcome outcome,
  ) async {
    final CoinService coinService = _ref.read(coinServiceProvider);
    final List<_CoinGrant> grants = _resolveCoinGrants(trigger, data, outcome);
    for (final _CoinGrant grant in grants) {
      await coinService.grant(
        source: grant.source,
        sourceId: grant.sourceId,
        amount: grant.amount,
        reason: grant.reason,
        metadata: grant.metadata,
        type: CoinTransactionType.reward,
      );
    }
  }

  List<_CoinGrant> _resolveCoinGrants(
    RewardTrigger trigger,
    RewardTriggerData data,
    RewardOutcome outcome,
  ) {
    final List<_CoinGrant> grants = <_CoinGrant>[];
    for (final Reward reward in outcome.grants) {
      if (reward is CoinReward) {
        grants.add(_CoinGrant(
          source: _sourceForTrigger(trigger, data),
          sourceId: _sourceIdForTrigger(trigger, data, reward),
          amount: reward.amount,
          reason: reward.title,
          metadata: <String, dynamic>{
            'trigger': trigger.name,
            'rewardId': reward.id,
          },
        ));
      } else if (reward is DailyRewardEntry && reward.coins > 0) {
        grants.add(_CoinGrant(
          source: CoinTransactionSource.daily,
          sourceId: 'day-${reward.day}',
          amount: reward.coins,
          reason: reward.title,
          metadata: <String, dynamic>{
            'trigger': trigger.name,
            'day': reward.day,
          },
        ));
      }
    }
    return grants;
  }

  CoinTransactionSource _sourceForTrigger(
    RewardTrigger trigger,
    RewardTriggerData data,
  ) {
    switch (trigger) {
      case RewardTrigger.quizCompleted:
        return CoinTransactionSource.quiz;
      case RewardTrigger.missionCompleted:
        return CoinTransactionSource.mission;
      case RewardTrigger.dailyLogin:
        return CoinTransactionSource.daily;
      case RewardTrigger.chestOpened:
        return CoinTransactionSource.chest;
      case RewardTrigger.lessonCompleted:
        return CoinTransactionSource.lesson;
      case RewardTrigger.levelCompleted:
        return CoinTransactionSource.level;
      case RewardTrigger.badgeEarned:
        return CoinTransactionSource.badge;
    }
  }

  String _sourceIdForTrigger(
    RewardTrigger trigger,
    RewardTriggerData data,
    Reward reward,
  ) {
    switch (data) {
      case QuizCompletedData _:
        return 'reward-${reward.id}-${trigger.name}';
      case MissionCompletedData m:
        return m.missionId;
      case DailyLoginData d:
        return 'day-${d.day}';
      case ChestOpenedData c:
        return c.chestId;
      case LessonCompletedData l:
        return l.lessonId;
      case LevelCompletedData lvl:
        return lvl.levelId;
      case BadgeEarnedData b:
        return b.badgeId;
    }
  }
}

class _CoinGrant {
  const _CoinGrant({
    required this.source,
    required this.sourceId,
    required this.amount,
    required this.reason,
    required this.metadata,
  });

  final CoinTransactionSource source;
  final String sourceId;
  final int amount;
  final String reason;
  final Map<String, dynamic> metadata;
}

final rewardsControllerProvider =
    StateNotifierProvider<RewardsController, RewardsViewState>(
  (ref) => RewardsController(
    ref: ref,
    grantRewards: ref.watch(grantRewardsUseCaseProvider),
    openChest: ref.watch(openRewardChestUseCaseProvider),
    claimDaily: ref.watch(claimDailyRewardUseCaseProvider),
    loadState: ref.watch(loadRewardsStateUseCaseProvider),
    loadHistory: ref.watch(loadRewardHistoryUseCaseProvider),
    toggleFavorite: ref.watch(toggleBadgeFavoriteUseCaseProvider),
  ),
);

/// Convenience provider that exposes the live snapshot directly.
final rewardsSnapshotProvider = Provider<UserRewardsState>(
  (ref) => ref.watch(rewardsControllerProvider).snapshot,
);