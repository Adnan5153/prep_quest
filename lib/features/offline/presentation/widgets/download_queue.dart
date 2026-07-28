import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/download_task_entity.dart';
import 'download_progress_card.dart';

/// Convenience scrollable list of download tasks. Used by the offline
/// downloads screen to render the active queue.
class DownloadQueue extends StatelessWidget {
  const DownloadQueue({
    super.key,
    required this.tasks,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    ),
  });

  final List<DownloadTaskEntity> tasks;
  final ValueChanged<String> onPause;
  final ValueChanged<String> onResume;
  final ValueChanged<String> onCancel;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: tasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (BuildContext context, int index) {
        final DownloadTaskEntity task = tasks[index];
        return DownloadProgressCard(
          task: task,
          onPause: () => onPause(task.id),
          onResume: () => onResume(task.id),
          onCancel: () => onCancel(task.id),
        );
      },
    );
  }
}