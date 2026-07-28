import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_blurs.dart';
import '../../../../../core/constants/app_colors.dart';

class StreakFlamePainter extends CustomPainter {
  StreakFlamePainter({
    required this.phase,
    required this.base,
    required this.highlight,
    required this.isAtRisk,
  });

  static final Paint _body = Paint();
  static final Paint _core = Paint()
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, AppBlurs.xs);

  final double phase;
  final Color base;
  final Color highlight;
  final bool isAtRisk;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final baseY = size.height * 0.92;
    final flicker = 0.04 * math.sin(phase * 2 * math.pi);

    final bodyPath = Path()
      ..moveTo(cx, baseY)
      ..quadraticBezierTo(
        size.width * (0.05 + flicker),
        size.height * 0.55,
        cx,
        size.height * (0.08 + flicker),
      )
      ..quadraticBezierTo(
        size.width * (0.95 - flicker),
        size.height * 0.55,
        cx,
        baseY,
      )
      ..close();

    _body.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isAtRisk
          ? <Color>[AppColors.buildingLocked, base]
          : <Color>[highlight, base],
    ).createShader(Offset.zero & size);
    canvas.drawPath(bodyPath, _body);

    _core.color = AppColors.lightBackground.withValues(alpha: 0.6);
    final corePath = Path()
      ..moveTo(cx, baseY * 0.85)
      ..quadraticBezierTo(
        cx - size.width * 0.10,
        size.height * 0.45,
        cx,
        size.height * 0.30,
      )
      ..quadraticBezierTo(
        cx + size.width * 0.10,
        size.height * 0.45,
        cx,
        baseY * 0.85,
      )
      ..close();
    canvas.drawPath(corePath, _core);
  }

  @override
  bool shouldRepaint(covariant StreakFlamePainter old) {
    return old.phase != phase ||
        old.base != base ||
        old.highlight != highlight ||
        old.isAtRisk != isAtRisk;
  }
}
