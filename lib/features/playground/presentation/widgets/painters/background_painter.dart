import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import 'mountain_painter.dart';

enum PlaygroundBiome { meadow, forest, desert, snow, volcanic }

class BackgroundPalette {
  const BackgroundPalette({
    required this.skyTop,
    required this.skyBottom,
    required this.groundTop,
    required this.groundBottom,
    required this.mountainAccent,
    required this.mountainShade,
  });

  final Color skyTop;
  final Color skyBottom;
  final Color groundTop;
  final Color groundBottom;
  final Color mountainAccent;
  final Color mountainShade;

  static BackgroundPalette forBiome(
    PlaygroundBiome biome, {
    required bool isDark,
  }) {
    switch (biome) {
      case PlaygroundBiome.meadow:
        return BackgroundPalette(
          skyTop: isDark ? AppColors.skyDark : AppColors.skyLight,
          skyBottom: isDark
              ? AppColors.foliageGreenDark
              : AppColors.foliageGreenLight,
          groundTop: isDark
              ? AppColors.foliageGreenDark
              : AppColors.foliageGreenLight,
          groundBottom: isDark
              ? AppColors.trunkBrownDark
              : AppColors.trunkBrown,
          mountainAccent: AppColors.mountainStone,
          mountainShade: AppColors.mountainStoneDark,
        );
      case PlaygroundBiome.forest:
        return BackgroundPalette(
          skyTop: isDark ? AppColors.skyDark : AppColors.skyLight,
          skyBottom: isDark
              ? AppColors.foliageGreenDark
              : AppColors.foliageGreen,
          groundTop: isDark
              ? AppColors.foliageGreenDark
              : AppColors.foliageGreen,
          groundBottom: isDark
              ? AppColors.trunkBrownDark
              : AppColors.trunkBrown,
          mountainAccent: AppColors.foliageGreenDark,
          mountainShade: AppColors.trunkBrownDark,
        );
      case PlaygroundBiome.desert:
        return BackgroundPalette(
          skyTop: isDark ? AppColors.skyDark : AppColors.skyLight,
          skyBottom: isDark ? AppColors.warning : AppColors.plankLight,
          groundTop: isDark ? AppColors.warning : AppColors.plankLight,
          groundBottom: isDark
              ? AppColors.trunkBrownDark
              : AppColors.trunkBrown,
          mountainAccent: AppColors.plankLight,
          mountainShade: AppColors.trunkBrown,
        );
      case PlaygroundBiome.snow:
        return BackgroundPalette(
          skyTop: isDark ? AppColors.skyDark : AppColors.skyLight,
          skyBottom: isDark ? AppColors.mountainStoneDark : AppColors.snowCap,
          groundTop: isDark ? AppColors.mountainStoneDark : AppColors.snowCap,
          groundBottom: isDark
              ? AppColors.mountainStoneDark
              : AppColors.mountainStone,
          mountainAccent: AppColors.snowCap,
          mountainShade: AppColors.mountainStoneDark,
        );
      case PlaygroundBiome.volcanic:
        return BackgroundPalette(
          skyTop: isDark ? AppColors.skyDark : AppColors.skyLight,
          skyBottom: isDark ? AppColors.error : AppColors.warning,
          groundTop: isDark ? AppColors.error : AppColors.warning,
          groundBottom: isDark
              ? AppColors.trunkBrownDark
              : AppColors.trunkBrown,
          mountainAccent: AppColors.mountainStoneDark,
          mountainShade: AppColors.trunkBrownDark,
        );
    }
  }
}

class BackgroundPainter extends CustomPainter {
  BackgroundPainter({
    required this.palette,
    required this.parallaxOffset,
    required this.isDark,
  });

  static final Paint _skyPaint = Paint();
  static final Paint _groundPaint = Paint();
  static final Paint _mountainPaint = Paint();

