import 'package:flutter/material.dart';

import '../../../constants/playground_sizes.dart';
import 'reward_chest_models.dart';
import 'reward_chest_sparkle.dart';
import 'reward_chest_utils.dart';

class RewardChestSparkles extends StatelessWidget {
  const RewardChestSparkles({
    super.key,
    required this.size,
    required this.color,
    required this.progress,
  });

  final double size;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: size * PlaygroundSizes.rewardChestSparkleFieldExpand,
        height: size * PlaygroundSizes.rewardChestSparkleFieldExpand,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            for (final spot in RewardChestSparkleField.spots)
              _ChestSparkleParticle(
                key: ValueKey<RewardChestSparkleSpot>(spot),
                chestSize: size,
                color: color,
                spot: spot,
                progress: progress,
              ),
          ],
        ),
      ),
    );
  }
}

class _ChestSparkleParticle extends StatelessWidget {
  const _ChestSparkleParticle({
    super.key,
    required this.chestSize,
    required this.color,
    required this.spot,
    required this.progress,
  });

  final double chestSize;
  final Color color;
  final RewardChestSparkleSpot spot;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final local = (progress - spot.delay).clamp(0.0, 1.0);
    if (local <= 0) return const SizedBox.shrink();
    final lift =
        -chestSize * PlaygroundSizes.rewardChestSparkleLiftRatio * local;
    final opacity = (1 - local).clamp(0.0, 1.0);
    return Transform.translate(
      offset: Offset(chestSize * spot.dx, chestSize * spot.dy + lift),
      child: Opacity(
        opacity: opacity,
        child: RewardChestSparkle(
          color: color,
          size: chestSize * PlaygroundSizes.rewardChestSparkleSizeRatio,
        ),
      ),
    );
  }
}

class RewardChestSingleSparkle extends StatelessWidget {
  const RewardChestSingleSparkle({
    super.key,
    required this.color,
    required this.size,
    required this.progress,
  });

  final Color color;
  final double size;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final scale =
        PlaygroundSizes.rewardChestSparkleScaleStart +
        PlaygroundSizes.rewardChestSparkleScaleAmplitude * progress;
    return Opacity(
      opacity: (1 - progress).clamp(0.0, 1.0),
      child: Transform.scale(
        scale: scale,
        child: RewardChestSparkle(color: color, size: size),
      ),
    );
  }
}
