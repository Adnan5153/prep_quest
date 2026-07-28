import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';
import '../painters/animated_path_painter.dart';
import '../painters/path_glow_painter.dart';
import '../painters/path_painter.dart';
import '../painters/path_shadow_painter.dart';

class AnimatedPath extends StatefulWidget {
  const AnimatedPath({
    super.key,
    required this.start,
    required this.end,
    this.controlA,
    this.controlB,
    this.variant = PlaygroundPathVariant.curved,
    this.revealProgress = 1.0,
    this.isDark = false,
    this.showShadow = true,
    this.showGlow = true,
    this.flowController,
    this.glowController,
    this.shimmerController,
  });

  final Offset start;
  final Offset end;
  final Offset? controlA;
  final Offset? controlB;
  final PlaygroundPathVariant variant;
  final double revealProgress;
  final bool isDark;
  final bool showShadow;
  final bool showGlow;
  final AnimationController? flowController;
  final AnimationController? glowController;
  final AnimationController? shimmerController;

  @override
  State<AnimatedPath> createState() => _AnimatedPathState();
}

class _AnimatedPathState extends State<AnimatedPath>
    with TickerProviderStateMixin {
  late final AnimationController _flowController;
  late final AnimationController _glowController;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _flowController =
        widget.flowController ??
        AnimationController(
          duration: PlaygroundPathDurations.dashMarch,
          vsync: this,
        );
    _glowController =
        widget.glowController ??
        AnimationController(
          duration: PlaygroundPathDurations.glowCycle,
          vsync: this,
        );
    _shimmerController =
        widget.shimmerController ??
        AnimationController(
          duration: PlaygroundPathDurations.shimmer,
          vsync: this,
        );

    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (!reduceMotion) {
      _flowController.repeat();
      _glowController.repeat(reverse: true);
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedPath oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (!reduceMotion) {
      if (!_flowController.isAnimating) _flowController.repeat();
      if (!_glowController.isAnimating) _glowController.repeat(reverse: true);
      if (!_shimmerController.isAnimating) _shimmerController.repeat();
    } else {
      _flowController.stop();
      _glowController.stop();
      _shimmerController.stop();
    }
  }

  @override
  void dispose() {
    if (widget.flowController == null) _flowController.dispose();
    if (widget.glowController == null) _glowController.dispose();
    if (widget.shimmerController == null) _shimmerController.dispose();
    super.dispose();
  }

  PlaygroundPathSpec get _spec => PlaygroundPathSpec(
    start: widget.start,
    end: widget.end,
    state: PlaygroundPathSegmentState.active,
    controlA: widget.controlA,
    controlB: widget.controlB,
    variant: widget.variant,
  );

  Rect get _bounds {
    final xs = <double>[widget.start.dx, widget.end.dx];
    final ys = <double>[widget.start.dy, widget.end.dy];
    if (widget.controlA != null) {
      xs.add(widget.controlA!.dx);
      ys.add(widget.controlA!.dy);
    }
    if (widget.controlB != null) {
      xs.add(widget.controlB!.dx);
      ys.add(widget.controlB!.dy);
    }
    return Rect.fromLTRB(
      xs.reduce((a, b) => a < b ? a : b),
      ys.reduce((a, b) => a < b ? a : b),
      xs.reduce((a, b) => a > b ? a : b),
      ys.reduce((a, b) => a > b ? a : b),
    ).inflate(48);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: _bounds,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[
            _flowController,
            _glowController,
            _shimmerController,
          ]),
          builder: (context, _) {
            return CustomPaint(
              painter: PathShadowPainter(
                spec: _spec,
                isDark: widget.isDark,
                revealProgress: widget.revealProgress,
              ),
              foregroundPainter: _CompositeForeground(
                primary: PathPainter(
                  spec: _spec,
                  isDark: widget.isDark,
                  revealProgress: widget.revealProgress,
                ),
                glow: widget.showGlow
                    ? PathGlowPainter(
                        spec: _spec,
                        isDark: widget.isDark,
                        glowPhase: _glowController.value,
                        revealProgress: widget.revealProgress,
                      )
                    : null,
                animation: AnimatedPathPainter(
                  spec: _spec,
                  isDark: widget.isDark,
                  flowPhase: _flowController.value,
                  shimmerPhase: _shimmerController.value,
                  revealProgress: widget.revealProgress,
                ),
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
    );
  }
}

class _CompositeForeground extends CustomPainter {
  _CompositeForeground({
    required this.primary,
    required this.animation,
    this.glow,
  });
  final CustomPainter primary;
  final CustomPainter animation;
  final CustomPainter? glow;

  @override
  void paint(Canvas canvas, Size size) {
    glow?.paint(canvas, size);
    primary.paint(canvas, size);
    animation.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant _CompositeForeground old) {
    if (old.primary.shouldRepaint(primary)) return true;
    if (old.animation.shouldRepaint(animation)) return true;
    if (old.glow != glow && (old.glow == null || glow == null)) return true;
    if (old.glow != null && glow != null && old.glow!.shouldRepaint(glow!)) {
      return true;
    }
    return false;
  }
}
