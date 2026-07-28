import 'package:flutter/foundation.dart';

import '../enums/mission_enums.dart';

/// One mission a user can complete during a fixed window.
@immutable
class MissionEntity {
  const MissionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.cadence,
    required this.status,
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
  final MissionCategory category;
  final MissionCadence cadence;
  final MissionStatus status;
  final int progress;
  final int goal;
  final int rewardXp;
  final int rewardCoins;
  final int rewardEnergy;
  final String expiresAtIso;
  final String? rewardBadgeId;
  final String? rewardChestId;
  final String? specialKey;

  double get ratio => goal <= 0 ? 1.0 : (progress / goal).clamp(0.0, 1.0);

  bool get isCompleted => progress >= goal && goal > 0;
  bool get isClaimable => status == MissionStatus.completed;
  bool get isLocked => status == MissionStatus.locked;
  bool get isClaimed => status == MissionStatus.claimed;
  bool get isExpired => status == MissionStatus.expired;

  MissionEntity copyWith({
    MissionStatus? status,
    int? progress,
    String? expiresAtIso,
  }) {
    return MissionEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      cadence: cadence,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      goal: goal,
      rewardXp: rewardXp,
      rewardCoins: rewardCoins,
      rewardEnergy: rewardEnergy,
      expiresAtIso: expiresAtIso ?? this.expiresAtIso,
      rewardBadgeId: rewardBadgeId,
      rewardChestId: rewardChestId,
      specialKey: specialKey,
    );
  }
}