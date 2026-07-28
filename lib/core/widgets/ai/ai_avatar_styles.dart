import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'ai_avatar_constants.dart';
import 'ai_avatar_status.dart';

/// Resolved style values used by [AiAvatarAnimation]. Building these in
/// one place keeps the widget layer free of branching logic and gives the
/// rest of the app a single point to interrogate when, e.g., a screen
/// wants to mirror the avatar's accent in its surrounding chrome.
@immutable
class AiAvatarStyle {
  const AiAvatarStyle({
    required this.tuning,
    required this.brightness,
    required this.gradient,
    required this.accent,
    required this.coreShadow,
    required this.foregroundIconColor,
    required this.outerOpacity,
    required this.borderColor,
  });

  final AiAvatarTuning tuning;
  final Brightness brightness;

  /// Gradient applied to the orb body.
  final Gradient gradient;

  /// Single accent colour driving glow + particles.
  final Color accent;

  /// Drop-shadow list painted under the orb.
  final List<BoxShadow> coreShadow;

  /// Foreground colour for the semantic icon inside the orb.
  final Color foregroundIconColor;

  /// Effective opacity multiplier (status-driven, e.g. offline = 0.55).
  final double outerOpacity;

  /// Border colour used as the orb outline.
  final Color borderColor;

  bool get isDark => brightness == Brightness.dark;
}

/// Resolves an [AiAvatarStyle] for any [AiAvatarStatus] + brightness pair.
///
/// Pure function — safe to call from `build` and from outside widgets.
class AiAvatarStyles {
  const AiAvatarStyles._();

  static AiAvatarStyle resolve(AiAvatarStatus status, Brightness brightness) {
    final AiAvatarTuning tuning = AiAvatarTuning.of(status);

    final Color accent = tuning.accent;
    final Color foregroundIconColor = _resolveForeground(brightness, tuning);
    final List<BoxShadow> coreShadow = _resolveShadows(brightness, tuning);
    final double outerOpacity = status == AiAvatarStatus.offline
        ? AiAvatarConstants.offlineOpacity
        : 1.0;
    final Color borderColor = AiAvatarConstants.defaultBorder(brightness);

    return AiAvatarStyle(
      tuning: tuning,
      brightness: brightness,
      gradient: tuning.orbGradient,
      accent: accent,
      coreShadow: coreShadow,
      foregroundIconColor: foregroundIconColor,
      outerOpacity: outerOpacity,
      borderColor: borderColor,
    );
  }

  static Color _resolveForeground(
    Brightness brightness,
    AiAvatarTuning tuning,
  ) {
    // White reads well on the saturated orb gradient in every theme.
    if (tuning.status == AiAvatarStatus.offline) {
      return brightness == Brightness.dark
          ? AppColors.darkOnSurface
          : Colors.white;
    }
    return Colors.white;
  }

  static List<BoxShadow> _resolveShadows(
    Brightness brightness,
    AiAvatarTuning tuning,
  ) {
    final double scale = brightness == Brightness.dark ? 1.2 : 0.85;
    return AiAvatarConstants.coreShadow(tuning.accent, intensity: scale);
  }
}
