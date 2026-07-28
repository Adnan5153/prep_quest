import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../painters/bush_painter.dart';

enum BushKind { round, hedge, flowering, snow }

class Bush extends StatefulWidget {
  const Bush({
    super.key,
    this.kind = BushKind.round,
    this.accentColor,
    this.sway = true,
    this.swaySeed = 0,
    this.scale = 1.0,
  });

  final BushKind kind;
  final Color? accentColor;
  final bool sway;
  final int swaySeed;
  final double scale;

  @override
  State<Bush> createState() => _BushState();
}

class _BushState extends State<Bush> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _sway;

  @override
  void initState() {
    super.initState();
    if (widget.sway) {
      _controller = AnimationController(
        vsync: this,
        duration: PlaygroundDecorationDurations.windSway,
      );
      _sway =
          Tween<double>(
            begin: -PlaygroundDecorationLimits.maxSwayAmplitude * 0.6,
            end: PlaygroundDecorationLimits.maxSwayAmplitude * 0.6,
          ).animate(
            CurvedAnimation(
              parent: _controller!,
              curve: PlaygroundDecorationCurves.sway,
            ),
          );
      final phase = (widget.swaySeed % 5) / 5;
      _controller!.value = phase;
      _controller!.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? _resolveFoliage();
    final responsiveScale = ResponsiveBuilder.value<double>(
      context,
      mobile: widget.scale,
      tablet: widget.scale * PlaygroundSizes.bushTabletScale,
      desktop: widget.scale * PlaygroundSizes.bushDesktopScale,
    );
    final width = PlaygroundSizes.bushWidth * responsiveScale;
    final height = PlaygroundSizes.bushHeight * responsiveScale;

    final Widget painter = SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: BushPainter(kind: _toPainterKind(widget.kind), accent: accent),
      ),
    );

    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: widget.sway && _sway != null
            ? AnimatedBuilder(
                animation: _sway!,
                builder: (context, child) => Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.rotationZ(_sway!.value),
                  child: child,
                ),
                child: painter,
              )
            : painter,
      ),
    );
  }

  Color _resolveFoliage() {
    switch (widget.kind) {
      case BushKind.round:
      case BushKind.hedge:
        return AppColors.foliageGreen;
      case BushKind.flowering:
        return AppColors.foliageGreen;
      case BushKind.snow:
        return AppColors.snowCap;
    }
  }

  BushPainterKind _toPainterKind(BushKind kind) {
    switch (kind) {
      case BushKind.round:
        return BushPainterKind.round;
      case BushKind.hedge:
        return BushPainterKind.hedge;
      case BushKind.flowering:
        return BushPainterKind.flowering;
      case BushKind.snow:
        return BushPainterKind.snow;
    }
  }
}
