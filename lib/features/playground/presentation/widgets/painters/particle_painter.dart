import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';

enum ParticleKind { leaf, sparkle, dust, star, ambient }

class ParticleSpec {
  const ParticleSpec({
    required this.kind,
    required this.offset,
    required this.radius,
    required this.phase,
  });

  final ParticleKind kind;
  final Offset offset;
  final double radius;
  final double phase;
}

class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.isDark,
  });

  static const double _baseOpacity = 0.85;

  static final Paint _leafFill = Paint()..style = PaintingStyle.fill;
  static final Paint _leafVein = Paint()..strokeWidth = 0.8;
  static final Paint _sparkleFill = Paint();
  static final Paint _dustFill = Paint();
  static final Paint _starFill = Paint();
  static final Paint _ambientFill = Paint();

  final List<ParticleSpec> particles;
  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      _paintSingle(canvas, p, size);
    }
  }

  void _paintSingle(Canvas canvas, ParticleSpec spec, Size bounds) {
    final verticalDrift =
        math.sin((progress + spec.phase) * 2 * math.pi) * bounds.height * 0.04;
    final horizontalDrift =
        math.cos((progress + spec.phase) * 2 * math.pi) * bounds.width * 0.02;
    final dx = spec.offset.dx + horizontalDrift;
    final dy = spec.offset.dy + verticalDrift;
    if (dx < -spec.radius ||
        dx > bounds.width + spec.radius ||
        dy < -spec.radius ||
        dy > bounds.height + spec.radius) {
      return;
    }
    final fade = 0.55 + 0.45 * math.sin((progress + spec.phase) * 2 * math.pi);
    switch (spec.kind) {
      case ParticleKind.leaf:
        _paintLeaf(canvas, Offset(dx, dy), spec.radius, fade);
      case ParticleKind.sparkle:
        _paintSparkle(canvas, Offset(dx, dy), spec.radius, fade);
      case ParticleKind.dust:
        _paintDust(canvas, Offset(dx, dy), spec.radius, fade);
      case ParticleKind.star:
        _paintStar(canvas, Offset(dx, dy), spec.radius, fade);
      case ParticleKind.ambient:
        _paintAmbient(canvas, Offset(dx, dy), spec.radius, fade);
    }
  }

  void _paintLeaf(Canvas canvas, Offset c, double r, double fade) {
    _leafFill.color = Color.lerp(
      AppColors.foliageGreen,
      AppColors.foliageGreenDark,
      PlaygroundAlpha.treeCanopyBlend,
    )!.withValues(alpha: _baseOpacity * fade);
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx + r, c.dy - r * 0.5, c.dx + r * 0.6, c.dy + r)
      ..quadraticBezierTo(c.dx, c.dy + r * 0.5, c.dx - r * 0.6, c.dy + r)
      ..quadraticBezierTo(c.dx - r, c.dy + r * 0.5, c.dx, c.dy - r)
      ..close();
    canvas.drawPath(path, _leafFill);

    _leafVein.color = AppColors.darkBackground.withValues(
      alpha: PlaygroundAlpha.shadow * fade,
    );
    canvas.drawLine(
      Offset(c.dx, c.dy - r * 0.8),
      Offset(c.dx, c.dy + r * 0.8),
      _leafVein,
    );
  }

  void _paintSparkle(Canvas canvas, Offset c, double r, double fade) {
    _sparkleFill.color = AppColors.sparkleGold.withValues(
      alpha: _baseOpacity * fade,
    );
    final double d = r * 0.55;
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx + d, c.dy - d)
      ..lineTo(c.dx + r, c.dy)
      ..lineTo(c.dx + d, c.dy + d)
      ..lineTo(c.dx, c.dy + r)
      ..lineTo(c.dx - d, c.dy + d)
      ..lineTo(c.dx - r, c.dy)
      ..lineTo(c.dx - d, c.dy - d)
      ..close();
    canvas.drawPath(path, _sparkleFill);
  }

  void _paintDust(Canvas canvas, Offset c, double r, double fade) {
    _dustFill.color = AppColors.lightMuted.withValues(
      alpha: _baseOpacity * PlaygroundAlpha.shadow * fade,
    );
    canvas.drawCircle(c, r, _dustFill);
  }

  void _paintStar(Canvas canvas, Offset c, double r, double fade) {
    _starFill.color = AppColors.snowCap.withValues(alpha: _baseOpacity * fade);
    final path = Path();
    const int arms = 5;
    for (int i = 0; i < arms * 2; i++) {
      final double angle = (i / (arms * 2)) * 2 * math.pi - math.pi / 2;
      final double outer = (i.isEven) ? r : r * 0.45;
      final double x = c.dx + outer * math.cos(angle);
      final double y = c.dy + outer * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, _starFill);
  }

  void _paintAmbient(Canvas canvas, Offset c, double r, double fade) {
    _ambientFill.shader = RadialGradient(
      colors: <Color>[
        AppColors.sparkleGold.withValues(alpha: _baseOpacity * fade),
        AppColors.sparkleGold.withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: c, radius: r * 2));
    canvas.drawCircle(c, r * 1.8, _ambientFill);
  }

  @override
  bool shouldRepaint(covariant ParticlePainter old) {
    return old.progress != progress ||
        old.isDark != isDark ||
        old.particles.length != particles.length;
  }
}

class ParticleFactory {
  ParticleFactory({required this.seed, required this.count});

  final int seed;
  final int count;

  List<ParticleSpec> generate({required Rect bounds}) {
    final rng = math.Random(seed);
    return List.generate(count, (i) {
      final kindRand = rng.nextDouble();
      final kind = switch (kindRand) {
        < 0.30 => ParticleKind.leaf,
        < 0.55 => ParticleKind.sparkle,
        < 0.80 => ParticleKind.dust,
        < 0.92 => ParticleKind.ambient,
        _ => ParticleKind.star,
      };
      final radius =
          PlaygroundSizes.particleMinRadius +
          rng.nextDouble() *
              (PlaygroundSizes.particleMaxRadius -
                  PlaygroundSizes.particleMinRadius);
      return ParticleSpec(
        kind: kind,
        offset: Offset(
          bounds.left + rng.nextDouble() * bounds.width,
          bounds.top + rng.nextDouble() * bounds.height,
        ),
        radius: radius,
        phase: rng.nextDouble(),
      );
    });
  }
}
