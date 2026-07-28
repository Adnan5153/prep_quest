import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/mission_local_datasource.dart';
import '../../data/datasources/mission_remote_datasource.dart';
import '../../data/repositories/mission_repository_impl.dart';
import '../../domain/entities/mission_entity.dart';
import '../../domain/entities/mission_progress_entity.dart';
import '../../domain/entities/mission_reward_entity.dart';
import '../../domain/entities/reward_event.dart';
import '../../domain/enums/mission_enums.dart';
import '../../domain/enums/reward_enums.dart';
import '../../domain/repositories/mission_repository.dart';
import '../../domain/services/mission_clock.dart';
import '../../domain/usecases/claim_mission_reward.dart';
import '../../domain/usecases/get_daily_missions.dart';
import '../../domain/usecases/get_monthly_missions.dart';
import '../../domain/usecases/get_weekly_missions.dart';
import '../../domain/usecases/reset_expired_missions.dart';
import '../../domain/usecases/update_mission_progress.dart';
import 'rewards_provider.dart';

/// Wall-clock source — overridden in tests.
final missionClockProvider = Provider<MissionClock>(
  (ref) => const SystemMissionClock(),
);

/// In-memory source of truth — overridden in tests.
final missionLocalDataSourceProvider = Provider<MissionLocalDataSource>(
  (ref) => MissionLocalDataSource(clock: ref.watch(missionClockProvider)),
);

/// Remote source — currently a no-op stub.
final missionRemoteDataSourceProvider = Provider<MissionRemoteDataSource>(
  (ref) => const MissionRemoteDataSource(),
);

/// Single repository the rest of the feature consumes.
final missionRepositoryProvider = Provider<MissionRepository>(
  (ref) => MissionRepositoryImpl(
    local: ref.watch(missionLocalDataSourceProvider),
    remote: ref.watch(missionRemoteDataSourceProvider),
  ),
);

final getDailyMissionsProvider = Provider<GetDailyMissions>(
  (ref) => GetDailyMissions(ref.watch(missionRepositoryProvider)),
);

final getWeeklyMissionsProvider = Provider<GetWeeklyMissions>(
  (ref) => GetWeeklyMissions(ref.watch(missionRepositoryProvider)),
);

final getMonthlyMissionsProvider = Provider<GetMonthlyMissions>(
  (ref) => GetMonthlyMissions(ref.watch(missionRepositoryProvider)),
);

final updateMissionProgressProvider = Provider<UpdateMissionProgress>(
  (ref) => UpdateMissionProgress(ref.watch(missionRepositoryProvider)),
);

final claimMissionRewardProvider = Provider<ClaimMissionReward>(
  (ref) => ClaimMissionReward(ref.watch(missionRepositoryProvider)),
);

final resetExpiredMissionsProvider = Provider<ResetExpiredMissions>(
  (ref) => ResetExpiredMissions(ref.watch(missionRepositoryProvider)),
);

/// View-state snapshot consumed by [MissionsController].
@immutable
class MissionsViewState {
  const MissionsViewState({
    required this.status,
    required this.daily,
    required this.weekly,
    required this.monthly,
    this.nextDailyReset,
    this.nextWeeklyReset,
    this.nextMonthlyReset,
    this.errorMessage,
    this.lastReward,
    this.lastRewardMissionTitle,
  });

  final MissionsStatus status;
  final List<MissionEntity> daily;
  final List<MissionEntity> weekly;
  final List<MissionEntity> monthly;
  final DateTime? nextDailyReset;
  final DateTime? nextWeeklyReset;
  final DateTime? nextMonthlyReset;
  final String? errorMessage;
  final MissionRewardEntity? lastReward;
  final String? lastRewardMissionTitle;

  bool get isLoading => status == MissionsStatus.loading;
  bool get isReady => status == MissionsStatus.ready;

  List<MissionEntity> get allMissions => <MissionEntity>[
        ...daily,
        ...weekly,
        ...monthly,
      ];

  int get totalCount => allMissions.length;
  int get completedCount =>
      allMissions.where((MissionEntity m) => m.isCompleted || m.isClaimed).length;

