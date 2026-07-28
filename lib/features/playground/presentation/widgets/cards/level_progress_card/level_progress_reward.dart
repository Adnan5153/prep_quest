import 'package:flutter/material.dart';

import 'level_progress_enums.dart';

class LevelProgressReward {
  const LevelProgressReward({
    required this.kind,
    required this.amount,
    this.icon,
    this.label,
    this.heroTag,
  });

  final LevelProgressRewardKind kind;
  final int amount;
  final IconData? icon;
  final String? label;
  final String? heroTag;

  factory LevelProgressReward.xp(
    int amount, {
    IconData? icon,
    String? label,
    String? heroTag,
  }) => LevelProgressReward(
    kind: LevelProgressRewardKind.xp,
    amount: amount,
    icon: icon,
    label: label,
    heroTag: heroTag,
  );

  factory LevelProgressReward.coin(
    int amount, {
    IconData? icon,
    String? label,
    String? heroTag,
  }) => LevelProgressReward(
    kind: LevelProgressRewardKind.coin,
    amount: amount,
    icon: icon,
    label: label,
    heroTag: heroTag,
  );

  factory LevelProgressReward.gem(
    int amount, {
    IconData? icon,
    String? label,
    String? heroTag,
  }) => LevelProgressReward(
    kind: LevelProgressRewardKind.gem,
    amount: amount,
    icon: icon,
    label: label,
    heroTag: heroTag,
  );

  factory LevelProgressReward.badge(
    int amount, {
    IconData? icon,
    String? label,
    String? heroTag,
  }) => LevelProgressReward(
    kind: LevelProgressRewardKind.badge,
    amount: amount,
    icon: icon,
    label: label,
    heroTag: heroTag,
  );
}
