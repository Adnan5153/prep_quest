import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../constants/playground_sizes.dart';

class RewardChestLockBadge extends StatelessWidget {
  const RewardChestLockBadge({
    super.key,
    required this.size,
    required this.iconColor,
    required this.borderColor,
    required this.surfaceColor,
  });

  final double size;
  final Color iconColor;
  final Color borderColor;
  final Color surfaceColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        PlaygroundSizes.rewardChestLockBadgePadding,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: PlaygroundSizes.rewardChestLockBadgeBorderWidth,
        ),
      ),
      child: Icon(
        AppIcons.lockFilled,
        size: size * PlaygroundSizes.rewardChestLockBadgeIconSizeRatio,
        color: iconColor,
      ),
    );
  }
}

class RewardChestLockedOverlay extends StatelessWidget {
  const RewardChestLockedOverlay({
    super.key,
    required this.size,
    required this.surfaceColor,
  });

  final double size;
  final Color surfaceColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: size * PlaygroundSizes.rewardChestLockBadgeOffsetRightRatio,
      top: size * PlaygroundSizes.rewardChestLockBadgeOffsetTopRatio,
      child: RewardChestLockBadge(
        size: size,
        iconColor: AppColors.buildingLocked,
        borderColor: AppColors.buildingLocked,
        surfaceColor: surfaceColor,
      ),
    );
  }
}
