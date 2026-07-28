import '../../../../shared/typedefs/result.dart';
import '../entities/reward_outcome.dart';
import '../entities/user_rewards_state.dart';
import '../repositories/rewards_repository.dart';

/// Opens one of the user's chests and returns the rolled contents.
class OpenRewardChest {
  const OpenRewardChest(this._repository);

  final RewardsRepository _repository;

  Future<Result<RewardOutcome>> call({
    required String chestId,
    required UserRewardsState currentState,
  }) {
    return _repository.openChest(chestId: chestId, currentState: currentState);
  }
}