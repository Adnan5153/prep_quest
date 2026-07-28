import 'package:flutter/material.dart';

import '../../painters/reward_chest_light_beam_painter.dart';
import '../../painters/reward_chest_painter.dart';
import 'reward_chest_models.dart';

class RewardChestLightBeam extends StatelessWidget {
  const RewardChestLightBeam({
    super.key,
    required this.size,
    required this.progress,
    required this.data,
  });

  final double size;
  final double progress;
  final RewardChestPaintData data;

  @override
  Widget build(BuildContext context) {
    if (data.state != RewardChestState.opening) {
      return const SizedBox.shrink();
    }
    return RepaintBoundary(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          size: Size(size, size),
          painter: RewardChestLightBeamPainter(progress: progress, data: data),
        ),
      ),
    );
  }
}
