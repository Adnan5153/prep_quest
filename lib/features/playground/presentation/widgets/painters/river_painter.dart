import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';

enum RiverPainterCurve { straight, meander }

class RiverPainter extends CustomPainter {
  RiverPainter({
    required this.curve,
    required this.accent,
    required this.phase,
    required this.seed,
    required this.isDark,
  });

  static final Paint _bed = Paint();
  static final Paint _water = Paint();
  static final Paint _foam = Paint();

  final RiverPainterCurve curve;
  final Color accent;
  final double phase;
  final int seed;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final bedPath = Path();
    if (curve == RiverPainterCurve.straight) {
      bedPath
        ..moveTo(0, size.height * 0.20)
        ..lineTo(size.width, size.height * 0.20)
        ..lineTo(size.width, size.height * 0.80)
        ..lineTo(0, size.height * 0.80)
        ..close();
    } else {
      final w = size.width;
      final h = size.height;
      bedPath
        ..moveTo(0, h * 0.30)
        ..cubicTo(w * 0.30, h * 0.10, w * 0.45, h * 0.55, w * 0.65, h * 0.30)
        ..cubicTo(w * 0.80, h * 0.15, w * 0.95, h * 0.45, w, h * 0.30)
        ..lineTo(w, h * 0.70)
        ..cubicTo(w * 0.95, h * 0.85, w * 0.80, h * 0.55, w * 0.65, h * 0.70)
        ..cubicTo(w * 0.45, h * 0.95, w * 0.30, h * 0.50, 0, h * 0.70)
        ..close();
    }

    _bed.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.trunkBrownDark.withValues(
          alpha: PlaygroundAlpha.riverBedShade,
        ),
        AppColors.trunkBrownDark,
      ],
    ).createShader(Offset.zero & size);
    canvas.drawPath(bedPath, _bed);

    final waterPath = Path();
    if (curve == RiverPainterCurve.straight) {
      waterPath.addRect(
        Rect.fromLTRB(0, size.height * 0.26, size.width, size.height * 0.74),
      );
    } else {
      final w = size.width;
      final h = size.height;
      waterPath
        ..moveTo(0, h * 0.36)
        ..cubicTo(w * 0.30, h * 0.18, w * 0.45, h * 0.60, w * 0.65, h * 0.36)
        ..cubicTo(w * 0.80, h * 0.22, w * 0.95, h * 0.50, w, h * 0.36)
        ..lineTo(w, h * 0.64)
        ..cubicTo(w * 0.95, h * 0.78, w * 0.80, h * 0.50, w * 0.65, h * 0.64)
        ..cubicTo(w * 0.45, h * 0.88, w * 0.30, h * 0.46, 0, h * 0.64)
        ..close();
    }

    final shift = phase * 2 * 3.14159;
    _water.shader = LinearGradient(
      begin: Alignment(-1 + phase * 2, 0),
      end: Alignment(1 + phase * 2, 0),
      colors: <Color>[
        Color.lerp(accent, AppColors.waterFoam, 0.10)!,
        accent,
        Color.lerp(accent, AppColors.darkBackground, 0.30)!,
        accent,
        Color.lerp(accent, AppColors.waterFoam, 0.10)!,
      ],
      stops: <double>[
        ((0.0 + shift / (2 * 3.14159)) % 1.0).clamp(0.001, 0.999).toDouble(),
        ((0.25 + shift / (2 * 3.14159)) % 1.0).clamp(0.001, 0.999).toDouble(),
        ((0.50 + shift / (2 * 3.14159)) % 1.0).clamp(0.001, 0.999).toDouble(),
        ((0.75 + shift / (2 * 3.14159)) % 1.0).clamp(0.001, 0.999).toDouble(),
        ((1.0 + shift / (2 * 3.14159)) % 1.0).clamp(0.001, 0.999).toDouble(),
      ],
    ).createShader(Offset.zero & size);
    canvas.drawPath(waterPath, _water);

    _foam
      ..color = AppColors.waterFoam.withValues(
        alpha: isDark
            ? PlaygroundAlpha.riverFoamShadow
            : PlaygroundAlpha.riverFoamLight,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final rng = _FlowRandom(seed);
    final foamStep = size.width / 12;
    for (int i = 0; i < 12; i++) {
      final t = ((i + phase * 12) % 12) / 12;
      final x = t * size.width;
      final y =
          size.height *
          (0.50 + (rng.next() - 0.5) * 0.30 + (phase - 0.5) * 0.20);
      final length = foamStep * 0.35;
      canvas.drawLine(
        Offset(x - length / 2, y),
        Offset(x + length / 2, y),
        _foam,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RiverPainter old) {
    return old.curve != curve ||
        old.accent != accent ||
        old.phase != phase ||
        old.seed != seed ||
        old.isDark != isDark;
  }
}

class _FlowRandom {
  _FlowRandom(int seed) : _value = seed;
  int _value;

  double next() {
    _value = (_value * 1103515245 + 12345) & 0x7fffffff;
    return (_value % 1000) / 1000;
  }
}
