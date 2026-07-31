import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Ambient confetti rain that can be layered above any foreground
/// widget. Used by the canonical `LevelRewardDialog` to amplify the
/// level-up celebration, and reusable elsewhere (e.g. chest unlocks).
class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({
    super.key,
    this.particleCount = 32,
    this.duration = const Duration(milliseconds: 1800),
    this.palette,
  });

  final int particleCount;
  final Duration duration;
  final List<Color>? palette;

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final List<_ConfettiParticle> _particles;
  late final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _particles = List<_ConfettiParticle>.generate(
      widget.particleCount,
      (int i) => _ConfettiParticle.random(_random),
      growable: false,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> _paletteForBrightness(Brightness brightness) {
    if (widget.palette != null) return widget.palette!;
    return brightness == Brightness.dark
        ? <Color>[
            AppColors.darkOnSurface,
            const Color(0xFFFFD700),
            const Color(0xFFFFB300),
            const Color(0xFF80DEEA),
          ]
        : <Color>[
            const Color(0xFFFFB300),
            const Color(0xFFE91E63),
            const Color(0xFF3F51B5),
            const Color(0xFF4CAF50),
          ];
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness =
        Theme.of(context).brightness;
    final List<Color> palette = _paletteForBrightness(brightness);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? _) {
          return IgnorePointer(
            child: CustomPaint(
              painter: _ConfettiPainter(
                progress: _controller.value,
                particles: _particles,
                palette: palette,
              ),
              size: Size.infinite,
            ),
          );
        },
      ),
    );
  }
}

class _ConfettiParticle {
  _ConfettiParticle({
    required this.startFractionX,
    required this.colorIndex,
    required this.rotationSpeed,
    required this.sizeFactor,
    required this.horizontalDrift,
  });

  factory _ConfettiParticle.random(math.Random random) {
    return _ConfettiParticle(
      startFractionX: random.nextDouble(),
      colorIndex: random.nextInt(4),
      rotationSpeed: 0.75 + random.nextDouble() * 1.25,
      sizeFactor: 0.6 + random.nextDouble() * 0.6,
      horizontalDrift: (random.nextDouble() - 0.5) * 0.35,
    );
  }

  final double startFractionX;
  final int colorIndex;
  final double rotationSpeed;
  final double sizeFactor;
  final double horizontalDrift;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.progress,
    required this.particles,
    required this.palette,
  });

  final double progress;
  final List<_ConfettiParticle> particles;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final Paint paint = Paint()..style = PaintingStyle.fill;
    for (final _ConfettiParticle particle in particles) {
      final double y = -20.0 + (size.height + 40.0) * progress;
      final double drift = math.sin(progress * math.pi * 2) *
          particle.horizontalDrift *
          size.width;
      final double x = particle.startFractionX * size.width + drift;
      paint.color = palette[particle.colorIndex % palette.length]
          .withValues(alpha: (1.0 - progress).clamp(0.0, 1.0));
      final double rectW = 10.0 * particle.sizeFactor;
      final double rectH = 14.0 * particle.sizeFactor;
      final Rect rect = Rect.fromCenter(
        center: Offset(x, y),
        width: rectW,
        height: rectH,
      );
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(progress * particle.rotationSpeed * math.pi * 2);
      canvas.translate(-rect.center.dx, -rect.center.dy);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
