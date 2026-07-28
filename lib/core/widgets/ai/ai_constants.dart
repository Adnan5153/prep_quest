import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// Centralised design tokens for the AI-powered widget family.
///
/// These constants power every chat-surface style such as the
/// [AiChatBubble], the typing indicator and the upcoming tutor
/// bottom sheet. They are kept separate from the global `AppColors`
/// because the AI palette is brand-adjacent (premium violet/indigo
/// family) and animates independently from the rest of the app.
class AiConstants {
  const AiConstants._();

  // ---------------------------------------------------------------------------
  // Brand palette
  // ---------------------------------------------------------------------------

  /// Primary AI violet — the signature "intelligence" accent.
  static const Color aiViolet = Color(0xFF6366F1);

  /// Deeper indigo used for grounding the primary gradient.
  static const Color aiIndigo = Color(0xFF4F46E5);

  /// Soft purple used for hover/secondary accents.
  static const Color aiPurple = Color(0xFF8B5CF6);

  /// Cool cyan — emphasises the streaming and thinking affordances.
  static const Color aiCyan = Color(0xFF06B6D4);

  /// Warm rose — used for system / error accents.
  static const Color aiRose = Color(0xFFF43F5E);

  /// Success green from the global palette, re-exported for convenience.
  static const Color aiSuccess = AppColors.success;

  // ---------------------------------------------------------------------------
  // Semantic surfaces
  // ---------------------------------------------------------------------------

  /// Default "glass" tint applied to AI chat bubbles in light mode.
  static const Color aiBubbleTintLight = Color(0xFFFFFFFF);

  /// Default "glass" tint applied to AI chat bubbles in dark mode.
  static const Color aiBubbleTintDark = Color(0xFF15171F);

  /// Tint applied to user-authored bubbles in light mode.
  static const Color userBubbleTintLight = Color(0xFFEEF2FF);

  /// Tint applied to user-authored bubbles in dark mode.
  static const Color userBubbleTintDark = Color(0xFF1F2233);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  /// Signature vertical gradient used for AI bubbles and avatar glows.
  static const Gradient aiGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFEEF1FF), Color(0xFFE0E7FF)],
  );

  /// Dark-mode counterpart of [aiGlassGradient].
  static const Gradient aiGlassGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF1F2240), Color(0xFF14162A)],
  );

  /// Subtle gradient used for the streaming "thinking" state.
  static const Gradient thinkingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF8B5CF6), Color(0xFF06B6D4)],
  );

  /// User-facing gradient — solid tone with a subtle highlight.
  static const Gradient userGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF6366F1), Color(0xFF4F46E5)],
  );

  /// Border gradient applied around the glass capsule.
  static const Gradient borderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFE0E7FF), Color(0xFFC7D2FE), Color(0xFFE0E7FF)],
  );

  /// Dark-mode border gradient.
  static const Gradient borderGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF2A2D55), Color(0xFF1F2240), Color(0xFF2A2D55)],
  );

  // ---------------------------------------------------------------------------
  // Spacing & radii (exposed via this file so consumers don't import
  // multiple constant files). Values mirror the global scale.
  // ---------------------------------------------------------------------------

  /// Outer spacing scale used inside AI chat bubbles.
  static const double gapXxs = 2.0;
  static const double gapXs = 4.0;
  static const double gapSm = 6.0;
  static const double gapMd = 10.0;
  static const double gapLg = 14.0;

  /// Capsule border-radius for chat bubbles.
  static const double capsuleRadius = 22.0;

  /// Smaller radius used for inline badges, code chips and footer pills.
  static const double badgeRadius = 12.0;

  /// Full pill radius used for tag-style elements.
  static const double pillRadius = 999.0;

  /// Maximum allowed width of a chat bubble relative to its parent.
  static const double maxBubbleRatio = 0.78;

  /// Maximum absolute width of a chat bubble (prevents long lines on desktop).
  static const double maxBubbleWidth = 720.0;

  /// Avatar diameter used inside the header.
  static const double headerAvatarSize = 36.0;

  /// Slightly smaller avatar for compact bubbles.
  static const double compactAvatarSize = 28.0;

  // ---------------------------------------------------------------------------
  // Durations
  // ---------------------------------------------------------------------------

  static const Duration fastDuration = Duration(milliseconds: 180);
  static const Duration normalDuration = Duration(milliseconds: 320);
  static const Duration slowDuration = Duration(milliseconds: 600);
  static const Duration streamingDuration = Duration(milliseconds: 1400);
  static const Duration breathingDuration = Duration(milliseconds: 2400);
  static const Duration typingDotDuration = Duration(milliseconds: 600);

  // ---------------------------------------------------------------------------
  // Shadow helpers
  // ---------------------------------------------------------------------------

  /// Soft floating shadow used by AI chat bubbles.
  static List<BoxShadow> floatingShadow(Color base) => <BoxShadow>[
    BoxShadow(
      color: base.withValues(alpha: 0.18),
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: base.withValues(alpha: 0.08),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  /// Accent glow used for the "streaming" indicator.
  static List<BoxShadow> streamingGlow(Color accent) => <BoxShadow>[
    BoxShadow(
      color: accent.withValues(alpha: 0.45),
      blurRadius: 18,
      spreadRadius: -2,
    ),
  ];

  /// Subtle error glow used by error bubbles.
  static List<BoxShadow> errorGlow() => <BoxShadow>[
    BoxShadow(
      color: aiRose.withValues(alpha: 0.28),
      blurRadius: 18,
      spreadRadius: -2,
    ),
  ];
}
