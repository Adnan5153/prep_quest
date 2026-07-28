import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';

enum TreeKind { oak, pine, palm, blossom, autumn }

class TreePainter extends CustomPainter {
  TreePainter({required this.kind, required this.accent});

  static final Paint _trunkPaint = Paint();
  static final Paint _canopyFill = Paint();
  static final Paint _canopyHighlight = Paint();
  static final Paint _palmFrond = Paint();
  static final Paint _pineLayer = Paint();

  final TreeKind kind;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final baseY = size.height;
    final trunkWidth = size.width * 0.12;
    final trunkHeight = size.height * 0.32;

    final trunkRect = Rect.fromLTWH(
      cx - trunkWidth / 2,
      baseY - trunkHeight,
      trunkWidth,
      trunkHeight,
    );
    _trunkPaint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[AppColors.trunkBrown, AppColors.trunkBrownDark],
    ).createShader(trunkRect);
    final rrect = RRect.fromRectAndCorners(
      trunkRect,
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
      bottomLeft: const Radius.circular(2),
      bottomRight: const Radius.circular(2),
    );
    canvas.drawRRect(rrect, _trunkPaint);

    final canopyRect = Rect.fromLTWH(0, 0, size.width, baseY - trunkHeight);

    switch (kind) {
      case TreeKind.oak:
      case TreeKind.autumn:
      case TreeKind.blossom:
        _paintBushyCanopy(canvas, canopyRect);
      case TreeKind.pine:
        _paintPineCanopy(canvas, canopyRect);
      case TreeKind.palm:
        _paintPalmCanopy(canvas, canopyRect);
    }
  }

  void _paintBushyCanopy(Canvas canvas, Rect rect) {
    final p1 = Offset(rect.center.dx, rect.top);
    final p2 = Offset(rect.left, rect.center.dy);
    final p3 = Offset(rect.center.dx, rect.bottom);
    final p4 = Offset(rect.right, rect.center.dy);

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..quadraticBezierTo(
        rect.left - rect.width * 0.10,
        rect.top + rect.height * 0.20,
        p2.dx,
        p2.dy,
      )
      ..quadraticBezierTo(
        rect.left + rect.width * 0.10,
        rect.bottom + rect.height * 0.20,
        p3.dx,
        p3.dy,
      )
      ..quadraticBezierTo(
        rect.right - rect.width * 0.10,
        rect.bottom + rect.height * 0.20,
        p4.dx,
        p4.dy,
      )
      ..quadraticBezierTo(
        rect.right + rect.width * 0.10,
        rect.top + rect.height * 0.20,
        p1.dx,
        p1.dy,
      )
      ..close();

    _canopyFill.shader = RadialGradient(
      center: const Alignment(-0.4, -0.6),
      radius: 0.9,
      colors: <Color>[
        Color.lerp(
          accent,
          AppColors.lightBackground,
          PlaygroundAlpha.treeCanopyBlend,
        )!,
        accent,
        AppColors.foliageGreenDark,
      ],
    ).createShader(rect);
    canvas.drawShadow(path, AppColors.darkBackground, 4, false);
    canvas.drawPath(path, _canopyFill);

    _canopyHighlight.color = Color.lerp(
      accent,
      AppColors.lightBackground,
      PlaygroundAlpha.treeCanopyHighlightBlend,
    )!.withValues(alpha: PlaygroundAlpha.treeHighlight);
    final highlightPath = Path()
      ..moveTo(rect.center.dx, p1.dy)
      ..quadraticBezierTo(
        rect.left + rect.width * 0.10,
        rect.top + rect.height * 0.15,
        rect.left + rect.width * 0.25,
        rect.top + rect.height * 0.35,
      )
      ..quadraticBezierTo(
        rect.center.dx,
        rect.top + rect.height * 0.10,
        rect.center.dx,
        rect.top + rect.height * 0.25,
      )
      ..close();
    canvas.drawPath(highlightPath, _canopyHighlight);
  }

  void _paintPineCanopy(Canvas canvas, Rect rect) {
    _pineLayer.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color.lerp(
          accent,
          AppColors.lightBackground,
          PlaygroundAlpha.treeCanopyBlend,
        )!,
        accent,
        AppColors.foliageGreenDark,
      ],
    ).createShader(rect);

    const int layers = 3;
    for (int i = 0; i < layers; i++) {
      final double t = i / layers;
      final double y = rect.top + rect.height * t * 0.85;
      final double layerHeight = rect.height * (0.30 - i * 0.04);
      final double halfWidth = rect.width * (0.35 + i * 0.10);
      final path = Path()
        ..moveTo(rect.center.dx - halfWidth, y)
        ..lineTo(rect.center.dx + halfWidth, y)
        ..lineTo(rect.center.dx, y - layerHeight)
        ..close();
      canvas.drawPath(path, _pineLayer);
    }
  }

  void _paintPalmCanopy(Canvas canvas, Rect rect) {
    _palmFrond
      ..color = accent
      ..style = PaintingStyle.fill;
    const int fronds = 6;
    final Offset center = Offset(rect.center.dx, rect.bottom);
    final double length = rect.height * 0.55;
    for (int i = 0; i < fronds; i++) {
      final double offsetMultiplier = (i - (fronds - 1) / 2);
      final double ctrlX = center.dx + length * 0.40 * offsetMultiplier;
      final double ctrlY = center.dy - length * 0.55;
      final double tipX = center.dx + length * 0.95 * offsetMultiplier;
      final double tipY = center.dy - length * 0.10;
      final path = Path()
        ..moveTo(center.dx - 6, center.dy)
        ..quadraticBezierTo(ctrlX, ctrlY, tipX, tipY)
        ..quadraticBezierTo(ctrlX + 4, ctrlY + 8, center.dx + 6, center.dy)
        ..close();
      canvas.drawPath(path, _palmFrond);
    }
  }

  @override
  bool shouldRepaint(covariant TreePainter old) {
    return old.kind != kind || old.accent != accent;
  }
}
