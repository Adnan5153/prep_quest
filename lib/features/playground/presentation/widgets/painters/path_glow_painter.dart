import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'path_painter.dart';

class PathGlowPainter extends CustomPainter {
  PathGlowPainter({
    required this.spec,
    required this.isDark,
    required this.glowPhase,
    this.revealProgress = 1.0,
  });

  static final Paint _glowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..maskFilter = MaskFilter.blur(
      BlurStyle.normal,
      PlaygroundSizes.roadActiveGlowBlur,
    );

  final PlaygroundPathSpec spec;
  final bool isDark;
  final double glowPhase;
  final double revealProgress;

  @override
  void paint(Canvas canvas, Size size) {
    if (spec.state == PlaygroundPathSegmentState.locked) return;
    final clamped = revealProgress.clamp(0.0, 1.0);
    if (clamped <= 0) return;

    final end = spec.start + (spec.end - spec.start) * clamped;
    final path = _buildPath(end);

    final baseColor = _glowColor();
    final alpha =
        PlaygroundPathPulse.glowAlphaFloor +
        glowPhase * PlaygroundPathPulse.glowAlphaAmplitude;
    final scale =
        PlaygroundPathPulse.glowRadiusFloor +
        glowPhase * PlaygroundPathPulse.glowRadiusAmplitude;

    _glowPaint.color = baseColor.withValues(alpha: alpha);
    _glowPaint.strokeWidth =
        (PlaygroundSizes.roadStrokeWidth +
            PlaygroundSizes.roadGlowExpandActive) *
        scale;
    canvas.drawPath(path, _glowPaint);
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

  Color _glowColor() {
    switch (spec.state) {
      case PlaygroundPathSegmentState.completed:
        return isDark
            ? PlaygroundColors.roadCompletedDark
            : PlaygroundColors.roadCompletedLight;
      case PlaygroundPathSegmentState.active:
        return isDark
            ? PlaygroundColors.roadGlowDark
            : PlaygroundColors.roadGlowLight;
      case PlaygroundPathSegmentState.locked:
        return PlaygroundColors.roadLockedLight;
    }
  }

  @override
  bool shouldRepaint(covariant PathGlowPainter old) {
    return old.isDark != isDark ||
        old.glowPhase != glowPhase ||
        old.revealProgress != revealProgress ||
        !PlaygroundPathSpec.equals(old.spec, spec);
  }
}
