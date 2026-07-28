import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import 'coin_reward_glow.dart';
import 'coin_reward_models.dart';
import 'coin_reward_sparkles.dart';

class CoinRewardSurface extends StatelessWidget {
  const CoinRewardSurface({
    super.key,
    required this.diameter,
    required this.rarity,
    required this.showGlow,
  });

  final double diameter;
  final PlaygroundRarity rarity;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    final rimColor = CoinRewardRarityResolver.resolveRimColor(rarity);
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          if (showGlow)
            Positioned.fill(
              child: CoinRewardGlow(diameter: diameter, color: rimColor),
            ),
          _CoinBody(diameter: diameter, rimColor: rimColor),
        ],
      ),
    );
  }
}

class CoinRewardAnimatedLayer extends StatelessWidget {
  const CoinRewardAnimatedLayer({
    super.key,
    required this.diameter,
    required this.isDark,
    required this.showSparkle,
    required this.animation,
  });

  final double diameter;
  final bool isDark;
  final bool showSparkle;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          if (showSparkle)
            CoinRewardSparkles(
              diameter: diameter,
              isDark: isDark,
              animation: animation,
            ),
        ],
      ),
    );
  }
}

class _CoinBody extends StatelessWidget {
  const _CoinBody({required this.diameter, required this.rimColor});

  final double diameter;
  final Color rimColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 0.95,
          colors: <Color>[
            PlaygroundColors.coinRimLight,
            PlaygroundColors.coin,
            rimColor,
          ],
          stops: const <double>[0.0, 0.55, 1.0],
        ),
        border: Border.all(
          color: rimColor,
          width: PlaygroundSizes.rewardCoinBorderWidth,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: rimColor.withValues(alpha: 0.45),
            blurRadius: PlaygroundSizes.rewardCoinHighlightBlur,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: AppColors.nodeDropShadow.withValues(alpha: 0.55),
            blurRadius: diameter * 0.18,
            offset: Offset(0, diameter * 0.10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: diameter * 0.14,
            left: diameter * 0.18,
            right: diameter * 0.18,
            child: Container(
              height: diameter * 0.18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    PlaygroundColors.coinHighlight,
                    PlaygroundColors.coinHighlight.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Icon(
            AppIcons.coinIcon,
            size: diameter * 0.45,
            color: AppColors.darkOnSurface,
          ),
        ],
      ),
    );
  }
}
