import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/streak_local_datasource.dart';
import '../../data/datasources/streak_remote_datasource.dart';
import '../../data/repositories/streak_repository_impl.dart';
import '../../data/repositories/streak_bonus_catalog.dart';
import '../../domain/entities/reward_event.dart';
import '../../domain/entities/reward_outcome.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/entities/streak_state.dart';
import '../../domain/enums/reward_enums.dart';
import '../../domain/enums/streak_enums.dart';
import '../../domain/repositories/streak_repository.dart';
import '../../domain/usecases/claim_streak_bonus.dart';
import '../../domain/usecases/get_current_streak.dart';
import '../../domain/usecases/recover_streak.dart';
import '../../domain/usecases/update_streak.dart';
import '../../domain/value_objects/streak_bonus_result.dart';
import '../../domain/value_objects/streak_recovery_result.dart';
import 'rewards_provider.dart';

/// Provides the in-memory datasource. Overridden in tests.
final streakLocalDataSourceProvider = Provider<StreakLocalDataSource>(
  (ref) => StreakLocalDataSource(),
);

/// Optional remote datasource (Firestore seam). Tests can override
/// to force the remote path.
final streakRemoteDataSourceProvider = Provider<StreakRemoteDataSource>(
  (ref) => const StreakRemoteDataSource(),
);

/// Single repository the entire feature consumes.
final streakRepositoryProvider = Provider<StreakRepository>(
  (ref) => StreakRepositoryImpl(
    local: ref.watch(streakLocalDataSourceProvider),
    remote: ref.watch(streakRemoteDataSourceProvider),
  ),
);

final getCurrentStreakUseCaseProvider = Provider<GetCurrentStreak>(
  (ref) => GetCurrentStreak(ref.watch(streakRepositoryProvider)),
);

final updateDailyStreakUseCaseProvider = Provider<UpdateDailyStreak>(
  (ref) => UpdateDailyStreak(ref.watch(streakRepositoryProvider)),
);

final recoverStreakUseCaseProvider = Provider<RecoverStreak>(
  (ref) => RecoverStreak(ref.watch(streakRepositoryProvider)),
);

final claimStreakBonusUseCaseProvider = Provider<ClaimStreakBonus>(
  (ref) => ClaimStreakBonus(ref.watch(streakRepositoryProvider)),
);

/// Top-level snapshot surfaced by the controller.
@immutable
class StreakViewState {
  const StreakViewState({
    required this.status,
    required this.snapshot,
    this.bonusLedger = const <StreakEntity>[],
    this.lastOutcome,
    this.errorMessage,
  });

  final StreakStatus status;
  final StreakState snapshot;
  final List<StreakEntity> bonusLedger;
  final RewardOutcome? lastOutcome;
  final String? errorMessage;

  bool get isLoading => status == StreakStatus.loading;
  bool get isReady => status == StreakStatus.ready;

