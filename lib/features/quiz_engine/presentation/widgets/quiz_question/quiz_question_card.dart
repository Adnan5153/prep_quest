import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/question_entity.dart';
import 'quiz_question_body.dart';
import 'quiz_question_header.dart';

/// Composite card displaying a single question. The card is split
/// into a [QuizQuestionHeader] (subject + index + topic) and a
/// [QuizQuestionBody] (prompt + media + actions). The widget is
/// presentation-only; selection state and feedback are passed in.
class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.total,
    required this.subject,
    required this.isFlagged,
    required this.isBookmarked,
    required this.revealCorrectness,
    required this.hintCount,
    required this.hintsRevealedCount,
    required this.onFlagToggle,
    required this.onBookmarkToggle,
    required this.onReport,
    required this.onHintReveal,
  });

  final QuestionEntity question;
  final int index;
  final int total;
  final String subject;
  final bool isFlagged;
  final bool isBookmarked;
  final bool revealCorrectness;
  final int hintCount;
  final int hintsRevealedCount;
  final VoidCallback onFlagToggle;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onReport;
  final VoidCallback onHintReveal;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          QuizQuestionHeader(
            question: question,
            index: index,
            total: total,
            subject: subject,
            isFlagged: isFlagged,
            isBookmarked: isBookmarked,
            onFlagToggle: onFlagToggle,
            onBookmarkToggle: onBookmarkToggle,
            onReport: onReport,
          ),
          const SizedBox(height: AppSpacing.md),
          QuizQuestionBody(
            question: question,
            revealCorrectness: revealCorrectness,
            hintCount: hintCount,
            hintsRevealedCount: hintsRevealedCount,
            onHintReveal: onHintReveal,
          ),
        ],
      ),
    );
  }
}