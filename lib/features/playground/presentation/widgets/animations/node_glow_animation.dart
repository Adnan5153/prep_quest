import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

import '../../constants/playground_constants.dart';

/// Animation drivers for the ambient glow painted behind a Playground node.
class NodeGlowAnimationDriver {
  const NodeGlowAnimationDriver._();

  /// Returns a 0..1 looped value usable as an alpha/glow phase.
  static double phaseForController(AnimationController controller) {
    return controller.value.clamp(0.0, 1.0);
  }

  /// Returns the alpha factor applied to a glow paint based on the phase.
  static double glowAlpha(double phase) {
    final clamped = phase.clamp(0.0, 1.0);
    return PlaygroundGlowPulse.alphaFloor +
        clamped * PlaygroundGlowPulse.alphaAmplitude;
  }

  /// Returns the radius scale applied to a glow paint based on the phase.
  static double glowRadius(double phase) {
    final clamped = phase.clamp(0.0, 1.0);
    return PlaygroundGlowPulse.radiusFloor +
        clamped * PlaygroundGlowPulse.radiusAmplitude;
  }

  static Duration cycleDuration() => PlaygroundDurations.ringPulseCycle;
  static Curve cycleCurve() => Curves.easeInOutSine;
}