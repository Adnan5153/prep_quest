import '../../../../shared/typedefs/result.dart';
import '../entities/mission_progress_entity.dart';
import '../repositories/mission_repository.dart';

/// Adds `delta` to a mission's progress and returns the updated row.
class UpdateMissionProgress {
  const UpdateMissionProgress(this._repository);

  final MissionRepository _repository;

  Future<Result<MissionProgressEntity>> call({
    required String missionId,
    required int delta,
  }) {
    return _repository.updateProgress(missionId: missionId, delta: delta);
  }
}