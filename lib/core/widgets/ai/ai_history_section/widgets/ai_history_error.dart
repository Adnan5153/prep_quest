import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/app_spacing.dart';

/// Error placeholder used when the history stream fails.
class AiHistoryError extends StatelessWidget {
  const AiHistoryError({
    super.key,
    required this.isDark,
    this.title,
    this.subtitle,
    this.onRetry,
  });

  final bool isDark;
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color iconBackground = AppColors.error.withValues(
      alpha: isDark ? 0.20 : 0.10,
    );

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
            child: const Icon(
              Icons.error_outline_rounded,
              size: AppSizes.iconXl,
              color: AppColors.error,
              semanticLabel: 'Error',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title ?? 'Could not load history',
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
            subtitle ?? 'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            ),
          ),
          if (onRetry != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: AppSizes.iconSm),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
