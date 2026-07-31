import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/mission_progress_attempt.dart';
import '../../../../core/services/mission_progress_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/mission_local_datasource.dart';
import '../../data/datasources/mission_remote_datasource.dart';
import '../../data/repositories/mission_repository_impl.dart';
import '../../domain/entities/mission_entity.dart';
import '../../domain/entities/mission_progress_entity.dart';
import '../../domain/entities/mission_reward_entity.dart';
import '../../domain/entities/mission_summary_entity.dart';
import '../../domain/enums/mission_enums.dart';
import '../../domain/enums/reward_enums.dart';
import '../../domain/repositories/mission_repository.dart';
import '../../domain/services/mission_clock.dart';
import '../../domain/entities/reward_event.dart';
import '../../domain/repositories/mission_progress_repository.dart';
import '../../domain/usecases/claim_mission_reward.dart';
import '../../domain/usecases/get_daily_missions.dart';
import '../../domain/usecases/get_monthly_missions.dart';
import '../../domain/usecases/get_weekly_missions.dart';
import '../../domain/usecases/reset_expired_missions.dart';
import '../../domain/usecases/update_mission_progress.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
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
    this.summaries = const <String, MissionSummaryEntity>{},
    this.totalCompleted = 0,
    this.totalStars = 0,
    this.bestScoreOverall = 0,
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
  final Map<String, MissionSummaryEntity> summaries;
  final int totalCompleted;
  final int totalStars;
  final int bestScoreOverall;
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

  int get completedCount => allMissions
      .where((MissionEntity m) => _isMissionCompleted(m))
      .length;

  int get dailyCompleted => daily
      .where((MissionEntity m) => _isMissionCompleted(m))
      .length;
  int get weeklyCompleted => weekly
      .where((MissionEntity m) => _isMissionCompleted(m))
      .length;
  int get monthlyCompleted => monthly
      .where((MissionEntity m) => _isMissionCompleted(m))
      .length;

  bool _isMissionCompleted(MissionEntity m) {
    final MissionSummaryEntity? summary = summaries[m.id];
    if (summary != null) {
      return summary.isCompleted;
    }
    return m.isCompleted || m.isClaimed;
  }

  /// Returns the summary for a mission, or falls back to the catalog
  /// `progress` value when no realtime snapshot has arrived yet.
  int effectiveProgress(MissionEntity mission) {
    final MissionSummaryEntity? summary = summaries[mission.id];
    if (summary != null && summary.totalCompleted > 0) {
      return mission.goal;
    }
    return mission.progress;
  }

  /// Returns the live completion status for [mission] — the
  /// realtime summary wins, otherwise the catalog status is returned.
  MissionCompletionStatus completionStatus(MissionEntity mission) {
    final MissionSummaryEntity? summary = summaries[mission.id];
    return summary?.completionStatus ?? _statusFromCatalog(mission.status);
  }

  static MissionCompletionStatus _statusFromCatalog(MissionStatus s) {
    switch (s) {
      case MissionStatus.locked:
        return MissionCompletionStatus.locked;
      case MissionStatus.available:
      case MissionStatus.inProgress:
        return MissionCompletionStatus.started;
      case MissionStatus.completed:
        return MissionCompletionStatus.completed;
      case MissionStatus.claimed:
        return MissionCompletionStatus.completed;
      case MissionStatus.expired:
        return MissionCompletionStatus.expired;
    }
  }

  /// Returns the live best score for [mission], or 0 if no attempt
  /// has been recorded yet.
  int bestScore(MissionEntity mission) {
    return summaries[mission.id]?.bestScore ?? 0;
  }

  /// Returns the live stars for [mission], or 0 if no attempt has
  /// been recorded yet.
  int stars(MissionEntity mission) {
    return summaries[mission.id]?.stars ?? 0;
  }

  MissionsViewState copyWith({
    MissionsStatus? status,
    List<MissionEntity>? daily,
    List<MissionEntity>? weekly,
    List<MissionEntity>? monthly,
    Map<String, MissionSummaryEntity>? summaries,
    int? totalCompleted,
    int? totalStars,
    int? bestScoreOverall,
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
      summaries: summaries ?? this.summaries,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      totalStars: totalStars ?? this.totalStars,
      bestScoreOverall: bestScoreOverall ?? this.bestScoreOverall,
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
/// Owns loading, sweep-on-load, progress updates, the user-driven
/// claim flow, and the realtime summary subscription. Reward grants
/// are dispatched into [RewardsController] so the existing reward
/// engine remains the single source of truth.
class MissionsController extends StateNotifier<MissionsViewState> {
  MissionsController({
    required GetDailyMissions getDaily,
    required GetWeeklyMissions getWeekly,
    required GetMonthlyMissions getMonthly,
    required UpdateMissionProgress updateProgress,
    required ClaimMissionReward claimReward,
    required ResetExpiredMissions resetExpired,
    required this.ref,
    MissionProgressService? progressService,
  })  : _getDaily = getDaily,
        _getWeekly = getWeekly,
        _getMonthly = getMonthly,
        _updateProgress = updateProgress,
        _claimReward = claimReward,
        _resetExpired = resetExpired,
        _progressService = progressService,
        super(MissionsViewState.initial) {
    _subscribeSummaries();
  }

  final GetDailyMissions _getDaily;
  final GetWeeklyMissions _getWeekly;
  final GetMonthlyMissions _getMonthly;
  final UpdateMissionProgress _updateProgress;
  final ClaimMissionReward _claimReward;
  final ResetExpiredMissions _resetExpired;
  final MissionProgressService? _progressService;
  final Ref ref;

  StreamSubscription<List<MissionSummaryEntity>>? _summarySub;
  String _watchedUid = '';

  void _subscribeSummaries() {
    final auth = ref.read(authStateProvider);
    final String uid = auth.user?.id ?? '';
    if (uid == _watchedUid) return;
    _watchedUid = uid;
    _summarySub?.cancel();
    if (uid.isEmpty) {
      state = state.copyWith(
        summaries: const <String, MissionSummaryEntity>{},
        totalCompleted: 0,
        totalStars: 0,
        bestScoreOverall: 0,
      );
      return;
    }
    final MissionProgressService service =
        _progressService ?? ref.read(missionProgressServiceProvider);
    _summarySub = service.watch(uid).listen(
      (List<MissionSummaryEntity> rows) {
        final MissionProgressBundle bundle = _bundleFrom(rows);
        final Map<String, MissionSummaryEntity> byId =
            <String, MissionSummaryEntity>{
          for (final MissionSummaryEntity s in bundle.summaries) s.missionId: s,
        };
        state = state.copyWith(
          summaries: byId,
          totalCompleted: bundle.totalCompleted,
          totalStars: bundle.totalStars,
          bestScoreOverall: bundle.bestScoreOverall,
        );
      },
    );
  }

  @override
  void dispose() {
    _summarySub?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    state = state.copyWith(status: MissionsStatus.loading, clearError: true);
    _subscribeSummaries();
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

  /// Records a quiz completion attempt against the matching
  /// mission(s) and updates the user's realtime summary. No-op
  /// when there is no authenticated user (mirrors the local
  /// catalog progress so the UI stays consistent).
  Future<void> recordQuizAttempt({
    required String sessionId,
    required int score,
    required MissionCategory category,
    String? quizId,
    DateTime? completedAtIso,
  }) async {
    final String uid = ref.read(authStateProvider).user?.id ?? '';
    if (uid.isEmpty) {
      // Guest path — no Firestore write, but increment the local
      // catalog progress so the UI still reflects the attempt.
      await _incrementLocalCatalogProgress(
        category: category,
        sessionId: sessionId,
        score: score,
      );
      return;
    }
    final MissionProgressService service =
        _progressService ?? ref.read(missionProgressServiceProvider);
    final List<MissionEntity> candidates = _matchableMissions(category);
    if (candidates.isEmpty) return;
    final DateTime stamp = completedAtIso ?? DateTime.now().toUtc();
    for (final MissionEntity mission in candidates) {
      final MissionProgressAttempt attempt = MissionProgressAttempt(
        sessionId: sessionId,
        score: score,
        achievedGoal: mission.isCompleted,
        completedAtIso: stamp.toIso8601String(),
        metadata: <String, dynamic>{
          'quizId': quizId,
          'categoryId': category.name,
        },
      );
      await service.recordAttempt(
        uid: uid,
        mission: mission,
        attempt: attempt,
      );
    }
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
        final String uid = ref.read(authStateProvider).user?.id ?? '';
        if (uid.isNotEmpty) {
          final MissionProgressService service =
              _progressService ?? ref.read(missionProgressServiceProvider);
          await service.markRewardsClaimed(uid: uid, missionId: missionId);
        }
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

  Future<void> _incrementLocalCatalogProgress({
    required MissionCategory category,
    required String sessionId,
    required int score,
  }) async {
    final List<MissionEntity> candidates = _matchableMissions(category);
    for (final MissionEntity mission in candidates) {
      final bool wasCompleted = mission.isCompleted;
      if (mission.isClaimed || mission.expiresAtIso.isEmpty) continue;
      final int nextProgress = (mission.progress + 1).clamp(0, mission.goal);
      final MissionStatus nextStatus = nextProgress >= mission.goal
          ? MissionStatus.completed
          : (nextProgress > 0
              ? MissionStatus.inProgress
              : MissionStatus.available);
      final MissionEntity updated = mission.copyWith(
        progress: nextProgress,
        status: nextStatus,
      );
      // Update the in-memory state with the synthesized mission.
      state = _replaceMission(state, updated);
      if (wasCompleted) continue;
    }
  }

  List<MissionEntity> _matchableMissions(MissionCategory category) {
    final List<MissionEntity> all = <MissionEntity>[
      ...state.daily,
      ...state.weekly,
      ...state.monthly,
    ];
    return all.where((MissionEntity m) {
      if (m.category != category) return false;
      if (m.isClaimed || m.isExpired) return false;
      // Only auto-record on missions this session hasn't already
      // resolved — replays of the same sessionId are deduped server-side.
      return true;
    }).toList(growable: false);
  }

  MissionsViewState _replaceMission(
    MissionsViewState current,
    MissionEntity updated,
  ) {
    List<MissionEntity> replaceIn(
      List<MissionEntity> list,
      MissionEntity replacement,
    ) {
      return list
          .map((MissionEntity m) => m.id == replacement.id ? replacement : m)
          .toList(growable: false);
    }

    return current.copyWith(
      daily: replaceIn(current.daily, updated),
      weekly: replaceIn(current.weekly, updated),
      monthly: replaceIn(current.monthly, updated),
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

/// Provider exposing the realtime progress bundle independently of
/// the controller's view state. Useful for widgets that only need
/// aggregate counters (dashboard, profile stats, achievements hub).
final missionProgressBundleProvider =
    Provider<MissionProgressBundle>((ref) {
  final async = ref.watch(_missionProgressBundleStreamProvider);
  return async.maybeWhen(
    data: (MissionProgressBundle value) => value,
    orElse: () => MissionProgressBundle.empty,
  );
});

final _missionProgressBundleStreamProvider =
    StreamProvider<MissionProgressBundle>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<MissionProgressBundle>.value(MissionProgressBundle.empty);
  }
  final MissionProgressService service =
      ref.watch(missionProgressServiceProvider);
  return service.watch(uid).map((List<MissionSummaryEntity> rows) {
    return _bundleFrom(rows);
  });
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
