import '../../../../shared/typedefs/result.dart';
import '../enums/streak_enums.dart';
import '../repositories/streak_repository.dart';
import '../value_objects/streak_recovery_result.dart';

/// Pays the recovery price (coins or premium) and resets the user's
/// streak to day-1. Returns a [StreakRecoveryResult] the controller
/// passes to the rewards engine for celebration.
class RecoverStreak {
  const RecoverStreak(this._repository);

  final StreakRepository _repository;

  Future<Result<StreakRecoveryResult>> call({required RecoveryMethod method}) {
    return _repository.recover(method: method);
  }
}