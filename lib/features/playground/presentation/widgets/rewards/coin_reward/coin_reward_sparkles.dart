import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../constants/playground_sizes.dart';
import 'coin_reward_utils.dart';

class CoinRewardSparkles extends StatelessWidget {
  const CoinRewardSparkles({
    super.key,
    required this.diameter,
    required this.isDark,
    required this.animation,
  });

  final double diameter;
  final bool isDark;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              for (final spec in CoinSparkleLayout.spots)
                Positioned(
                  left: diameter / 2 + spec.dx * diameter,
                  top: diameter / 2 + spec.dy * diameter,
                  child: Opacity(
                    opacity: CoinSparkleLayout.opacityFor(
                      animation.value,
                      spec.delay,
                    ),
                    child: Transform.scale(
                      scale: CoinSparkleLayout.scaleFor(
                        animation.value,
                        spec.delay,
                      ),
                      child: Icon(
                        AppIcons.sparkle,
                        size: PlaygroundSizes.rewardCoinSparkleSize,
                        color: isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
