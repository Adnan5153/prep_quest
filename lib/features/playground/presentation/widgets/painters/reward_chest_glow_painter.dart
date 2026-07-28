import 'package:flutter/material.dart';

import '../../constants/playground_sizes.dart';

class RewardChestGlowPainter extends CustomPainter {
  RewardChestGlowPainter({required this.color, required this.opacity});

  static final Paint _glowPaint = Paint();

  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    _glowPaint.shader = RadialGradient(
      colors: <Color>[
        color.withValues(
          alpha: PlaygroundSizes.rewardChestGlowInnerAlpha * opacity,
        ),
        color.withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, _glowPaint);
  }

  @override
  bool shouldRepaint(covariant RewardChestGlowPainter old) {
    return old.color != color || old.opacity != opacity;
  }
}
