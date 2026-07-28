import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';

enum CoinRewardSize { compact, standard, large }

enum CoinRewardLayout { iconOnly, compact, detailed }

class CoinSparkleSpec {
  const CoinSparkleSpec({
    required this.dx,
    required this.dy,
    required this.delay,
  });

  final double dx;
  final double dy;
  final double delay;
}

class CoinRewardRarityResolver {
  const CoinRewardRarityResolver._();

  static Color resolveRimColor(PlaygroundRarity rarity) {
    switch (rarity) {
      case PlaygroundRarity.common:
        return PlaygroundColors.coinRimDark;
      case PlaygroundRarity.rare:
        return PlaygroundColors.rarityRare;
      case PlaygroundRarity.epic:
        return PlaygroundColors.rarityEpic;
      case PlaygroundRarity.legendary:
        return PlaygroundColors.rarityLegendary;
    }
  }
}
