import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'level_progress_visual.dart';

class LevelProgressStars extends StatelessWidget {
  const LevelProgressStars({
    super.key,
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final LevelProgressVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final starSize = PlaygroundSizes.cardStarSize * scale;
    final starSpacing = PlaygroundSizes.cardStarSpacing * scale;
    final total = visual.totalStars;
    final earned = visual.earnedStars.clamp(0, total);

    final stars = <Widget>[];
    for (int i = 0; i < total; i++) {
      final isEarned = i < earned;
      stars.add(
        Icon(
          isEarned ? AppIcons.star : AppIcons.starOutline,
          size: starSize,
          color: isEarned
              ? (visual.isPremium
                    ? PlaygroundColors.premiumChrome
                    : PlaygroundColors.coin)
              : isDark
              ? AppColors.darkMuted.withValues(alpha: 0.55)
              : AppColors.lightMuted.withValues(alpha: 0.55),
        ),
      );
      if (i < total - 1) stars.add(SizedBox(width: starSpacing));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          PlaygroundStrings.levelProgressStarsLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            fontWeight: FontWeight.w700,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
        Expanded(
          child: Wrap(
            spacing: starSpacing,
            runSpacing: starSpacing,
            children: stars,
          ),
        ),
        Text(
          '$earned / $total',
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            fontWeight: FontWeight.w800,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
