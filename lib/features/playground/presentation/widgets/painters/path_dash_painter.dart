import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'paint_utilities.dart';
import 'path_painter.dart';

class PathDashPainter extends CustomPainter {
  PathDashPainter({
    required this.spec,
    required this.isDark,
    this.dashOffset = 0.0,
    this.dashLength = PlaygroundDashTokens.roadDashLength,
    this.gapLength = PlaygroundDashTokens.roadDashGap,
    this.revealProgress = 1.0,
  });

  static final Paint _dashPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  final PlaygroundPathSpec spec;
  final bool isDark;
  final double dashOffset;
  final double dashLength;
  final double gapLength;
  final double revealProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final clamped = revealProgress.clamp(0.0, 1.0);
    if (clamped <= 0) return;

    final end = spec.start + (spec.end - spec.start) * clamped;
    final source = _buildSourcePath(end);
    final shifted = source.shift(Offset.zero);
    final dashed = buildDashedPath(
      shifted,
      dashLength: dashLength,
      gapLength: gapLength,
    );

    _dashPaint.color = _dashColor();
    _dashPaint.strokeWidth = _dashStrokeWidth();
    canvas.save();
    if (dashOffset != 0) {
      canvas.translate(dashOffset, 0);
    }
    canvas.drawPath(dashed, _dashPaint);
    canvas.restore();
  }

  Path _buildSourcePath(Offset end) {
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

  Color _dashColor() {
    if (spec.state == PlaygroundPathSegmentState.locked) {
      return isDark
          ? PlaygroundColors.roadLockedDark
          : PlaygroundColors.roadLockedLight;
    }
    return isDark
        ? PlaygroundColors.roadActiveDark
        : PlaygroundColors.roadActiveLight;
  }

  double _dashStrokeWidth() {
    return spec.state == PlaygroundPathSegmentState.locked
        ? PlaygroundSizes.roadStrokeWidthLocked
        : PlaygroundSizes.roadTravelHighlightStroke;
  }

  @override
  bool shouldRepaint(covariant PathDashPainter old) {
    return old.isDark != isDark ||
        old.dashOffset != dashOffset ||
        old.dashLength != dashLength ||
        old.gapLength != gapLength ||
        old.revealProgress != revealProgress ||
        !PlaygroundPathSpec.equals(old.spec, spec);
  }
}
