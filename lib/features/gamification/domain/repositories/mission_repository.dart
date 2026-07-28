import '../../../../shared/typedefs/result.dart';
import '../entities/mission_entity.dart';
import '../entities/mission_progress_entity.dart';
import '../entities/mission_reward_entity.dart';
import '../enums/mission_enums.dart';

/// Snapshot returned by [MissionRepository.loadAll].
class MissionBundle {
  const MissionBundle({
    required this.daily,
    required this.weekly,
    required this.monthly,
    this.nextDailyReset,
    this.nextWeeklyReset,
    this.nextMonthlyReset,
  });

  final List<MissionEntity> daily;
  final List<MissionEntity> weekly;
  final List<MissionEntity> monthly;
  final DateTime? nextDailyReset;
  final DateTime? nextWeeklyReset;
  final DateTime? nextMonthlyReset;

  static const MissionBundle empty = MissionBundle(
    daily: <MissionEntity>[],
    weekly: <MissionEntity>[],
    monthly: <MissionEntity>[],
  );
}

/// Contract the data layer fulfils. The presentation layer only talks
/// to use cases — they wrap this interface.
abstract class MissionRepository {
  Future<Result<MissionBundle>> loadAll();
  Future<Result<MissionProgressEntity>> updateProgress({
    required String missionId,
    required int delta,
  });
  Future<Result<MissionRewardEntity>> claim({required String missionId});
  Future<Result<int>> resetExpired();

  /// Convenience helper exposed for tests and the controller —
  /// returns the missions for a specific cadence without loading the
  /// whole bundle.
  Future<Result<List<MissionEntity>>> loadByCadence(MissionCadence cadence);
}