import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';
import 'coin_reward_layout.dart';
import 'coin_reward_models.dart';
import 'coin_reward_utils.dart';

export 'coin_reward_models.dart' show CoinRewardSize, CoinRewardLayout;

class CoinReward extends StatelessWidget {
  const CoinReward({
    super.key,
    required this.amount,
    this.size = CoinRewardSize.standard,
    this.layout = CoinRewardLayout.detailed,
    this.label,
    this.isDark = false,
    this.rarity = PlaygroundRarity.common,
    this.showGlow = true,
    this.showSparkle = true,
    this.isAnimating = true,
    this.heroTag,
  });

  final int amount;
  final CoinRewardSize size;
  final CoinRewardLayout layout;
  final String? label;
  final bool isDark;
  final PlaygroundRarity rarity;
  final bool showGlow;
  final bool showSparkle;
  final bool isAnimating;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final diameter = CoinRewardSizing.resolveDiameter(context, size);
    return CoinRewardLayoutView(
      diameter: diameter,
      amount: amount,
      label: label,
      isDark: isDark,
      rarity: rarity,
      layout: layout,
      showGlow: showGlow,
      showSparkle: showSparkle,
      isAnimating: isAnimating,
      heroTag: heroTag,
    );
  }
}
