import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/quiz_strings.dart';
import '../../../domain/entities/question_entity.dart';
import '../../utils/quiz_visual_mapper.dart';

class QuizQuestionHeader extends StatelessWidget {
  const QuizQuestionHeader({
    super.key,
    required this.question,
    required this.index,
    required this.total,
    required this.subject,
    required this.isFlagged,
    required this.isBookmarked,
    required this.onFlagToggle,
    required this.onBookmarkToggle,
    required this.onReport,
  });

  final QuestionEntity question;
  final int index;
  final int total;
  final String subject;
  final bool isFlagged;
  final bool isBookmarked;
  final VoidCallback onFlagToggle;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QuestionTypeVisual type =
        QuizVisualMapper.toQuestionTypeVisual(question.type);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                '${QuizStrings.questionLabel} ${index + 1} ${QuizStrings.ofLabel} $total',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                type.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: isFlagged
                  ? QuizStrings.unflagQuestion
                  : QuizStrings.flagQuestion,
              onPressed: onFlagToggle,
              icon: Icon(
                isFlagged ? Icons.flag : Icons.flag_outlined,
                color: isFlagged
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.primary,
              ),
            ),
            IconButton(
              tooltip: isBookmarked
                  ? QuizStrings.bookmarkRemove
                  : QuizStrings.bookmarkAdd,
              onPressed: onBookmarkToggle,
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: theme.colorScheme.primary,
              ),
            ),
            IconButton(
              tooltip: QuizStrings.reportQuestion,
              onPressed: onReport,
              icon: const Icon(Icons.report_outlined),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            _SubjectChip(label: subject),
            const SizedBox(width: AppSpacing.xs),
            _TopicChip(label: question.topic),
            const SizedBox(width: AppSpacing.xs),
            _DifficultyChip(label: question.difficulty),
          ],
        ),
      ],
    );
  }
}

class _SubjectChip extends StatelessWidget {
  const _SubjectChip({required this.label});

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
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label});

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
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.label});

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
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}