  StreakViewState copyWith({
    StreakStatus? status,
    StreakState? snapshot,
    List<StreakEntity>? bonusLedger,
    RewardOutcome? lastOutcome,
    bool clearOutcome = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StreakViewState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      bonusLedger: bonusLedger ?? this.bonusLedger,
      lastOutcome: clearOutcome ? null : (lastOutcome ?? this.lastOutcome),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static final StreakViewState initial = StreakViewState(
    status: StreakStatus.initial,
    snapshot: const StreakState(
      currentDays: 0,
      bestDays: 0,
      lastClaimedAtIso: '',
      shieldCharges: 2,
    ),
    bonusLedger: const <StreakEntity>[],
  );
}

enum StreakStatus { initial, loading, ready, error }

/// State notifier for the streak feature.
///
/// Widgets subscribe to [streakControllerProvider] for the live
/// snapshot; they call methods on the notifier to mutate state. The
/// controller is the only place that talks to the use cases and to
/// the rewards engine.
class StreakController extends StateNotifier<StreakViewState> {
  StreakController({
    required GetCurrentStreak getCurrentStreak,
    required UpdateDailyStreak updateDailyStreak,
    required RecoverStreak recoverStreak,
    required ClaimStreakBonus claimStreakBonus,
    required RewardsController rewardsController,
    required StreakRepository repository,
  })  : _getCurrentStreak = getCurrentStreak,
        _updateDailyStreak = updateDailyStreak,
        _recoverStreak = recoverStreak,
        _claimStreakBonus = claimStreakBonus,
        _rewardsController = rewardsController,
        _repository = repository,
        super(StreakViewState.initial);

  final GetCurrentStreak _getCurrentStreak;
  final UpdateDailyStreak _updateDailyStreak;
  final RecoverStreak _recoverStreak;
  final ClaimStreakBonus _claimStreakBonus;
  final RewardsController _rewardsController;
  final StreakRepository _repository;

  Future<void> load() async {
    state = state.copyWith(status: StreakStatus.loading, clearError: true);
    final Result<StreakState> streakResult = await _getCurrentStreak();
    final Result<List<StreakEntity>> ledgerResult =
        await _repository.loadBonusLedger();
    if (!mounted) return;
    streakResult.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: StreakStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (snapshot) {
        state = state.copyWith(
          status: StreakStatus.ready,
          snapshot: snapshot,
          bonusLedger: ledgerResult.fold(
            onFailure: (_) => const <StreakEntity>[],
            onSuccess: (rows) => rows,
          ),
          clearError: true,
        );
      },
    );
  }

  Future<RewardOutcome?> claimToday() async {
    final Result<StreakState> result = await _updateDailyStreak();
    if (!mounted) return null;
    return result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return null;
      },
      onSuccess: (snapshot) async {
        state = state.copyWith(
          status: StreakStatus.ready,
          snapshot: snapshot,
          clearError: true,
        );
        final RewardOutcome? outcome =
            await _rewardsController.grantFromEvent(
          trigger: RewardTrigger.dailyLogin,
          data: DailyLoginData(
            day: snapshot.currentDays,
            streakDays: snapshot.currentDays,
          ),
        );
        if (outcome != null && mounted) {
          state = state.copyWith(lastOutcome: outcome);
        }
        return outcome;
      },
    );
  }

  Future<RewardOutcome?> recover({required RecoveryMethod method}) async {
    final Result<StreakRecoveryResult> result =
        await _recoverStreak(method: method);
    if (!mounted) return null;
    return result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return null;
      },
      onSuccess: (recovery) async {
        state = state.copyWith(
          status: StreakStatus.ready,
          snapshot: recovery.state,
          clearError: true,
        );
        final RewardOutcome? outcome =
            await _rewardsController.grantFromEvent(
          trigger: RewardTrigger.dailyLogin,
          data: DailyLoginData(
            day: recovery.state.currentDays,
            streakDays: recovery.state.currentDays,
          ),
        );
        if (outcome != null && mounted) {
          state = state.copyWith(lastOutcome: outcome);
        }
        return outcome;
      },
    );
  }

  Future<RewardOutcome?> claimBonus({
    required int day,
    required StreakBonusType type,
  }) async {
    final Result<StreakBonusResult> result =
        await _claimStreakBonus(day: day, type: type);
    if (!mounted) return null;
    return result.fold(
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return null;
      },
      onSuccess: (bonus) async {
        final List<StreakEntity> ledger = state.bonusLedger
            .map((StreakEntity e) => e.id == bonus.bonus.id ? bonus.bonus : e)
            .toList(growable: false);
        state = state.copyWith(
          status: StreakStatus.ready,
          bonusLedger: ledger,
          clearError: true,
        );
        if (bonus.badgeId != null) {
          final RewardOutcome? outcome =
              await _rewardsController.grantFromEvent(
            trigger: RewardTrigger.badgeEarned,
            data: BadgeEarnedData(badgeId: bonus.badgeId!),
          );
          if (outcome != null && mounted) {
            state = state.copyWith(lastOutcome: outcome);
          }
          return outcome;
        }
        return null;
      },
    );
  }

  void clearOutcome() {
    if (state.lastOutcome == null && state.errorMessage == null) return;
    state = state.copyWith(clearOutcome: true, clearError: true);
  }
}

final streakControllerProvider =
    StateNotifierProvider<StreakController, StreakViewState>(
  (ref) => StreakController(
    getCurrentStreak: ref.watch(getCurrentStreakUseCaseProvider),
    updateDailyStreak: ref.watch(updateDailyStreakUseCaseProvider),
    recoverStreak: ref.watch(recoverStreakUseCaseProvider),
    claimStreakBonus: ref.watch(claimStreakBonusUseCaseProvider),
    rewardsController: ref.watch(rewardsControllerProvider.notifier),
    repository: ref.watch(streakRepositoryProvider),
  ),
);

/// Convenience provider that exposes the live snapshot directly.
final streakSnapshotProvider = Provider<StreakState>(
  (ref) => ref.watch(streakControllerProvider).snapshot,
);

/// Re-export the catalog for any screen that needs a static lookup.
const StreakBonusCatalog kStreakBonusCatalog = StreakBonusCatalog();

// Internal — public so widgets can subscribe to ledger-only refreshes.
typedef StreakBonusLedgerProvider = AutoDisposeFutureProvider<List<StreakEntity>>;