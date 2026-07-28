import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';
import 'reward_entry_kind.dart';

class RewardEntry {
  const RewardEntry({
    required this.kind,
    required this.amount,
    this.label,
    this.rarity = PlaygroundRarity.common,
    this.customIcon,
    this.customTitle,
  });

  final RewardEntryKind kind;
  final int amount;
  final String? label;
  final PlaygroundRarity rarity;
  final IconData? customIcon;
  final String? customTitle;
}
