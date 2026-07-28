import '../../../../shared/typedefs/result.dart';
import '../entities/streak_entity.dart';
import '../entities/streak_state.dart';
import '../enums/streak_enums.dart';
import '../value_objects/streak_bonus_result.dart';
import '../value_objects/streak_recovery_result.dart';

/// Storage contract for the streak feature.
///
/// Implementations are responsible for reset-on-load, recovery budget
/// tracking, and bonus-ledger persistence. The repository does **not**
/// dispatch into the rewards engine — the controller does that, via
/// the typed result objects returned by [recover] and [claimBonus].
abstract class StreakRepository {
  /// Returns the cached streak state, sweeping expired shields /
  /// recovery budgets as it loads.
  Future<Result<StreakState>> load();

  /// Persists today's claim — increments the streak, refreshes the
  /// best record, and consumes a shield if one was available. Returns
  /// the updated [StreakState].
  Future<Result<StreakState>> updateDaily();

  /// Returns the bonus ledger (daily / weekly / milestone rows).
  Future<Result<List<StreakEntity>>> loadBonusLedger();

  /// Pays for a streak recovery (coins or premium). The returned
  /// [StreakRecoveryResult] is the controller's ticket to render a
  /// celebration dialog and dispatch rewards.
  Future<Result<StreakRecoveryResult>> recover({required RecoveryMethod method});

  /// Claims a single bonus row. The returned [StreakBonusResult]
  /// describes what to grant and whether to celebrate.
  Future<Result<StreakBonusResult>> claimBonus({
    required int day,
    required StreakBonusType type,
  });
}