  final BackgroundPalette palette;
  final double parallaxOffset;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final skyRect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height * PlaygroundSizes.mapSkyEndY,
    );
    _skyPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[palette.skyTop, palette.skyBottom],
    ).createShader(skyRect);
    canvas.drawRect(skyRect, _skyPaint);

    _paintMountains(canvas, size);

    final groundRect = Rect.fromLTWH(
      0,
      size.height * PlaygroundSizes.mapGroundStartY,
      size.width,
      size.height *
          (PlaygroundSizes.mapGroundEndY - PlaygroundSizes.mapGroundStartY),
    );
    _groundPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[palette.groundTop, palette.groundBottom],
    ).createShader(groundRect);
    canvas.drawRect(groundRect, _groundPaint);
  }

  void _paintMountains(Canvas canvas, Size size) {
    final layers = <_BackgroundMountainLayer>[
      _BackgroundMountainLayer(
        parallax: PlaygroundSizes.mapMountainParallaxBack,
        width: PlaygroundSizes.mapMountainBackWidth,
        height: PlaygroundSizes.mapMountainBackHeight,
        accent: palette.mountainShade,
        y:
            size.height * PlaygroundSizes.mapSkyEndY -
            PlaygroundSizes.mapMountainBackHeight *
                PlaygroundSizes.mapMountainParallaxBack,
        layer: MountainLayer.back,
      ),
      _BackgroundMountainLayer(
        parallax: PlaygroundSizes.mapMountainParallaxMid,
        width: PlaygroundSizes.mapMountainMidWidth,
        height: PlaygroundSizes.mapMountainMidHeight,
        accent: palette.mountainAccent,
        y:
            size.height * PlaygroundSizes.mapSkyEndY -
            PlaygroundSizes.mapMountainMidHeight *
                PlaygroundSizes.mapMountainParallaxMid,
        layer: MountainLayer.mid,
      ),
      _BackgroundMountainLayer(
        parallax: PlaygroundSizes.mapMountainParallaxFront,
        width: PlaygroundSizes.mapMountainFrontWidth,
        height: PlaygroundSizes.mapMountainFrontHeight,
        accent: palette.mountainAccent,
        y:
            size.height * PlaygroundSizes.mapSkyEndY -
            PlaygroundSizes.mapMountainFrontHeight *
                PlaygroundSizes.mapMountainParallaxFront,
        layer: MountainLayer.front,
      ),
    ];

    for (final layer in layers) {
      final offsetX = (-parallaxOffset * layer.parallax) % layer.width;
      _paintMountainRow(canvas, size, layer, offsetX);
    }
  }

  void _paintMountainRow(
    Canvas canvas,
    Size size,
    _BackgroundMountainLayer spec,
    double baseOffset,
  ) {
    final count = (size.width / spec.width).ceil() + 2;
    for (int i = -1; i < count; i++) {
      final x = baseOffset + i * spec.width;
      if (x > size.width || x + spec.width < 0) continue;
      canvas.save();
      canvas.translate(x, spec.y);
      canvas.scale(spec.width / PlaygroundSizes.mapMountainBackWidth);
      _paintMountainSilhouette(canvas, spec);
      canvas.restore();
    }
  }

  void _paintMountainSilhouette(Canvas canvas, _BackgroundMountainLayer spec) {
    final w = PlaygroundSizes.mapMountainBackWidth;
    final h = PlaygroundSizes.mapMountainBackHeight;
    final opacity = switch (spec.layer) {
      MountainLayer.back => PlaygroundMapOpacity.mountainBack,
      MountainLayer.mid => PlaygroundMapOpacity.mountainMid,
      MountainLayer.front => PlaygroundMapOpacity.mountainFront,
    };

    _mountainPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color.lerp(
          spec.accent,
          AppColors.snowCap,
          PlaygroundAlpha.treeCanopyBlend,
        )!.withValues(alpha: opacity),
        spec.accent.withValues(alpha: opacity),
        palette.mountainShade.withValues(alpha: opacity),
      ],
      stops: PlaygroundGradientStops.bezel3Stop,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final path = Path()
      ..moveTo(0, h * 0.95)
      ..lineTo(0, h * 0.55)
      ..lineTo(w * 0.18, h * 0.40)
      ..lineTo(w * 0.32, h * 0.20)
      ..lineTo(w * 0.50, h * 0.05)
      ..lineTo(w * 0.68, h * 0.22)
      ..lineTo(w * 0.85, h * 0.35)
      ..lineTo(w, h * 0.55)
      ..lineTo(w, h * 0.95)
      ..close();
    canvas.drawPath(path, _mountainPaint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter old) {
    return old.parallaxOffset != parallaxOffset ||
        old.isDark != isDark ||
        old.palette.skyTop != palette.skyTop ||
        old.palette.skyBottom != palette.skyBottom ||
        old.palette.groundTop != palette.groundTop ||
        old.palette.groundBottom != palette.groundBottom ||
        old.palette.mountainAccent != palette.mountainAccent ||
        old.palette.mountainShade != palette.mountainShade;
  }
}

class _BackgroundMountainLayer {
  const _BackgroundMountainLayer({
    required this.parallax,
    required this.width,
    required this.height,
    required this.accent,
    required this.y,
    required this.layer,
  });

  final double parallax;
  final double width;
  final double height;
  final Color accent;
  final double y;
  final MountainLayer layer;
}
