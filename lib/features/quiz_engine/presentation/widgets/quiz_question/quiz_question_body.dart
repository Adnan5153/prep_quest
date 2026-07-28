import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/quiz_strings.dart';
import '../../../domain/entities/question_entity.dart';
import 'quiz_question_image.dart';

class QuizQuestionBody extends StatelessWidget {
  const QuizQuestionBody({
    super.key,
    required this.question,
    required this.revealCorrectness,
    required this.hintCount,
    required this.hintsRevealedCount,
    required this.onHintReveal,
  });

  final QuestionEntity question;
  final bool revealCorrectness;
  final int hintCount;
  final int hintsRevealedCount;
  final VoidCallback onHintReveal;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          question.prompt,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (question.imageUrl != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          QuizQuestionImage(
            imageUrl: question.imageUrl!,
            caption: question.mediaCaption,
          ),
        ],
        if (question.tags.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: question.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      '#$tag',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
        if (question.points > 1) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${question.points} points',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        if (hintCount > 0) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  hintsRevealedCount == 0
                      ? 'Hints available: $hintCount'
                      : 'Hints revealed: $hintsRevealedCount/$hintCount',
                  style: theme.textTheme.labelMedium,
                ),
              ),
              TextButton.icon(
                onPressed: hintsRevealedCount >= hintCount ? null : onHintReveal,
                icon: const Icon(Icons.lightbulb_outline),
                label: Text(QuizStrings.revealHint),
              ),
            ],
          ),
        ],
        if (revealCorrectness && question.explanation != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        QuizStrings.explanation,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        question.explanation!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
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