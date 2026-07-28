import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_blurs.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../buildings/playground_building.dart' show BuildingState;

class LibraryBuildingPainter extends CustomPainter {
  LibraryBuildingPainter({
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
  static final Paint _wallFill = Paint();
  static final Paint _wallPlank = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8;
  static final Paint _shelf = Paint();
  static final Paint _book = Paint();
  static final Paint _windowFrame = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  static final Paint _door = Paint();
  static final Paint _doorHandle = Paint();
  static final Paint _doorStep = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  static final Paint _roof = Paint();
  static final Paint _roofEdge = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  static final Paint _roofBook = Paint();
  static final Paint _roofSpine = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8;
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

    final wall = wallColor ?? AppColors.libraryPrimary;
    final wallHighlight = AppColors.libraryHighlight;
    final wallShade = AppColors.libraryShade;
    final roof = roofColor ?? AppColors.libraryRoof;

    final wallRect = Rect.fromLTWH(
      cx - size.width * 0.42,
      baseY - size.height * 0.78,
      size.width * 0.84,
      size.height * 0.65,
    );
    _paintWalls(canvas, wallRect, wall, wallHighlight, wallShade);

    _paintBookshelfWindows(canvas, wallRect);

    final doorRect = Rect.fromLTWH(
      cx - size.width * 0.10,
      wallRect.bottom - wallRect.height * 0.50,
      size.width * 0.20,
      wallRect.height * 0.50,
    );
    _paintDoor(canvas, doorRect, wallShade, wallHighlight);

    final roofHeight = size.height * 0.25;
    final roofRect = Rect.fromLTWH(
      cx - size.width * 0.46,
      wallRect.top - roofHeight,
      size.width * 0.92,
      roofHeight,
    );
    _paintRoof(canvas, roofRect, roof, wallShade);

    final flagX = roofRect.left + roofRect.width * 0.78;
    final flagTopY = roofRect.top - size.height * 0.16;
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

    _wallPlank.color = shade.withValues(
      alpha: PlaygroundAlpha.bridgePlankShadow,
    );
    const int plankCount = 6;
    for (int i = 1; i < plankCount; i++) {
      final y = rect.top + rect.height * (i / plankCount);
      canvas.drawLine(
        Offset(rect.left + 2, y),
        Offset(rect.right - 2, y),
        _wallPlank,
      );
    }
  }

  void _paintBookshelfWindows(Canvas canvas, Rect rect) {
    final baseBrightness = state == BuildingState.locked ? 0.15 : 1.0;
    final pulse =
        PlaygroundGlowPulse.alphaFloor +
        PlaygroundGlowPulse.alphaAmplitude *
            (0.5 + 0.5 * math.sin(windowPhase * 2 * math.pi));
    final glow = baseBrightness * pulse;
    final clamped = glow.clamp(0.0, 1.0);

    _shelf.color = Color.lerp(
      AppColors.windowGlow,
      AppColors.snowCap,
      clamped,
    )!;

    final windowWidth = rect.width * 0.16;
    final windowHeight = rect.height * 0.40;
    final positions = <Offset>[
      Offset(rect.left + rect.width * 0.18, rect.top + rect.height * 0.12),
      Offset(rect.left + rect.width * 0.82, rect.top + rect.height * 0.12),
    ];

    for (final p in positions) {
      final wRect = Rect.fromCenter(
        center: p,
        width: windowWidth,
        height: windowHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(wRect, const Radius.circular(2)),
        _shelf,
      );

      final bookColors = <Color>[
        AppColors.error,
        AppColors.primary,
        AppColors.info,
        AppColors.secondary,
      ];
      final bookHeight = windowHeight * 0.22;
      const int bookCount = 4;
      for (int row = 0; row < 2; row++) {
        for (int i = 0; i < bookCount; i++) {
          final bookWidth = (windowWidth - 4) / bookCount - 1;
          final x = wRect.left + 2 + i * (bookWidth + 1);
          final y = wRect.top + 2 + row * (bookHeight + 2);
          _book.color = bookColors[i % bookColors.length].withValues(
            alpha: PlaygroundAlpha.bookSpine,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, y, bookWidth, bookHeight),
              const Radius.circular(1),
            ),
            _book,
          );
        }
      }

      _windowFrame.color = AppColors.darkBackground.withValues(
        alpha: PlaygroundAlpha.bookShelfFrame,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(wRect, const Radius.circular(2)),
        _windowFrame,
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

    _doorStep.color = AppColors.trunkBrownDark;
    canvas.drawLine(
      Offset(rect.left, rect.bottom - 1),
      Offset(rect.right, rect.bottom - 1),
      _doorStep,
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

    _roofBook.color = AppColors.accent.withValues(
      alpha: PlaygroundAlpha.bookSpine,
    );
    final bookRect = Rect.fromCenter(
      center: Offset(rect.center.dx, rect.top + rect.height * 0.35),
      width: rect.width * 0.10,
      height: rect.height * 0.40,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bookRect, const Radius.circular(1.5)),
      _roofBook,
    );

    _roofSpine.color = AppColors.darkBackground.withValues(
      alpha: PlaygroundAlpha.bookShelfFrame,
    );
    canvas.drawLine(
      Offset(bookRect.center.dx, bookRect.top + 1),
      Offset(bookRect.center.dx, bookRect.bottom - 1),
      _roofSpine,
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
    final flagWidth = 14.0 * scale;
    final flagHeight = 8.0 * scale;
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
      Offset(cx, baseY - size.height * 0.45),
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
  bool shouldRepaint(covariant LibraryBuildingPainter old) {
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
