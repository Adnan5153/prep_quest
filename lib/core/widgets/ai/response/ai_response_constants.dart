import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../ai_constants.dart';

/// Centralised design tokens for the [AiResponseCard] widget family.
///
/// The response card is the *generic* envelope for any AI-generated output
/// across Prep Quest. Every colour, gradient, duration, and decorative
/// size used inside the card is declared here so the surface stays
/// visually consistent and easy to retheme without touching widget code.
class AiResponseConstants {
  const AiResponseConstants._();

  // ---------------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------------

  /// Base tint applied to the card in light mode.
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Base tint applied to the card in dark mode.
  static const Color darkSurface = Color(0xFF15171F);

  /// Soft violet wash that sits behind the body copy in light mode.
  static const Color lightBodyTint = Color(0xFFF6F7FB);

  /// Soft violet wash that sits behind the body copy in dark mode.
  static const Color darkBodyTint = Color(0xFF1A1D2A);

  /// Border tint used in light mode.
  static const Color lightBorder = Color(0xFFE0E7FF);

  /// Border tint used in dark mode.
  static const Color darkBorder = Color(0xFF2A2D55);

  // ---------------------------------------------------------------------------
  // Gradients
  // ---------------------------------------------------------------------------

  /// Vertical light-mode gradient that runs the full height of the card.
  static const Gradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFFFFFFF), Color(0xFFF6F7FB)],
  );

  /// Vertical dark-mode counterpart of [lightGradient].
  static const Gradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF1B1E2E), Color(0xFF14162A)],
  );

  /// Signature AI accent strip painted along the leading edge.
  static const Gradient accentStripGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AiConstants.aiViolet,
      AiConstants.aiPurple,
      AiConstants.aiCyan,
    ],
  );

  // ---------------------------------------------------------------------------
  // Decorative sizes
  // ---------------------------------------------------------------------------

  /// Width of the leading accent strip.
  static const double accentStripWidth = AppSizes.borderThick * 2;

  /// Avatar diameter displayed in the header.
  static const double headerAvatarSize = 36.0;

  /// Diameter of the inline spark icon next to the title.
  static const double headerIconSize = AppSizes.iconSm;

  /// Height of the badge pill in the header.
  static const double badgeHeight = 24.0;

  /// Footer icon button diameter.
  static const double footerIconSize = AppSizes.iconSm;

  /// Footer icon button tap target.
  static const double footerActionSize = AppSizes.minTapTarget;

  /// Maximum width the card will ever render at, regardless of viewport.
  static const double maxCardWidth = 720.0;

  /// Minimum width below which the card switches to compact layout.
  static const double compactBreakpoint = AppSizes.mobileMaxWidth;

  // ---------------------------------------------------------------------------
  // Radii
  // ---------------------------------------------------------------------------

  /// Outer radius of the card.
  static const double cardRadius = AppRadius.lg;

  /// Inner radius for content sections (code, callouts).
  static const double sectionRadius = AppRadius.md;

  /// Pill radius for the badge and footer toggles.
  static const double pillRadius = AppRadius.pill;

  // ---------------------------------------------------------------------------
  // Spacing scale (overrides for card-internal rhythm).
  // ---------------------------------------------------------------------------

  static const double gapXxs = AppSpacing.xxs;
  static const double gapXs = AppSpacing.xs;
  static const double gapSm = AppSpacing.sm;
  static const double gapMd = AppSpacing.md;
  static const double gapLg = AppSpacing.lg;
  static const double gapXl = AppSpacing.xl;
  static const double gapXxl = AppSpacing.xxl;

  /// Comfortable padding applied on tablet+ layouts.
  static const EdgeInsets comfortablePadding = EdgeInsets.all(AppSpacing.xl);

  /// Compact padding applied on phone layouts.
  static const EdgeInsets compactPadding = EdgeInsets.all(AppSpacing.lg);

  // ---------------------------------------------------------------------------
  // Durations
  // ---------------------------------------------------------------------------

  static const Duration hoverDuration = Duration(milliseconds: 180);
  static const Duration pressDuration = Duration(milliseconds: 100);
  static const Duration expandDuration = Duration(milliseconds: 320);

  // ---------------------------------------------------------------------------
  // Opacity / glow
  // ---------------------------------------------------------------------------

  /// Subtle glow painted around the card on hover.
  static const double hoverGlowOpacity = 0.18;

  /// Resting shadow opacity.
  static const double restingShadowOpacity = 0.08;

  /// Soft "breathing" glow drawn behind the avatar.
  static const double avatarGlowOpacity = 0.35;

  // ---------------------------------------------------------------------------
  // Shadows
  // ---------------------------------------------------------------------------

  /// Default floating shadow used by the card.
  static List<BoxShadow> floatingShadow(Color tint) => <BoxShadow>[
    BoxShadow(
      color: tint.withValues(alpha: 0.14),
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: tint.withValues(alpha: 0.06),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  /// Hover shadow — slightly stronger than [floatingShadow].
  static List<BoxShadow> hoverShadow(Color tint) => <BoxShadow>[
    BoxShadow(
      color: tint.withValues(alpha: 0.28),
      blurRadius: 32,
      spreadRadius: -2,
      offset: const Offset(0, 16),
    ),
    BoxShadow(
      color: tint.withValues(alpha: 0.10),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];
}

/// Semantic category for an [AiResponseCard].
///
/// Drives the badge label, icon, and accent palette. Generic enough to
/// cover every AI surface Prep Quest ships, but narrow enough that a
/// caller that needs a custom theme can pass [AiResponseCard.accentColor]
/// to override the resolved colour.
enum AiResponseType {
  /// Default "AI generated" label.
  generic,

  /// A question-answer / chat reply.
  answer,

  /// A nudge, hint, or contextual suggestion.
  hint,

  /// A compressed recap of larger content.
  summary,

  /// A recommended next action or item.
  recommendation,

  /// An analytical breakdown.
  analysis,

  /// A free-form explanation or insight.
  explanation,
}

/// Lifecycle / delivery status of an AI response. Used by the badge and
/// metadata row.
enum AiResponseStatus {
  /// Brand-new response that hasn't been read.
  fresh,

  /// Response delivered successfully and is current.
  delivered,

  /// Response is being regenerated or streamed in.
  streaming,

  /// Response failed; an error or retry affordance is expected.
  failed,

  /// Response has been archived or is no longer relevant.
  archived,
}

/// Confidence indicator for an AI response. Surfaces a label + colour
/// in the metadata row.
enum AiResponseConfidence {
  /// High confidence — green.
  high,

  /// Medium confidence — amber.
  medium,

  /// Low confidence — rose.
  low,

  /// Unknown / not reported.
  unknown,
}
