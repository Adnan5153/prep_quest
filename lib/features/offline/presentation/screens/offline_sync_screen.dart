import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/sync_task_entity.dart';
import '../providers/sync_provider.dart';
import '../widgets/offline_banner.dart';
import '../widgets/sync_indicator.dart';
import '../widgets/sync_progress_widget.dart';

/// Surfaces the sync queue, status and a manual sync button.
class OfflineSyncScreen extends ConsumerWidget {
  const OfflineSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final SyncState state = ref.watch(syncControllerProvider);
    final AsyncValue<List<SyncTaskEntity>> queueAsync =
        ref.watch(syncQueueStreamProvider);
    final AsyncValue<bool> onlineAsync = ref.watch(networkStateProvider);
    final bool online =
        onlineAsync.maybeWhen(data: (bool v) => v, orElse: () => true);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sync status',
        subtitle: 'Track what is being uploaded to the cloud',
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Center(
              child: SyncIndicator(
                label: online ? 'Online' : 'Offline',
                isSyncing: state.status == SyncStatusKind.syncing,
                failed: state.status == SyncStatusKind.failed,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          children: <Widget>[
            if (!online) OfflineBanner.waiting(),
            queueAsync.when(
              data: (List<SyncTaskEntity> queue) => SyncProgressWidget(
                queue: queue,
                isSyncing: state.status == SyncStatusKind.syncing,
                failed: state.status == SyncStatusKind.failed,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, StackTrace _) =>
                  Text('Failed to load sync queue: $e'),
            ),
            const SizedBox(height: AppSpacing.md),
            if (state.message != null)
              Text(
                state.message!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: online ? 'Sync now' : 'Waiting for connection',
              icon: Icons.cloud_sync_rounded,
              isLoading: state.status == SyncStatusKind.syncing,
              isEnabled:
                  online && state.status != SyncStatusKind.syncing,
              fullWidth: true,
              onPressed: () async {
                await ref.read(syncControllerProvider.notifier).syncNow();
                if (!context.mounted) return;
                AppSnackBar.showInfo(context, 'Sync triggered');
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Queued items',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            queueAsync.when(
              data: (List<SyncTaskEntity> queue) {
                if (queue.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    child: Text(
                      'No queued items. New actions will appear here when '
                      'you use Prep Quest offline.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                }
                return Column(
                  children: <Widget>[
                    for (final SyncTaskEntity item in queue)
                      _SyncTile(task: item),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, StackTrace _) =>
                  Text('Failed to load queue: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncTile extends StatelessWidget {
  const _SyncTile({required this.task});

  final SyncTaskEntity task;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String label = _label(task);
    final String status = task.status.name;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.cloud_queue_rounded,
                color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Attempts: ${task.attempts} · $status',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _label(SyncTaskEntity task) {
    switch (task.payloadType) {
      case SyncPayloadType.quizAttempt:
        return 'Quiz attempt · ${task.payload['quiz_id'] ?? ''}';
      case SyncPayloadType.xpEvent:
        return 'XP +${task.payload['amount'] ?? 0}';
      case SyncPayloadType.coinEvent:
        return 'Coins +${task.payload['amount'] ?? 0}';
      case SyncPayloadType.streakEvent:
        return 'Streak update';
      case SyncPayloadType.bookmark:
        return 'Bookmark · ${task.payload['item_id'] ?? ''}';
      case SyncPayloadType.note:
        return 'Note sync';
      case SyncPayloadType.aiMessage:
        return 'AI tutor history';
    }
  }
}
