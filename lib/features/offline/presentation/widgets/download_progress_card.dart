import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/download_task_entity.dart';
import '../../domain/enums/offline_content_type.dart';
import 'formatting.dart';

/// Live progress card used by the download queue screen. Shows a
/// linear progress bar, the byte counts, and pause/resume/cancel
/// controls.
class DownloadProgressCard extends StatelessWidget {
  const DownloadProgressCard({
    super.key,
    required this.task,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
  });

  final DownloadTaskEntity task;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String status = _statusLabel(task);
    final Color tint = _statusColor(task, theme);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: AppSizes.iconLg,
                height: AppSizes.iconLg,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                alignment: Alignment.center,
                child: Icon(_iconFor(task.contentType), color: tint),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${formatBytes(task.receivedBytes)} of ${formatBytes(task.totalBytes)} · $status',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (task.isActive)
                IconButton(
                  onPressed: onPause,
                  icon: Icon(Icons.pause_circle_outline, color: tint),
                  tooltip: 'Pause',
                )
              else if (task.isPaused)
                IconButton(
                  onPressed: onResume,
                  icon: Icon(Icons.play_circle_outline, color: tint),
                  tooltip: 'Resume',
                ),
              IconButton(
                onPressed: onCancel,
                icon: Icon(Icons.cancel_outlined, color: AppColors.error),
                tooltip: 'Cancel',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: task.progress,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.06),
              color: tint,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(DownloadTaskEntity task) {
    switch (task.status) {
      case DownloadStatus.queued:
        return 'Queued';
      case DownloadStatus.downloading:
        return 'Downloading';
      case DownloadStatus.paused:
        return 'Paused';
      case DownloadStatus.completed:
        return 'Completed';
      case DownloadStatus.failed:
        return task.errorMessage ?? 'Failed';
      case DownloadStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _statusColor(DownloadTaskEntity task, ThemeData theme) {
    switch (task.status) {
      case DownloadStatus.completed:
        return AppColors.success;
      case DownloadStatus.failed:
        return AppColors.error;
      case DownloadStatus.paused:
        return AppColors.warning;
      case DownloadStatus.cancelled:
        return theme.colorScheme.onSurface.withValues(alpha: 0.4);
      case DownloadStatus.queued:
      case DownloadStatus.downloading:
        return theme.colorScheme.primary;
    }
  }

  IconData _iconFor(OfflineContentType type) {
    switch (type) {
      case OfflineContentType.lesson:
        return Icons.menu_book_rounded;
      case OfflineContentType.chapter:
        return Icons.layers_outlined;
      case OfflineContentType.subject:
        return Icons.book_outlined;
      case OfflineContentType.questionSet:
        return Icons.help_outline_rounded;
      case OfflineContentType.mockTest:
        return Icons.assignment_rounded;
    }
  }
}