import 'package:flutter/material.dart';

import '../painters/completed_path_painter.dart';
import '../painters/path_glow_painter.dart';
import '../painters/path_painter.dart';
import '../painters/path_shadow_painter.dart';

class CompletedPath extends StatelessWidget {
  const CompletedPath({
    super.key,
    required this.start,
    required this.end,
    this.controlA,
    this.controlB,
    this.variant = PlaygroundPathVariant.curved,
    this.revealProgress = 1.0,
    this.glowPhase = 0.0,
    this.isDark = false,
    this.showShadow = true,
    this.showGlow = true,
  });

  final Offset start;
  final Offset end;
  final Offset? controlA;
  final Offset? controlB;
  final PlaygroundPathVariant variant;
  final double revealProgress;
  final double glowPhase;
  final bool isDark;
  final bool showShadow;
  final bool showGlow;

  PlaygroundPathSpec get _spec => PlaygroundPathSpec(
    start: start,
    end: end,
    state: PlaygroundPathSegmentState.completed,
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
    return Rect.fromLTRB(
      xs.reduce((a, b) => a < b ? a : b),
      ys.reduce((a, b) => a < b ? a : b),
      xs.reduce((a, b) => a > b ? a : b),
      ys.reduce((a, b) => a > b ? a : b),
    ).inflate(32);
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

  CustomPainter? _buildForeground() {
    final children = <CustomPainter>[];
    if (showGlow) {
      children.add(
        PathGlowPainter(
          spec: _spec,
          isDark: isDark,
          glowPhase: glowPhase,
          revealProgress: revealProgress,
        ),
      );
    }
    children.add(
      CompletedPathPainter(
        spec: _spec,
        isDark: isDark,
        revealProgress: revealProgress,
      ),
    );
    return _CompositePainter(children);
  }
}

class _CompositePainter extends CustomPainter {
  _CompositePainter(this.children);
  final List<CustomPainter> children;

  @override
  void paint(Canvas canvas, Size size) {
    for (final child in children) {
      child.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant _CompositePainter old) {
    if (old.children.length != children.length) return true;
    for (var i = 0; i < children.length; i++) {
      if (old.children[i].shouldRepaint(children[i])) return true;
    }
    return false;
  }
}
