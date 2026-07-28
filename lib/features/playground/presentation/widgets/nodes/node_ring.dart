import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../painters/node_ring_painter.dart';

export '../painters/node_ring_painter.dart' show NodeRingState, NodeRingStyle;

class NodeRing extends StatelessWidget {
  const NodeRing({
    super.key,
    required this.state,
    this.diameter = PlaygroundSizes.nodeDiameter,
    this.strokeWidth = PlaygroundSizes.nodeRingStrokeWidth,
    this.style = NodeRingStyle.solid,
    this.glow = true,
    this.isAnimated = true,
    this.gradientColors,
    this.foregroundColor,
    this.backgroundColor,
    this.semanticLabel,
  });

  final NodeRingState state;
  final double diameter;
  final double strokeWidth;
  final NodeRingStyle style;
  final bool glow;
  final bool isAnimated;
  final List<Color>? gradientColors;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resolvedForeground = foregroundColor ?? _resolveStateColor(isDark);
    final resolvedBackground =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    final fullSize = diameter + PlaygroundSizes.nodeBezelOuter * 2;
    final rim = PlaygroundSizes.nodeBezelOuter;
    final highlight = PlaygroundSizes.nodeBezelHighlightThickness;

    final stateTone = NodeRingTone.fromBase(resolvedForeground, isDark: isDark);

    final Widget bezel = SizedBox(
      height: fullSize,
      width: fullSize,
      child: CustomPaint(
        painter: NodeRingPainter(
          stateTone: stateTone,
          highlightAlpha: isDark
              ? PlaygroundBezelTokens.highlightAlphaDark
              : PlaygroundBezelTokens.highlightAlphaLight,
          shadowAlpha: isDark
              ? PlaygroundBezelTokens.shadowAlphaDark
              : PlaygroundBezelTokens.shadowAlphaLight,
          insetAlpha: isDark
              ? PlaygroundBezelTokens.insetAlphaDark
              : PlaygroundBezelTokens.insetAlphaLight,
          rimThickness: rim,
          highlightThickness: highlight,
          gradientColors: gradientColors,
          style: style,
        ),
      ),
    );

    Widget wrapped = bezel;

    if (glow) {
      wrapped = DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: _resolveGlowShadow(resolvedForeground),
        ),
        child: wrapped,
      );
    }

    if (isAnimated && state == NodeRingState.inProgress) {
      wrapped = _AnimatedPulse(child: wrapped);
    }

    return Semantics(
      label: semanticLabel ?? state.name,
      container: true,
      child: SizedBox(
        height: fullSize,
        width: fullSize,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: diameter,
              width: diameter,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: resolvedBackground,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            wrapped,
          ],
        ),
      ),
    );
  }

  Color _resolveStateColor(bool isDark) {
    switch (state) {
      case NodeRingState.locked:
        return isDark ? AppColors.darkMuted : AppColors.lightMuted;
      case NodeRingState.unlocked:
        return AppColors.primary;
      case NodeRingState.inProgress:
        return AppColors.warning;
      case NodeRingState.completed:
        return AppColors.success;
      case NodeRingState.boss:
        return AppColors.error;
      case NodeRingState.premium:
        return AppColors.accent;
      case NodeRingState.seasonal:
        return AppColors.info;
      case NodeRingState.event:
        return AppColors.secondary;
      case NodeRingState.disabled:
        return isDark ? AppColors.darkMuted : AppColors.lightMuted;
      case NodeRingState.unknown:
        return isDark ? AppColors.darkMuted : AppColors.lightMuted;
    }
  }

  List<BoxShadow> _resolveGlowShadow(Color color) {
    if (!glow) return const [];
    final intensity = switch (state) {
      NodeRingState.boss => PlaygroundBezelTokens.glowIntensityBoss,
      NodeRingState.premium => PlaygroundBezelTokens.glowIntensityPremium,
      NodeRingState.inProgress => PlaygroundBezelTokens.glowIntensityInProgress,
      NodeRingState.seasonal => PlaygroundBezelTokens.glowIntensitySeasonal,
      NodeRingState.event => PlaygroundBezelTokens.glowIntensityEvent,
      NodeRingState.unlocked => PlaygroundBezelTokens.glowIntensityUnlocked,
      _ => 0.0,
    };
    if (intensity == 0.0) return const [];
    return [
      BoxShadow(
        color: color.withValues(
          alpha: PlaygroundBezelTokens.glowIntensityMultiplier * intensity,
        ),
        blurRadius: PlaygroundSizes.nodeGlowBlur,
        spreadRadius: PlaygroundSizes.nodeGlowSpread,
      ),
    ];
  }
}

class _AnimatedPulse extends StatefulWidget {
  const _AnimatedPulse({required this.child});

  final Widget child;

  @override
  State<_AnimatedPulse> createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<_AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.ringPulseCycle,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale =
            PlaygroundSizes.nodeIdleBreathMin +
            (_controller.value *
                (PlaygroundSizes.nodeIdleBreathMax -
                    PlaygroundSizes.nodeIdleBreathMin));
        return Opacity(
          opacity: 0.85 + (_controller.value * 0.15),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: widget.child,
    );
  }
}
