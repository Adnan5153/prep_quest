import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../painters/cloud_painter.dart';

enum CloudKind { fluffy, thin, storm, golden }

class Cloud extends StatefulWidget {
  const Cloud({
    super.key,
    this.kind = CloudKind.fluffy,
    this.accentColor,
    this.driftDuration,
    this.scale = 1.0,
    this.seed = 0,
  });

  final CloudKind kind;
  final Color? accentColor;
  final Duration? driftDuration;
  final double scale;
  final int seed;

  @override
  State<Cloud> createState() => _CloudState();
}

class _CloudState extends State<Cloud> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.driftDuration ?? PlaygroundDecorationDurations.cloudDrift,
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
        (isDark ? AppColors.cloudDark : AppColors.cloudLight);

    final responsiveScale = ResponsiveBuilder.value<double>(
      context,
      mobile: widget.scale,
      tablet: widget.scale * PlaygroundSizes.cloudTabletScale,
      desktop: widget.scale * PlaygroundSizes.cloudDesktopScale,
    );

    final width = PlaygroundSizes.cloudWidth * responsiveScale;
    final height = PlaygroundSizes.cloudHeight * responsiveScale;

    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: CloudPainter(
                kind: _toPainterKind(widget.kind),
                fill: accent,
                highlight: Color.lerp(
                  accent,
                  AppColors.lightBackground,
                  isDark
                      ? PlaygroundAlpha.treeCanopyBlend
                      : PlaygroundAlpha.treeCanopyHighlightBlend,
                )!,
                seed: widget.seed,
              ),
            );
          },
        ),
      ),
    );
  }

  CloudPainterKind _toPainterKind(CloudKind kind) {
    switch (kind) {
      case CloudKind.fluffy:
        return CloudPainterKind.fluffy;
      case CloudKind.thin:
        return CloudPainterKind.thin;
      case CloudKind.storm:
        return CloudPainterKind.storm;
      case CloudKind.golden:
        return CloudPainterKind.golden;
    }
  }
}
