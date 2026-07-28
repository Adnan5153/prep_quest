import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../domain/entities/lesson_entity.dart';
import '../constants/lesson_strings.dart';
import '../providers/lesson_provider.dart';
import '../widgets/lesson_progress/lesson_progress_bar.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonDetailScreen> createState() =>
      _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
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
        title: Text(LessonStrings.detailTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.lessons),
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
          LessonStatus.ready => _LoadedDetail(lesson: state.lesson!),
        },
      ),
    );
  }
}

class _LoadedDetail extends ConsumerWidget {
  const _LoadedDetail({required this.lesson});

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final LessonProgressState progress =
        ref.watch(lessonProgressControllerProvider);
    final bool isCompleted = progress.isLessonCompleted(lesson.id);
    final bool isBookmarked = progress.isLessonBookmarked(lesson.id);
    final double completionRatio =
        isCompleted ? 1.0 : lesson.sectionCompletionRatio;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      lesson.subject,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip:
                        isBookmarked ? 'Remove bookmark' : 'Add bookmark',
                    onPressed: () => ref
                        .read(lessonProgressControllerProvider.notifier)
                        .toggleBookmark(lesson.id),
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                lesson.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (lesson.subtitle.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  lesson.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  _Pill(
                    icon: Icons.schedule,
                    label:
                        '${lesson.estimatedReadingMinutes} ${LessonStrings.minutesShort}',
                  ),
                  _Pill(
                    icon: Icons.signal_cellular_alt,
                    label: lesson.difficulty,
                  ),
                  _Pill(
                    icon: Icons.bolt,
                    label: '+${lesson.rewardXp} XP',
                  ),
                  if (lesson.rewardCoins > 0)
                    _Pill(
                      icon: Icons.savings_outlined,
                      label: '+${lesson.rewardCoins}',
                    ),
                  if (lesson.isPremium)
                    const _Pill(
                      icon: Icons.workspace_premium,
                      label: LessonStrings.premiumTag,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        LessonProgressBar(
          progress: completionRatio,
          label: LessonStrings.readerProgressLabel,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          lesson.summary,
          style: theme.textTheme.bodyLarge,
        ),
        if (lesson.tags.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: lesson.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      '#$tag',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        _MetaRow(
          icon: Icons.flag_outlined,
          label: LessonStrings.requiresLevelLabel,
          value: 'Level ${lesson.requiresLevel}',
        ),
        const SizedBox(height: AppSpacing.sm),
        _MetaRow(
          icon: Icons.access_time,
          label: LessonStrings.estimatedReading,
          value:
              '${lesson.estimatedReadingMinutes} ${LessonStrings.minutesShort}',
        ),
        if (lesson.prerequisiteLessonIds.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.link,
            label: LessonStrings.prerequisiteLabel,
            value: lesson.prerequisiteLessonIds.length.toString(),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        _SectionPreview(
          title: 'Sections',
          subtitle: '${lesson.sections.length} parts',
          icon: Icons.layers_outlined,
          count: lesson.sections.length,
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionPreview(
          title: LessonStrings.viewExamples,
          subtitle: '${lesson.examples.length} examples',
          icon: Icons.psychology_outlined,
          count: lesson.examples.length,
        ),
        const SizedBox(height: AppSpacing.md),
        _SectionPreview(
          title: LessonStrings.openSummary,
          subtitle:
              '${lesson.summarySection.keyTakeaways.length} takeaways',
          icon: Icons.checklist,
          count: lesson.summarySection.keyTakeaways.length,
        ),
        const SizedBox(height: AppSpacing.xxl),
        _ActionButtons(lesson: lesson, isCompleted: isCompleted),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: theme.colorScheme.onPrimaryContainer),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionPreview extends StatelessWidget {
  const _SectionPreview({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.count,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '$count',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons({required this.lesson, required this.isCompleted});

  final LessonEntity lesson;
  final bool isCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FilledButton.icon(
          icon: Icon(
            isCompleted ? Icons.refresh : Icons.play_arrow,
          ),
          label: Text(
            isCompleted
                ? LessonStrings.reviewLesson
                : LessonStrings.startLesson,
          ),
          onPressed: () => context.goNamed(
            AppRoutes.lessonReader,
            queryParameters: <String, String>{'lessonId': lesson.id},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          icon: const Icon(Icons.psychology_outlined),
          label: Text(LessonStrings.viewExamples),
          onPressed: () => context.goNamed(
            AppRoutes.lessonExamples,
            queryParameters: <String, String>{'lessonId': lesson.id},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          icon: const Icon(Icons.checklist),
          label: Text(LessonStrings.openSummary),
          onPressed: () => context.goNamed(
            AppRoutes.lessonSummary,
            queryParameters: <String, String>{'lessonId': lesson.id},
          ),
        ),
        if (isCompleted) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.verified,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    LessonStrings.completedCongrats,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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