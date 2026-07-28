import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'ai_avatar_constants.dart';
import 'ai_avatar_status.dart';

/// Repaints a constellation of orbiting particles around the orb core.
///
/// The painter is built to be reused across frames — its [shouldRepaint]
/// returns false when the only delta is the parent status 's identity
/// (already encoded into the resolved colours).
class AiAvatarParticlesPainter extends CustomPainter {
  const AiAvatarParticlesPainter({
    required this.color,
    required this.density,
    required this.count,
    required this.progress,
    required this.size,
  });

  final Color color;
  final double density;
  final int count;
  final double progress;
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    if (count <= 0 || density <= 0.01) return;
    final Offset centre = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final double orbitRadius =
        canvasSize.shortestSide * AiAvatarConstants.particleOrbitFactor / 2;
    final double particleRadius =
        canvasSize.shortestSide * AiAvatarConstants.particleRadiusFactor / 2;

    final Paint glowPaint = Paint()
      ..color = color.withValues(alpha: 0.65 * density)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, particleRadius * 1.6);

    final Paint corePaint = Paint()
      ..color = color.withValues(alpha: 0.95 * density);

    for (int i = 0; i < count; i++) {
      final double angle = (i / count) * math.pi * 2 + progress * math.pi * 2;
      final double verticalDrift = math.sin(progress * math.pi * 2 + i) * 0.06;
      final Offset position = Offset(
        centre.dx + math.cos(angle) * orbitRadius,
        centre.dy +
            math.sin(angle) * orbitRadius * (0.92 + 0.08 * verticalDrift),
      );

      canvas.drawCircle(position, particleRadius * 1.8, glowPaint);
      canvas.drawCircle(position, particleRadius, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant AiAvatarParticlesPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.density != density ||
        oldDelegate.count != count ||
        oldDelegate.progress != progress ||
        oldDelegate.size != size;
  }
}

/// Convenience widget that handles the [RepaintBoundary] plus sizing for
/// the particle painter. The parent only feeds in the resolved [tuning]
/// and animated [progress].
class AiAvatarParticles extends StatelessWidget {
  const AiAvatarParticles({
    super.key,
    required this.tuning,
    required this.progress,
    required this.size,
  });

  final AiAvatarTuning tuning;
  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (!tuning.usesParticles) {
      return IgnorePointer(child: SizedBox.square(dimension: size));
    }
    final int count = AiAvatarConstants.defaultParticleCount.clamp(
      0,
      AiAvatarConstants.maxParticleCount,
    );
    return IgnorePointer(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: AiAvatarParticlesPainter(
              color: tuning.accent,
              density: tuning.particleDensity,
              count: count,
              progress: progress,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
