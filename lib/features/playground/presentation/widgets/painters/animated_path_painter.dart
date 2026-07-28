import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'path_painter.dart';

class AnimatedPathPainter extends CustomPainter {
  AnimatedPathPainter({
    required this.spec,
    required this.isDark,
    required this.flowPhase,
    this.shimmerPhase = 0.0,
    this.revealProgress = 1.0,
  });

  static final Paint _flowStroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  static final Paint _travelHighlight = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  static final Paint _shimmer = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  static final Paint _spark = Paint()..isAntiAlias = true;

  final PlaygroundPathSpec spec;
  final bool isDark;
  final double flowPhase;
  final double shimmerPhase;
  final double revealProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final clamped = revealProgress.clamp(0.0, 1.0);
    if (clamped <= 0) return;
    if (spec.state == PlaygroundPathSegmentState.locked) return;

    final end = spec.start + (spec.end - spec.start) * clamped;
    final metricPath = _buildPath(end);
    _paintFlowDashes(canvas, metricPath);
    _paintTravelHighlight(canvas, metricPath);
    _paintShimmer(canvas, metricPath);
    _paintSparkTrail(canvas, metricPath);
  }

  void _paintFlowDashes(Canvas canvas, Path path) {
    _flowStroke.color =
        (isDark
                ? PlaygroundColors.roadHighlightDark
                : PlaygroundColors.roadHighlightLight)
            .withValues(alpha: PlaygroundAlpha.roadHighlightAlphaLight);
    _flowStroke.strokeWidth = PlaygroundSizes.roadHighlightThickness;
    canvas.save();
    canvas.translate(flowPhase * 24.0, 0);
    canvas.drawPath(path, _flowStroke);
    canvas.restore();
  }

  void _paintTravelHighlight(Canvas canvas, Path path) {
    _travelHighlight.color = _travelColor().withValues(
      alpha: PlaygroundAlpha.roadTravelHighlightAlpha,
    );
    _travelHighlight.strokeWidth = PlaygroundSizes.roadTravelHighlightStroke;
    canvas.drawPath(path, _travelHighlight);
  }

  void _paintShimmer(Canvas canvas, Path path) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final bandStart = metric.length * shimmerPhase;
    final bandEnd =
        bandStart + metric.length * PlaygroundSizes.roadShimmerBandRatio;
    if (bandStart >= metric.length) return;
    final segment = metric.extractPath(
      bandStart.clamp(0.0, metric.length),
      bandEnd.clamp(0.0, metric.length),
    );
    _shimmer.color =
        (isDark
                ? PlaygroundColors.roadHighlightDark
                : PlaygroundColors.roadHighlightLight)
            .withValues(alpha: PlaygroundSizes.roadShimmerBandAlpha);
    canvas.drawPath(segment, _shimmer);
  }

  void _paintSparkTrail(Canvas canvas, Path path) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final headTangent = metric.getTangentForOffset(metric.length * 0.5);
    final headPosition = headTangent?.position ?? spec.end;
    final headAlpha =
        PlaygroundPathPulse.travelHeadFloor +
        flowPhase * PlaygroundPathPulse.travelHeadAmplitude;

    _spark.color =
        (isDark
                ? PlaygroundColors.roadHighlightDark
                : PlaygroundColors.roadHighlightLight)
            .withValues(alpha: PlaygroundAlpha.roadTravelHeadAlpha * headAlpha);
    canvas.drawCircle(
      headPosition,
      PlaygroundSizes.roadTravelHeadRadius,
      _spark,
    );

    final sparkCount = 4;
    for (int i = 1; i <= sparkCount; i++) {
      final t = i / (sparkCount + 1);
      final sparkOffset =
          metric.length * (0.5 - t * PlaygroundSizes.roadSparkTrailLength);
      if (sparkOffset < 0) continue;
      final tangent = metric.getTangentForOffset(sparkOffset);
      if (tangent == null) continue;
      final radius = PlaygroundSizes.roadTravelHeadRadius * (1.0 - t);
      _spark.color =
          (isDark
                  ? PlaygroundColors.roadHighlightDark
                  : PlaygroundColors.roadHighlightLight)
              .withValues(
                alpha: PlaygroundAlpha.roadSparkTrailAlpha * (1.0 - t),
              );
      canvas.drawCircle(tangent.position, math.max(radius, 0.5), _spark);
    }
  }

  Path _buildPath(Offset end) {
    final path = Path()..moveTo(spec.start.dx, spec.start.dy);
    switch (spec.variant) {
      case PlaygroundPathVariant.straight:
        path.lineTo(end.dx, end.dy);
      case PlaygroundPathVariant.curved:
        final mid = Offset(
          (spec.start.dx + end.dx) / 2,
          (spec.start.dy + end.dy) / 2,
        );
        path.cubicTo(mid.dx, spec.start.dy, mid.dx, end.dy, end.dx, end.dy);
      case PlaygroundPathVariant.bezier:
        final control =
            spec.controlA ??
            Offset(
              (spec.start.dx + end.dx) / 2,
              (spec.start.dy + end.dy) / 2 -
                  (end.dx - spec.start.dx).abs() * 0.30,
            );
        path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    }
    return path;
  }

  Color _travelColor() {
    return isDark
        ? PlaygroundColors.roadActiveDark
        : PlaygroundColors.roadActiveLight;
  }

  @override
  bool shouldRepaint(covariant AnimatedPathPainter old) {
    return old.isDark != isDark ||
        old.flowPhase != flowPhase ||
        old.shimmerPhase != shimmerPhase ||
        old.revealProgress != revealProgress ||
        !PlaygroundPathSpec.equals(old.spec, spec);
  }
}