  int get dailyCompleted =>
      daily.where((MissionEntity m) => m.isCompleted || m.isClaimed).length;
  int get weeklyCompleted =>
      weekly.where((MissionEntity m) => m.isCompleted || m.isClaimed).length;
  int get monthlyCompleted =>
      monthly.where((MissionEntity m) => m.isCompleted || m.isClaimed).length;

  MissionsViewState copyWith({
    MissionsStatus? status,
    List<MissionEntity>? daily,
    List<MissionEntity>? weekly,
    List<MissionEntity>? monthly,
    DateTime? nextDailyReset,
    DateTime? nextWeeklyReset,
    DateTime? nextMonthlyReset,
    String? errorMessage,
    bool clearError = false,
    MissionRewardEntity? lastReward,
    String? lastRewardMissionTitle,
    bool clearReward = false,
  }) {
    return MissionsViewState(
      status: status ?? this.status,
      daily: daily ?? this.daily,
      weekly: weekly ?? this.weekly,
      monthly: monthly ?? this.monthly,
      nextDailyReset: nextDailyReset ?? this.nextDailyReset,
      nextWeeklyReset: nextWeeklyReset ?? this.nextWeeklyReset,
      nextMonthlyReset: nextMonthlyReset ?? this.nextMonthlyReset,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastReward: clearReward ? null : (lastReward ?? this.lastReward),
      lastRewardMissionTitle: clearReward
          ? null
          : (lastRewardMissionTitle ?? this.lastRewardMissionTitle),
    );
  }

  static const MissionsViewState initial = MissionsViewState(
    status: MissionsStatus.initial,
    daily: <MissionEntity>[],
    weekly: <MissionEntity>[],
    monthly: <MissionEntity>[],
  );
}

enum MissionsStatus { initial, loading, ready, error }

/// State notifier for the daily-missions screen.
///
/// Owns loading, sweep-on-load, progress updates and the user-driven
/// claim flow. Reward grants are dispatched into [RewardsController]
/// so the existing reward engine remains the single source of truth.
class MissionsController extends StateNotifier<MissionsViewState> {
  MissionsController({
    required GetDailyMissions getDaily,
    required GetWeeklyMissions getWeekly,
    required GetMonthlyMissions getMonthly,
    required UpdateMissionProgress updateProgress,
    required ClaimMissionReward claimReward,
    required ResetExpiredMissions resetExpired,
    required this.ref,
  })  : _getDaily = getDaily,
        _getWeekly = getWeekly,
        _getMonthly = getMonthly,
        _updateProgress = updateProgress,
        _claimReward = claimReward,
        _resetExpired = resetExpired,
        super(MissionsViewState.initial);

  final GetDailyMissions _getDaily;
  final GetWeeklyMissions _getWeekly;
  final GetMonthlyMissions _getMonthly;
  final UpdateMissionProgress _updateProgress;
  final ClaimMissionReward _claimReward;
  final ResetExpiredMissions _resetExpired;
  final Ref ref;

  Future<void> load() async {
    state = state.copyWith(status: MissionsStatus.loading, clearError: true);
    final List<Result<List<MissionEntity>>> results =
        await Future.wait<Result<List<MissionEntity>>>(<Future<
            Result<List<MissionEntity>>>>[
      _getDaily(),
      _getWeekly(),
      _getMonthly(),
    ]);
    if (!mounted) return;
    final Result<List<MissionEntity>> firstFailure = results.firstWhere(
      (Result<List<MissionEntity>> r) => r.isFailure,
      orElse: () => Result.success(<MissionEntity>[]),
    );
    if (firstFailure.isFailure) {
      state = state.copyWith(
        status: MissionsStatus.error,
        errorMessage: firstFailure.failureOrNull?.message ?? 'Unknown error',
      );
      return;
    }
    final DateTime now = DateTime.now();
    state = state.copyWith(
      status: MissionsStatus.ready,
      daily: results[0].valueOrNull ?? <MissionEntity>[],
      weekly: results[1].valueOrNull ?? <MissionEntity>[],
      monthly: results[2].valueOrNull ?? <MissionEntity>[],
      nextDailyReset: _computeReset(MissionCadence.daily, now),
      nextWeeklyReset: _computeReset(MissionCadence.weekly, now),
      nextMonthlyReset: _computeReset(MissionCadence.monthly, now),
      clearError: true,
    );
  }

