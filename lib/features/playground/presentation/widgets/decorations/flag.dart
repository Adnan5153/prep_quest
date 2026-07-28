import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../painters/flag_painter.dart';

enum FlagColor { red, green, gold, premium, event, seasonal }

class Flag extends StatefulWidget {
  const Flag({
    super.key,
    this.color = FlagColor.red,
    this.accentColor,
    this.waveDuration,
    this.scale = 1.0,
  });

  final FlagColor color;
  final Color? accentColor;
  final Duration? waveDuration;
  final double scale;

  @override
  State<Flag> createState() => _FlagState();
}

class _FlagState extends State<Flag> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.waveDuration ?? PlaygroundDecorationDurations.flagWave,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? _resolveColor();
    final width = PlaygroundSizes.flagWidth * widget.scale;
    final height = PlaygroundSizes.flagHeight * widget.scale;
    final poleWidth = PlaygroundSizes.flagPoleWidth;
    final flagH = height * 0.65;

    return RepaintBoundary(
      child: SizedBox(
        width: width + poleWidth,
        height: height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: FlagPainter(
                accent: accent,
                phase: _controller.value,
                poleWidth: poleWidth,
                flagWidth: width,
                flagHeight: flagH,
                highlight: Color.lerp(
                  accent,
                  AppColors.lightBackground,
                  PlaygroundAlpha.flagWaveHighlight,
                )!,
                shadow: Color.lerp(
                  accent,
                  AppColors.darkBackground,
                  PlaygroundAlpha.flagWaveShade,
                )!,
              ),
            );
          },
        ),
      ),
    );
  }

  Color _resolveColor() {
    switch (widget.color) {
      case FlagColor.red:
        return AppColors.flagRed;
      case FlagColor.green:
        return AppColors.success;
      case FlagColor.gold:
        return AppColors.accent;
      case FlagColor.premium:
        return AppColors.secondary;
      case FlagColor.event:
        return AppColors.info;
      case FlagColor.seasonal:
        return AppColors.foliageGreen;
    }
  }
}
