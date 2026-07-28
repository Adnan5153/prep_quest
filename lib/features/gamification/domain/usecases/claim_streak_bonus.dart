import '../../../../shared/typedefs/result.dart';
import '../enums/streak_enums.dart';
import '../repositories/streak_repository.dart';
import '../value_objects/streak_bonus_result.dart';

/// Claims a single bonus row (daily / weekly / milestone) from the
/// streak-bonus ledger.
class ClaimStreakBonus {
  const ClaimStreakBonus(this._repository);

  final StreakRepository _repository;

  Future<Result<StreakBonusResult>> call({
    required int day,
    required StreakBonusType type,
  }) {
    return _repository.claimBonus(day: day, type: type);
  }
}