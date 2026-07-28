import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import 'node_badge.dart';
import 'node_icon.dart';
import 'node_label.dart';
import 'node_progress_indicator.dart';
import 'node_ring.dart';

class NodeVisual {
  const NodeVisual({
    required this.kind,
    required this.ringState,
    required this.iconKind,
    required this.iconVariant,
    required this.progress,
    required this.progressState,
    required this.title,
    required this.subtitle,
    required this.badgeKind,
    required this.isInteractive,
    required this.showLabel,
    required this.showProgress,
    required this.showBadge,
  });

  final NodeIconKind kind;
  final NodeRingState ringState;
  final NodeIconKind iconKind;
  final NodeIconVariant iconVariant;
  final double progress;
  final NodeProgressState progressState;
  final String title;
  final String subtitle;
  final NodeBadgeKind? badgeKind;
  final bool isInteractive;
  final bool showLabel;
  final bool showProgress;
  final bool showBadge;
}

class PlaygroundNode extends StatelessWidget {
  const PlaygroundNode({
    super.key,
    required this.visual,
    this.diameter = PlaygroundSizes.nodeDiameter,
    this.ringStyle = NodeRingStyle.gradient,
    this.onTap,
    this.onLongPress,
    this.gradientColors,
    this.foregroundColor,
    this.backgroundColor,
  });

  final NodeVisual visual;
  final double diameter;
  final NodeRingStyle ringStyle;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<Color>? gradientColors;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseDiameter = ResponsiveBuilder.value<double>(
      context,
      mobile: diameter,
      tablet: PlaygroundSizes.nodeDiameterTablet,
      desktop: PlaygroundSizes.nodeDiameterDesktop,
    );

    final stateScale = _resolveStateScale();
    final responsiveDiameter = baseDiameter * stateScale;

    final semanticLabel = _resolveSemanticLabel();
    final ringForeground = foregroundColor ?? theme.colorScheme.primary;

    final floatShadowColor = isDark
        ? AppColors.darkBackground.withValues(alpha: 0.55)
        : AppColors.nodeDropShadow;

    final Widget content = SizedBox(
      height: responsiveDiameter,
      width: responsiveDiameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: floatShadowColor,
              blurRadius: PlaygroundSizes.nodeFloatShadowBlur,
              offset: const Offset(0, PlaygroundSizes.nodeFloatShadowOffsetY),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            RepaintBoundary(
              child: NodeRing(
                state: visual.ringState,
                diameter: responsiveDiameter,
                style: ringStyle,
                gradientColors: gradientColors,
                foregroundColor: ringForeground,
                backgroundColor: backgroundColor,
              ),
            ),
            if (visual.showProgress)
              RepaintBoundary(
                child: NodeProgressIndicator(
                  progress: visual.progress,
                  state: visual.progressState,
                  diameter: responsiveDiameter * 0.78,
                ),
              ),
            RepaintBoundary(
              child: _TopSurfaceInset(
                diameter: responsiveDiameter,
                isDark: isDark,
                child: NodeIcon(
                  kind: visual.iconKind,
                  variant: visual.iconVariant,
                  size: responsiveDiameter * 0.44,
                  color: ringForeground,
                  isEnabled: visual.isInteractive,
                ),
              ),
            ),
            if (visual.showBadge && visual.badgeKind != null)
              NodeBadge(
                kind: visual.badgeKind!,
                size: responsiveDiameter * 0.32,
              ),
            if (visual.showLabel)
              NodeLabel(title: visual.title, subtitle: visual.subtitle),
          ],
        ),
      ),
    );

    Widget wrapped = content;

    if (_shouldBreath()) {
      wrapped = _BreathingNode(child: wrapped);
    }

    return Semantics(
      label: semanticLabel,
      button: visual.isInteractive && onTap != null,
      enabled: visual.isInteractive,
      child: _NodeHitArea(
        hitSize: PlaygroundSizes.nodeHitArea,
        enabled: visual.isInteractive && onTap != null,
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedScale(
          scale: 1.0,
          duration: PlaygroundDurations.pressFeedback,
          curve: PlaygroundCurves.stateEase,
          child: wrapped,
        ),
      ),
    );
  }

  double _resolveStateScale() {
    if (visual.ringState == NodeRingState.boss) {
      return PlaygroundSizes.nodeBossScaleBoost;
    }
    return 1.0;
  }

  bool _shouldBreath() {
    switch (visual.ringState) {
      case NodeRingState.unlocked:
      case NodeRingState.inProgress:
      case NodeRingState.premium:
      case NodeRingState.boss:
      case NodeRingState.seasonal:
      case NodeRingState.event:
        return true;
      case NodeRingState.locked:
      case NodeRingState.completed:
      case NodeRingState.disabled:
      case NodeRingState.unknown:
        return false;
    }
  }

  String _resolveSemanticLabel() {
    switch (visual.ringState) {
      case NodeRingState.locked:
        return PlaygroundStrings.nodeSemanticLocked;
      case NodeRingState.unlocked:
        return PlaygroundStrings.nodeSemanticUnlocked;
      case NodeRingState.inProgress:
        return PlaygroundStrings.nodeSemanticInProgress;
      case NodeRingState.completed:
        return PlaygroundStrings.nodeSemanticCompleted;
      case NodeRingState.boss:
        return PlaygroundStrings.nodeSemanticBoss;
      case NodeRingState.premium:
        return PlaygroundStrings.nodeSemanticPremium;
      case NodeRingState.event:
        return PlaygroundStrings.nodeSemanticEvent;
      case NodeRingState.seasonal:
        return PlaygroundStrings.nodeSemanticSeasonal;
      case NodeRingState.disabled:
      case NodeRingState.unknown:
        return visual.title.isEmpty
            ? PlaygroundStrings.nodeLabelFallback
            : visual.title;
    }
  }
}

