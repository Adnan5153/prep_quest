import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'path_painter.dart';

class PathShadowPainter extends CustomPainter {
  PathShadowPainter({
    required this.spec,
    required this.isDark,
    this.revealProgress = 1.0,
  });

  static final Paint _shadowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..maskFilter = MaskFilter.blur(
      BlurStyle.normal,
      PlaygroundSizes.roadShadowBlur,
    );

  final PlaygroundPathSpec spec;
  final bool isDark;
  final double revealProgress;

  @override
  void paint(Canvas canvas, Size size) {
    if (spec.state == PlaygroundPathSegmentState.locked) return;
    final clamped = revealProgress.clamp(0.0, 1.0);
    if (clamped <= 0) return;

    final end = spec.start + (spec.end - spec.start) * clamped;
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

    _shadowPaint.color =
        (isDark
                ? PlaygroundColors.roadShadowDark
                : PlaygroundColors.roadShadowLight)
            .withValues(alpha: PlaygroundAlpha.roadShadowAlpha);
    _shadowPaint.strokeWidth =
        PlaygroundSizes.roadStrokeWidth + PlaygroundSizes.roadShadowSpread;
    canvas.save();
    canvas.translate(0, PlaygroundSizes.roadShadowSpread);
    canvas.drawPath(path, _shadowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant PathShadowPainter old) {
    return old.isDark != isDark ||
        old.revealProgress != revealProgress ||
        !PlaygroundPathSpec.equals(old.spec, spec);
  }
}
