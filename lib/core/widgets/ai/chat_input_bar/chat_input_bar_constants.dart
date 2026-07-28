import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';
import '../ai_constants.dart';

/// Centralised design tokens for the [ChatInputBar] widget family.
///
/// Every colour, gradient, duration, and decorative size used inside the
/// bar is declared here so the surface stays visually consistent and easy
/// to retheme without touching widget code. Values are tuned for a modern
/// AI-chat surface (rounded glass capsule, glowing send affordance).
class ChatInputBarConstants {
  const ChatInputBarConstants._();

  // ---------------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------------

  /// Light-mode background tint applied to the bar surface.
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Dark-mode background tint applied to the bar surface.
  static const Color darkSurface = Color(0xFF15171F);

  /// Light-mode input field tint (slightly inset).
  static const Color lightField = Color(0xFFF6F7FB);

  /// Dark-mode input field tint (slightly inset).
  static const Color darkField = Color(0xFF1A1D2A);

  /// Light-mode resting border colour.
  static const Color lightBorder = Color(0xFFE0E7FF);

  /// Dark-mode resting border colour.
  static const Color darkBorder = Color(0xFF2A2D55);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  /// Light-mode gradient that runs across the bar background.
  static const Gradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFFFFFFF), Color(0xFFF6F7FB)],
  );

  /// Dark-mode counterpart of [lightGradient].
  static const Gradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF1B1E2E), Color(0xFF14162A)],
  );

  /// Send-button gradient — uses the AI violet → indigo pair so the
  /// affordance reads as "AI action".
  static const Gradient sendGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[AiConstants.aiViolet, AiConstants.aiIndigo],
  );

  // ---------------------------------------------------------------------------
  // Radii
  // ---------------------------------------------------------------------------

  /// Outer radius of the bar capsule.
  static const double surfaceRadius = AppRadius.xl;

  /// Inner radius of the text-field well.
  static const double fieldRadius = AppRadius.lg;

  /// Pill radius used by the icon action buttons.
  static const double actionRadius = AppRadius.pill;

  // ---------------------------------------------------------------------------
  // Decorative sizes
  // ---------------------------------------------------------------------------

  /// Diameter of an icon action button (attach / mic).
  static const double actionSize = 40.0;

  /// Diameter of the primary send affordance.
  static const double sendSize = 44.0;

  /// Default icon size used inside the action buttons.
  static const double actionIconSize = AppSizes.iconSm;

  /// Icon size used inside the send affordance.
  static const double sendIconSize = AppSizes.iconMd - 4;

  /// Stroke width used for the inline send-loader.
  static const double sendLoaderStroke = 2.4;

  /// Maximum width the bar will ever render at, regardless of viewport.
  static const double maxBarWidth = 840.0;

  /// Minimum content width (text + actions) on phones. Drives the
  /// compact / regular breakpoint.
  static const double compactBreakpoint = AppSizes.mobileMaxWidth;

  /// Default minLines applied when the caller doesn't override it.
  static const int defaultMinLines = 1;

  /// Default maxLines applied when the caller doesn't override it.
  static const int defaultMaxLines = 6;

  // ---------------------------------------------------------------------------
  // Spacing scale (overrides for bar-internal rhythm).
  // ---------------------------------------------------------------------------

  static const double gapXxs = AppSpacing.xxs;
  static const double gapXs = AppSpacing.xs;
  static const double gapSm = AppSpacing.sm;
  static const double gapMd = AppSpacing.md;
  static const double gapLg = AppSpacing.lg;
  static const double gapXl = AppSpacing.xl;
  static const double gapXxl = AppSpacing.xxl;

  /// Padding applied to the whole bar (capsule).
  static const EdgeInsets barPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );

  /// Padding applied to the inner text-field well.
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.md,
  );

  /// Gap between the inner field and the action row.
  static const double fieldToActionsGap = AppSpacing.sm;

  /// Gap between adjacent action buttons.
  static const double actionsGap = AppSpacing.xs;

  /// Gap between the leading slot and the input.
  static const double leadingGap = AppSpacing.sm;

  // ---------------------------------------------------------------------------
  // Counter
  // ---------------------------------------------------------------------------

  /// Counter text size.
  static const double counterFontSize = 11.0;

  // ---------------------------------------------------------------------------
  // Durations
  // ---------------------------------------------------------------------------

  /// Default colour / size transition duration.
  static const Duration transitionDuration = Duration(milliseconds: 180);

  /// Send-button press feedback duration.
  static const Duration pressDuration = Duration(milliseconds: 100);

  /// Focus border draw-in duration.
  static const Duration focusDuration = Duration(milliseconds: 220);

  // ---------------------------------------------------------------------------
  // Shadows
  // ---------------------------------------------------------------------------

  /// Soft floating shadow used by the bar surface.
  static List<BoxShadow> floatingShadow(Color tint, bool isDark) => <BoxShadow>[
    BoxShadow(
      color: tint.withValues(alpha: isDark ? 0.45 : 0.10),
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: tint.withValues(alpha: isDark ? 0.18 : 0.04),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  /// Accent glow rendered under the send affordance.
  static List<BoxShadow> sendGlow(Color accent) => <BoxShadow>[
    BoxShadow(
      color: accent.withValues(alpha: 0.45),
      blurRadius: 16,
      spreadRadius: -2,
    ),
  ];
}

/// Visual style applied to the [ChatInputBar] surface.
enum ChatInputBarStyle {
  /// Soft frosted-glass capsule (matches the AI chat surfaces).
  glass,

  /// Flat solid surface — minimal / focused mode.
  flat,

  /// Outlined capsule with transparent fill.
  outlined,
}
