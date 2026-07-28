import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../painters/river_painter.dart';

enum RiverCurve { straight, meander }

class River extends StatefulWidget {
  const River({
    super.key,
    this.curve = RiverCurve.straight,
    this.accentColor,
    this.height,
    this.flowDuration,
    this.seed = 0,
  });

  final RiverCurve curve;
  final Color? accentColor;
  final double? height;
  final Duration? flowDuration;
  final int seed;

  @override
  State<River> createState() => _RiverState();
}

class _RiverState extends State<River> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.flowDuration ?? PlaygroundDecorationDurations.riverFlow,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent =
        widget.accentColor ??
        (isDark ? AppColors.waterDark : AppColors.waterLight);
    final height = widget.height ?? PlaygroundSizes.riverHeight;

    return RepaintBoundary(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: RiverPainter(
                curve: _toPainterCurve(widget.curve),
                accent: accent,
                phase: _controller.value,
                seed: widget.seed,
                isDark: isDark,
              ),
            );
          },
        ),
      ),
    );
  }

  RiverPainterCurve _toPainterCurve(RiverCurve curve) {
    switch (curve) {
      case RiverCurve.straight:
        return RiverPainterCurve.straight;
      case RiverCurve.meander:
        return RiverPainterCurve.meander;
    }
  }
}
