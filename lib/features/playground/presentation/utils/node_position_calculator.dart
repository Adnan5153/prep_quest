import 'package:flutter/material.dart';

class NodePositionCalculator {
  const NodePositionCalculator._();

  static Offset alongSegment(
    Offset start,
    Offset end, {
    required double fraction,
  }) {
    final clamped = fraction.clamp(0.0, 1.0);
    return Offset(
      start.dx + (end.dx - start.dx) * clamped,
      start.dy + (end.dy - start.dy) * clamped,
    );
  }

  static double segmentLength(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    return (dx * dx + dy * dy);
  }

  static Offset bezierPoint(
    Offset start,
    Offset control,
    Offset end, {
    required double t,
  }) {
    final clamped = t.clamp(0.0, 1.0);
    final inverse = 1.0 - clamped;
    final x =
        inverse * inverse * start.dx +
        2 * inverse * clamped * control.dx +
        clamped * clamped * end.dx;
    final y =
        inverse * inverse * start.dy +
        2 * inverse * clamped * control.dy +
        clamped * clamped * end.dy;
    return Offset(x, y);
  }

  static List<Offset> sampleBezier(
    Offset start,
    Offset control,
    Offset end, {
    int samples = 16,
  }) {
    return List<Offset>.generate(
      samples + 1,
      (i) => bezierPoint(start, control, end, t: i / samples),
    );
  }
}
