import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_sizes.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../painters/reward_chest_painter.dart';
import 'reward_chest_controller.dart';
import 'reward_chest_glow.dart';
import 'reward_chest_light_beam.dart';
import 'reward_chest_lock.dart';
import 'reward_chest_models.dart';
import 'reward_chest_sparkles.dart';
import 'reward_chest_utils.dart';

class RewardChestLayout extends StatelessWidget {
  const RewardChestLayout({
    super.key,
    required this.size,
    required this.state,
    required this.rarity,
    required this.showGlow,
    required this.autoOpen,
    required this.onTap,
    required this.onOpen,
    required this.semanticLabel,
  });

  final double size;
  final RewardChestState state;
  final PlaygroundRarity rarity;
  final bool showGlow;
  final bool autoOpen;
  final VoidCallback? onTap;
  final VoidCallback? onOpen;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Semantics(
        label: semanticLabel ?? RewardChestSemantics.labelFor(state),
        button: onTap != null && state != RewardChestState.locked,
        enabled: state != RewardChestState.locked,
        container: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppSizes.minTapTarget,
            minHeight: AppSizes.minTapTarget,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: state == RewardChestState.locked
                ? null
                : () => onTap?.call(),
            child: SizedBox(
              width: size,
              height: size,
              child: RewardChestController(
                state: state,
                autoOpen: autoOpen,
                duration: PlaygroundDurations.rewardChest,
                onOpen: onOpen ?? () {},
                child: (context, animation) {
                  final data = RewardChestPaintData(
                    size: size,
                    state: state,
                    progress: animation.value,
                    rarity: rarity,
                  );
                  final color = RewardChestRarityColors.band(rarity);
                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      if (showGlow && state != RewardChestState.locked)
                        Positioned.fill(
                          child: RewardChestGlow(
                            diameter: size,
                            color: color,
                            opacity: animation.value,
                          ),
                        ),
                      RewardChestLightBeam(
                        size: size,
                        progress: animation.value,
                        data: data,
                      ),
                      CustomPaint(
                        size: Size(size, size),
                        painter: RewardChestPainter(data: data),
                      ),
                      if (state != RewardChestState.locked &&
                          animation.value >
                              PlaygroundSizes.rewardChestOpeningSparkleStart &&
                          animation.value <
                              PlaygroundSizes.rewardChestOpeningSparkleEnd)
                        Positioned(
                          top:
                              -size *
                              PlaygroundSizes.rewardChestSparkleOffsetTopRatio,
                          child: RewardChestSingleSparkle(
                            color: color,
                            size: AppSizes.iconMd,
                            progress: animation.value,
                          ),
                        ),
                      if (state == RewardChestState.opened &&
                          animation.value >=
                              PlaygroundSizes.rewardChestOpenedSparkleThreshold)
                        RewardChestSparkles(
                          size: size,
                          color: color,
                          progress: animation.value,
                        ),
                      if (state == RewardChestState.locked)
                        RewardChestLockedOverlay(
                          size: size,
                          surfaceColor: Theme.of(context).colorScheme.surface,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
