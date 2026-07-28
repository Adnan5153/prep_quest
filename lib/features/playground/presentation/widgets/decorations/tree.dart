import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../painters/tree_painter.dart' show TreeKind, TreePainter;

export '../painters/tree_painter.dart' show TreeKind;

class Tree extends StatefulWidget {
  const Tree({
    super.key,
    this.kind = TreeKind.oak,
    this.accentColor,
    this.sway = true,
    this.swaySeed = 0,
    this.scale = 1.0,
  });

  final TreeKind kind;
  final Color? accentColor;
  final bool sway;
  final int swaySeed;
  final double scale;

  @override
  State<Tree> createState() => _TreeState();
}

class _TreeState extends State<Tree> with SingleTickerProviderStateMixin {
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
            begin: -PlaygroundDecorationLimits.maxSwayAmplitude,
            end: PlaygroundDecorationLimits.maxSwayAmplitude,
          ).animate(
            CurvedAnimation(
              parent: _controller!,
              curve: PlaygroundDecorationCurves.sway,
            ),
          );
      final phase = (widget.swaySeed % 7) / 7;
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
      tablet: widget.scale * PlaygroundSizes.treeTabletScale,
      desktop: widget.scale * PlaygroundSizes.treeDesktopScale,
    );
    final width = PlaygroundSizes.treeWidth * responsiveScale;
    final height = PlaygroundSizes.treeHeight * responsiveScale;

    final Widget foliage = CustomPaint(
      size: Size(width, height),
      painter: TreePainter(kind: widget.kind, accent: accent),
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
                child: foliage,
              )
            : foliage,
      ),
    );
  }

  Color _resolveFoliage() {
    switch (widget.kind) {
      case TreeKind.oak:
      case TreeKind.pine:
        return AppColors.foliageGreen;
      case TreeKind.palm:
        return AppColors.foliageGreenLight;
      case TreeKind.blossom:
        return AppColors.accent.withValues(alpha: PlaygroundAlpha.blossomTint);
      case TreeKind.autumn:
        return AppColors.warning;
    }
  }
}
