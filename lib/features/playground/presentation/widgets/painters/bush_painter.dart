import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';

class BushPainter extends CustomPainter {
  BushPainter({required this.kind, required this.accent});

  static final Paint _shadow = Paint();
  static final Paint _cluster = Paint();
  static final Paint _flowerDot = Paint();
  static final Paint _snowDust = Paint();

  final BushPainterKind kind;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height;

    _shadow.color = AppColors.darkBackground.withValues(
      alpha: PlaygroundAlpha.shadow,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, baseY - 2),
        width: size.width * 1.05,
        height: size.height * 0.30,
      ),
      _shadow,
    );

    final clusters = switch (kind) {
      BushPainterKind.round => 3,
      BushPainterKind.hedge => 4,
      BushPainterKind.flowering => 5,
      BushPainterKind.snow => 3,
    };

    final clusterWidth = size.width / clusters;
    for (int i = 0; i < clusters; i++) {
      final cx = clusterWidth * (i + 0.5);
      final cy = baseY - size.height * 0.40;
      final radiusX = clusterWidth * 0.50;
      final radiusY = size.height * 0.55;
      final cRect = Rect.fromCenter(
        center: Offset(cx, cy),
        width: radiusX,
        height: radiusY,
      );

      _cluster.shader = RadialGradient(
        center: const Alignment(-0.3, -0.5),
        radius: 0.95,
        colors: <Color>[
          Color.lerp(
            accent,
            AppColors.lightBackground,
            PlaygroundAlpha.treeCanopyBlend,
          )!,
          accent,
          AppColors.foliageGreenDark,
        ],
      ).createShader(cRect);
      canvas.drawOval(cRect, _cluster);
    }

    if (kind == BushPainterKind.flowering) {
      _flowerDot.color = AppColors.accent;
      final rng = _SeedRandom(42);
      for (int i = 0; i < 12; i++) {
        final dx = rng.next() * size.width;
        final dy = rng.next() * size.height * 0.7;
        canvas.drawCircle(Offset(dx, dy), 1.4, _flowerDot);
      }
    }

    if (kind == BushPainterKind.snow) {
      _snowDust.color = AppColors.snowCap.withValues(
        alpha: PlaygroundAlpha.dust,
      );
      final rng = _SeedRandom(7);
      for (int i = 0; i < 18; i++) {
        final dx = rng.next() * size.width;
        final dy = rng.next() * size.height * 0.6;
        canvas.drawCircle(Offset(dx, dy), rng.next() * 1.6 + 0.6, _snowDust);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BushPainter old) {
    return old.kind != kind || old.accent != accent;
  }
}

enum BushPainterKind { round, hedge, flowering, snow }

class _SeedRandom {
  _SeedRandom(int seed) : _value = seed;
  int _value;

  double next() {
    _value = (_value * 1103515245 + 12345) & 0x7fffffff;
    return (_value % 1000) / 1000;
  }
}
