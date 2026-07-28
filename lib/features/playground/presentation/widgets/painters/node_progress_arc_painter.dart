import 'dart:math' as math;

import 'package:flutter/material.dart';

class NodeProgressArcPainter extends CustomPainter {
  NodeProgressArcPainter({
    required this.progress,
    required this.color,
    this.trackColor,
    this.strokeWidth = 2.5,
  });

  static final Paint _trackPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  static final Paint _arcPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final double progress;
  final Color color;
  final Color? trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    if (trackColor != null) {
      _trackPaint
        ..color = trackColor!
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius, _trackPaint);
    }

    if (progress <= 0) return;

    _arcPaint
      ..color = color
      ..strokeWidth = strokeWidth;
    const double startAngle = -math.pi / 2;
    final double sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      _arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant NodeProgressArcPainter old) {
    return old.progress != progress ||
        old.color != color ||
        old.trackColor != trackColor ||
        old.strokeWidth != strokeWidth;
  }
}
