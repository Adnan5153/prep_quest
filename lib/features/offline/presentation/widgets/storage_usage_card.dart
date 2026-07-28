import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/storage_usage_entity.dart';
import 'formatting.dart';

/// Visual summary of how much of the device's storage is consumed by
/// downloads. Renders a horizontal bar plus the headline numbers.
class StorageUsageCard extends StatelessWidget {
  const StorageUsageCard({super.key, required this.usage});

  final StorageUsageEntity usage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double ratio = usage.usedRatio.clamp(0.0, 1.0);
    final Color tint = ratio > 0.85
        ? AppColors.error
        : ratio > 0.65
            ? AppColors.warning
            : AppColors.success;
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.sd_storage_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Storage usage',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 12,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.06),
              color: tint,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              _Stat(
                label: 'Used',
                value: formatBytes(usage.usedBytes),
                color: tint,
              ),
              const SizedBox(width: AppSpacing.lg),
              _Stat(
                label: 'Free',
                value: formatBytes(usage.freeBytes),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.lg),
              _Stat(
                label: 'Total',
                value: formatBytes(usage.totalBytes),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}