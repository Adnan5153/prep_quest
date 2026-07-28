import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';

enum BridgePainterVariant { wooden, rope, stone }

class BridgePainter extends CustomPainter {
  BridgePainter({required this.variant, required this.accent});

  static final Paint _shadow = Paint();
  static final Paint _deck = Paint();
  static final Paint _plank = Paint();
  static final Paint _underside = Paint();
  static final Paint _rope = Paint();
  static final Paint _ropeDetail = Paint();
  static final Paint _stone = Paint();
  static final Paint _stoneBlock = Paint();

  final BridgePainterVariant variant;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height;

    _shadow.color = AppColors.darkBackground.withValues(
      alpha: PlaygroundAlpha.bridgeRopeHighlight,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, baseY - 1),
        width: size.width * 1.05,
        height: size.height * 0.35,
      ),
      _shadow,
    );

    final archDepth = size.height * 0.55;
    final archRect = Rect.fromCenter(
      center: Offset(size.width / 2, baseY - archDepth * 0.45),
      width: size.width * 0.95,
      height: archDepth * 0.85,
    );

    _deck.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: _deckGradient(accent),
    ).createShader(Offset.zero & size);
    final deckPath = Path()
      ..moveTo(0, baseY - 4)
      ..lineTo(0, baseY - size.height * 0.45)
      ..quadraticBezierTo(
        size.width / 2,
        baseY - size.height * 0.95,
        size.width,
        baseY - size.height * 0.45,
      )
      ..lineTo(size.width, baseY - 4)
      ..close();
    canvas.drawPath(deckPath, _deck);

    _plank.color = Color.lerp(accent, AppColors.darkBackground, 0.25)!;
    const int plankCount = 8;
    for (int i = 0; i <= plankCount; i++) {
      final t = i / plankCount;
      final x = t * size.width;
      _plank.strokeWidth = 1.0;
      canvas.drawLine(
        Offset(x, baseY - 4),
        Offset(
          x,
          baseY -
              size.height * 0.45 -
              (1 - (t - 0.5).abs() * 2) * size.height * 0.50,
        ),
        _plank,
      );
    }

    switch (variant) {
      case BridgePainterVariant.wooden:
        _paintRopeRails(canvas, size);
      case BridgePainterVariant.rope:
        _paintRopeRails(canvas, size);
        _paintRopeDetails(canvas, size);
      case BridgePainterVariant.stone:
        _paintStoneArch(canvas, size, archRect);
    }

    _underside.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.darkBackground.withValues(alpha: PlaygroundAlpha.chestShadow),
        AppColors.darkBackground.withValues(alpha: 0.0),
      ],
    ).createShader(Offset.zero & size);
    final underPath = Path()
      ..moveTo(0, baseY)
      ..lineTo(0, baseY - size.height * 0.45)
      ..quadraticBezierTo(
        size.width / 2,
        baseY - size.height * 0.95,
        size.width,
        baseY - size.height * 0.45,
      )
      ..lineTo(size.width, baseY)
      ..close();
    canvas.drawPath(underPath, _underside);
  }

  void _paintRopeRails(Canvas canvas, Size size) {
    _rope
      ..color = Color.lerp(accent, AppColors.lightBackground, 0.30)!
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final ropeArc = Path()
      ..moveTo(0, size.height * 0.10)
      ..quadraticBezierTo(
        size.width / 2,
        -size.height * 0.20,
        size.width,
        size.height * 0.10,
      );
    canvas.drawPath(ropeArc, _rope);
  }

  void _paintRopeDetails(Canvas canvas, Size size) {
    _ropeDetail
      ..color = AppColors.darkBackground.withValues(
        alpha: PlaygroundAlpha.chestShadow,
      )
      ..strokeWidth = 0.8;
    const int posts = 5;
    for (int i = 0; i <= posts; i++) {
      final t = i / posts;
      final x = t * size.width;
      final curveY = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
      canvas.drawLine(
        Offset(x, size.height * 0.10 - size.height * 0.20 * curveY),
        Offset(x, size.height * 0.50 - size.height * 0.10 * curveY),
        _ropeDetail,
      );
    }
  }

  void _paintStoneArch(Canvas canvas, Size size, Rect rect) {
    _stone.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[AppColors.mountainStone, AppColors.mountainStoneDark],
    ).createShader(rect);
    canvas.drawArc(rect, 3.14159, 3.14159, false, _stone);

    _stoneBlock
      ..color = AppColors.darkBackground.withValues(alpha: 0.30)
      ..strokeWidth = 1.0;
    for (int i = 1; i < 6; i++) {
      final t = i / 6;
      final y = rect.top + rect.height * t;
      canvas.drawLine(
        Offset(rect.left + rect.width * 0.05, y),
        Offset(rect.right - rect.width * 0.05, y),
        _stoneBlock,
      );
    }
  }

  List<Color> _deckGradient(Color base) {
    return <Color>[
      Color.lerp(base, AppColors.lightBackground, 0.40)!,
      base,
      AppColors.trunkBrownDark,
    ];
  }

  @override
  bool shouldRepaint(covariant BridgePainter old) {
    return old.variant != variant || old.accent != accent;
  }
}
