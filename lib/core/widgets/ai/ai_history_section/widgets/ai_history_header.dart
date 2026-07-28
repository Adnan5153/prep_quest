import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_radius.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../widgets/title_with_action.dart';
import '../../ai_constants.dart';

/// Section header shown above the history list.
///
/// Renders an accent icon tile, the section title + optional
/// subtitle, and an optional "View All" action.
class AiHistoryHeader extends StatelessWidget {
  const AiHistoryHeader({
    super.key,
    required this.isDark,
    this.title,
    this.subtitle,
    required this.icon,
    this.showViewAll = true,
    this.viewAllText,
    this.onViewAll,
  });

  final bool isDark;
  final String? title;
  final String? subtitle;
  final IconData icon;
  final bool showViewAll;
  final String? viewAllText;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color iconBackground = isDark
        ? AiConstants.aiViolet.withValues(alpha: 0.18)
        : AiConstants.aiViolet.withValues(alpha: 0.10);

    final Widget leading = Container(
      width: AppSizes.iconLg + 4,
      height: AppSizes.iconLg + 4,
      decoration: BoxDecoration(
        color: iconBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: AppSizes.iconMd, color: AiConstants.aiViolet),
    );

    return TitleWithAction(
      title: title ?? 'AI History',
      subtitle: subtitle,
      leading: leading,
      maxLines: 1,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
      ),
      subtitleStyle: theme.textTheme.bodySmall?.copyWith(
        color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
      ),
      actionText: showViewAll ? (viewAllText ?? 'View All') : null,
      actionIcon: showViewAll ? Icons.arrow_forward_rounded : null,
      onActionPressed: showViewAll ? onViewAll : null,
    );
  }
}
