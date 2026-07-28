import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../domain/entities/lesson_entity.dart';
import '../constants/lesson_constants.dart';
import '../constants/lesson_strings.dart';
import '../providers/lesson_provider.dart';
import '../widgets/lesson_progress/lesson_progress_bar.dart';
import '../widgets/lesson_section/lesson_section_card.dart';

class LessonReaderScreen extends ConsumerStatefulWidget {
  const LessonReaderScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonReaderScreen> createState() => _LessonReaderScreenState();
}

class _LessonReaderScreenState extends ConsumerState<LessonReaderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(lessonDetailControllerProvider(widget.lessonId).notifier)
          .load(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final LessonDetailState state =
        ref.watch(lessonDetailControllerProvider(widget.lessonId));

    return Scaffold(
      appBar: AppBar(
        title: Text(LessonStrings.readerTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(
            AppRoutes.lessonDetail,
            queryParameters: <String, String>{'lessonId': widget.lessonId},
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: LessonStrings.viewExamples,
            icon: const Icon(Icons.psychology_outlined),
            onPressed: () => context.goNamed(
              AppRoutes.lessonExamples,
              queryParameters: <String, String>{'lessonId': widget.lessonId},
            ),
          ),
          IconButton(
            tooltip: LessonStrings.openSummary,
            icon: const Icon(Icons.checklist),
            onPressed: () => context.goNamed(
              AppRoutes.lessonSummary,
              queryParameters: <String, String>{'lessonId': widget.lessonId},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (state.status) {
          LessonStatus.initial ||
          LessonStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          LessonStatus.error => _ErrorView(
              message: state.errorMessage ?? 'Could not load lesson',
              onRetry: () => ref
                  .read(lessonDetailControllerProvider(widget.lessonId).notifier)
                  .load(widget.lessonId),
            ),
          LessonStatus.ready => _LoadedReader(lesson: state.lesson!),
        },
      ),
    );
  }
}

class _LoadedReader extends ConsumerWidget {
  const _LoadedReader({required this.lesson});

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final LessonProgressState progress =
        ref.watch(lessonProgressControllerProvider);
    final int completedSections = progress.completedSectionIds
        .where((String id) => lesson.sections.any((s) => s.id == id))
        .length;
    final double ratio = lesson.sections.isEmpty
        ? 0
        : (completedSections / lesson.sections.length).clamp(0.0, 1.0);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: LessonLimits.readerMaxWidth,
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lesson.subject,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    lesson.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LessonProgressBar(
                    progress: ratio,
                    label: LessonStrings.readerProgressLabel,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ...lesson.sections.map((section) {
              final bool isSectionCompleted = progress.isSectionCompleted(
                section.id,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: LessonSectionCard(
                  section: section,
                  isCompleted: isSectionCompleted,
                  onComplete: () => ref
                      .read(lessonProgressControllerProvider.notifier)
                      .markSectionComplete(section.id),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.xl),
            _NextActions(lesson: lesson, ratio: ratio),
          ],
        ),
      ),
    );
  }
}

class _NextActions extends ConsumerWidget {
  const _NextActions({required this.lesson, required this.ratio});

  final LessonEntity lesson;
  final double ratio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FilledButton.icon(
          icon: const Icon(Icons.psychology_outlined),
          label: Text(LessonStrings.viewExamples),
          onPressed: () => context.goNamed(
            AppRoutes.lessonExamples,
            queryParameters: <String, String>{'lessonId': lesson.id},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.tonalIcon(
          icon: const Icon(Icons.checklist),
          label: Text(LessonStrings.openSummary),
          onPressed: () => context.goNamed(
            AppRoutes.lessonSummary,
            queryParameters: <String, String>{'lessonId': lesson.id},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (ratio >= 0.999)
          TextButton.icon(
            icon: const Icon(Icons.celebration),
            label: const Text('Finish lesson'),
            onPressed: () => _completeLesson(context, ref),
          ),
        OutlinedButton(
          onPressed: () => context.goNamed(AppRoutes.playground),
          child: Text(LessonStrings.backToMap),
        ),
      ],
    );
  }

  void _completeLesson(BuildContext context, WidgetRef ref) {
    final LessonProgressController controller =
        ref.read(lessonProgressControllerProvider.notifier);
    for (final dynamic s in lesson.sections) {
      controller.markSectionComplete(s.id as String);
    }
    controller.markLessonComplete(lesson.id);
    context.goNamed(
      AppRoutes.lessonSummary,
      queryParameters: <String, String>{'lessonId': lesson.id},
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

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