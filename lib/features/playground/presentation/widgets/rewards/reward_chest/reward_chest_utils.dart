import 'package:flutter/material.dart';

import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'reward_chest_models.dart';

class RewardChestSizing {
  const RewardChestSizing._();

  static double resolveSize(BuildContext context, RewardChestSize size) {
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.cardTabletScale,
      desktop: PlaygroundSizes.cardDesktopScale,
    );
    final base = switch (size) {
      RewardChestSize.compact => PlaygroundSizes.rewardChestSizeCompact,
      RewardChestSize.standard => PlaygroundSizes.rewardChestSizeStandard,
      RewardChestSize.large => PlaygroundSizes.rewardChestSizeLarge,
    };
    return base * scale;
  }
}

class RewardChestSemantics {
  const RewardChestSemantics._();

  static String labelFor(RewardChestState state) {
    switch (state) {
      case RewardChestState.closed:
        return PlaygroundStrings.rewardPopupClosedSemantic;
      case RewardChestState.opening:
        return PlaygroundStrings.rewardPopupChestSemantic;
      case RewardChestState.opened:
        return PlaygroundStrings.rewardPopupOpenedSemantic;
      case RewardChestState.locked:
        return PlaygroundStrings.rewardPopupLockedSemantic;
    }
  }
}

class RewardChestPhase {
  const RewardChestPhase._();

  static double lift(double progress) {
    return Curves.easeOutBack.transform(progress.clamp(0.0, 1.0));
  }

  static double beamProgress(double progress) {
    return ((progress - PlaygroundSizes.rewardChestBeamStart) /
            (1.0 - PlaygroundSizes.rewardChestBeamStart))
        .clamp(0.0, 1.0);
  }
}

class RewardChestSparkleField {
  const RewardChestSparkleField._();

  static const List<RewardChestSparkleSpot> spots = <RewardChestSparkleSpot>[
    RewardChestSparkleSpot(
      dx: -PlaygroundSizes.rewardChestSparkleSpreadHorizontalRatio,
      dy: PlaygroundSizes.rewardChestSparkleSpreadVerticalRatio,
      delay: 0.0,
    ),
    RewardChestSparkleSpot(
      dx: PlaygroundSizes.rewardChestSparkleOffsetOuterRightRatio,
      dy: PlaygroundSizes.rewardChestSparkleSpreadVerticalRatio / 2,
      delay: PlaygroundSizes.rewardChestSparkleDelayStep,
    ),
    RewardChestSparkleSpot(
      dx: -PlaygroundSizes.rewardChestSparkleOffsetCenterHorizontalRatio,
      dy: -PlaygroundSizes.rewardChestSparkleOffsetCenterTopRatio,
      delay: 2 * PlaygroundSizes.rewardChestSparkleDelayStep,
    ),
    RewardChestSparkleSpot(
      dx: PlaygroundSizes.rewardChestSparkleOffsetInnerRightRatio,
      dy: -PlaygroundSizes.rewardChestSparkleSpreadVerticalRatio / 2,
      delay: 3 * PlaygroundSizes.rewardChestSparkleDelayStep,
    ),
  ];
}
