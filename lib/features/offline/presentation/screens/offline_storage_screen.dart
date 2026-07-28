import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/entities/offline_item_entity.dart';
import '../providers/offline_provider.dart';
import '../widgets/download_card.dart';
import '../widgets/formatting.dart';
import '../widgets/offline_empty_state.dart';
import '../widgets/storage_usage_card.dart';

/// Storage management screen — usage card, per-item list, clear
/// cache / delete all actions.
class OfflineStorageScreen extends ConsumerWidget {
  const OfflineStorageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<OfflineItemEntity>> itemsAsync =
        ref.watch(offlineItemsStreamProvider);
    final AsyncValue<dynamic> usageAsync = ref.watch(storageUsageProvider);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Storage management',
        subtitle: 'Manage cached and downloaded content',
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          children: <Widget>[
            usageAsync.when(
              data: (dynamic usage) => StorageUsageCard(usage: usage),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, StackTrace _) =>
                  Text('Could not compute usage: $e'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildActions(context, ref),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Downloaded content',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            itemsAsync.when(
              data: (List<OfflineItemEntity> items) {
                if (items.isEmpty) {
                  return const OfflineEmptyState(
                    title: 'No downloaded content',
                    message:
                        'Nothing to manage yet. Download lessons or question '
                        'sets to see them here.',
                    icon: AppIcons.bookmarkOffline,
                  );
                }
                return Column(
                  children: <Widget>[
                    for (final OfflineItemEntity item in items) ...<Widget>[
                      DownloadCard(
                        item: item,
                        onDownload: () => AppSnackBar.showInfo(
                          context,
                          'Refreshing ${item.title}…',
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
                            'Removed ${formatBytes(item.sizeBytes)} from downloads',
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, StackTrace _) =>
                  Text('Failed to load items: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SecondaryButton(
            text: 'Clear cache',
            icon: Icons.cleaning_services_rounded,
            onPressed: () async {
              await ref.read(clearCacheUseCaseProvider).call();
              if (!context.mounted) return;
              AppSnackBar.showInfo(context, 'Sync queue cleared');
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: PrimaryButton(
            text: 'Delete all downloads',
            icon: Icons.delete_sweep_outlined,
            variant: PrimaryButtonVariant.outlined,
            onPressed: () async {
              await ref.read(deleteAllDownloadsUseCaseProvider).call();
              if (!context.mounted) return;
              AppSnackBar.showInfo(context, 'All downloads removed');
            },
          ),
        ),
      ],
    );
  }
}
