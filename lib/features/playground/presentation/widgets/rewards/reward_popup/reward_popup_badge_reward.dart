import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'reward_entry.dart';
import 'reward_popup_constants.dart';

class RewardPopupBadgeReward extends StatelessWidget {
  const RewardPopupBadgeReward({
    super.key,
    required this.entry,
    required this.isDark,
  });

  final RewardEntry entry;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = RewardPopupRarityStyles.color(entry.rarity);
    final titleColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return RepaintBoundary(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: AppSizes.minTapTarget,
            height: AppSizes.minTapTarget,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  accent,
                  accent.withValues(
                    alpha: PlaygroundOpacity.rewardPopupBadgeGradientEnd,
                  ),
                ],
              ),
              border: Border.all(
                color: accent.withValues(
                  alpha: PlaygroundOpacity.rewardPopupBadgeRing,
                ),
                width: AppSizes.borderThin,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: accent.withValues(
                    alpha: PlaygroundOpacity.rewardPopupBadgeGlow,
                  ),
                  blurRadius: PlaygroundSizes.rewardPopupBadgeGlowBlur,
                  spreadRadius: PlaygroundSizes.rewardPopupBadgeGlowSpread,
                ),
              ],
            ),
            child: Icon(
              entry.customIcon ?? AppIcons.badgeStar,
              size: AppSizes.iconMd,
              color: AppColors.darkOnSurface,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.customTitle ??
                      entry.label ??
                      RewardPopupRarityStyles.label(entry.rarity),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (entry.amount > 0)
                  Text(
                    '${PlaygroundStrings.rewardAmountPrefix}${entry.amount}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: mutedColor,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
