import 'package:flutter/material.dart';

import '../../providers/quiz_timer_provider.dart';

class QuizTimerPalette {
  const QuizTimerPalette({
    required this.background,
    required this.foreground,
    required this.border,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final IconData icon;
}

class QuizTimerUtils {
  const QuizTimerUtils._();

  static QuizTimerPalette paletteFor(ThemeData theme, QuizTimerSnapshot s) {
    final ColorScheme scheme = theme.colorScheme;
    if (s.isExpired) {
      return const QuizTimerPalette(
        background: Color(0xFFFDECEA),
        foreground: Color(0xFF8B1A1A),
        border: Color(0xFFE53935),
        icon: Icons.timer_off_outlined,
      );
    }
    if (s.isDanger) {
      return const QuizTimerPalette(
        background: Color(0xFFFFF3E0),
        foreground: Color(0xFF8A4B00),
        border: Color(0xFFFB8C00),
        icon: Icons.timer_outlined,
      );
    }
    if (s.isWarning) {
      return const QuizTimerPalette(
        background: Color(0xFFFFFDE7),
        foreground: Color(0xFF6A4F00),
        border: Color(0xFFFFC107),
        icon: Icons.timer_outlined,
      );
    }
    if (s.state == QuizTimerState.paused) {
      return QuizTimerPalette(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurface,
        border: scheme.outline,
        icon: Icons.pause_circle_outline,
      );
    }
    return QuizTimerPalette(
      background: scheme.primaryContainer,
      foreground: scheme.onPrimaryContainer,
      border: scheme.primary,
      icon: Icons.timer_outlined,
    );
  }
}