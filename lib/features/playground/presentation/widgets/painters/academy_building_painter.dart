import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_blurs.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../buildings/playground_building.dart' show BuildingState;

class AcademyBuildingPainter extends CustomPainter {
  AcademyBuildingPainter({
    required this.state,
    required this.scale,
    required this.floatPhase,
    required this.windowPhase,
    required this.flagPhase,
    this.wallColor,
    this.roofColor,
    this.flagColor,
  });

  static final Paint _shadow = Paint();
  static final Paint _stair = Paint();
  static final Paint _wallFill = Paint();
  static final Paint _wallColumn = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  static final Paint _wallBeam = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  static final Paint _windowFill = Paint();
  static final Paint _windowFrame = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8;
  static final Paint _windowCross = Paint()..strokeWidth = 0.6;
  static final Paint _door = Paint();
  static final Paint _doorHandle = Paint();
  static final Paint _archLight = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  static final Paint _roof = Paint();
  static final Paint _roofEdge = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  static final Paint _finial = Paint();
  static final Paint _flagPole = Paint();
  static final Paint _flag = Paint();
  static final Paint _premiumGlow = Paint()
    ..maskFilter = const MaskFilter.blur(BlurStyle.outer, AppBlurs.md);
  static final Paint _lockOverlay = Paint();
  static final Paint _padlockBody = Paint();
  static final Paint _padlockRing = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final BuildingState state;
  final double scale;
  final double floatPhase;
  final double windowPhase;
  final double flagPhase;
  final Color? wallColor;
  final Color? roofColor;
  final Color? flagColor;

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height;
    final cx = size.width / 2;

    _paintGroundShadow(canvas, size);
    _paintStairs(canvas, size);

    final wall = wallColor ?? AppColors.academyPrimary;
    final wallHighlight = AppColors.academyHighlight;
    final wallShade = AppColors.academyShade;
    final roof = roofColor ?? AppColors.academyRoof;

    final wallRect = Rect.fromLTWH(
      cx - size.width * 0.38,
      baseY - size.height * 0.70,
      size.width * 0.76,
      size.height * 0.55,
    );
    _paintWalls(canvas, wallRect, wall, wallHighlight, wallShade);
    _paintWindows(canvas, wallRect);

    final doorRect = Rect.fromLTWH(
      cx - size.width * 0.10,
      wallRect.bottom - wallRect.height * 0.45,
      size.width * 0.20,
      wallRect.height * 0.45,
    );
    _paintDoor(canvas, doorRect, wallShade, wallHighlight);

    final roofHeight = size.height * 0.30;
    final roofRect = Rect.fromLTWH(
      cx - size.width * 0.50,
      wallRect.top - roofHeight,
      size.width,
      roofHeight,
    );
    _paintRoof(canvas, roofRect, roof, wallShade);

    final flagX = roofRect.left + roofRect.width * 0.78;
    final flagTopY = roofRect.top - size.height * 0.18;
    _paintFlag(canvas, flagX, flagTopY, roofRect.top);

    if (state == BuildingState.premium) {
      _paintPremiumGlow(canvas, size, cx, baseY);
    }

