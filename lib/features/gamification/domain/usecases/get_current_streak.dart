import '../../../../shared/typedefs/result.dart';
import '../entities/streak_state.dart';
import '../repositories/streak_repository.dart';

/// Reads the cached streak state — the controller uses this on init.
class GetCurrentStreak {
  const GetCurrentStreak(this._repository);

  final StreakRepository _repository;

  Future<Result<StreakState>> call() => _repository.load();
}