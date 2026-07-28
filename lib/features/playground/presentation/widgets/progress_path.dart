import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/playground_constants.dart';
import '../constants/playground_sizes.dart';
import 'path/path_segment.dart';

class ProgressPathVisual {
  const ProgressPathVisual({
    required this.progress,
    required this.currentLevel,
    required this.totalLevels,
    this.upcomingMilestone,
    this.variant = PlaygroundPathVariant.straight,
    this.showLabels = true,
    this.animate = true,
  });

  final double progress;
  final int currentLevel;
  final int totalLevels;
  final String? upcomingMilestone;
  final PlaygroundPathVariant variant;
  final bool showLabels;
  final bool animate;

  double get normalizedProgress => progress.clamp(0.0, 1.0);
  int get completionPercent => (normalizedProgress * 100).round();
}

enum ProgressPathAxis { horizontal, vertical }

class ProgressPath extends StatefulWidget {
  const ProgressPath({
    super.key,
    required this.visual,
    this.axis = ProgressPathAxis.horizontal,
    this.onTap,
    this.semanticLabel,
  });

  final ProgressPathVisual visual;
  final ProgressPathAxis axis;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<ProgressPath> createState() => _ProgressPathState();
}

class _ProgressPathState extends State<ProgressPath>
    with TickerProviderStateMixin {
  late final AnimationController _revealController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.progressPathReveal,
  );
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.progressPathPulse,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMotion();
  }

  @override
  void didUpdateWidget(covariant ProgressPath oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visual.progress != widget.visual.progress ||
        oldWidget.visual.animate != widget.visual.animate) {
      _updateMotion(restart: true);
    }
  }

  void _updateMotion({bool restart = false}) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion || !widget.visual.animate) {
      _revealController.value = 1.0;
      _pulseController.stop();
      _pulseController.value = 0.0;
      return;
    }
    if (restart || _revealController.value == 0.0) {
      _revealController.forward(from: 0.0);
    }
    if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _revealController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final semantic =
        widget.semanticLabel ??
        'Playground progress: ${widget.visual.completionPercent}% complete, '
            'level ${widget.visual.currentLevel} of '
            '${widget.visual.totalLevels}';

    final surface = _ProgressPathSurface(
      visual: widget.visual,
      axis: widget.axis,
      isDark: isDark,
      revealProgress: _revealController.value,
      pulsePhase: _pulseController.value,
    );

    final content = RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[
          _revealController,
          _pulseController,
        ]),
        builder: (context, _) => surface,
      ),
    );

    return Semantics(
      label: semantic,
      value: '${widget.visual.completionPercent}%',
      button: widget.onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: content,
      ),
    );
  }
}

class _ProgressPathSurface extends StatelessWidget {
  const _ProgressPathSurface({
    required this.visual,
    required this.axis,
    required this.isDark,
    required this.revealProgress,
    required this.pulsePhase,
  });

  final ProgressPathVisual visual;
  final ProgressPathAxis axis;
  final bool isDark;
  final double revealProgress;
  final double pulsePhase;

