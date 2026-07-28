import '../../../../shared/typedefs/result.dart';
import '../entities/reward_event.dart';
import '../entities/reward_outcome.dart';
import '../enums/reward_enums.dart';
import '../entities/user_rewards_state.dart';
import '../repositories/rewards_repository.dart';

/// Routes a [RewardTrigger] through the reward engine and returns
/// the resulting [RewardOutcome].
class GrantRewards {
  const GrantRewards(this._repository);

  final RewardsRepository _repository;

  Future<Result<RewardOutcome>> call({
    required RewardTrigger trigger,
    required RewardTriggerData data,
    required UserRewardsState currentState,
  }) {
    return _repository.grantFromTrigger(
      trigger: trigger,
      data: data,
      currentState: currentState,
    );
  }
}