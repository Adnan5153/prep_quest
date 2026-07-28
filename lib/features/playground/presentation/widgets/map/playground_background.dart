import 'package:flutter/material.dart';

import '../painters/background_painter.dart';

export '../painters/background_painter.dart' show PlaygroundBiome;

class PlaygroundBackground extends StatelessWidget {
  const PlaygroundBackground({
    super.key,
    this.biome = PlaygroundBiome.meadow,
    this.parallaxOffset = 0.0,
  });

  final PlaygroundBiome biome;
  final double parallaxOffset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = BackgroundPalette.forBiome(biome, isDark: isDark);

    return RepaintBoundary(
      child: CustomPaint(
        painter: BackgroundPainter(
          palette: palette,
          parallaxOffset: parallaxOffset,
          isDark: isDark,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
