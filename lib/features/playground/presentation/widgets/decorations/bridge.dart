import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_sizes.dart';
import '../painters/bridge_painter.dart';

enum BridgeVariant { wooden, rope, stone }

class Bridge extends StatelessWidget {
  const Bridge({
    super.key,
    this.variant = BridgeVariant.wooden,
    this.accentColor,
    this.scale = 1.0,
  });

  final BridgeVariant variant;
  final Color? accentColor;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.trunkBrown;
    final width = PlaygroundSizes.bridgeWidth * scale;
    final height = PlaygroundSizes.bridgeHeight * scale;

    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: BridgePainter(
            variant: _toPainterVariant(variant),
            accent: accent,
          ),
        ),
      ),
    );
  }

  BridgePainterVariant _toPainterVariant(BridgeVariant v) {
    switch (v) {
      case BridgeVariant.wooden:
        return BridgePainterVariant.wooden;
      case BridgeVariant.rope:
        return BridgePainterVariant.rope;
      case BridgeVariant.stone:
        return BridgePainterVariant.stone;
    }
  }
}
