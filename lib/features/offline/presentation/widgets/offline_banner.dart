import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';

/// Banner shown at the top of the screen when the device is offline
/// or while sync is pending. Reusable across feature screens.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = AppIcons.bookmarkOffline,
    this.variant = OfflineBannerVariant.offline,
    this.onAction,
    this.actionLabel,
  });

  factory OfflineBanner.offline({Key? key, VoidCallback? onRetry}) =>
      OfflineBanner(
        key: key,
        title: 'You are offline',
        subtitle: 'Showing your downloaded content. We will sync when '
            'connection returns.',
        variant: OfflineBannerVariant.offline,
        onAction: onRetry,
        actionLabel: onRetry != null ? 'Retry' : null,
      );

  factory OfflineBanner.syncing({Key? key}) => OfflineBanner(
        key: key,
        title: 'Syncing your progress',
        subtitle: 'Uploading queued changes from your last session.',
        variant: OfflineBannerVariant.syncing,
      );

  factory OfflineBanner.waiting({Key? key}) => OfflineBanner(
        key: key,
        title: 'Waiting for connection',
        subtitle: 'Your action is queued. It will sync the moment you '
            'are back online.',
        variant: OfflineBannerVariant.waiting,
      );

  final String title;
  final String subtitle;
  final IconData icon;
  final OfflineBannerVariant variant;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _Palette palette = _resolvePalette(variant, theme);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: palette.foreground, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: palette.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.foreground.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          if (onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(foregroundColor: palette.foreground),
              child: Text(actionLabel ?? 'Retry'),
            ),
        ],
      ),
    );
  }

  _Palette _resolvePalette(OfflineBannerVariant v, ThemeData theme) {
    switch (v) {
      case OfflineBannerVariant.offline:
        return _Palette(
          background: AppColors.warning.withValues(alpha: 0.12),
          border: AppColors.warning.withValues(alpha: 0.4),
          foreground: AppColors.warning,
        );
      case OfflineBannerVariant.syncing:
        return _Palette(
          background: theme.colorScheme.primary.withValues(alpha: 0.12),
          border: theme.colorScheme.primary.withValues(alpha: 0.4),
          foreground: theme.colorScheme.primary,
        );
      case OfflineBannerVariant.waiting:
        return _Palette(
          background: theme.colorScheme.secondary.withValues(alpha: 0.12),
          border: theme.colorScheme.secondary.withValues(alpha: 0.4),
          foreground: theme.colorScheme.secondary,
        );
    }
  }
}

enum OfflineBannerVariant { offline, syncing, waiting }

class _Palette {
  const _Palette({
    required this.background,
    required this.border,
    required this.foreground,
  });
  final Color background;
  final Color border;
  final Color foreground;
}