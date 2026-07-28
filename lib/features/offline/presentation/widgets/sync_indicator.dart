import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';

/// Compact sync indicator chip used in app bars and cards.
class SyncIndicator extends StatelessWidget {
  const SyncIndicator({
    super.key,
    required this.label,
    this.isSyncing = false,
    this.failed = false,
  });

  final String label;
  final bool isSyncing;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color base = failed
        ? AppColors.error
        : isSyncing
            ? theme.colorScheme.primary
            : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isSyncing)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(base),
              ),
            )
          else
            Icon(
              failed ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
              size: 14,
              color: base,
            ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: base,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}