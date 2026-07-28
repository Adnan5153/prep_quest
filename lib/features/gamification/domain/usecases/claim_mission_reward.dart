import '../../../../shared/typedefs/result.dart';
import '../entities/mission_reward_entity.dart';
import '../repositories/mission_repository.dart';

/// Marks a completed mission as claimed and returns the promised
/// reward the controller hands to the rewards engine.
class ClaimMissionReward {
  const ClaimMissionReward(this._repository);

  final MissionRepository _repository;

  Future<Result<MissionRewardEntity>> call({required String missionId}) {
    return _repository.claim(missionId: missionId);
  }
}