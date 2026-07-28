import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/app_spacing.dart';
import '../../ai_constants.dart';

/// Friendly empty state shown when the history contains no entries.
class AiHistoryEmpty extends StatelessWidget {
  const AiHistoryEmpty({
    super.key,
    required this.isDark,
    this.title,
    this.subtitle,
    this.icon = Icons.history_toggle_off_rounded,
  });

  final bool isDark;
  final String? title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color iconBackground = isDark
        ? AiConstants.aiViolet.withValues(alpha: 0.18)
        : AiConstants.aiViolet.withValues(alpha: 0.10);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: AppSizes.iconXl + 16,
            height: AppSizes.iconXl + 16,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: AppSizes.iconXl,
              color: AiConstants.aiViolet,
              semanticLabel: 'Empty',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title ?? 'No history yet',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkOnSurface
                  : AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle ??
                'Your AI conversations will appear here once you start asking.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            ),
          ),
        ],
      ),
    );
  }
}
