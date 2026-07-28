import 'package:flutter/material.dart';
import '../ai_constants.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';

/// Semantic tone for [AiHintCard] to drive visual cues.
enum AiHintType {
  examStrategy,
  memoryTrick,
  quickTip,
  commonMistake,
  shortcut,
  importantFact,
  revisionReminder,
  aiRecommendation,
}

/// Difficulty indicator for the hint.
enum AiHintDifficulty { beginner, intermediate, advanced, expert }

/// Design tokens specific to the [AiHintCard] family.
class AiHintConstants {
  const AiHintConstants._();

  // ---------------------------------------------------------------------------
  // Surfaces & Colors
  // ---------------------------------------------------------------------------

  static const Color lightBorder = Color(0xFFE0E7FF);
  static const Color darkBorder = Color(0xFF2A2D55);

  static const Gradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
  );

  static const Gradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B1E2E), Color(0xFF14162A)],
  );

  // ---------------------------------------------------------------------------
  // Dimensions
  // ---------------------------------------------------------------------------

  static const double cardRadius = AppRadius.lg;
  static const double accentStripWidth = 4.0;
  static const double iconSize = AppSizes.iconSm;
  static const double badgeHeight = 24.0;
  static const double pillRadius = AppRadius.pill;
  static const double maxCardWidth = 600.0;
  static const double compactBreakpoint = 400.0;

  // ---------------------------------------------------------------------------
  // Durations
  // ---------------------------------------------------------------------------

  static const Duration hoverDuration = Duration(milliseconds: 200);
  static const Duration pressDuration = Duration(milliseconds: 100);

  // ---------------------------------------------------------------------------
  // Mapping Helpers
  // ---------------------------------------------------------------------------

  static Color colorForType(AiHintType type) {
    switch (type) {
      case AiHintType.examStrategy:
        return const Color(0xFF6366F1); // Indigo
      case AiHintType.memoryTrick:
        return const Color(0xFF8B5CF6); // Purple
      case AiHintType.quickTip:
        return const Color(0xFF06B6D4); // Cyan
      case AiHintType.commonMistake:
        return const Color(0xFFF43F5E); // Rose
      case AiHintType.shortcut:
        return const Color(0xFFF59E0B); // Amber
      case AiHintType.importantFact:
        return const Color(0xFF3B82F6); // Blue
      case AiHintType.revisionReminder:
        return const Color(0xFF10B981); // Emerald
      case AiHintType.aiRecommendation:
        return AiConstants.aiViolet;
    }
  }

  static IconData iconForType(AiHintType type) {
    switch (type) {
      case AiHintType.examStrategy:
        return Icons.military_tech_rounded;
      case AiHintType.memoryTrick:
        return Icons.psychology_rounded;
      case AiHintType.quickTip:
        return Icons.lightbulb_rounded;
      case AiHintType.commonMistake:
        return Icons.report_problem_rounded;
      case AiHintType.shortcut:
        return Icons.bolt_rounded;
      case AiHintType.importantFact:
        return Icons.info_rounded;
      case AiHintType.revisionReminder:
        return Icons.history_rounded;
      case AiHintType.aiRecommendation:
        return Icons.auto_awesome_rounded;
    }
  }

  static String labelForType(AiHintType type) {
    switch (type) {
      case AiHintType.examStrategy:
        return 'Exam Strategy';
      case AiHintType.memoryTrick:
        return 'Memory Trick';
      case AiHintType.quickTip:
        return 'Quick Tip';
      case AiHintType.commonMistake:
        return 'Common Mistake';
      case AiHintType.shortcut:
        return 'Shortcut';
      case AiHintType.importantFact:
        return 'Important Fact';
      case AiHintType.revisionReminder:
        return 'Revision';
      case AiHintType.aiRecommendation:
        return 'AI Suggestion';
    }
  }

  static Color colorForDifficulty(AiHintDifficulty difficulty) {
    switch (difficulty) {
      case AiHintDifficulty.beginner:
        return const Color(0xFF22C55E);
      case AiHintDifficulty.intermediate:
        return const Color(0xFFF59E0B);
      case AiHintDifficulty.advanced:
        return const Color(0xFFEF4444);
      case AiHintDifficulty.expert:
        return const Color(0xFF7C3AED);
    }
  }
}
