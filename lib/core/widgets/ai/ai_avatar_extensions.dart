import 'package:flutter/material.dart';

import 'ai_avatar_status.dart';

/// Lightweight helpers that translate an [AiAvatarStatus] into the small
/// semantic bits every layer in the avatar stack reaches for. Keeping these
/// here avoids scattering string literals and icon lookups across widgets.
extension AiAvatarStatusX on AiAvatarStatus {
  /// Human-readable label suitable for screen readers and tooltips.
  String get semanticLabel {
    switch (this) {
      case AiAvatarStatus.idle:
        return 'AI assistant is ready';
      case AiAvatarStatus.listening:
        return 'AI assistant is listening';
      case AiAvatarStatus.thinking:
        return 'AI assistant is thinking';
      case AiAvatarStatus.generating:
        return 'AI assistant is generating a response';
      case AiAvatarStatus.typing:
        return 'AI assistant is typing';
      case AiAvatarStatus.speaking:
        return 'AI assistant is speaking';
      case AiAvatarStatus.success:
        return 'AI assistant completed successfully';
      case AiAvatarStatus.warning:
        return 'AI assistant has a warning';
      case AiAvatarStatus.error:
        return 'AI assistant encountered an error';
      case AiAvatarStatus.offline:
        return 'AI assistant is offline';
    }
  }

  /// Single-line caption shown underneath the avatar in some surfaces.
  String get caption {
    switch (this) {
      case AiAvatarStatus.idle:
        return 'Ready';
      case AiAvatarStatus.listening:
        return 'Listening';
      case AiAvatarStatus.thinking:
        return 'Thinking';
      case AiAvatarStatus.generating:
        return 'Generating';
      case AiAvatarStatus.typing:
        return 'Typing';
      case AiAvatarStatus.speaking:
        return 'Speaking';
      case AiAvatarStatus.success:
        return 'Done';
      case AiAvatarStatus.warning:
        return 'Heads up';
      case AiAvatarStatus.error:
        return 'Error';
      case AiAvatarStatus.offline:
        return 'Offline';
    }
  }

  /// Icon shown at the centre of the orb in idle / persisted states.
  IconData get coreIcon {
    switch (this) {
      case AiAvatarStatus.idle:
        return Icons.auto_awesome_rounded;
      case AiAvatarStatus.listening:
        return Icons.mic_rounded;
      case AiAvatarStatus.thinking:
        return Icons.psychology_rounded;
      case AiAvatarStatus.generating:
        return Icons.bolt_rounded;
      case AiAvatarStatus.typing:
        return Icons.edit_rounded;
      case AiAvatarStatus.speaking:
        return Icons.graphic_eq_rounded;
      case AiAvatarStatus.success:
        return Icons.check_rounded;
      case AiAvatarStatus.warning:
        return Icons.warning_amber_rounded;
      case AiAvatarStatus.error:
        return Icons.priority_high_rounded;
      case AiAvatarStatus.offline:
        return Icons.cloud_off_rounded;
    }
  }

  /// Whether this status is "active" (non-ambient).
  bool get isActive {
    switch (this) {
      case AiAvatarStatus.idle:
      case AiAvatarStatus.offline:
        return false;
      case AiAvatarStatus.listening:
      case AiAvatarStatus.thinking:
      case AiAvatarStatus.generating:
      case AiAvatarStatus.typing:
      case AiAvatarStatus.speaking:
      case AiAvatarStatus.success:
      case AiAvatarStatus.warning:
      case AiAvatarStatus.error:
        return true;
    }
  }

  /// Whether orbiting particles should accelerate.
  bool get intensifiesParticles =>
      this == AiAvatarStatus.generating ||
      this == AiAvatarStatus.speaking ||
      this == AiAvatarStatus.error;

  /// Returns the status name — used in semantics & debug logging.
  String get name => toString().split('.').last;
}

/// Extensions on [double] for the partial particle computations used by
/// [AiAvatarParticles].
extension AiAvatarMathX on double {
  /// Linearly maps [a]..[b] to [c]..[d].
  double mapTo(double a, double b, double c, double d) {
    if ((b - a).abs() < 1e-9) return c;
    final double t = ((this - a) / (b - a)).clamp(0.0, 1.0);
    return c + (d - c) * t;
  }
}
