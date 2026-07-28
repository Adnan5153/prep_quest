import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/playground_constants.dart';

enum NodeRingState {
  locked,
  unlocked,
  inProgress,
  completed,
  boss,
  premium,
  seasonal,
  event,
  disabled,
  unknown,
}

enum NodeRingStyle { solid, gradient, dashed, glowing }

class NodeRingTone {
  const NodeRingTone({
    required this.light,
    required this.mid,
    required this.dark,
    required this.base,
  });

  final Color light;
  final Color mid;
  final Color dark;
  final Color base;

  static NodeRingTone fromBase(Color base, {required bool isDark}) {
    final hsl = HSLColor.fromColor(base);
    final light = HSLColor.fromAHSL(
      1.0,
      hsl.hue,
      (hsl.saturation * 0.85).clamp(0.0, 1.0),
      (hsl.lightness + (isDark ? 0.22 : 0.30)).clamp(0.0, 1.0),
    ).toColor();
    final mid = base;
    final dark = HSLColor.fromAHSL(
      1.0,
      hsl.hue,
      (hsl.saturation * 1.05).clamp(0.0, 1.0),
      (hsl.lightness - (isDark ? 0.18 : 0.28)).clamp(0.0, 1.0),
    ).toColor();
    return NodeRingTone(light: light, mid: mid, dark: dark, base: base);
  }
}

class NodeRingPainter extends CustomPainter {
  NodeRingPainter({
    required this.stateTone,
    required this.style,
    required this.highlightAlpha,
    required this.shadowAlpha,
    required this.insetAlpha,
    required this.rimThickness,
    required this.highlightThickness,
    this.gradientColors,
  });

  static final Paint _outerPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  static final Paint _arcPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  static final Paint _highlightFill = Paint()..style = PaintingStyle.fill;

  static final Paint _gradientAccent = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  final NodeRingTone stateTone;
  final NodeRingStyle style;
  final double highlightAlpha;
  final double shadowAlpha;
  final double insetAlpha;
  final double rimThickness;
  final double highlightThickness;
  final List<Color>? gradientColors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.shortestSide / 2;
    final rimRadius = outerRadius - rimThickness / 2;
    final innerRadius = outerRadius - rimThickness - 1;
    final innerEdge = innerRadius - 1;
    final rect = Rect.fromCircle(center: center, radius: outerRadius);

    if (style == NodeRingStyle.glowing) {
      _outerPaint
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 2)
        ..color = stateTone.base.withValues(
          alpha: PlaygroundBezelTokens.bezelGlowAlpha,
        )
        ..strokeWidth = 0
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, outerRadius - 1, _outerPaint);
    }

    _outerPaint
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[stateTone.light, stateTone.mid, stateTone.dark],
        stops: PlaygroundGradientStops.bezel3Stop,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = rimThickness
      ..maskFilter = null;

    if (style == NodeRingStyle.dashed) {
      _drawDashedCircle(canvas, center, rimRadius);
    } else {
      canvas.drawCircle(center, rimRadius, _outerPaint);
    }

    _arcPaint
      ..color = Color.fromRGBO(255, 255, 255, highlightAlpha)
      ..strokeWidth = highlightThickness;
    _drawArcSpan(
      canvas: canvas,
      center: center,
      radius: innerRadius,
      startAngle: math.pi + math.pi * 0.18,
      sweepAngle: math.pi * 0.64,
    );

    _arcPaint.color = Color.fromRGBO(0, 0, 0, shadowAlpha);
    _drawArcSpan(
      canvas: canvas,
      center: center,
      radius: innerRadius,
      startAngle: math.pi * 0.18,
      sweepAngle: math.pi * 0.64,
    );

    _highlightFill.shader = RadialGradient(
      center: const Alignment(-0.4, -0.55),
      radius: 0.95,
      colors: <Color>[
        Color.fromRGBO(255, 255, 255, highlightAlpha * 0.6),
        const Color(0x00FFFFFF),
      ],
    ).createShader(rect);
    canvas.drawCircle(center, innerEdge, _highlightFill);

    _highlightFill.shader = RadialGradient(
      center: const Alignment(0.0, 0.0),
      radius: 0.85,
      colors: <Color>[
        const Color(0x00000000),
        Color.fromRGBO(0, 0, 0, insetAlpha),
      ],
    ).createShader(rect);
    canvas.drawCircle(center, innerEdge, _highlightFill);

    if (style == NodeRingStyle.gradient && gradientColors != null) {
      _gradientAccent.shader = SweepGradient(
        colors: gradientColors!,
        startAngle: 0,
        endAngle: math.pi * 2,
      ).createShader(rect);
      canvas.drawCircle(center, innerRadius - 1, _gradientAccent);
    }
  }

  void _drawArcSpan({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
  }) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      _arcPaint,
    );
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius) {
    const int dashCount = 24;
    const double dashLength = 4;
    final double step = (2 * math.pi * radius) / dashCount;
    final double gap = step - dashLength;
    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i / dashCount) * 2 * math.pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashLength / radius,
        false,
        _outerPaint,
      );
      if (gap > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + dashLength / radius,
          gap / radius,
          false,
          _outerPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant NodeRingPainter old) {
    return old.stateTone.base != stateTone.base ||
        old.stateTone.light != stateTone.light ||
        old.stateTone.mid != stateTone.mid ||
        old.stateTone.dark != stateTone.dark ||
        old.highlightAlpha != highlightAlpha ||
        old.shadowAlpha != shadowAlpha ||
        old.insetAlpha != insetAlpha ||
        old.rimThickness != rimThickness ||
        old.highlightThickness != highlightThickness ||
        old.style != style ||
        old.gradientColors != gradientColors;
  }
}
