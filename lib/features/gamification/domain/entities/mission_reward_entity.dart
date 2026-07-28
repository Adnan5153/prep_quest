import 'package:flutter/foundation.dart';

/// What a mission promises to grant on claim.
///
/// Separate from the gamification `Reward` hierarchy because this
/// represents the **catalog promise** surfaced to the user, not the
/// concrete grants produced by the reward engine. The presentation
/// layer uses it for chips and preview cards; the controller hands
/// the claim off to `RewardsController.grantFromEvent(...)` to produce
/// the actual `RewardOutcome`.
@immutable
class MissionRewardEntity {
  const MissionRewardEntity({
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

  bool get hasBadge => badgeId != null && badgeId!.isNotEmpty;
  bool get hasChest => chestId != null && chestId!.isNotEmpty;

  MissionRewardEntity copyWith({
    int? xp,
    int? coins,
    int? energy,
    String? badgeId,
    String? chestId,
    String? specialKey,
  }) {
    return MissionRewardEntity(
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      energy: energy ?? this.energy,
      badgeId: badgeId ?? this.badgeId,
      chestId: chestId ?? this.chestId,
      specialKey: specialKey ?? this.specialKey,
    );
  }
}