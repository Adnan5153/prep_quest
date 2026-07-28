import 'package:flutter/material.dart';

class XpOrbPainter extends CustomPainter {
  XpOrbPainter({required this.color});

  static final Paint _stroke = Paint()
    ..strokeWidth = 1.2
    ..strokeCap = StrokeCap.round;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    _stroke.color = color.withValues(alpha: 0.7);
    canvas.drawLine(
      Offset(center.dx - size.width * 0.30, center.dy),
      Offset(center.dx + size.width * 0.30, center.dy),
      _stroke,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - size.height * 0.30),
      Offset(center.dx, center.dy + size.height * 0.30),
      _stroke,
    );
  }

  @override
  bool shouldRepaint(covariant XpOrbPainter old) {
    return old.color != color;
  }
}
