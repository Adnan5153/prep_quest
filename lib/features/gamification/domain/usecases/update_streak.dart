import '../../../../shared/typedefs/result.dart';
import '../entities/streak_state.dart';
import '../repositories/streak_repository.dart';

/// Increments the user's daily streak.
///
/// This usecase is the only place that mutates [StreakState] for
/// ordinary logins. The repository handles the date math (today,
/// missed, shield consumption); the controller hands the resulting
/// state's diff to the rewards engine for celebration.
class UpdateDailyStreak {
  const UpdateDailyStreak(this._repository);

  final StreakRepository _repository;

  Future<Result<StreakState>> call() => _repository.updateDaily();
}