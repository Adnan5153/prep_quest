import 'package:flutter/material.dart';

/// Visual classification for a quiz option. The widget decides how
/// to render based on this single enum value.
enum QuizOptionVisualKind {
  idle,
  selected,
  correct,
  incorrect,
  mutedCorrect,
}

/// One-sided color palette for a single option. Built by
/// [QuizOptionUtils.paletteFor] so widgets don't need to compute
/// colors themselves.
class QuizOptionPalette {
  const QuizOptionPalette({
    required this.background,
    required this.foreground,
    required this.border,
    required this.letterBackground,
    required this.borderWidth,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final Color letterBackground;
  final double borderWidth;
}

class QuizOptionUtils {
  const QuizOptionUtils._();

  static QuizOptionVisualKind resolve({
    required bool isSelected,
    required bool revealCorrectness,
    required bool isCorrectAnswer,
  }) {
    if (!revealCorrectness) {
      return isSelected ? QuizOptionVisualKind.selected : QuizOptionVisualKind.idle;
    }
    if (isCorrectAnswer) {
      return isSelected
          ? QuizOptionVisualKind.correct
          : QuizOptionVisualKind.mutedCorrect;
    }
    if (isSelected) {
      return QuizOptionVisualKind.incorrect;
    }
    return QuizOptionVisualKind.idle;
  }

  static QuizOptionPalette paletteFor(
    ThemeData theme,
    QuizOptionVisualKind kind,
  ) {
    final ColorScheme scheme = theme.colorScheme;
    switch (kind) {
      case QuizOptionVisualKind.idle:
        return QuizOptionPalette(
          background: scheme.surface,
          foreground: scheme.onSurface,
          border: scheme.outlineVariant,
          letterBackground: scheme.surfaceContainerHighest,
          borderWidth: 1.0,
        );
      case QuizOptionVisualKind.selected:
        return QuizOptionPalette(
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          border: scheme.primary,
          letterBackground: scheme.primary,
          borderWidth: 1.5,
        );
      case QuizOptionVisualKind.correct:
        return QuizOptionPalette(
          background: const Color(0xFFE6F6EA),
          foreground: const Color(0xFF1E5631),
          border: const Color(0xFF34A853),
          letterBackground: const Color(0xFF34A853),
          borderWidth: 1.5,
        );
      case QuizOptionVisualKind.mutedCorrect:
        return QuizOptionPalette(
          background: const Color(0xFFF1F8E9),
          foreground: const Color(0xFF33691E),
          border: const Color(0xFF8BC34A),
          letterBackground: const Color(0xFF8BC34A),
          borderWidth: 1.0,
        );
      case QuizOptionVisualKind.incorrect:
        return QuizOptionPalette(
          background: const Color(0xFFFDECEA),
          foreground: const Color(0xFF8B1A1A),
          border: const Color(0xFFE53935),
          letterBackground: const Color(0xFFE53935),
          borderWidth: 1.5,
        );
    }
  }

  static IconData iconFor({
    required QuizOptionVisualKind kind,
    required bool isMultiSelect,
  }) {
    switch (kind) {
      case QuizOptionVisualKind.idle:
        return isMultiSelect ? Icons.check_box_outline_blank : Icons.radio_button_unchecked;
      case QuizOptionVisualKind.selected:
        return isMultiSelect ? Icons.check_box : Icons.radio_button_checked;
      case QuizOptionVisualKind.correct:
        return Icons.check_circle;
      case QuizOptionVisualKind.mutedCorrect:
        return Icons.check_circle_outline;
      case QuizOptionVisualKind.incorrect:
        return Icons.cancel;
    }
  }

  static String letterAt(int index) {
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (index < 0 || index >= alphabet.length) return '?';
    return alphabet[index];
  }
}