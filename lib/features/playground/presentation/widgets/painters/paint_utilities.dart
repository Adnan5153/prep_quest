import 'package:flutter/material.dart';

enum PlaygroundPathSegmentState { completed, active, locked }

class PlaygroundPathSegment {
  const PlaygroundPathSegment({
    required this.start,
    required this.end,
    required this.state,
    this.controlA,
    this.controlB,
  });

  final Offset start;
  final Offset end;
  final PlaygroundPathSegmentState state;
  final Offset? controlA;
  final Offset? controlB;

  bool get isCurved => controlA != null && controlB != null;
}

class PlaygroundPathSegmentSpec {
  const PlaygroundPathSegmentSpec({
    required this.start,
    required this.end,
    required this.state,
  });

  final Offset start;
  final Offset end;
  final PlaygroundPathSegmentState state;

  static bool equals(PlaygroundPathSegmentSpec a, PlaygroundPathSegmentSpec b) {
    if (identical(a, b)) return true;
    return a.state == b.state && a.start == b.start && a.end == b.end;
  }
}

class PlaygroundGlowSpec {
  const PlaygroundGlowSpec({
    required this.center,
    required this.radius,
    required this.color,
    required this.intensity,
  });

  final Offset center;
  final double radius;
  final Color color;
  final double intensity;

  static bool equals(PlaygroundGlowSpec a, PlaygroundGlowSpec b) {
    if (identical(a, b)) return true;
    return a.center == b.center &&
        a.radius == b.radius &&
        a.color == b.color &&
        a.intensity == b.intensity;
  }
}

class PlaygroundParticleSpec {
  const PlaygroundParticleSpec({
    required this.center,
    required this.radius,
    required this.color,
    required this.alpha,
  });

  final Offset center;
  final double radius;
  final Color color;
  final double alpha;

  static bool equals(PlaygroundParticleSpec a, PlaygroundParticleSpec b) {
    if (identical(a, b)) return true;
    return a.center == b.center &&
        a.radius == b.radius &&
        a.color == b.color &&
        a.alpha == b.alpha;
  }
}

bool playgroundPathSegmentListEquals(
  List<PlaygroundPathSegmentSpec> a,
  List<PlaygroundPathSegmentSpec> b,
) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (!PlaygroundPathSegmentSpec.equals(a[i], b[i])) return false;
  }
  return true;
}

bool playgroundPathSegmentListEqualsSegments(
  List<PlaygroundPathSegment> a,
  List<PlaygroundPathSegment> b,
) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    final lhs = a[i];
    final rhs = b[i];
    if (lhs.state != rhs.state ||
        lhs.start != rhs.start ||
        lhs.end != rhs.end ||
        lhs.controlA != rhs.controlA ||
        lhs.controlB != rhs.controlB) {
      return false;
    }
  }
  return true;
}

bool playgroundGlowListEquals(
  List<PlaygroundGlowSpec> a,
  List<PlaygroundGlowSpec> b,
) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (!PlaygroundGlowSpec.equals(a[i], b[i])) return false;
  }
  return true;
}

bool playgroundParticleListEquals(
  List<PlaygroundParticleSpec> a,
  List<PlaygroundParticleSpec> b,
) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (!PlaygroundParticleSpec.equals(a[i], b[i])) return false;
  }
  return true;
}

class PlaygroundCachedPaint {
  PlaygroundCachedPaint({
    PaintingStyle style = PaintingStyle.fill,
    StrokeCap cap = StrokeCap.round,
    StrokeJoin join = StrokeJoin.round,
    bool antialias = true,
  }) : _paint = Paint()
         ..style = style
         ..strokeCap = cap
         ..strokeJoin = join
         ..isAntiAlias = antialias;

  final Paint _paint;

  Paint configure({
    Color? color,
    Color? strokeColor,
    double? strokeWidth,
    MaskFilter? maskFilter,
    Shader? shader,
    PaintingStyle? style,
    BlendMode? blendMode,
  }) {
    if (color != null) _paint.color = color;
    if (strokeColor != null) _paint.color = strokeColor;
    if (strokeWidth != null) _paint.strokeWidth = strokeWidth;
    if (maskFilter != null) _paint.maskFilter = maskFilter;
    if (shader != null) _paint.shader = shader;
    if (style != null) _paint.style = style;
    if (blendMode != null) _paint.blendMode = blendMode;
    return _paint;
  }

  Paint get paint => _paint;
}

Path buildDashedPath(
  Path source, {
  required double dashLength,
  required double gapLength,
}) {
  final result = Path();
  for (final metric in source.computeMetrics()) {
    double distance = 0.0;
    bool drawing = true;
    while (distance < metric.length) {
      final next = distance + (drawing ? dashLength : gapLength);
      if (drawing) {
        result.addPath(
          metric.extractPath(distance, next.clamp(0.0, metric.length)),
          Offset.zero,
        );
      }
      distance = next;
      drawing = !drawing;
    }
  }
  return result;
}
