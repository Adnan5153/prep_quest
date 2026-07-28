import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';

class PathAnimationDriver {
  const PathAnimationDriver._();

  static double flowPhase(double raw) => raw.clamp(0.0, 1.0);

  static double glowPhase(double raw) => raw.clamp(0.0, 1.0);

  static double shimmerPhase(double raw) => raw.clamp(0.0, 1.0);

  static double revealProgress(double raw) => raw.clamp(0.0, 1.0);

  static Duration revealDuration() => PlaygroundPathDurations.reveal;
  static Duration glowDuration() => PlaygroundPathDurations.glowCycle;
  static Duration dashMarchDuration() => PlaygroundPathDurations.dashMarch;
  static Duration travelDuration() => PlaygroundPathDurations.travelHighlight;
  static Duration shimmerDuration() => PlaygroundPathDurations.shimmer;
  static Curve revealCurve() => PlaygroundPathCurves.reveal;
  static Curve glowCurve() => PlaygroundPathCurves.glow;
  static Curve dashMarchCurve() => PlaygroundPathCurves.dashMarch;
  static Curve travelCurve() => PlaygroundPathCurves.travel;
  static Curve shimmerCurve() => PlaygroundPathCurves.shimmer;
}
