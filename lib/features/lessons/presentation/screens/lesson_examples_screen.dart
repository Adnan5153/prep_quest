import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../constants/lesson_strings.dart';
import '../providers/lesson_provider.dart';
import '../widgets/lesson_example/lesson_example_card.dart';

class LessonExamplesScreen extends ConsumerStatefulWidget {
  const LessonExamplesScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonExamplesScreen> createState() =>
      _LessonExamplesScreenState();
}

class _LessonExamplesScreenState
    extends ConsumerState<LessonExamplesScreen> {
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
        title: Text(LessonStrings.examplesTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(
            AppRoutes.lessonReader,
            queryParameters: <String, String>{'lessonId': widget.lessonId},
          ),
        ),
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
          LessonStatus.ready => _LoadedExamples(
              lessonTitle: state.lesson!.title,
              examples: state.lesson!.examples,
              lessonId: widget.lessonId,
            ),
        },
      ),
    );
  }
}

class _LoadedExamples extends StatelessWidget {
  const _LoadedExamples({
    required this.lessonTitle,
    required this.examples,
    required this.lessonId,
  });

  final String lessonTitle;
  final List<dynamic> examples;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Text(
          lessonTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          LessonStrings.examplesTitle,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (examples.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.psychology_alt_outlined,
                  size: 48,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  LessonStrings.examplesEmpty,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )
        else
          ...examples.map(
            (example) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: LessonExampleCard(example: example),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          icon: const Icon(Icons.checklist),
          label: Text(LessonStrings.openSummary),
          onPressed: () => context.goNamed(
            AppRoutes.lessonSummary,
            queryParameters: <String, String>{'lessonId': lessonId},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: () => context.goNamed(AppRoutes.playground),
          child: Text(LessonStrings.backToMap),
        ),
      ],
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