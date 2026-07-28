import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'ai_avatar_constants.dart';
import 'ai_avatar_status.dart';

/// Paints the orb core: gradient orb, highlight sheen, and the optional
/// rotating energy ring. It is intentionally a pure painter so the parent
/// widget can wrap it in a [RepaintBoundary] for cheap repaints.
class AiAvatarOrbPainter extends CustomPainter {
  const AiAvatarOrbPainter({
    required this.tuning,
    required this.brightness,
    required this.intensity,
    required this.orbitProgress,
    required this.breathePhase,
    required this.shakeOffset,
  });

  final AiAvatarTuning tuning;
  final Brightness brightness;
  final double intensity; // 0..1 breathing amplitude
  final double orbitProgress; // 0..1 ring rotation
  final double breathePhase; // 0..1 across the cycle
  final double shakeOffset; // 0..1 small lateral offset for errors

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centre = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2;
    if (radius <= 0) return;

    _paintShadow(canvas, centre, radius);
    _paintBorder(canvas, centre, radius);
    _paintOrbBody(canvas, centre, radius);
    _paintHighlight(canvas, centre, radius);
    _paintInnerSpark(canvas, centre, radius);

    if (tuning.usesEnergyRing) {
      _paintEnergyRing(canvas, centre, radius);
    }
  }

  void _paintShadow(Canvas canvas, Offset centre, double radius) {
    final Paint shadow = Paint()
      ..color = tuning.accent.withValues(alpha: 0.25 * intensity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.35);
    canvas.drawCircle(centre, radius * 0.92, shadow);
  }

  void _paintBorder(Canvas canvas, Offset centre, double radius) {
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * AiAvatarConstants.borderStrokeFactor * 2
      ..color = AiAvatarConstants.defaultBorder(brightness);
    canvas.drawCircle(centre, radius * 0.96, borderPaint);
  }

  void _paintOrbBody(Canvas canvas, Offset centre, double radius) {
    final Rect orbRect = Rect.fromCircle(center: centre, radius: radius * 0.94);
    final Paint bodyPaint = Paint()
      ..shader = tuning.orbGradient.createShader(orbRect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(centre, radius * 0.94, bodyPaint);
  }

  void _paintHighlight(Canvas canvas, Offset centre, double radius) {
    final double highlightY = centre.dy - radius * 0.4;
    final Rect highlightRect = Rect.fromCircle(
      center: Offset(centre.dx, highlightY),
      radius: radius * AiAvatarConstants.innerHighlightFactor,
    );
    final Paint highlightPaint = Paint()
      ..shader = AiAvatarConstants.highlightGradient.createShader(highlightRect)
      ..style = PaintingStyle.fill;
    final Path highlightPath = Path()
      ..addOval(highlightRect)
      ..addOval(
        Rect.fromCircle(
          center: Offset(centre.dx, highlightY + radius * 0.4),
          radius: radius * AiAvatarConstants.innerHighlightFactor,
        ),
      )
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(highlightPath, highlightPaint);
  }

  void _paintInnerSpark(Canvas canvas, Offset centre, double radius) {
    // Tiny radial bloom that pulses with the breathing cycle. Drawn over
    // the highlight but below the icon so it reads as "energy under glass".
    final double sparkRadius = radius * (0.35 + 0.08 * breathePhase);
    final Paint spark = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          tuning.accent.withValues(alpha: 0.65),
          tuning.accent.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: centre, radius: sparkRadius))
      ..blendMode = BlendMode.plus;
    canvas.drawCircle(centre, sparkRadius, spark);
  }

  void _paintEnergyRing(Canvas canvas, Offset centre, double radius) {
    final double ringRadius =
        radius * (0.98 + 0.04 * math.sin(breathePhase * math.pi * 2));
    final double thickness = radius * AiAvatarConstants.ringThicknessFactor;
    final Rect ringRect = Rect.fromCircle(center: centre, radius: ringRadius);
    final Paint ringPaint = Paint()
      ..shader = AiAvatarConstants.energyRingGradient.createShader(ringRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    final double rotation = orbitProgress * math.pi * 2;
    canvas.save();
    canvas.translate(centre.dx, centre.dy);
    canvas.rotate(rotation);
    canvas.translate(-centre.dx, -centre.dy);

    final Path arc = Path()
      ..addArc(
        Rect.fromCircle(center: centre, radius: ringRadius),
        -math.pi / 2,
        math.pi * 1.35,
      );
    canvas.drawPath(arc, ringPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AiAvatarOrbPainter oldDelegate) {
    return oldDelegate.tuning.status != tuning.status ||
        oldDelegate.brightness != brightness ||
        oldDelegate.intensity != intensity ||
        oldDelegate.orbitProgress != orbitProgress ||
        oldDelegate.breathePhase != breathePhase ||
        oldDelegate.shakeOffset != shakeOffset;
  }
}
