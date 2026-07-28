import '../../../../shared/typedefs/result.dart';
import '../entities/reward_outcome.dart';
import '../entities/user_rewards_state.dart';
import '../repositories/rewards_repository.dart';

/// Claims the reward for the requested daily-rewards calendar day.
class ClaimDailyReward {
  const ClaimDailyReward(this._repository);

  final RewardsRepository _repository;

  Future<Result<RewardOutcome>> call({
    required int day,
    required UserRewardsState currentState,
  }) {
    return _repository.claimDailyReward(day: day, currentState: currentState);
  }
}