  Future<void> incrementProgress({
    required String missionId,
    int delta = 1,
  }) async {
    final Result<MissionProgressEntity> result =
        await _updateProgress(missionId: missionId, delta: delta);
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      onSuccess: (_) => _refreshFromRepositories(),
    );
  }

  Future<void> claim(String missionId) async {
    final MissionEntity? previous = _findById(missionId);
    if (previous == null) return;
    final Result<MissionRewardEntity> result =
        await _claimReward(missionId: missionId);
    if (!mounted) return;
    await result.fold<Future<void>>(
      onFailure: (failure) async {
        state = state.copyWith(errorMessage: failure.message);
      },
      onSuccess: (reward) async {
        state = state.copyWith(
          lastReward: reward,
          lastRewardMissionTitle: previous.title,
          clearError: true,
        );
        await ref.read(rewardsControllerProvider.notifier).grantFromEvent(
              trigger: RewardTrigger.missionCompleted,
              data: MissionCompletedData(
                missionId: missionId,
                objectivesCompleted: previous.goal,
                totalObjectives: previous.goal,
              ),
            );
        await _refreshFromRepositories();
      },
    );
  }

  Future<void> resetExpired() async {
    final Result<int> result = await _resetExpired();
    if (!mounted) return;
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      onSuccess: (_) => _refreshFromRepositories(),
    );
  }

  void clearReward() {
    if (state.lastReward == null) return;
    state = state.copyWith(clearReward: true);
  }

  Future<void> _refreshFromRepositories() async {
    final List<Result<List<MissionEntity>>> results =
        await Future.wait<Result<List<MissionEntity>>>(<Future<
            Result<List<MissionEntity>>>>[
      _getDaily(),
      _getWeekly(),
      _getMonthly(),
    ]);
    if (!mounted) return;
    state = state.copyWith(
      status: MissionsStatus.ready,
      daily: results[0].valueOrNull ?? state.daily,
      weekly: results[1].valueOrNull ?? state.weekly,
      monthly: results[2].valueOrNull ?? state.monthly,
      clearError: true,
    );
  }

  MissionEntity? _findById(String missionId) {
    for (final MissionEntity m in state.allMissions) {
      if (m.id == missionId) return m;
    }
    return null;
  }

  DateTime _computeReset(MissionCadence cadence, DateTime now) {
    switch (cadence) {
      case MissionCadence.daily:
        final DateTime midnight = DateTime(now.year, now.month, now.day);
        return midnight.isAfter(now)
            ? midnight
            : midnight.add(const Duration(days: 1));
      case MissionCadence.weekly:
        final DateTime today = DateTime(now.year, now.month, now.day);
        final int daysUntilMonday = (DateTime.monday - today.weekday) % 7;
        return today.add(
          Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday),
        );
      case MissionCadence.monthly:
        return now.month == 12
            ? DateTime(now.year + 1, 1)
            : DateTime(now.year, now.month + 1);
    }
  }
}

final missionsControllerProvider =
    StateNotifierProvider<MissionsController, MissionsViewState>(
  (ref) => MissionsController(
    getDaily: ref.watch(getDailyMissionsProvider),
    getWeekly: ref.watch(getWeeklyMissionsProvider),
    getMonthly: ref.watch(getMonthlyMissionsProvider),
    updateProgress: ref.watch(updateMissionProgressProvider),
    claimReward: ref.watch(claimMissionRewardProvider),
    resetExpired: ref.watch(resetExpiredMissionsProvider),
    ref: ref,
  ),
);

/// Convenience provider exposing the live snapshot directly.
final missionsSnapshotProvider = Provider<MissionsViewState>(
  (ref) => ref.watch(missionsControllerProvider),
);