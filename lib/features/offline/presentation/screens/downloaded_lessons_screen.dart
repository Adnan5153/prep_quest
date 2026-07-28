import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../domain/entities/offline_item_entity.dart';
import '../../domain/enums/offline_content_type.dart';
import '../providers/offline_provider.dart';
import '../../domain/usecases/get_offline_items.dart';
import '../widgets/download_card.dart';
import '../widgets/offline_empty_state.dart';

class DownloadedLessonsScreen extends ConsumerWidget {
  const DownloadedLessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<OfflineItemEntity>> asyncLessons = ref.watch(
      _lessonsProvider,
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Downloaded lessons',
        subtitle: 'Read without internet',
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: asyncLessons.when(
          data: (List<OfflineItemEntity> items) {
            if (items.isEmpty) {
              return const OfflineEmptyState(
                title: 'No lessons downloaded',
                message: 'Lessons you download will appear here so you can '
                    'read them without internet.',
                icon: AppIcons.bookmarkLesson,
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (BuildContext context, int index) {
                final OfflineItemEntity item = items[index];
                return DownloadCard(
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
                      '${item.title} removed from downloads',
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object e, StackTrace _) =>
              Center(child: Text('Failed to load lessons: $e')),
        ),
      ),
    );
  }
}

final _lessonsProvider = FutureProvider<List<OfflineItemEntity>>((Ref ref) async {
  ref.watch(offlineItemsStreamProvider);
  final GetOfflineItems useCase = ref.watch(getOfflineItemsUseCaseProvider);
  final dynamic result = await useCase.call(filter: OfflineContentType.lesson);
  if (result.isFailure) {
    throw StateError('Could not load lessons');
  }
  return (result.value as List).cast<OfflineItemEntity>();
});