class _TopSurfaceInset extends StatelessWidget {
  const _TopSurfaceInset({
    required this.diameter,
    required this.isDark,
    required this.child,
  });

  final double diameter;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final highlightRadius = diameter * 0.36;
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          IgnorePointer(
            child: Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.25, -0.45),
                  radius: 0.9,
                  colors: [
                    AppColors.nodeHighlight.withValues(
                      alpha: isDark ? 0.06 : 0.18,
                    ),
                    const Color(0x00FFFFFF),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(diameter * 0.22),
            child: SizedBox(
              width: diameter * 0.56,
              height: diameter * 0.56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(0.0, 0.0),
                    radius: 0.9,
                    colors: [
                      const Color(0x00000000),
                      Color.fromRGBO(0, 0, 0, isDark ? 0.45 : 0.22),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(diameter * 0.04),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
          Positioned(
            left: diameter * 0.16,
            top: diameter * 0.14,
            child: IgnorePointer(
              child: Container(
                width: diameter * 0.32,
                height: diameter * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(highlightRadius),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 255, 255, isDark ? 0.18 : 0.55),
                      const Color(0x00FFFFFF),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingNode extends StatefulWidget {
  const _BreathingNode({required this.child});

  final Widget child;

  @override
  State<_BreathingNode> createState() => _BreathingNodeState();
}

class _BreathingNodeState extends State<_BreathingNode>
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
        final t = _controller.value;
        final amplitude =
            PlaygroundSizes.nodeIdleBreathMax -
            PlaygroundSizes.nodeIdleBreathMin;
        final scale = PlaygroundSizes.nodeIdleBreathMin + (t * amplitude);
        return Transform.scale(scale: scale, child: child);
      },
      child: widget.child,
    );
  }
}

class _NodeHitArea extends StatefulWidget {
  const _NodeHitArea({
    required this.child,
    required this.enabled,
    required this.onTap,
    required this.onLongPress,
    required this.hitSize,
  });

  final Widget child;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double hitSize;

  @override
  State<_NodeHitArea> createState() => _NodeHitAreaState();
}

class _NodeHitAreaState extends State<_NodeHitArea> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed && widget.enabled
        ? PlaygroundSizes.nodeScalePressed
        : 1.0;

    final Widget hitArea = Semantics(
      button: true,
      enabled: widget.enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
        onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
        onTapCancel: widget.enabled ? () => _setPressed(false) : null,
        onTap: widget.enabled ? widget.onTap : null,
        onLongPress: widget.enabled ? widget.onLongPress : null,
        child: AnimatedScale(
          scale: scale,
          duration: WidgetConstants.pressAnimationDuration,
          curve: PlaygroundCurves.stateEase,
          child: widget.child,
        ),
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.hitSize,
        minHeight: widget.hitSize,
      ),
      child: hitArea,
    );
  }
}
