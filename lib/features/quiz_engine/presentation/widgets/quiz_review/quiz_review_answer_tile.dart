import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/answer_entity.dart';

class QuizReviewAnswerTile extends StatelessWidget {
  const QuizReviewAnswerTile({
    super.key,
    required this.answer,
    required this.isSelected,
    required this.isCorrect,
  });

  final AnswerEntity answer;
  final bool isSelected;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color border = isCorrect
        ? const Color(0xFF34A853)
        : (isSelected ? const Color(0xFFE53935) : theme.colorScheme.outlineVariant);
    final Color background = isCorrect
        ? const Color(0xFFE6F6EA)
        : (isSelected ? const Color(0xFFFDECEA) : theme.colorScheme.surface);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: border),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            isCorrect ? Icons.check_circle : (isSelected ? Icons.cancel : Icons.radio_button_unchecked),
            color: border,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              answer.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isCorrect
                    ? FontWeight.w800
                    : (isSelected ? FontWeight.w700 : FontWeight.w500),
              ),
            ),
          ),
          if (isCorrect)
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.xs),
              child: Text('Correct'),
            ),
          if (isSelected && !isCorrect)
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.xs),
              child: Text('Your pick'),
            ),
        ],
      ),
    );
  }
}