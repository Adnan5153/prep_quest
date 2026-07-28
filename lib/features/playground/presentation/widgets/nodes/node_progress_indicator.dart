import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../painters/node_progress_arc_painter.dart';

enum NodeProgressState { indeterminate, empty, partial, completed, failed }

class NodeProgressIndicator extends StatelessWidget {
  const NodeProgressIndicator({
    super.key,
    required this.progress,
    this.state = NodeProgressState.partial,
    this.diameter = PlaygroundSizes.nodeDiameter,
    this.strokeWidth = PlaygroundSizes.nodeProgressArcStroke,
    this.color,
    this.trackColor,
    this.showLabel = false,
    this.completedLabel,
  });

  final double progress;
  final NodeProgressState state;
  final double diameter;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;
  final bool showLabel;
  final String? completedLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? _resolveStateColor(theme);
    final effectiveTrackColor =
        trackColor ?? effectiveColor.withValues(alpha: 0.18);

    final double clampedProgress = progress.clamp(
      PlaygroundNodeDefaults.minProgress,
      PlaygroundNodeDefaults.maxProgress,
    );

    final Widget visual;

    switch (state) {
      case NodeProgressState.indeterminate:
        visual = SizedBox(
          height: diameter,
          width: diameter,
          child: RepaintBoundary(
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            ),
          ),
        );
      case NodeProgressState.empty:
        visual = SizedBox(
          height: diameter,
          width: diameter,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: NodeProgressArcPainter(
                progress: 0,
                color: effectiveTrackColor,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
        );
      case NodeProgressState.partial:
        visual = SizedBox(
          height: diameter,
          width: diameter,
          child: TweenAnimationBuilder<double>(
            duration: PlaygroundDurations.progressAnimation,
            curve: PlaygroundCurves.breathe,
            tween: Tween<double>(begin: 0, end: clampedProgress),
            builder: (context, value, _) {
              return RepaintBoundary(
                child: CustomPaint(
                  painter: NodeProgressArcPainter(
                    progress: value,
                    color: effectiveColor,
                    trackColor: effectiveTrackColor,
                    strokeWidth: strokeWidth,
                  ),
                ),
              );
            },
          ),
        );
      case NodeProgressState.completed:
        visual = SizedBox(
          height: diameter,
          width: diameter,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: NodeProgressArcPainter(
                progress: 1,
                color: effectiveColor,
                trackColor: effectiveTrackColor,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
        );
      case NodeProgressState.failed:
        visual = SizedBox(
          height: diameter,
          width: diameter,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: NodeProgressArcPainter(
                progress: clampedProgress,
                color: AppColors.error,
                trackColor: AppColors.error.withValues(alpha: 0.18),
                strokeWidth: strokeWidth,
              ),
            ),
          ),
        );
    }

    if (!showLabel) return visual;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        visual,
        const SizedBox(height: 2),
        _Label(
          label: state == NodeProgressState.completed
              ? (completedLabel ?? '100%')
              : '${(clampedProgress * 100).round()}%',
          color: effectiveColor,
        ),
      ],
    );
  }

  Color _resolveStateColor(ThemeData theme) {
    switch (state) {
      case NodeProgressState.indeterminate:
        return AppColors.info;
      case NodeProgressState.empty:
        return AppColors.lightMuted;
      case NodeProgressState.partial:
        return AppColors.primary;
      case NodeProgressState.completed:
        return AppColors.success;
      case NodeProgressState.failed:
        return AppColors.error;
    }
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
