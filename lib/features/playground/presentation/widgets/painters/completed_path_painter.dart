import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'path_painter.dart';

class CompletedPathPainter extends CustomPainter {
  CompletedPathPainter({
    required this.spec,
    required this.isDark,
    this.revealProgress = 1.0,
  });

  static final Paint _stroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  static final Paint _highlight = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  final PlaygroundPathSpec spec;
  final bool isDark;
  final double revealProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final clamped = revealProgress.clamp(0.0, 1.0);
    if (clamped <= 0) return;

    final end = spec.start + (spec.end - spec.start) * clamped;
    final path = _buildPath(end);

    _stroke.color = _baseColor();
    _stroke.strokeWidth = PlaygroundSizes.roadStrokeWidth;
    canvas.drawPath(path, _stroke);

    _highlight.color =
        (isDark
                ? PlaygroundColors.roadHighlightDark
                : PlaygroundColors.roadHighlightLight)
            .withValues(
              alpha: isDark
                  ? PlaygroundAlpha.roadHighlightAlphaDark
                  : PlaygroundAlpha.roadHighlightAlphaLight,
            );
    _highlight.strokeWidth = PlaygroundSizes.roadHighlightThickness;
    canvas.drawPath(path, _highlight);
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

  Color _baseColor() {
    return isDark
        ? PlaygroundColors.roadCompletedDark
        : PlaygroundColors.roadCompletedLight;
  }

  @override
  bool shouldRepaint(covariant CompletedPathPainter old) {
    return old.isDark != isDark ||
        old.revealProgress != revealProgress ||
        !PlaygroundPathSpec.equals(old.spec, spec);
  }
}