  @override
  Widget build(BuildContext context) {
    final labels = visual.showLabels ? _buildLabels(context) : null;
    final path = LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = axis == ProgressPathAxis.horizontal;
        final width = horizontal
            ? constraints.maxWidth
            : PlaygroundSizes.progressPathMinHeight;
        final height = horizontal
            ? PlaygroundSizes.progressPathMinHeight
            : constraints.maxHeight;
        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: _buildSegments(Size(width, height)),
          ),
        );
      },
    );

    if (!visual.showLabels) return path;
    return axis == ProgressPathAxis.horizontal
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              labels!,
              const SizedBox(height: PlaygroundSizes.progressPathLabelGap),
              path,
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              path,
              const SizedBox(width: PlaygroundSizes.progressPathLabelGap),
              Flexible(child: labels!),
            ],
          );
  }

  List<Widget> _buildSegments(Size size) {
    final count = visual.totalLevels.clamp(1, 100);
    final horizontal = axis == ProgressPathAxis.horizontal;
    final inset = PlaygroundSizes.progressPathSegmentGap;
    final extent = horizontal ? size.width : size.height;
    final step = count == 1 ? 0.0 : (extent - inset * 2) / (count - 1);
    final widgets = <Widget>[];

    for (var index = 0; index < count - 1; index++) {
      final start = horizontal
          ? Offset(inset + step * index, size.height / 2)
          : Offset(size.width / 2, inset + step * index);
      final end = horizontal
          ? Offset(inset + step * (index + 1), size.height / 2)
          : Offset(size.width / 2, inset + step * (index + 1));
      final state = _stateFor(index);
      final segmentReveal = _segmentReveal(index, count - 1);
      widgets.add(
        PathSegment(
          start: start,
          end: end,
          state: state,
          variant: visual.variant,
          revealProgress: segmentReveal,
          glowPhase: pulsePhase,
          dashOffset: pulsePhase,
          isDark: isDark,
          showGlow: state == PlaygroundPathSegmentState.active,
        ),
      );
    }

    for (var index = 0; index < count; index++) {
      final center = horizontal
          ? Offset(inset + step * index, size.height / 2)
          : Offset(size.width / 2, inset + step * index);
      widgets.add(
        Positioned(
          left: center.dx - PlaygroundSizes.progressPathSegmentHeight,
          top: center.dy - PlaygroundSizes.progressPathSegmentHeight,
          child: _ProgressMarker(
            state: _markerStateFor(index),
            isDark: isDark,
            pulsePhase: pulsePhase,
          ),
        ),
      );
    }
    return widgets;
  }

  double _segmentReveal(int index, int segmentCount) {
    if (segmentCount <= 0) return 1.0;
    final scaled = revealProgress * segmentCount;
    return (scaled - index).clamp(0.0, 1.0);
  }

  PlaygroundPathSegmentState _stateFor(int index) {
    final span = visual.totalLevels <= 1 ? 1 : visual.totalLevels - 1;
    final position = visual.normalizedProgress * span;
    if (index + 1 <= position) {
      return PlaygroundPathSegmentState.completed;
    }
    if (index <= position) {
      return PlaygroundPathSegmentState.active;
    }
    return PlaygroundPathSegmentState.locked;
  }

  PlaygroundPathSegmentState _markerStateFor(int index) {
    if (index < visual.currentLevel - 1) {
      return PlaygroundPathSegmentState.completed;
    }
    if (index == visual.currentLevel - 1) {
      return PlaygroundPathSegmentState.active;
    }
    return PlaygroundPathSegmentState.locked;
  }

  Widget _buildLabels(BuildContext context) {
    final theme = Theme.of(context);
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final milestone = visual.upcomingMilestone;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: PlaygroundSizes.progressPathLabelGap,
      children: <Widget>[
        Text(
          'Level ${visual.currentLevel} / ${visual.totalLevels}',
          style: theme.textTheme.labelLarge?.copyWith(
            color: muted,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        Text(
          '${visual.completionPercent}%',
          style: theme.textTheme.labelLarge?.copyWith(
            color: PlaygroundColors.progressionInProgress,
            fontWeight: FontWeight.w700,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        if (milestone != null && milestone.isNotEmpty)
          Text(
            'Next: $milestone',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
      ],
    );
  }
}

class _ProgressMarker extends StatelessWidget {
  const _ProgressMarker({
    required this.state,
    required this.isDark,
    required this.pulsePhase,
  });

  final PlaygroundPathSegmentState state;
  final bool isDark;
  final double pulsePhase;

  @override
  Widget build(BuildContext context) {
    final diameter = PlaygroundSizes.progressPathSegmentHeight * 2;
    final color = switch (state) {
      PlaygroundPathSegmentState.completed =>
        PlaygroundColors.progressionCompleted,
      PlaygroundPathSegmentState.active =>
        PlaygroundColors.progressionInProgress,
      PlaygroundPathSegmentState.locked => PlaygroundColors.progressionLocked,
    };
    final scale = state == PlaygroundPathSegmentState.active
        ? PlaygroundAlpha.bossGatePulseFloor +
              pulsePhase * PlaygroundAlpha.bossGatePulseAmplitude
        : 1.0;
    return Transform.scale(
      scale: scale,
      child: SizedBox.square(
        dimension: diameter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: isDark
                  ? PlaygroundColors.progressionHighlightDark
                  : PlaygroundColors.progressionHighlightLight,
            ),
            boxShadow: state == PlaygroundPathSegmentState.active
                ? <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(
                        alpha: PlaygroundAlpha.progressionSegmentActive,
                      ),
                      blurRadius: PlaygroundSizes.progressPathPulseBlur,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
