import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'paint_utilities.dart';

class DashedPathPainter extends CustomPainter {
  DashedPathPainter({
    required this.segments,
    required this.isDark,
    this.dashLength = PlaygroundDashTokens.mapDashLength,
    this.gapLength = PlaygroundDashTokens.mapDashGap,
  });

  static final Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final List<PlaygroundPathSegment> segments;
  final bool isDark;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    if (segments.isEmpty) return;

    _strokePaint.color = _dashColor();
    _strokePaint.strokeWidth = PlaygroundSizes.mapStrokeWidthDashed;

    final path = Path();
    for (final segment in segments) {
      if (segment.state != PlaygroundPathSegmentState.locked) continue;
      path
        ..reset()
        ..moveTo(segment.start.dx, segment.start.dy)
        ..lineTo(segment.end.dx, segment.end.dy);
      canvas.drawPath(
        buildDashedPath(path, dashLength: dashLength, gapLength: gapLength),
        _strokePaint,
      );
    }
  }

  Color _dashColor() {
    return isDark
        ? AppColors.darkMuted.withValues(alpha: PlaygroundMapOpacity.pathDashed)
        : AppColors.lightMuted.withValues(
            alpha: PlaygroundMapOpacity.pathDashed,
          );
  }

  @override
  bool shouldRepaint(covariant DashedPathPainter old) {
    return old.isDark != isDark ||
        old.dashLength != dashLength ||
        old.gapLength != gapLength ||
        !playgroundPathSegmentListEqualsSegments(old.segments, segments);
  }
}
