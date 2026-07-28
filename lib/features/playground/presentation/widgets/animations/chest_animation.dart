import 'package:flutter/animation.dart';

import '../../constants/playground_constants.dart';

/// Animation drivers used by the reward-chest widget.
class ChestAnimationDriver {
  const ChestAnimationDriver._();

  static Animation<double> lidLift(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.0,
        0.55,
        curve: Curves.easeOutBack,
      ),
    );
  }

  static Animation<double> lightBeam(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.10,
        0.70,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  static Animation<double> contentRise(AnimationController controller) {
    return CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.30,
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  static Duration totalDuration() => PlaygroundDurations.rewardChest;
}