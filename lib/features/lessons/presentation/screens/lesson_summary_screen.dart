import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/lesson_summary_entity.dart';
import '../constants/lesson_strings.dart';
import '../providers/lesson_provider.dart';

class LessonSummaryScreen extends ConsumerStatefulWidget {
  const LessonSummaryScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonSummaryScreen> createState() =>
      _LessonSummaryScreenState();
}

class _LessonSummaryScreenState extends ConsumerState<LessonSummaryScreen> {
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
        title: Text(LessonStrings.summaryTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(
            AppRoutes.lessonExamples,
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
          LessonStatus.ready => _LoadedSummary(
              lesson: state.lesson!,
              lessonId: widget.lessonId,
            ),
        },
      ),
    );
  }
}

class _LoadedSummary extends ConsumerWidget {
  const _LoadedSummary({required this.lesson, required this.lessonId});

  final LessonEntity lesson;
  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final LessonProgressState progress =
        ref.watch(lessonProgressControllerProvider);
    final bool isCompleted = progress.isLessonCompleted(lesson.id);
    final LessonSummaryEntity summary = lesson.summarySection;

    return ListView(
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
              Row(
                children: <Widget>[
                  Icon(
                    Icons.celebration_outlined,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      isCompleted
                          ? LessonStrings.completedCongrats
                          : 'You are close!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isCompleted
                    ? LessonStrings.completedHint
                    : 'Read the key takeaways, then return to the Playground.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _SectionHeading(
          icon: Icons.checklist,
          text: LessonStrings.keyTakeaways,
        ),
        const SizedBox(height: AppSpacing.md),
        ...summary.keyTakeaways.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _Bullet(
              icon: Icons.fiber_manual_record,
              text: point,
              iconColor: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeading(
          icon: Icons.arrow_forward,
          text: LessonStrings.nextSteps,
        ),
        const SizedBox(height: AppSpacing.md),
        ...summary.nextSteps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _Bullet(
              icon: Icons.arrow_right_alt,
              text: step,
              iconColor: theme.colorScheme.tertiary,
            ),
          ),
        ),
        if (summary.recommendedChallengeId != null) ...<Widget>[
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
                  Icons.psychology_outlined,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Recommended challenge: ${summary.recommendedChallengeId}',
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
        const SizedBox(height: AppSpacing.xl),
        _RewardCard(lesson: lesson, isCompleted: isCompleted),
        const SizedBox(height: AppSpacing.xl),
        _ActionButtons(lesson: lesson, lessonId: lessonId, isCompleted: isCompleted),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4, right: AppSpacing.sm),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        Expanded(
          child: Text(text, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.lesson, required this.isCompleted});

  final LessonEntity lesson;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.bolt,
                color: theme.colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                LessonStrings.rewardBadge,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              _RewardStat(
                icon: Icons.bolt,
                label: 'XP',
                value: lesson.rewardXp,
              ),
              const SizedBox(width: AppSpacing.lg),
              _RewardStat(
                icon: Icons.savings_outlined,
                label: 'Coins',
                value: lesson.rewardCoins,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isCompleted
                ? 'Rewards already granted for this lesson.'
                : 'Complete the lesson to earn these rewards.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardStat extends StatelessWidget {
  const _RewardStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: theme.colorScheme.onSecondaryContainer,
          size: 18,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '+$value $label',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons({
    required this.lesson,
    required this.lessonId,
    required this.isCompleted,
  });

  final LessonEntity lesson;
  final String lessonId;
  final bool isCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (!isCompleted)
          FilledButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('Mark lesson as complete'),
            onPressed: () {
              final LessonProgressController controller =
                  ref.read(lessonProgressControllerProvider.notifier);
              for (final dynamic s in lesson.sections) {
                controller.markSectionComplete(s.id as String);
              }
              controller.markLessonComplete(lesson.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Lesson completed! Reward earned.'),
                ),
              );
            },
          ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          icon: const Icon(Icons.replay),
          label: Text(LessonStrings.reviewLesson),
          onPressed: () => context.goNamed(
            AppRoutes.lessonReader,
            queryParameters: <String, String>{'lessonId': lessonId},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton(
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