import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';
import 'reward_chest_layout.dart';
import 'reward_chest_models.dart';
import 'reward_chest_utils.dart';

export 'reward_chest_models.dart' show RewardChestState, RewardChestSize;

class RewardChest extends StatelessWidget {
  const RewardChest({
    super.key,
    this.state = RewardChestState.closed,
    this.size = RewardChestSize.standard,
    this.isDark = false,
    this.rarity = PlaygroundRarity.common,
    this.showGlow = true,
    this.autoOpen = false,
    this.onTap,
    this.onOpen,
    this.semanticLabel,
  });

  final RewardChestState state;
  final RewardChestSize size;
  final bool isDark;
  final PlaygroundRarity rarity;
  final bool showGlow;
  final bool autoOpen;
  final VoidCallback? onTap;
  final VoidCallback? onOpen;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final chestSize = RewardChestSizing.resolveSize(context, size);
    return RewardChestLayout(
      size: chestSize,
      state: state,
      rarity: rarity,
      showGlow: showGlow,
      autoOpen: autoOpen,
      onTap: onTap,
      onOpen: onOpen,
      semanticLabel: semanticLabel,
    );
  }
}
