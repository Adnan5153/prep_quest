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

class DownloadedQuestionsScreen extends ConsumerWidget {
  const DownloadedQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<OfflineItemEntity>> asyncQuestions =
        ref.watch(_questionsProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Downloaded question sets',
        subtitle: 'Take quizzes without internet',
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: asyncQuestions.when(
          data: (List<OfflineItemEntity> items) {
            if (items.isEmpty) {
              return const OfflineEmptyState(
                title: 'No question sets downloaded',
                message: 'Question sets you download will appear here so '
                    'you can attempt them offline.',
                icon: AppIcons.bookmarkQuestion,
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
                    'Starting quiz: ${item.title}',
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
              Center(child: Text('Failed to load question sets: $e')),
        ),
      ),
    );
  }
}

final _questionsProvider =
    FutureProvider<List<OfflineItemEntity>>((Ref ref) async {
  ref.watch(offlineItemsStreamProvider);
  final GetOfflineItems useCase = ref.watch(getOfflineItemsUseCaseProvider);
  final dynamic result =
      await useCase.call(filter: OfflineContentType.questionSet);
  if (result.isFailure) {
    throw StateError('Could not load question sets');
  }
  return (result.value as List).cast<OfflineItemEntity>();
});
