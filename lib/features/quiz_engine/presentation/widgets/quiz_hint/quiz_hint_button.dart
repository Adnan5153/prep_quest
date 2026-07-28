import 'package:flutter/material.dart';

import '../../constants/quiz_strings.dart';
import '../../../domain/entities/hint_entity.dart';
import 'quiz_hint_utils.dart';

class QuizHintButton extends StatelessWidget {
  const QuizHintButton({
    super.key,
    required this.hint,
    required this.alreadyRevealed,
    required this.canAfford,
    required this.onReveal,
  });

  final HintEntity hint;
  final bool alreadyRevealed;
  final bool canAfford;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QuizHintButtonPalette palette = QuizHintUtils.paletteFor(theme, hint);
    final bool disabled = alreadyRevealed || !canAfford;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: disabled ? null : onReveal,
        icon: Icon(
          alreadyRevealed
              ? Icons.visibility
              : (hint.isPremium ? Icons.workspace_premium : Icons.lightbulb_outline),
          color: disabled ? palette.foreground : palette.foreground,
        ),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            alreadyRevealed
                ? 'Revealed'
                : hint.isPremium
                    ? QuizStrings.premiumHint
                    : QuizStrings.revealHint,
            style: theme.textTheme.labelLarge?.copyWith(
              color: palette.foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          side: BorderSide(color: palette.border),
          backgroundColor: palette.background,
        ),
      ),
    );
  }
}