import 'package:flutter/material.dart';

import '../../../domain/entities/hint_entity.dart';

class QuizHintButtonPalette {
  const QuizHintButtonPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

class QuizHintCardPalette {
  const QuizHintCardPalette({
    required this.background,
    required this.foreground,
    required this.border,
    required this.accent,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final Color accent;
}

class QuizHintUtils {
  const QuizHintUtils._();

  static QuizHintButtonPalette paletteFor(ThemeData theme, HintEntity hint) {
    final ColorScheme scheme = theme.colorScheme;
    if (hint.isPremium) {
      return QuizHintButtonPalette(
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
        border: scheme.tertiary,
      );
    }
    return QuizHintButtonPalette(
      background: scheme.primaryContainer,
      foreground: scheme.onPrimaryContainer,
      border: scheme.primary,
    );
  }

  static QuizHintCardPalette cardPalette(ThemeData theme, HintEntity hint) {
    final ColorScheme scheme = theme.colorScheme;
    if (hint.isPremium) {
      return QuizHintCardPalette(
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
        border: scheme.tertiary,
        accent: scheme.tertiary,
      );
    }
    return QuizHintCardPalette(
      background: scheme.primaryContainer,
      foreground: scheme.onPrimaryContainer,
      border: scheme.primary,
      accent: scheme.primary,
    );
  }
}