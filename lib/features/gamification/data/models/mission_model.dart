import '../../domain/entities/mission_entity.dart';
import '../../domain/enums/mission_enums.dart';

/// JSON-ready persistence shape for [MissionEntity].
///
/// Stored by [MissionLocalDataSource]; the entity is the only object
/// exposed to the rest of the app so domain and presentation stay free
/// of data-layer concerns.
class MissionModel {
  const MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.cadenceId,
    required this.statusId,
    required this.progress,
    required this.goal,
    required this.rewardXp,
    required this.rewardCoins,
    required this.rewardEnergy,
    required this.expiresAtIso,
    this.rewardBadgeId,
    this.rewardChestId,
    this.specialKey,
  });

  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String cadenceId;
  final String statusId;
  final int progress;
  final int goal;
  final int rewardXp;
  final int rewardCoins;
  final int rewardEnergy;
  final String expiresAtIso;
  final String? rewardBadgeId;
  final String? rewardChestId;
  final String? specialKey;

  MissionEntity toEntity() {
    return MissionEntity(
      id: id,
      title: title,
      description: description,
      category: _categoryFromId(categoryId),
      cadence: _cadenceFromId(cadenceId),
      status: _statusFromId(statusId),
      progress: progress,
      goal: goal,
      rewardXp: rewardXp,
      rewardCoins: rewardCoins,
      rewardEnergy: rewardEnergy,
      expiresAtIso: expiresAtIso,
      rewardBadgeId: rewardBadgeId,
      rewardChestId: rewardChestId,
      specialKey: specialKey,
    );
  }

  static MissionModel fromEntity(MissionEntity entity) {
    return MissionModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      categoryId: entity.category.name,
      cadenceId: entity.cadence.name,
      statusId: entity.status.name,
      progress: entity.progress,
      goal: entity.goal,
      rewardXp: entity.rewardXp,
      rewardCoins: entity.rewardCoins,
      rewardEnergy: entity.rewardEnergy,
      expiresAtIso: entity.expiresAtIso,
      rewardBadgeId: entity.rewardBadgeId,
      rewardChestId: entity.rewardChestId,
      specialKey: entity.specialKey,
    );
  }

  static MissionCategory _categoryFromId(String id) {
    for (final MissionCategory c in MissionCategory.values) {
      if (c.name == id) return c;
    }
    return MissionCategory.mixed;
  }

  static MissionCadence _cadenceFromId(String id) {
    for (final MissionCadence c in MissionCadence.values) {
      if (c.name == id) return c;
    }
    return MissionCadence.daily;
  }

  static MissionStatus _statusFromId(String id) {
    for (final MissionStatus s in MissionStatus.values) {
      if (s.name == id) return s;
    }
    return MissionStatus.available;
  }
}