import 'package:flutter/material.dart';

import '../painters/path_dash_painter.dart';
import '../painters/path_glow_painter.dart';
import '../painters/path_painter.dart';
import '../painters/path_shadow_painter.dart';

export '../painters/path_painter.dart'
    show PlaygroundPathSegmentState, PlaygroundPathVariant;

class PathSegment extends StatelessWidget {
  const PathSegment({
    super.key,
    required this.start,
    required this.end,
    required this.state,
    this.controlA,
    this.controlB,
    this.variant = PlaygroundPathVariant.curved,
    this.revealProgress = 1.0,
    this.glowPhase = 0.0,
    this.dashOffset = 0.0,
    this.isDark = false,
    this.showShadow = true,
    this.showGlow = true,
  });

  final Offset start;
  final Offset end;
  final PlaygroundPathSegmentState state;
  final Offset? controlA;
  final Offset? controlB;
  final PlaygroundPathVariant variant;
  final double revealProgress;
  final double glowPhase;
  final double dashOffset;
  final bool isDark;
  final bool showShadow;
  final bool showGlow;

  PlaygroundPathSpec get _spec => PlaygroundPathSpec(
    start: start,
    end: end,
    state: state,
    controlA: controlA,
    controlB: controlB,
    variant: variant,
  );

  Rect get _bounds {
    final xs = <double>[start.dx, end.dx];
    final ys = <double>[start.dy, end.dy];
    if (controlA != null) {
      xs.add(controlA!.dx);
      ys.add(controlA!.dy);
    }
    if (controlB != null) {
      xs.add(controlB!.dx);
      ys.add(controlB!.dy);
    }
    final minX = xs.reduce((a, b) => a < b ? a : b);
    final maxX = xs.reduce((a, b) => a > b ? a : b);
    final minY = ys.reduce((a, b) => a < b ? a : b);
    final maxY = ys.reduce((a, b) => a > b ? a : b);
    return Rect.fromLTRB(minX, minY, maxX, maxY).inflate(32);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _bounds,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: PathShadowPainter(
            spec: _spec,
            isDark: isDark,
            revealProgress: revealProgress,
          ),
          foregroundPainter: _buildForeground(),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  CustomPainter _buildForeground() {
    switch (state) {
      case PlaygroundPathSegmentState.locked:
        return PathDashPainter(
          spec: _spec,
          isDark: isDark,
          revealProgress: revealProgress,
        );
      case PlaygroundPathSegmentState.active:
        return PathGlowPainter(
          spec: _spec,
          isDark: isDark,
          glowPhase: glowPhase,
          revealProgress: revealProgress,
        );
      case PlaygroundPathSegmentState.completed:
        return PathPainter(
          spec: _spec,
          isDark: isDark,
          revealProgress: revealProgress,
        );
    }
  }
}
