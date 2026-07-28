import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../router.dart';
import '../../domain/entities/download_task_entity.dart';
import '../../domain/entities/offline_item_entity.dart';
import '../../domain/enums/offline_content_type.dart';
import '../providers/download_queue_provider.dart';
import '../providers/offline_provider.dart';
import '../providers/sync_provider.dart';
import '../widgets/download_card.dart';
import '../widgets/download_queue.dart';
import '../widgets/offline_banner.dart';
import '../widgets/offline_empty_state.dart';
import '../widgets/sync_indicator.dart';

/// Hub screen that combines the active download queue with the
/// catalogue of available downloads.
class OfflineDownloadsScreen extends ConsumerWidget {
  const OfflineDownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<DownloadTaskEntity>> queueAsync =
        ref.watch(downloadQueueStreamProvider);
    final AsyncValue<List<OfflineItemEntity>> itemsAsync =
        ref.watch(offlineItemsStreamProvider);
    final AsyncValue<bool> onlineAsync = ref.watch(networkStateProvider);

    final bool online = onlineAsync.maybeWhen(data: (bool v) => v, orElse: () => true);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Offline downloads',
        subtitle: 'Manage downloads and synced content',
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.offlineStorage),
            icon: const Icon(AppIcons.bookmarkOffline),
            tooltip: 'Storage',
          ),
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.offlineSync),
            icon: const Icon(Icons.cloud_sync_rounded),
            tooltip: 'Sync',
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        online
                            ? 'You are online. New downloads start instantly.'
                            : 'You are offline. New downloads will resume '
                                'when you reconnect.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SyncIndicator(
                      label: online ? 'Online' : 'Offline',
                      isSyncing: !online,
                      failed: !online,
                    ),
                  ],
                ),
              ),
            ),
            if (!online)
              SliverToBoxAdapter(
                child: OfflineBanner.offline(),
              ),
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Active downloads',
                onSeeAll: () => context.pushNamed(AppRoutes.offlineSync),
              ),
            ),
            queueAsync.when(
              data: (List<DownloadTaskEntity> queue) {
                if (queue.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: OfflineEmptyState(
                      title: 'No active downloads',
                      message:
                          'Pick a lesson or question set below to start a download.',
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: DownloadQueue(
                    tasks: queue,
                    onPause: (String id) =>
                        ref.read(downloadQueueControllerProvider.notifier)
                            .pause(id),
                    onResume: (String id) =>
                        ref.read(downloadQueueControllerProvider.notifier)
                            .resume(id),
                    onCancel: (String id) =>
                        ref.read(downloadQueueControllerProvider.notifier)
                            .cancel(id),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (Object e, StackTrace _) => SliverToBoxAdapter(
                child: Text('Failed to load queue: $e'),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Your downloads',
                onSeeAll: () => context.pushNamed(AppRoutes.offlineLessons),
              ),
            ),
            itemsAsync.when(
              data: (List<OfflineItemEntity> items) {
                if (items.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: OfflineEmptyState(
                      title: 'Nothing downloaded yet',
                      message:
                          'Tap a lesson or question set below to start '
                          'downloading for offline use.',
                      icon: AppIcons.bookmarkLesson,
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final OfflineItemEntity item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.xs,
                        ),
                        child: DownloadCard(
                          item: item,
                          onDownload: () => AppSnackBar.showInfo(
                            context,
                            'Re-downloading ${item.title}…',
                          ),
                          onOpen: () => AppSnackBar.showInfo(
                            context,
                            'Opening ${item.title}…',
                          ),
                          onDelete: () async {
                            await ref
                                .read(deleteDownloadUseCaseProvider)
                                .call(item.id);
                            if (!context.mounted) return;
                            AppSnackBar.showInfo(
                              context,
                              '${item.title} removed from downloads',
                            );
                          },
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (Object e, StackTrace _) => SliverToBoxAdapter(
                child: Text('Failed to load downloads: $e'),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Catalog · lessons',
                onSeeAll: () => context.pushNamed(AppRoutes.offlineLessons),
              ),
            ),
            SliverToBoxAdapter(
              child: _CatalogActions(
                onTapLesson: () => _enqueue(
                  ref,
                  context,
                  title: 'English Tenses — Complete Pack',
                  contentId: 'lesson-en-tenses',
                  type: OfflineContentType.lesson,
                  sizeMb: 24,
                ),
                onTapQuestions: () => _enqueue(
                  ref,
                  context,
                  title: 'BCS Preliminary 2024 — Model Set',
                  contentId: 'qs-bcs-2024',
                  type: OfflineContentType.questionSet,
                  sizeMb: 12,
                ),
                onTapMock: () => _enqueue(
                  ref,
                  context,
                  title: 'BCS Full Mock Test',
                  contentId: 'mt-bcs-full',
                  type: OfflineContentType.mockTest,
                  sizeMb: 32,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }

  Future<void> _enqueue(
    WidgetRef ref,
    BuildContext context, {
    required String title,
    required String contentId,
    required OfflineContentType type,
    required int sizeMb,
  }) async {
    await ref.read(downloadQueueControllerProvider.notifier).enqueue(
          contentId: contentId,
          title: title,
          contentType: type,
          totalBytes: sizeMb * 1024 * 1024,
        );
    if (!context.mounted) return;
    AppSnackBar.showSuccess(context, 'Queued: $title');
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See all'),
            ),
        ],
      ),
    );
  }
}

class _CatalogActions extends StatelessWidget {
  const _CatalogActions({
    required this.onTapLesson,
    required this.onTapQuestions,
    required this.onTapMock,
  });

  final VoidCallback onTapLesson;
  final VoidCallback onTapQuestions;
  final VoidCallback onTapMock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PrimaryButton(
            text: 'Download lesson · 24 MB',
            icon: AppIcons.bookmarkLesson,
            onPressed: onTapLesson,
            fullWidth: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            text: 'Download question set · 12 MB',
            icon: AppIcons.bookmarkQuestion,
            onPressed: onTapQuestions,
            fullWidth: true,
            variant: PrimaryButtonVariant.tonal,
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            text: 'Download full mock test · 32 MB',
            icon: Icons.assignment_rounded,
            onPressed: onTapMock,
            fullWidth: true,
            variant: PrimaryButtonVariant.outlined,
          ),
        ],
      ),
    );
  }
}
