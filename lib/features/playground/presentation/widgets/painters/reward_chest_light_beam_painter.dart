import 'package:flutter/material.dart';

import '../../constants/playground_sizes.dart';
import '../rewards/reward_chest/reward_chest_models.dart';
import '../rewards/reward_chest/reward_chest_utils.dart';
import 'reward_chest_painter.dart';

class RewardChestLightBeamPainter extends CustomPainter {
  RewardChestLightBeamPainter({required this.progress, required this.data});

  static final Paint _beamPaint = Paint();

  final double progress;
  final RewardChestPaintData data;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final lidHeight = height * PlaygroundSizes.rewardChestLidRatio;
    final bodyTopY = lidHeight + PlaygroundSizes.rewardChestTopInset;
    final lidLift = lidHeight * RewardChestPhase.lift(progress);

    final beamProgress = RewardChestPhase.beamProgress(progress);
    if (beamProgress <= 0) return;

    final beamOpacity =
        (1 - beamProgress) * PlaygroundSizes.rewardChestBeamMaxOpacity;
    final beamColor = RewardChestRarityColors.band(data.rarity);
    final beamRect = Rect.fromLTWH(
      width / 2 - PlaygroundSizes.rewardChestLightBeamWidth,
      lidHeight - lidLift - height * PlaygroundSizes.rewardChestBeamHeightRatio,
      PlaygroundSizes.rewardChestLightBeamWidth * 2,
      height * PlaygroundSizes.rewardChestBeamHeightRatio,
    );
    _beamPaint.shader = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: <Color>[
        beamColor.withValues(alpha: 0.0),
        beamColor.withValues(alpha: beamOpacity),
        beamColor.withValues(alpha: 0.0),
      ],
    ).createShader(beamRect);

    final beamPath = Path()
      ..moveTo(
        width / 2 - PlaygroundSizes.rewardChestLightBeamWidth,
        bodyTopY - lidLift,
      )
      ..lineTo(
        width / 2 + PlaygroundSizes.rewardChestLightBeamWidth,
        bodyTopY - lidLift,
      )
      ..lineTo(
        width / 2 +
            PlaygroundSizes.rewardChestLightBeamWidth *
                PlaygroundSizes.rewardChestBeamTopWidthRatio,
        beamRect.top,
      )
      ..lineTo(
        width / 2 -
            PlaygroundSizes.rewardChestLightBeamWidth *
                PlaygroundSizes.rewardChestBeamTopWidthRatio,
        beamRect.top,
      )
      ..close();
    canvas.drawPath(beamPath, _beamPaint);
  }

  @override
  bool shouldRepaint(covariant RewardChestLightBeamPainter old) {
    return old.progress != progress ||
        old.data.state != data.state ||
        old.data.rarity != data.rarity ||
        old.data.size != data.size;
  }
}
