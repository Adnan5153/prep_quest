import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';

enum RewardChestState { closed, opening, opened, locked }

enum RewardChestSize { compact, standard, large }

class RewardChestSparkleSpot {
  const RewardChestSparkleSpot({
    required this.dx,
    required this.dy,
    required this.delay,
  });

  final double dx;
  final double dy;
  final double delay;
}

class RewardChestRarityColors {
  const RewardChestRarityColors._();

  static Color band(PlaygroundRarity rarity) {
    switch (rarity) {
      case PlaygroundRarity.common:
        return PlaygroundColors.chestBand;
      case PlaygroundRarity.rare:
        return PlaygroundColors.rarityRare;
      case PlaygroundRarity.epic:
        return PlaygroundColors.rarityEpic;
      case PlaygroundRarity.legendary:
        return PlaygroundColors.rarityLegendary;
    }
  }
}
