import 'package:flutter/material.dart';

/// Constants used for AI-specific UI components.
class AiButtonConstants {
  const AiButtonConstants._();

  // ----- Colors -----
  static const Color aiViolet = Color(0xFF6366F1);
  static const Color aiIndigo = Color(0xFF4F46E5);
  static const Color aiPurple = Color(0xFF8B5CF6);
  static const Color aiCyan = Color(0xFF06B6D4);

  // ----- Gradients -----
  static const Gradient primaryGradient = LinearGradient(
    colors: [aiViolet, aiIndigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [aiPurple, aiViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient intelligenceGradient = LinearGradient(
    colors: [aiViolet, aiCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ----- Animations -----
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 400);
  static const Duration slowDuration = Duration(milliseconds: 800);
  static const Duration breathingDuration = Duration(milliseconds: 2000);

  // ----- Shadows -----
  static List<BoxShadow> glowShadow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.3),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];
}
