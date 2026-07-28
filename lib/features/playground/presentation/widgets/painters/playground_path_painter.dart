import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'paint_utilities.dart';

export 'paint_utilities.dart'
    show PlaygroundPathSegment, PlaygroundPathSegmentState;

class PlaygroundPathPainter extends CustomPainter {
  PlaygroundPathPainter({
    required this.segments,
    required this.isDark,
    this.revealProgress = 1.0,
  });

  static const double _glowBlur = PlaygroundSizes.mapPathGlowBlur;
  static const double _glowSpread = PlaygroundSizes.mapPathGlowSpread;

  static final Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static final Paint _glowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, _glowBlur);

  final Path _reusablePath = Path();

  final List<PlaygroundPathSegment> segments;
  final bool isDark;
  final double revealProgress;

  @override
  void paint(Canvas canvas, Size size) {
    if (segments.isEmpty) return;
    final clampedProgress = revealProgress.clamp(0.0, 1.0);
    final path = _reusablePath;

    for (final segment in segments) {
      if (clampedProgress <= 0) continue;

      path.reset();
      path.moveTo(segment.start.dx, segment.start.dy);
      if (segment.isCurved) {
        final a = segment.controlA!;
        final b = segment.controlB!;
        final partialA = segment.start + (a - segment.start) * clampedProgress;
        final partialB = a + (b - a) * clampedProgress;
        final partialEnd = b + (segment.end - b) * clampedProgress;
        path.cubicTo(
          partialA.dx,
          partialA.dy,
          partialB.dx,
          partialB.dy,
          partialEnd.dx,
          partialEnd.dy,
        );
      } else {
        final partialEnd =
            segment.start + (segment.end - segment.start) * clampedProgress;
        path.lineTo(partialEnd.dx, partialEnd.dy);
      }

      canvas.drawPath(path, _strokeForState(segment.state));
      if (segment.state == PlaygroundPathSegmentState.active) {
        _glowPaint.color = _activeColor().withValues(
          alpha: PlaygroundMapOpacity.cameraGlow,
        );
        _glowPaint.strokeWidth =
            PlaygroundSizes.mapStrokeWidthActive + _glowSpread;
        canvas.drawPath(path, _glowPaint);
      }
    }
  }

  Paint _strokeForState(PlaygroundPathSegmentState state) {
    switch (state) {
      case PlaygroundPathSegmentState.completed:
        _strokePaint.color = _completedColor();
        _strokePaint.strokeWidth = PlaygroundSizes.mapStrokeWidthCompleted;
      case PlaygroundPathSegmentState.active:
        _strokePaint.color = _activeColor();
        _strokePaint.strokeWidth = PlaygroundSizes.mapStrokeWidthActive;
      case PlaygroundPathSegmentState.locked:
        _strokePaint.color = _lockedColor();
        _strokePaint.strokeWidth = PlaygroundSizes.mapStrokeWidthFuture;
    }
    return _strokePaint;
  }

  Color _completedColor() => AppColors.success;
  Color _activeColor() => AppColors.accent;
  Color _lockedColor() => isDark
      ? AppColors.darkMuted.withValues(alpha: PlaygroundMapOpacity.pathLocked)
      : AppColors.lightMuted.withValues(alpha: PlaygroundMapOpacity.pathLocked);

  @override
  bool shouldRepaint(covariant PlaygroundPathPainter old) {
    return old.revealProgress != revealProgress ||
        old.isDark != isDark ||
        !playgroundPathSegmentListEqualsSegments(old.segments, segments);
  }
}
