import '../../../../shared/typedefs/result.dart';
import '../entities/user_rewards_state.dart';
import '../repositories/rewards_repository.dart';

/// Loads the aggregated rewards snapshot for the current user.
class LoadRewardsState {
  const LoadRewardsState(this._repository);

  final RewardsRepository _repository;

  Future<Result<UserRewardsState>> call() {
    return _repository.loadState();
  }
}