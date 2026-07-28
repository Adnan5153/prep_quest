import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'level_progress_badge.dart';
import 'level_progress_visual.dart';

class LevelProgressHeader extends StatelessWidget {
  const LevelProgressHeader({
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
    final titleColor = _titleColor();
    final subtitleColor = _subtitleColor();

    return Row(
      children: <Widget>[
        LevelProgressBadge(
          level: visual.level,
          isDark: isDark,
          isPremium: visual.isPremium,
          isCompleted: visual.isCompleted,
          scale: scale,
        ),
        SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                visual.title ?? PlaygroundStrings.levelProgressCardTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                visual.subtitle ?? PlaygroundStrings.levelProgressCardSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ..._trailingBadges(),
      ],
    );
  }

  Color _titleColor() {
    if (visual.isPremium) return AppColors.darkOnSurface;
    if (isDark) return AppColors.darkOnSurface;
    return AppColors.lightOnSurface;
  }

  Color _subtitleColor() {
    if (visual.isPremium) return AppColors.darkOnSurface.withValues(alpha: 0.7);
    if (isDark) return AppColors.darkMuted;
    return AppColors.lightMuted;
  }

  List<Widget> _trailingBadges() {
    final trailing = <Widget>[];
    if (visual.isCompleted) {
      trailing.add(
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.xs * scale),
          child: Icon(
            AppIcons.checkCircle,
            size: PlaygroundSizes.cardCompletedBadgeSize * scale,
            color: PlaygroundColors.completed,
          ),
        ),
      );
    } else if (visual.isLocked) {
      trailing.add(
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.xs * scale),
          child: Icon(
            AppIcons.lockFilled,
            size: PlaygroundSizes.cardBadgeSize * scale,
            color: PlaygroundColors.cardLockedSurface,
          ),
        ),
      );
    }
    return trailing;
  }
}
