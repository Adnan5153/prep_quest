import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'paint_utilities.dart';

export 'paint_utilities.dart' show PlaygroundPathSegmentState;

enum PlaygroundPathVariant { straight, curved, bezier }

class PlaygroundPathSpec {
  const PlaygroundPathSpec({
    required this.start,
    required this.end,
    required this.state,
    this.controlA,
    this.controlB,
    this.variant = PlaygroundPathVariant.curved,
  });

  final Offset start;
  final Offset end;
  final PlaygroundPathSegmentState state;
  final Offset? controlA;
  final Offset? controlB;
  final PlaygroundPathVariant variant;

  static bool equals(PlaygroundPathSpec a, PlaygroundPathSpec b) {
    if (identical(a, b)) return true;
    if (a.state != b.state ||
        a.start != b.start ||
        a.end != b.end ||
        a.controlA != b.controlA ||
        a.controlB != b.controlB ||
        a.variant != b.variant) {
      return false;
    }
    return true;
  }
}

class PathPainter extends CustomPainter {
  PathPainter({
    required this.spec,
    required this.isDark,
    this.revealProgress = 1.0,
  });

  static final Paint _stroke = Paint()
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

    _stroke.color = _baseColor();
    _stroke.strokeWidth = _strokeWidth();

    final metric = _resolveGeometry(clamped);
    if (metric == null) return;
    canvas.drawPath(metric, _stroke);
  }

  Path? _resolveGeometry(double clamped) {
    final path = Path();
    final start = spec.start;
    final end = spec.start + (spec.end - spec.start) * clamped;
    if (end == start) return null;

    switch (spec.variant) {
      case PlaygroundPathVariant.straight:
        path
          ..moveTo(start.dx, start.dy)
          ..lineTo(end.dx, end.dy);
      case PlaygroundPathVariant.curved:
        final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
        final controlA = spec.controlA ?? Offset(mid.dx, start.dy);
        final controlB = spec.controlB ?? Offset(mid.dx, end.dy);
        path
          ..moveTo(start.dx, start.dy)
          ..cubicTo(
            controlA.dx,
            controlA.dy,
            controlB.dx,
            controlB.dy,
            end.dx,
            end.dy,
          );
      case PlaygroundPathVariant.bezier:
        final control =
            spec.controlA ??
            Offset(
              (start.dx + end.dx) / 2,
              (start.dy + end.dy) / 2 - (end.dx - start.dx).abs() * 0.30,
            );
        path
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    }
    return path;
  }

  double _strokeWidth() {
    switch (spec.state) {
      case PlaygroundPathSegmentState.completed:
        return PlaygroundSizes.roadStrokeWidth;
      case PlaygroundPathSegmentState.active:
        return PlaygroundSizes.roadStrokeWidth;
      case PlaygroundPathSegmentState.locked:
        return PlaygroundSizes.roadStrokeWidthLocked;
    }
  }

  Color _baseColor() {
    switch (spec.state) {
      case PlaygroundPathSegmentState.completed:
        return isDark
            ? PlaygroundColors.roadCompletedDark
            : PlaygroundColors.roadCompletedLight;
      case PlaygroundPathSegmentState.active:
        return isDark
            ? PlaygroundColors.roadActiveDark
            : PlaygroundColors.roadActiveLight;
      case PlaygroundPathSegmentState.locked:
        return isDark
            ? AppColors.darkMuted.withValues(
                alpha: PlaygroundMapOpacity.pathLocked,
              )
            : AppColors.lightMuted.withValues(
                alpha: PlaygroundMapOpacity.pathLocked,
              );
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter old) {
    return old.isDark != isDark ||
        old.revealProgress != revealProgress ||
        !PlaygroundPathSpec.equals(old.spec, spec);
  }
}
