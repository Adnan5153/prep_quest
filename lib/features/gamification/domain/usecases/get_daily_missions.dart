import '../../../../shared/typedefs/result.dart';
import '../entities/mission_entity.dart';
import '../enums/mission_enums.dart';
import '../repositories/mission_repository.dart';

/// Loads only the daily-cadence missions.
class GetDailyMissions {
  const GetDailyMissions(this._repository);

  final MissionRepository _repository;

  Future<Result<List<MissionEntity>>> call() {
    return _repository.loadByCadence(MissionCadence.daily);
  }
}