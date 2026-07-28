import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';

enum MountainLayer { back, mid, front }

enum MountainKind { rocky, snowy, sandy, volcanic }

class MountainPainter extends CustomPainter {
  MountainPainter({required this.kind, required this.accent});

  static final Paint _fillPaint = Paint();
  static final Paint _shadowPaint = Paint();
  static final Paint _accentPaint = Paint();

  final MountainKind kind;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final baseY = size.height * 0.95;
    final peaks = _resolvePeaks(size);

    _fillPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: _bodyGradient(accent),
      stops: PlaygroundGradientStops.bezel3Stop,
    ).createShader(rect);
    _shadowPaint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        AppColors.mountainStoneDark,
        AppColors.mountainStoneDark.withValues(
          alpha: PlaygroundMapOpacity.mountainFront,
        ),
      ],
    ).createShader(rect);

    final bodyPath = Path()
      ..moveTo(0, baseY)
      ..lineTo(0, size.height * 0.55)
      ..lineTo(peaks.first.dx, peaks.first.dy);
    for (int i = 1; i < peaks.length; i++) {
      bodyPath.lineTo(peaks[i].dx, peaks[i].dy);
    }
    bodyPath
      ..lineTo(size.width, size.height * 0.65)
      ..lineTo(size.width, baseY)
      ..close();
    canvas.drawPath(bodyPath, _fillPaint);

    final shadePath = Path()
      ..moveTo(0, baseY)
      ..lineTo(0, size.height * 0.55)
      ..lineTo(peaks.first.dx, peaks.first.dy)
      ..lineTo(
        peaks.first.dx + (peaks[1].dx - peaks.first.dx) * 0.5,
        peaks.first.dy + (peaks[1].dy - peaks.first.dy) * 0.5,
      )
      ..lineTo(size.width * 0.45, baseY)
      ..close();
    canvas.drawPath(shadePath, _shadowPaint);

    if (kind == MountainKind.snowy || kind == MountainKind.rocky) {
      _paintSnowcaps(canvas, size, peaks);
    } else if (kind == MountainKind.volcanic) {
      _paintVolcanicCrater(canvas, size, peaks, baseY);
    }
  }

  void _paintSnowcaps(Canvas canvas, Size size, List<Offset> peaks) {
    _accentPaint.color = AppColors.snowCap.withValues(
      alpha: PlaygroundMapOpacity.mountainFront,
    );
    for (int i = 0; i < peaks.length; i++) {
      final peak = peaks[i];
      final next = peaks[(i + 1) % peaks.length];
      final heightFactor = (1 - peak.dy / size.height) * 0.40 + 0.10;
      final widthFactor = size.width * 0.06;
      final path = Path()
        ..moveTo(
          peak.dx - widthFactor,
          peak.dy + size.height * heightFactor * 0.20,
        )
        ..lineTo(peak.dx, peak.dy)
        ..lineTo(
          peak.dx + widthFactor,
          peak.dy + size.height * heightFactor * 0.20,
        )
        ..quadraticBezierTo(
          (peak.dx + next.dx) / 2,
          (peak.dy + next.dy) / 2 - size.height * 0.04,
          peak.dx,
          peak.dy + size.height * heightFactor,
        )
        ..close();
      canvas.drawPath(path, _accentPaint);
    }
  }

  void _paintVolcanicCrater(
    Canvas canvas,
    Size size,
    List<Offset> peaks,
    double baseY,
  ) {
    _accentPaint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[AppColors.error, AppColors.warning],
    ).createShader(Offset.zero & size);
    final crater = Path()
      ..moveTo(peaks[1].dx - size.width * 0.05, peaks[1].dy)
      ..quadraticBezierTo(
        peaks[1].dx,
        peaks[1].dy - size.height * 0.06,
        peaks[1].dx + size.width * 0.05,
        peaks[1].dy,
      )
      ..lineTo(peaks[1].dx + size.width * 0.04, baseY)
      ..lineTo(peaks[1].dx - size.width * 0.04, baseY)
      ..close();
    canvas.drawPath(crater, _accentPaint);
    _accentPaint.shader = null;
  }

  List<Offset> _resolvePeaks(Size size) {
    switch (kind) {
      case MountainKind.rocky:
      case MountainKind.snowy:
        return <Offset>[
          Offset(size.width * 0.20, size.height * 0.45),
          Offset(size.width * 0.45, size.height * 0.18),
          Offset(size.width * 0.72, size.height * 0.32),
          Offset(size.width * 0.92, size.height * 0.50),
        ];
      case MountainKind.sandy:
        return <Offset>[
          Offset(size.width * 0.18, size.height * 0.55),
          Offset(size.width * 0.42, size.height * 0.32),
          Offset(size.width * 0.70, size.height * 0.40),
          Offset(size.width * 0.92, size.height * 0.55),
        ];
      case MountainKind.volcanic:
        return <Offset>[
          Offset(size.width * 0.15, size.height * 0.50),
          Offset(size.width * 0.40, size.height * 0.30),
          Offset(size.width * 0.55, size.height * 0.22),
          Offset(size.width * 0.75, size.height * 0.35),
          Offset(size.width * 0.92, size.height * 0.55),
        ];
    }
  }

  List<Color> _bodyGradient(Color base) => <Color>[
    Color.lerp(base, AppColors.snowCap, PlaygroundAlpha.treeCanopyBlend)!,
    base,
    AppColors.mountainStoneDark,
  ];

  @override
  bool shouldRepaint(covariant MountainPainter old) {
    return old.kind != kind || old.accent != accent;
  }
}
