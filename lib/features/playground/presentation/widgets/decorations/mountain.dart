import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../painters/mountain_painter.dart';

export '../painters/mountain_painter.dart' show MountainKind, MountainLayer;

class Mountain extends StatelessWidget {
  const Mountain({
    super.key,
    this.layer = MountainLayer.mid,
    this.kind = MountainKind.rocky,
    this.accentColor,
    this.scale = 1.0,
  });

  final MountainLayer layer;
  final MountainKind kind;
  final Color? accentColor;
  final double scale;

  double get _layerScale {
    switch (layer) {
      case MountainLayer.back:
        return PlaygroundSizes.mountainBackScale;
      case MountainLayer.mid:
        return PlaygroundSizes.mountainMidScale;
      case MountainLayer.front:
        return PlaygroundSizes.mountainFrontScale;
    }
  }

  double get _layerOpacity {
    switch (layer) {
      case MountainLayer.back:
        return PlaygroundMapOpacity.mountainBack;
      case MountainLayer.mid:
        return PlaygroundMapOpacity.mountainMid;
      case MountainLayer.front:
        return PlaygroundMapOpacity.mountainFront;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseWidth = PlaygroundSizes.mountainWidthBase * _layerScale * scale;
    final baseHeight = PlaygroundSizes.mountainHeightBase * _layerScale * scale;

    final accent = accentColor ?? _resolveTone();

    return RepaintBoundary(
      child: SizedBox(
        width: baseWidth,
        height: baseHeight,
        child: Opacity(
          opacity: _layerOpacity,
          child: CustomPaint(
            painter: MountainPainter(kind: kind, accent: accent),
          ),
        ),
      ),
    );
  }

  Color _resolveTone() {
    switch (layer) {
      case MountainLayer.back:
        return AppColors.mountainStoneDark;
      case MountainLayer.mid:
        return AppColors.mountainStone;
      case MountainLayer.front:
        return AppColors.mountainStone;
    }
  }
}
