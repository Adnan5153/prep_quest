import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_constants.dart';
import 'coin_reward_animation.dart';
import 'coin_reward_label.dart';
import 'coin_reward_models.dart';
import 'coin_reward_surface.dart';
import 'coin_reward_utils.dart';

class CoinRewardLayoutView extends StatelessWidget {
  const CoinRewardLayoutView({
    super.key,
    required this.diameter,
    required this.amount,
    required this.label,
    required this.isDark,
    required this.rarity,
    required this.layout,
    required this.showGlow,
    required this.showSparkle,
    required this.isAnimating,
    required this.heroTag,
  });

  final double diameter;
  final int amount;
  final String? label;
  final bool isDark;
  final PlaygroundRarity rarity;
  final CoinRewardLayout layout;
  final bool showGlow;
  final bool showSparkle;
  final bool isAnimating;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    if (layout == CoinRewardLayout.iconOnly) {
      return _CoinRewardIconFrame(
        amount: amount,
        label: label,
        isDark: isDark,
        rarity: rarity,
        diameter: diameter,
        showGlow: showGlow,
        showSparkle: showSparkle,
        isAnimating: isAnimating,
        heroTag: heroTag,
      );
    }
    return RepaintBoundary(
      child: Semantics(
        label: CoinRewardSemantics.detailedLabel(label, amount),
        container: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _CoinRewardIconFrame(
              amount: amount,
              label: label,
              isDark: isDark,
              rarity: rarity,
              diameter: diameter,
              showGlow: showGlow,
              showSparkle: showSparkle,
              isAnimating: isAnimating,
              heroTag: heroTag,
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: CoinRewardLabel(amount: amount, isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinRewardIconFrame extends StatelessWidget {
  const _CoinRewardIconFrame({
    required this.amount,
    required this.label,
    required this.isDark,
    required this.rarity,
    required this.diameter,
    required this.showGlow,
    required this.showSparkle,
    required this.isAnimating,
    required this.heroTag,
  });

  final int amount;
  final String? label;
  final bool isDark;
  final PlaygroundRarity rarity;
  final double diameter;
  final bool showGlow;
  final bool showSparkle;
  final bool isAnimating;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final surface = CoinRewardSurface(
      diameter: diameter,
      rarity: rarity,
      showGlow: showGlow,
    );
    final framed = heroTag != null
        ? Hero(tag: heroTag!, child: surface)
        : surface;
    return Semantics(
      label: CoinRewardSemantics.iconLabel(label, amount),
      image: true,
      container: true,
      child: CoinFloatAnimation(
        enabled: isAnimating,
        staticChild: framed,
        animatedChild: (context, animation) {
          return CoinRewardAnimatedLayer(
            diameter: diameter,
            isDark: isDark,
            showSparkle: showSparkle,
            animation: animation,
          );
        },
      ),
    );
  }
}
