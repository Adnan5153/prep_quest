import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';

class FlagPainter extends CustomPainter {
  FlagPainter({
    required this.accent,
    required this.phase,
    required this.poleWidth,
    required this.flagWidth,
    required this.flagHeight,
    required this.highlight,
    required this.shadow,
  });

  static final Paint _pole = Paint();
  static final Paint _finial = Paint();
  static final Paint _flag = Paint();
  static final Paint _shadowPath = Paint();
  static final Paint _star = Paint();

  final Color accent;
  final double phase;
  final double poleWidth;
  final double flagWidth;
  final double flagHeight;
  final Color highlight;
  final Color shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final poleRect = Rect.fromLTWH(0, 0, poleWidth, size.height);
    _pole.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[AppColors.trunkBrown, AppColors.trunkBrownDark],
    ).createShader(poleRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(poleRect, const Radius.circular(2)),
      _pole,
    );

    _finial.color = AppColors.accent;
    canvas.drawCircle(Offset(poleWidth / 2, 0), poleWidth * 1.4, _finial);

    const int segments = 6;
    final double amplitude = flagHeight * 0.18;
    final double attachX = poleWidth;
    final double attachY = size.height * 0.05;

    final Path flagPath = Path();
    final Path shadowPath = Path();

    for (int i = 0; i <= segments; i++) {
      final double t = i / segments;
      final double x = attachX + t * flagWidth;
      final double wave = _wave(t, amplitude);
      final double y = attachY + wave;
      if (i == 0) {
        flagPath.moveTo(x, y);
        shadowPath.moveTo(x, y + flagHeight * 0.45);
      } else {
        flagPath.lineTo(x, y);
        shadowPath.lineTo(x, y + flagHeight * 0.45);
      }
    }
    flagPath
      ..lineTo(
        attachX + flagWidth,
        attachY + flagHeight * 0.85 + _wave(1.0, amplitude),
      )
      ..lineTo(attachX, attachY + flagHeight * 0.85 + _wave(0.0, amplitude))
      ..close();

    shadowPath
      ..lineTo(
        attachX + flagWidth,
        attachY + flagHeight * 0.85 + _wave(1.0, amplitude) + flagHeight * 0.25,
      )
      ..lineTo(
        attachX,
        attachY + flagHeight * 0.85 + _wave(0.0, amplitude) + flagHeight * 0.25,
      )
      ..close();

    _flag.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[highlight, accent, shadow],
    ).createShader(Rect.fromLTWH(attachX, attachY, flagWidth, flagHeight));

    _shadowPath.color = shadow;
    canvas.drawPath(shadowPath, _shadowPath);
    canvas.drawPath(flagPath, _flag);

    final Paint highlightShader = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              highlight.withValues(alpha: PlaygroundAlpha.flagWaveHighlight),
              AppColors.lightBackground.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromLTWH(attachX, attachY, flagWidth, flagHeight * 0.5),
          );
    canvas.drawRect(
      Rect.fromLTWH(attachX, attachY, flagWidth, flagHeight * 0.5),
      highlightShader,
    );

    _star.color = AppColors.snowCap;
    canvas.drawCircle(
      Offset(attachX + flagWidth * 0.20, attachY + flagHeight * 0.30),
      flagHeight * 0.07,
      _star,
    );
  }

  double _wave(double t, double amplitude) {
    final double twoPi = 2 * math.pi;
    return amplitude *
        (1 - t) *
        (0.45 * (1 - t) + 0.55 * math.sin(t * twoPi + phase * twoPi));
  }

  @override
  bool shouldRepaint(covariant FlagPainter old) {
    return old.accent != accent ||
        old.phase != phase ||
        old.poleWidth != poleWidth ||
        old.flagWidth != flagWidth ||
        old.flagHeight != flagHeight ||
        old.highlight != highlight ||
        old.shadow != shadow;
  }
}
