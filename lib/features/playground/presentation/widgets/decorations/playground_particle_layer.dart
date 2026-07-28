import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';
import 'particles.dart';

class PlaygroundParticleLayer extends StatefulWidget {
  const PlaygroundParticleLayer({
    super.key,
    this.seed = 7,
    this.count,
    this.bounds,
    this.duration,
  });

  final int seed;
  final int? count;
  final Rect? bounds;
  final Duration? duration;

  @override
  State<PlaygroundParticleLayer> createState() =>
      _PlaygroundParticleLayerState();
}

class _PlaygroundParticleLayerState extends State<PlaygroundParticleLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration ?? PlaygroundDecorationDurations.particleCycle,
  )..repeat();

  late List<ParticleSpec> _particles = _generate();

  List<ParticleSpec> _generate() {
    final count =
        widget.count ?? PlaygroundDecorationLimits.maxAmbientParticles;
    final bounds = widget.bounds ?? const Rect.fromLTWH(0, 0, 320, 240);
    return ParticleFactory(
      seed: widget.seed,
      count: count,
    ).generate(bounds: bounds);
  }

  @override
  void didUpdateWidget(covariant PlaygroundParticleLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seed != widget.seed ||
        oldWidget.count != widget.count ||
        oldWidget.bounds != widget.bounds) {
      _particles = _generate();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : 320.0;
          final height = constraints.hasBoundedHeight
              ? constraints.maxHeight
              : 240.0;
          return SizedBox(
            width: width,
            height: height,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    progress: _controller.value,
                    isDark: isDark,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
