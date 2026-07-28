import '../../domain/entities/mission_reward_entity.dart';

/// Persistence mirror of [MissionRewardEntity].
class MissionRewardModel {
  const MissionRewardModel({
    required this.xp,
    required this.coins,
    required this.energy,
    this.badgeId,
    this.chestId,
    this.specialKey,
  });

  final int xp;
  final int coins;
  final int energy;
  final String? badgeId;
  final String? chestId;
  final String? specialKey;

  MissionRewardEntity toEntity() {
    return MissionRewardEntity(
      xp: xp,
      coins: coins,
      energy: energy,
      badgeId: badgeId,
      chestId: chestId,
      specialKey: specialKey,
    );
  }

  static MissionRewardModel fromEntity(MissionRewardEntity entity) {
    return MissionRewardModel(
      xp: entity.xp,
      coins: entity.coins,
      energy: entity.energy,
      badgeId: entity.badgeId,
      chestId: entity.chestId,
      specialKey: entity.specialKey,
    );
  }
}