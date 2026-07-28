import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import 'reward_popup_constants.dart';

class RewardPopupHeader extends StatelessWidget {
  const RewardPopupHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.mutedColor,
    required this.rarity,
  });

  final String title;
  final String subtitle;
  final Color titleColor;
  final Color mutedColor;
  final PlaygroundRarity rarity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = RewardPopupRarityStyles.color(rarity);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: PlaygroundSizes.rewardPopupBadgePadding,
          decoration: BoxDecoration(
            color: accent.withValues(
              alpha: PlaygroundOpacity.rewardPopupBadgeFill,
            ),
            borderRadius: BorderRadius.circular(
              PlaygroundSizes.rewardPopupBadgeRadius,
            ),
            border: Border.all(
              color: accent.withValues(
                alpha: PlaygroundOpacity.rewardPopupBadgeBorder,
              ),
              width: AppSizes.borderThin,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(AppIcons.crown, size: AppSizes.iconXs, color: accent),
              SizedBox(width: AppSpacing.xxs),
              Text(
                RewardPopupRarityStyles.label(rarity).toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  fontSize: PlaygroundSizes.rewardPopupBadgeFontSize,
                  letterSpacing: PlaygroundSizes.rewardPopupBadgeLetterSpacing,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w800,
            fontSize: PlaygroundSizes.rewardPopupTitleFontSize,
            height: PlaygroundSizes.rewardPopupTitleLineHeight,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: mutedColor,
            fontWeight: FontWeight.w500,
            fontSize: PlaygroundSizes.rewardPopupSubtitleFontSize,
            height: PlaygroundSizes.rewardPopupSubtitleLineHeight,
          ),
        ),
      ],
    );
  }
}
