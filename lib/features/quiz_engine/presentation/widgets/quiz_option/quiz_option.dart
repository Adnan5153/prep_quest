import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/answer_entity.dart';
import 'quiz_option_tile.dart';
import 'quiz_option_utils.dart';

/// Composite quiz option widget. Renders the answer text, the
/// letter label, and the correct/incorrect state. Pressing a tile
/// invokes [onSelected] (selection is owned by the parent screen so
/// the widget stays UI-only).
class QuizOption extends StatelessWidget {
  const QuizOption({
    super.key,
    required this.answer,
    required this.index,
    required this.isSelected,
    required this.revealCorrectness,
    required this.onSelected,
    this.isMultiSelect = false,
    this.isCorrectAnswer = false,
    this.isLocked = false,
  });

  final AnswerEntity answer;
  final int index;
  final bool isSelected;
  final bool revealCorrectness;
  final bool isCorrectAnswer;
  final bool isMultiSelect;
  final bool isLocked;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QuizOptionVisualKind kind = QuizOptionUtils.resolve(
      isSelected: isSelected,
      revealCorrectness: revealCorrectness,
      isCorrectAnswer: isCorrectAnswer,
    );
    final QuizOptionPalette palette = QuizOptionUtils.paletteFor(
      theme,
      kind,
    );
    final String letter = QuizOptionUtils.letterAt(index);

    return QuizOptionTile(
      kind: kind,
      palette: palette,
      letter: letter,
      isMultiSelect: isMultiSelect,
      isSelected: isSelected,
      isLocked: isLocked,
      onTap: isLocked ? null : onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _BadgedLetter(letter: letter, palette: palette),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                answer.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: palette.foreground,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              QuizOptionUtils.iconFor(
                kind: kind,
                isMultiSelect: isMultiSelect,
              ),
              color: palette.foreground,
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgedLetter extends StatelessWidget {
  const _BadgedLetter({required this.letter, required this.palette});

  final String letter;
  final QuizOptionPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.letterBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        letter,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: palette.foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}