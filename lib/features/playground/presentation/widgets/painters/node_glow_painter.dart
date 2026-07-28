import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';

class NodeGlowSpec {
  const NodeGlowSpec({
    required this.center,
    required this.radius,
    required this.color,
    required this.intensity,
  });

  final Offset center;
  final double radius;
  final Color color;
  final double intensity;
}

class NodeGlowPainter extends CustomPainter {
  NodeGlowPainter({
    required this.glows,
    required this.isDark,
    this.pulsePhase = 0.0,
  });

  static final Paint _glowPaint = Paint();

  final List<NodeGlowSpec> glows;
  final bool isDark;
  final double pulsePhase;

  @override
  void paint(Canvas canvas, Size size) {
    if (glows.isEmpty) return;

    final pulse =
        PlaygroundGlowPulse.radiusFloor +
        PlaygroundGlowPulse.radiusAmplitude * pulsePhase;

    for (final glow in glows) {
      final radiusScale =
          1.0 +
          (PlaygroundSizes.mapNodeGlowRadiusScale - 1.0) *
              pulse *
              glow.intensity;
      final alpha =
          PlaygroundMapOpacity.cameraGlow *
          (PlaygroundGlowPulse.alphaFloor +
              PlaygroundGlowPulse.alphaAmplitude * pulsePhase) *
          glow.intensity;
      final radius = glow.radius * radiusScale;
      _glowPaint.shader = RadialGradient(
        colors: <Color>[
          glow.color.withValues(alpha: alpha),
          glow.color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: glow.center, radius: radius));
      canvas.drawCircle(glow.center, radius, _glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant NodeGlowPainter old) {
    if (old.pulsePhase != pulsePhase) return true;
    if (old.isDark != isDark) return true;
    if (old.glows.length != glows.length) return true;
    for (int i = 0; i < glows.length; i++) {
      final lhs = old.glows[i];
      final rhs = glows[i];
      if (lhs.center != rhs.center ||
          lhs.radius != rhs.radius ||
          lhs.color != rhs.color ||
          lhs.intensity != rhs.intensity) {
        return true;
      }
    }
    return false;
  }
}

class NodeGlowFactory {
  const NodeGlowFactory._();

  static List<NodeGlowSpec> build({
    required List<Offset> activeCenters,
    required List<double> diameters,
    required List<Color> colors,
    required List<double> intensities,
  }) {
    final result = <NodeGlowSpec>[];
    for (int i = 0; i < activeCenters.length; i++) {
      result.add(
        NodeGlowSpec(
          center: activeCenters[i],
          radius:
              diameters[i] * 0.5 +
              PlaygroundSizes.mapNodeGlowBlur *
                  PlaygroundSizes.mapNodeGlowSpread,
          color: colors[i],
          intensity: intensities[i].clamp(0.0, 1.0),
        ),
      );
    }
    return result;
  }

  static Color defaultColor() => AppColors.accent;
}
