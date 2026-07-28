import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_gradients.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../rewards/reward_chest/reward_chest_models.dart';
import '../rewards/reward_chest/reward_chest_utils.dart';

class RewardChestPaintData {
  const RewardChestPaintData({
    required this.size,
    required this.state,
    required this.progress,
    required this.rarity,
  });

  final double size;
  final RewardChestState state;
  final double progress;
  final PlaygroundRarity rarity;
}

class RewardChestPainter extends CustomPainter {
  RewardChestPainter({required this.data});

  static final Paint _woodStrokePaint = Paint()
    ..color = PlaygroundColors.chestWoodShade
    ..style = PaintingStyle.stroke
    ..strokeWidth = PlaygroundSizes.rewardChestWoodStrokeWidth;

  static final Paint _shadowPaint = Paint()
    ..color = AppColors.nodeDropShadow
    ..maskFilter = MaskFilter.blur(
      BlurStyle.normal,
      PlaygroundSizes.rewardChestShadowBlur,
    );

  static final Paint _bandPaint = Paint();
  static final Paint _dimPaint = Paint();
  static final Paint _woodPaint = Paint();

  final RewardChestPaintData data;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final lidHeight = height * PlaygroundSizes.rewardChestLidRatio;
    final lidLift = lidHeight * RewardChestPhase.lift(data.progress);
    final bodyTopY = lidHeight + PlaygroundSizes.rewardChestTopInset;
    _bandPaint.color = RewardChestRarityColors.band(data.rarity);

    _paintBody(
      canvas,
      width: width,
      bodyTopY: bodyTopY,
      height: height,
      lidLift: lidLift,
    );
    _paintLid(
      canvas,
      width: width,
      bodyTopY: bodyTopY,
      lidHeight: lidHeight,
      lidLift: lidLift,
      totalHeight: height,
    );
    _paintBottomShadow(canvas, width: width, height: height);
    if (data.state == RewardChestState.locked) {
      _paintLockedDim(canvas, width: width, height: height);
    }
  }

  void _paintBody(
    Canvas canvas, {
    required double width,
    required double bodyTopY,
    required double height,
    required double lidLift,
  }) {
    _configureWoodPaint(width, height);
    final bodyRect = _bodyRect(width, bodyTopY, height);
    canvas.drawRRect(bodyRect, _woodPaint);
    canvas.drawRRect(bodyRect, _woodStrokePaint);

    final bandHeight = PlaygroundSizes.rewardChestBandHeight;
    final bandRect = RRect.fromLTRBR(
      width * PlaygroundSizes.rewardChestBodyLeftInsetRatio,
      height * PlaygroundSizes.rewardChestBodyBandRatio - bandHeight / 2,
      width * PlaygroundSizes.rewardChestBodyRightInsetRatio,
      height * PlaygroundSizes.rewardChestBodyBandRatio + bandHeight / 2,
      Radius.circular(bandHeight / 2),
    );
    canvas.drawRRect(bandRect, _bandPaint);

    final lockSize = PlaygroundSizes.rewardChestLockSize;
    final lockRect = Rect.fromCenter(
      center: Offset(
        width / 2,
        height * PlaygroundSizes.rewardChestBodyBandRatio,
      ),
      width: lockSize * PlaygroundSizes.rewardChestLockWidthRatio,
      height: lockSize * PlaygroundSizes.rewardChestLockWidthRatio,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        lockRect,
        const Radius.circular(PlaygroundSizes.rewardChestLockCornerRadius),
      ),
      _bandPaint,
    );
    final keyRect = Rect.fromCenter(
      center: Offset(
        width / 2,
        height * PlaygroundSizes.rewardChestBodyBandRatio +
            lockSize * PlaygroundSizes.rewardChestKeyVerticalOffsetRatio,
      ),
      width: lockSize * PlaygroundSizes.rewardChestKeyWidthRatio,
      height: lockSize * PlaygroundSizes.rewardChestKeyHeightRatio,
    );
    canvas.drawRect(keyRect, _bandPaint);
  }

  void _paintLid(
    Canvas canvas, {
    required double width,
    required double bodyTopY,
    required double lidHeight,
    required double lidLift,
    required double totalHeight,
  }) {
    _configureWoodPaint(width, lidHeight);
    final lidRect = RRect.fromLTRBAndCorners(
      width * PlaygroundSizes.rewardChestBodyLeftInsetRatio,
      lidHeight - lidLift,
      width * PlaygroundSizes.rewardChestBodyRightInsetRatio,
      bodyTopY +
          lidHeight * PlaygroundSizes.rewardChestLidBottomInsetRatio -
          lidLift,
      topLeft: const Radius.circular(AppRadius.md),
      topRight: const Radius.circular(AppRadius.md),
    );
    canvas.save();
    canvas.translate(0, -lidLift);
    canvas.drawRRect(lidRect, _woodPaint);
    canvas.drawRRect(lidRect, _woodStrokePaint);
    final bandHeight = PlaygroundSizes.rewardChestBandHeight;
    final lidBandRect = RRect.fromLTRBR(
      width * PlaygroundSizes.rewardChestBodyLeftInsetRatio,
      totalHeight * PlaygroundSizes.rewardChestLidBandRatio - lidLift,
      width * PlaygroundSizes.rewardChestBodyRightInsetRatio,
      totalHeight * PlaygroundSizes.rewardChestLidBandRatio +
          bandHeight -
          lidLift,
      Radius.circular(PlaygroundSizes.rewardChestBandHeight / 2),
    );
    canvas.drawRRect(lidBandRect, _bandPaint);
    canvas.restore();
  }

  void _configureWoodPaint(double width, double height) {
    _woodPaint.shader = AppGradients.chestWood.createShader(
      Rect.fromLTWH(0, 0, width, height),
    );
  }

  RRect _bodyRect(double width, double bodyTopY, double height) {
    return RRect.fromLTRBR(
      width * PlaygroundSizes.rewardChestBodyLeftInsetRatio,
      bodyTopY,
      width * PlaygroundSizes.rewardChestBodyRightInsetRatio,
      height * PlaygroundSizes.rewardChestBodyBottomRatio,
      const Radius.circular(AppRadius.md),
    );
  }

  void _paintBottomShadow(
    Canvas canvas, {
    required double width,
    required double height,
  }) {
    _shadowPaint.color = AppColors.nodeDropShadow.withValues(
      alpha: PlaygroundAlpha.chestShadow,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          width / 2,
          height * PlaygroundSizes.rewardChestShadowCenterRatio,
        ),
        width: width * PlaygroundSizes.rewardChestShadowWidthRatio,
        height: height * PlaygroundSizes.rewardChestShadowHeightRatio,
      ),
      _shadowPaint,
    );
  }

  void _paintLockedDim(
    Canvas canvas, {
    required double width,
    required double height,
  }) {
    _dimPaint.color = AppColors.darkBackground.withValues(
      alpha: PlaygroundSizes.rewardChestLockedDimAlpha,
    );
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), _dimPaint);
  }

  @override
  bool shouldRepaint(covariant RewardChestPainter old) {
    return old.data.progress != data.progress ||
        old.data.state != data.state ||
        old.data.rarity != data.rarity ||
        old.data.size != data.size;
  }
}
