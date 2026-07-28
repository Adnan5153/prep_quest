import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/secondary_button.dart';

/// Friendly error state shown when SettingsController cannot load or
/// persist settings. Offers a retry CTA and an optional secondary
/// action.
class SettingsErrorState extends StatelessWidget {
  const SettingsErrorState({
    super.key,
    required this.message,
    this.title = 'Something went wrong',
    this.icon = Icons.error_outline_rounded,
    this.onRetry,
    this.retryLabel = 'Try again',
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryLabel;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: AppSizes.iconXl + AppSpacing.lg,
                height: AppSizes.iconXl + AppSpacing.lg,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: AppSizes.iconXl,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightMuted,
                ),
              ),
              if (onRetry != null) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                SecondaryButton(
                  text: retryLabel,
                  onPressed: onRetry,
                  icon: Icons.refresh_rounded,
                  fullWidth: false,
                ),
              ],
              if (secondaryLabel != null && onSecondary != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: onSecondary,
                  child: Text(secondaryLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}