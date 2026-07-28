import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/sync_task_entity.dart';
import '../../domain/enums/offline_content_type.dart';
import 'formatting.dart';

/// Renders an aggregated sync progress view — total queue length,
/// completed count, failed count, and (in flight) the active payload.
class SyncProgressWidget extends StatelessWidget {
  const SyncProgressWidget({
    super.key,
    required this.queue,
    this.isSyncing = false,
    this.failed = false,
  });

  final List<SyncTaskEntity> queue;
  final bool isSyncing;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int complete = queue
        .where((SyncTaskEntity t) => t.status == SyncStatus.synced)
        .length;
    final int failedCount = queue
        .where((SyncTaskEntity t) => t.status == SyncStatus.failed)
        .length;
    final int pending = queue.length - complete - failedCount;
    final double progress = queue.isEmpty ? 0 : complete / queue.length;
    final Color tint = failed
        ? AppColors.error
        : isSyncing
            ? theme.colorScheme.primary
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
              Icon(Icons.cloud_sync_rounded, color: tint),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Sync progress',
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
              value: progress.clamp(0, 1),
              minHeight: 10,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.06),
              color: tint,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              _Metric(label: 'Pending', value: '$pending', color: theme.colorScheme.primary),
              _Metric(label: 'Synced', value: '$complete', color: AppColors.success),
              _Metric(label: 'Failed', value: '$failedCount', color: AppColors.error),
              _Metric(label: 'Queue size', value: formatBytes(queue.length * 96), color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
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