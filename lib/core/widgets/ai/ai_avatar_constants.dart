import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import 'ai_constants.dart';

/// Design tokens for the [AiAvatarAnimation] "Living AI Orb".
///
/// Values are derived from the AI palette in [AiConstants] and the global
/// spacing / sizing scales. The intent is to keep the widget stack
/// (glow + particles + painter + core) visually unified.
class AiAvatarConstants {
  const AiAvatarConstants._();

  // ---------------------------------------------------------------------------
  // Geometry
  // ---------------------------------------------------------------------------

  /// Default avatar diameter used by most surfaces.
  static const double defaultSize = 48.0;

  /// Minimum diameter the avatar accepts without losing motion fidelity.
  static const double minSize = 24.0;

  /// Maximum diameter — used on desktop / hero placements.
  static const double maxSize = 192.0;

  /// Outer padding budget for the painter stack (glow + halo + ring).
  static const double stackPadding = 14.0;

  // ---------------------------------------------------------------------------
  // Ring / orb metrics (relative to [size])
  // ---------------------------------------------------------------------------

  /// Outer halo extension, as a fraction of the avatar diameter.
  static const double haloExtension = 0.55;

  /// Energy ring thickness, as a fraction of the avatar diameter.
  static const double ringThicknessFactor = 0.08;

  /// Border ring stroke width, as a fraction of the avatar diameter.
  static const double borderStrokeFactor = 0.025;

  /// Inner highlight radius, as a fraction of the avatar diameter.
  static const double innerHighlightFactor = 0.62;

  /// Bloom radius factor — controls glow spread.
  static const double bloomFactor = 0.85;

  // ---------------------------------------------------------------------------
  // Particles
  // ---------------------------------------------------------------------------

  /// Number of orbiting particles at the default size.
  static const int defaultParticleCount = 6;

  /// Hard cap on particles to keep frame budget predictable.
  static const int maxParticleCount = 14;

  /// Orbit radius factor (relative to diameter).
  static const double particleOrbitFactor = 0.74;

  /// Particle radius factor (relative to diameter).
  static const double particleRadiusFactor = 0.045;

  // ---------------------------------------------------------------------------
  // Animation durations
  // ---------------------------------------------------------------------------

  /// Slow "breathing" loop used by idle / thinking / listening states.
  static const Duration breathingDuration = Duration(milliseconds: 2400);

  /// Faster orbit for the energy ring during thinking.
  static const Duration orbitDuration = Duration(milliseconds: 3200);

  /// Particle drift duration.
  static const Duration particleDuration = Duration(milliseconds: 4800);

  /// Speaking wave pulse.
  static const Duration speakingDuration = Duration(milliseconds: 900);

  /// Short pulse used for success / warning / error acknowledgements.
  static const Duration pulseDuration = Duration(milliseconds: 700);

  /// Cross-fade duration when the status changes.
  static const Duration statusTransitionDuration = Duration(milliseconds: 320);

  // ---------------------------------------------------------------------------
  // Curves
  // ---------------------------------------------------------------------------

  static const Curve idleCurve = Curves.easeInOut;
  static const Curve orbitCurve = Curves.linear;
  static const Curve pulseCurve = Curves.easeOutCubic;
  static const Curve shakeCurve = Curves.easeInOut;
  static const Curve waveCurve = Curves.easeOut;

  // ---------------------------------------------------------------------------
  // Opacity scales
  // ---------------------------------------------------------------------------

  /// Opacity used for the avatar when [AiAvatarStatus.offline].
  static const double offlineOpacity = 0.55;

  /// Opacity ceiling for the halo during idle states.
  static const double idleHaloOpacity = 0.55;

  /// Opacity ceiling for the halo during active states.
  static const double activeHaloOpacity = 0.95;

  /// Base glow opacity floor for all states.
  static const double baseGlowOpacity = 0.18;

  /// Max glow opacity used during generating / speaking states.
  static const double maxGlowOpacity = 0.65;

  // ---------------------------------------------------------------------------
  // Visual presets
  // ---------------------------------------------------------------------------

  /// Default orb gradient — the brand "intelligence" sweep.
  static const Gradient orbGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF8B5CF6), Color(0xFF6366F1), Color(0xFF06B6D4)],
    stops: <double>[0.0, 0.55, 1.0],
  );

  /// Highlight gradient — vertical sheen used on the orb top.
  static const Gradient highlightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0x66FFFFFF), Color(0x00FFFFFF)],
    stops: <double>[0.0, 1.0],
  );

  /// Energy ring gradient used during thinking / generating.
  static const Gradient energyRingGradient = SweepGradient(
    startAngle: 0,
    endAngle: 6.283185307179586, // 2π
    colors: <Color>[
      Color(0x006366F1),
      Color(0xFF8B5CF6),
      Color(0xFF06B6D4),
      Color(0x006366F1),
    ],
    stops: <double>[0.0, 0.4, 0.75, 1.0],
  );

  /// Success gradient — for the [AiAvatarStatus.success] state.
  static const Gradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF34D399), Color(0xFF059669)],
  );

  /// Warning gradient — for the [AiAvatarStatus.warning] state.
  static const Gradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFFBBF24), Color(0xFFD97706)],
  );

  /// Error gradient — for the [AiAvatarStatus.error] state.
  static const Gradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFF87171), Color(0xFFDC2626)],
  );

  /// Offline gradient — desaturated grayscale.
  static const Gradient offlineGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF6B7280), Color(0xFF374151)],
  );

  // ---------------------------------------------------------------------------
  // Shadows
  // ---------------------------------------------------------------------------

  /// Soft drop shadow used under the orb.
  static List<BoxShadow> coreShadow(Color accent, {double intensity = 1.0}) {
    return <BoxShadow>[
      BoxShadow(
        color: accent.withValues(alpha: 0.28 * intensity),
        blurRadius: 18,
        spreadRadius: -2,
      ),
      BoxShadow(
        color: accent.withValues(alpha: 0.12 * intensity),
        blurRadius: 32,
        spreadRadius: -4,
      ),
    ];
  }

  /// Border fallback when no custom border color is supplied.
  static Color defaultBorder(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.55);
  }

  /// Convenience accessor for the default size.
  static double get iconSize => AppSizes.iconMd;
}
