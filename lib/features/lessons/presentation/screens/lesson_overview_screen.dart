import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../constants/lesson_strings.dart';
import '../providers/lesson_provider.dart';
import '../widgets/lesson_card/lesson_card.dart';

class LessonOverviewScreen extends ConsumerStatefulWidget {
  const LessonOverviewScreen({super.key, this.nodeId});

  final String? nodeId;

  @override
  ConsumerState<LessonOverviewScreen> createState() =>
      _LessonOverviewScreenState();
}

class _LessonOverviewScreenState extends ConsumerState<LessonOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final String? nodeId = widget.nodeId;
      if (nodeId != null && nodeId.isNotEmpty) {
        ref.read(lessonNodeControllerProvider(nodeId).notifier).load(nodeId);
      } else {
        ref.read(lessonListControllerProvider.notifier).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? nodeId = widget.nodeId;
    final bool filterByNode = nodeId != null && nodeId.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(LessonStrings.overviewTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      LessonStrings.overviewTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      LessonStrings.overviewSubtitle,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            if (filterByNode)
              _NodeLessonsSliver(nodeId: nodeId)
            else
              const _AllLessonsSliver(),
          ],
        ),
      ),
    );
  }
}

class _AllLessonsSliver extends ConsumerWidget {
  const _AllLessonsSliver();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LessonListState state = ref.watch(lessonListControllerProvider);
    switch (state.status) {
      case LessonStatus.initial:
      case LessonStatus.loading:
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        );
      case LessonStatus.error:
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _ErrorRetry(
            message: state.errorMessage ?? 'Something went wrong',
            onRetry: () =>
                ref.read(lessonListControllerProvider.notifier).load(),
          ),
        );
      case LessonStatus.ready:
        if (state.lessons.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyState(message: LessonStrings.emptyAllLessons),
          );
        }
        return _LessonListSliver(lessons: state.lessons);
    }
  }
}

class _NodeLessonsSliver extends ConsumerWidget {
  const _NodeLessonsSliver({required this.nodeId});

  final String nodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LessonNodeState state = ref.watch(lessonNodeControllerProvider(nodeId));
    switch (state.status) {
      case LessonStatus.initial:
      case LessonStatus.loading:
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        );
      case LessonStatus.error:
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _ErrorRetry(
            message: state.errorMessage ?? 'Something went wrong',
            onRetry: () => ref
                .read(lessonNodeControllerProvider(nodeId).notifier)
                .load(nodeId),
          ),
        );
      case LessonStatus.ready:
        if (state.lessons.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyState(message: LessonStrings.emptyLessons),
          );
        }
        return _LessonListSliver(lessons: state.lessons);
    }
  }
}

class _LessonListSliver extends ConsumerWidget {
  const _LessonListSliver({required this.lessons});

  final List<dynamic> lessons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LessonProgressState progress =
        ref.watch(lessonProgressControllerProvider);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      sliver: SliverList.separated(
        itemCount: lessons.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (BuildContext context, int index) {
          final dynamic lesson = lessons[index];
          final String lessonId = lesson.id as String;
          final bool isBookmarked = progress.isLessonBookmarked(lessonId);
          final bool isCompleted = progress.isLessonCompleted(lessonId);
          final double completionRatio = isCompleted
              ? 1.0
              : lesson.sectionCompletionRatio as double;
          return LessonCard(
            lesson: lesson,
            completionRatio: completionRatio,
            isBookmarked: isBookmarked,
            onTap: () => context.goNamed(
              AppRoutes.lessonDetail,
              queryParameters: <String, String>{'lessonId': lessonId},
            ),
            onBookmarkTap: () {
              ref
                  .read(lessonProgressControllerProvider.notifier)
                  .toggleBookmark(lessonId);
              final LessonProgressState next =
                  ref.read(lessonProgressControllerProvider);
              final ScaffoldMessengerState messenger =
                  ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    next.isLessonBookmarked(lessonId)
                        ? LessonStrings.bookmarkAdded
                        : LessonStrings.bookmarkRemoved,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonal(
            onPressed: onRetry,
            child: Text(LessonStrings.retry),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.menu_book_outlined,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
