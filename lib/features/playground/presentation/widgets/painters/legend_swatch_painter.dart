import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';

class LegendSwatchPainter extends CustomPainter {
  LegendSwatchPainter({
    required this.color,
    this.dashLength = PlaygroundDashTokens.legendDashLength,
    this.gapLength = PlaygroundDashTokens.legendDashGap,
    this.strokeWidth = PlaygroundDashTokens.legendDashStrokeWidth,
  });

  static final Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final Color color;
  final double dashLength;
  final double gapLength;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    _strokePaint
      ..color = color
      ..strokeWidth = strokeWidth;

    final y = size.height / 2;
    double x = 0;
    while (x < size.width) {
      final end = (x + dashLength).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, y), Offset(end, y), _strokePaint);
      x += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant LegendSwatchPainter old) {
    return old.color != color ||
        old.dashLength != dashLength ||
        old.gapLength != gapLength ||
        old.strokeWidth != strokeWidth;
  }
}
