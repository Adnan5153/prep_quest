import 'package:flutter/material.dart';

import '../../painters/reward_chest_glow_painter.dart';

class RewardChestGlow extends StatelessWidget {
  const RewardChestGlow({
    super.key,
    required this.diameter,
    required this.color,
    required this.opacity,
  });

  final double diameter;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: CustomPaint(
          painter: RewardChestGlowPainter(color: color, opacity: opacity),
        ),
      ),
    );
  }
}
