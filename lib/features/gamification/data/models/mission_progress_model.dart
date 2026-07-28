import '../../domain/entities/mission_progress_entity.dart';

/// Persistence mirror of [MissionProgressEntity]. Kept separate from
/// the entity so domain types stay free of JSON-shaped concerns.
class MissionProgressModel {
  const MissionProgressModel({
    required this.missionId,
    required this.currentValue,
    required this.targetValue,
    required this.updatedAtIso,
    this.claimedAtIso,
  });

  final String missionId;
  final int currentValue;
  final int targetValue;
  final String updatedAtIso;
  final String? claimedAtIso;

  MissionProgressEntity toEntity() {
    return MissionProgressEntity(
      missionId: missionId,
      currentValue: currentValue,
      targetValue: targetValue,
      updatedAtIso: updatedAtIso,
      claimedAtIso: claimedAtIso,
    );
  }

  static MissionProgressModel fromEntity(MissionProgressEntity entity) {
    return MissionProgressModel(
      missionId: entity.missionId,
      currentValue: entity.currentValue,
      targetValue: entity.targetValue,
      updatedAtIso: entity.updatedAtIso,
      claimedAtIso: entity.claimedAtIso,
    );
  }
}