    if (state == BuildingState.locked) {
      _paintLockedOverlay(canvas, size);
    }
  }

  void _paintGroundShadow(Canvas canvas, Size size) {
    _shadow.color = AppColors.darkBackground.withValues(
      alpha: PlaygroundAlpha.shadow,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height - 1),
        width: size.width * 1.05,
        height: size.height * 0.16,
      ),
      _shadow,
    );
  }

  void _paintStairs(Canvas canvas, Size size) {
    _stair.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[AppColors.trunkBrown, AppColors.trunkBrownDark],
    ).createShader(Offset.zero & size);
    final stairHeight = size.height * 0.06;
    final stairWidth = size.width * 0.55;
    final cx = size.width / 2;
    for (int i = 0; i < 3; i++) {
      final w = stairWidth * (1 - i * 0.15);
      final h = stairHeight;
      final y = size.height - (i + 1) * h;
      final rect = Rect.fromLTWH(cx - w / 2, y, w, h);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(2),
          topRight: const Radius.circular(2),
          bottomLeft: const Radius.circular(2),
          bottomRight: const Radius.circular(2),
        ),
        _stair,
      );
    }
  }

  void _paintWalls(
    Canvas canvas,
    Rect rect,
    Color wall,
    Color highlight,
    Color shade,
  ) {
    _wallFill.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[highlight, wall, shade],
      stops: PlaygroundGradientStops.wood3Stop,
    ).createShader(rect);
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: const Radius.circular(4),
      topRight: const Radius.circular(4),
      bottomLeft: const Radius.circular(2),
      bottomRight: const Radius.circular(2),
    );
    canvas.drawRRect(rrect, _wallFill);

    _wallColumn.color = shade.withValues(alpha: PlaygroundAlpha.shadow);
    const int columns = 3;
    for (int i = 1; i < columns; i++) {
      final x = rect.left + rect.width * (i / columns);
      canvas.drawLine(
        Offset(x, rect.top + 4),
        Offset(x, rect.bottom - 4),
        _wallColumn,
      );
    }

    _wallBeam.color = highlight.withValues(alpha: PlaygroundAlpha.shadow);
    canvas.drawLine(
      Offset(rect.left + 4, rect.top + 6),
      Offset(rect.right - 4, rect.top + 6),
      _wallBeam,
    );
  }

  void _paintWindows(Canvas canvas, Rect rect) {
    final baseBrightness = state == BuildingState.locked ? 0.15 : 1.0;
    final pulse =
        PlaygroundGlowPulse.alphaFloor +
        PlaygroundGlowPulse.alphaAmplitude *
            (0.5 + 0.5 * math.sin(windowPhase * 2 * math.pi));
    final glow = baseBrightness * pulse;
    final clamped = glow.clamp(0.0, 1.0);

    _windowFill.color = Color.lerp(
      AppColors.windowGlow,
      AppColors.snowCap,
      clamped,
    )!;
    final windowSize = rect.width * 0.10;
    final positions = <Offset>[
      Offset(rect.left + rect.width * 0.22, rect.top + rect.height * 0.25),
      Offset(rect.left + rect.width * 0.78, rect.top + rect.height * 0.25),
      Offset(rect.left + rect.width * 0.22, rect.top + rect.height * 0.55),
      Offset(rect.left + rect.width * 0.78, rect.top + rect.height * 0.55),
    ];
    for (final p in positions) {
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: p, width: windowSize, height: windowSize),
        const Radius.circular(2),
      );
      canvas.drawRRect(rrect, _windowFill);

      _windowFrame.color = AppColors.darkBackground.withValues(
        alpha: PlaygroundAlpha.windowFrameDark,
      );
      canvas.drawRRect(rrect, _windowFrame);

      _windowCross.color = AppColors.darkBackground.withValues(
        alpha: PlaygroundAlpha.windowMullion,
      );
      canvas.drawLine(
        Offset(p.dx - windowSize / 2, p.dy),
        Offset(p.dx + windowSize / 2, p.dy),
        _windowCross,
      );
      canvas.drawLine(
        Offset(p.dx, p.dy - windowSize / 2),
        Offset(p.dx, p.dy + windowSize / 2),
        _windowCross,
      );
    }
  }

  void _paintDoor(Canvas canvas, Rect rect, Color shade, Color highlight) {
    _door.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[shade, AppColors.darkBackground],
    ).createShader(rect);
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
      bottomLeft: const Radius.circular(2),
      bottomRight: const Radius.circular(2),
    );
    canvas.drawRRect(rrect, _door);

    _doorHandle.color = highlight;
    canvas.drawCircle(
      Offset(rect.right - rect.width * 0.20, rect.center.dy),
      rect.width * 0.06,
      _doorHandle,
    );

    _archLight.color = highlight.withValues(alpha: PlaygroundAlpha.archLight);
    canvas.drawArc(
      Rect.fromLTRB(rect.left, rect.top, rect.right, rect.top + rect.width),
      math.pi,
      math.pi,
      false,
      _archLight,
    );
  }

  void _paintRoof(Canvas canvas, Rect rect, Color roof, Color shade) {
    final path = Path()
      ..moveTo(rect.left, rect.bottom)
      ..lineTo(rect.center.dx, rect.top)
      ..lineTo(rect.right, rect.bottom)
      ..close();
    _roof.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[roof, shade],
    ).createShader(rect);
    canvas.drawPath(path, _roof);

    _roofEdge.color = AppColors.darkBackground.withValues(
      alpha: PlaygroundAlpha.roofEdgeShade,
    );
    canvas.drawPath(path, _roofEdge);

    _finial.color = AppColors.buildingGold;
    canvas.drawCircle(
      Offset(rect.center.dx, rect.top),
      rect.width * 0.04,
      _finial,
    );
  }

  void _paintFlag(Canvas canvas, double x, double topY, double bottomY) {
    _flagPole.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[AppColors.trunkBrown, AppColors.trunkBrownDark],
    ).createShader(Rect.fromLTWH(x, topY, 2, bottomY - topY));
    canvas.drawRect(Rect.fromLTWH(x - 1, topY, 2, bottomY - topY), _flagPole);

    final flagColor = this.flagColor ?? AppColors.buildingGold;
    final flagWidth = 18.0 * scale;
    final flagHeight = 10.0 * scale;
    final path = Path();
    const int segments = 5;
    final amplitude = flagHeight * 0.20;
    for (int i = 0; i <= segments; i++) {
      final t = i / segments;
      final px = x + 1 + t * flagWidth;
      final wave =
          (1 - t) *
          amplitude *
          (0.45 * (1 - t) +
              0.55 * math.sin(t * 2 * math.pi + flagPhase * 2 * math.pi));
      final py = topY + wave;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path
      ..lineTo(x + 1 + flagWidth, topY + flagHeight * 0.85)
      ..lineTo(x + 1, topY + flagHeight * 0.85)
      ..close();
    _flag.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color.lerp(
          flagColor,
          AppColors.snowCap,
          PlaygroundAlpha.treeCanopyBlend,
        )!,
        flagColor,
        Color.lerp(
          flagColor,
          AppColors.darkBackground,
          PlaygroundAlpha.chestShadow,
        )!,
      ],
    ).createShader(Rect.fromLTWH(x + 1, topY, flagWidth, flagHeight));
    canvas.drawPath(path, _flag);
  }

  void _paintPremiumGlow(Canvas canvas, Size size, double cx, double baseY) {
    _premiumGlow.color = AppColors.buildingGold.withValues(
      alpha: PlaygroundAlpha.premiumGlowAlpha,
    );
    canvas.drawCircle(
      Offset(cx, baseY - size.height * 0.40),
      size.width * 0.55,
      _premiumGlow,
    );
  }

  void _paintLockedOverlay(Canvas canvas, Size size) {
    _lockOverlay.color = AppColors.darkBackground.withValues(
      alpha: PlaygroundAlpha.lockedOverlay,
    );
    canvas.drawRect(Offset.zero & size, _lockOverlay);

    _padlockBody.color = AppColors.lightBackground;
    final cx = size.width / 2;
    final cy = size.height * 0.35;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: 12, height: 10),
        const Radius.circular(2),
      ),
      _padlockBody,
    );
    _padlockRing.color = AppColors.lightBackground;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 4), width: 8, height: 8),
      math.pi,
      math.pi,
      false,
      _padlockRing,
    );
  }

  @override
  bool shouldRepaint(covariant AcademyBuildingPainter old) {
    return old.state != state ||
        old.scale != scale ||
        old.floatPhase != floatPhase ||
        old.windowPhase != windowPhase ||
        old.flagPhase != flagPhase ||
        old.wallColor != wallColor ||
        old.roofColor != roofColor ||
        old.flagColor != flagColor;
  }
}
