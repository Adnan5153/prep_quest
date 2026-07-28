import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../quiz_engine/domain/entities/answer_entity.dart';
import '../../../quiz_engine/presentation/constants/quiz_strings.dart';
import '../../../quiz_engine/presentation/widgets/quiz_review/quiz_review_answer_tile.dart';

/// Answer area for a Review question card.
///
/// Lists every answer option with the same colour-coded semantics used
/// in the Quiz Engine review screen: green for correct, red for the
/// user's pick that was wrong, neutral otherwise.
class ReviewAnswerSection extends StatelessWidget {
  const ReviewAnswerSection({
    super.key,
    required this.answers,
    required this.selectedAnswerIds,
  });

  final List<AnswerEntity> answers;
  final Set<String> selectedAnswerIds;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          QuizStrings.yourAnswer,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (final AnswerEntity a in answers)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: QuizReviewAnswerTile(
                  answer: a,
                  isSelected: selectedAnswerIds.contains(a.id),
                  isCorrect: a.isCorrect,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Compact pill chip labelling the correctness status.
class ReviewStatusPill extends StatelessWidget {
  const ReviewStatusPill({
    super.key,
    required this.wasCorrect,
    required this.wasSkipped,
  });

  final bool wasCorrect;
  final bool wasSkipped;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color background;
    final Color foreground;
    final String label;
    if (wasSkipped) {
      background = theme.colorScheme.surfaceContainerHighest;
      foreground = theme.colorScheme.onSurface;
      label = QuizStrings.skippedLabel;
    } else if (wasCorrect) {
      background = const Color(0xFFE6F6EA);
      foreground = const Color(0xFF1E5631);
      label = QuizStrings.correctLabel;
    } else {
      background = const Color(0xFFFDECEA);
      foreground = const Color(0xFF8B1A1A);
      label = QuizStrings.incorrectLabel;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}