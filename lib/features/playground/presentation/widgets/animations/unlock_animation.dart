import 'package:flutter/animation.dart';

import '../../constants/playground_constants.dart';

/// Animation drivers used when a previously locked Playground node unlocks.
class UnlockAnimationDriver {
  const UnlockAnimationDriver._();

  /// Pop-in scale curve used by an unlock animation.
  static Animation<double> scaleIn(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );
  }

  /// Halo fade curve used by an unlock animation.
  static Animation<double> haloFade(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
    );
  }

  /// Label fade curve used by an unlock animation.
  static Animation<double> labelFade(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: const Interval(0.40, 1.0, curve: Curves.easeOutCubic),
    );
  }

  static Duration totalDuration() => PlaygroundDurations.stateTransition;
  static Curve enterCurve() => PlaygroundCurves.stateEnter;
}