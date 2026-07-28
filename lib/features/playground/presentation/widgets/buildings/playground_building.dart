import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import 'building_label.dart';
import 'building_progress.dart';

enum BuildingState { locked, unlocked, current, completed, premium }

class BuildingVisual {
  const BuildingVisual({
    required this.state,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.level,
    required this.isInteractive,
    required this.showLabel,
    required this.showProgress,
    required this.labelPlacement,
    required this.labelEmphasis,
    required this.progressKind,
  });

  final BuildingState state;
  final String title;
  final String subtitle;
  final double progress;
  final int level;
  final bool isInteractive;
  final bool showLabel;
  final bool showProgress;
  final BuildingLabelPlacement labelPlacement;
  final BuildingLabelEmphasis labelEmphasis;
  final BuildingProgressKind progressKind;
}

class PlaygroundBuilding extends StatelessWidget {
  const PlaygroundBuilding({
    super.key,
    required this.visual,
    required this.sprite,
    this.width = PlaygroundSizes.buildingAcademyWidth,
    this.height = PlaygroundSizes.buildingAcademyHeight,
    this.hitSize = PlaygroundSizes.buildingHitArea,
    this.onTap,
    this.onLongPress,
    this.spriteBackgroundColor,
    this.spriteForegroundColor,
    this.accentColor,
    this.labelBackgroundColor,
    this.labelForegroundColor,
    this.progressBackgroundColor,
    this.progressForegroundColor,
    this.progressBorderColor,
  });

  final BuildingVisual visual;
  final Widget sprite;
  final double width;
  final double height;
  final double hitSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? spriteBackgroundColor;
  final Color? spriteForegroundColor;
  final Color? accentColor;
  final Color? labelBackgroundColor;
  final Color? labelForegroundColor;
  final Color? progressBackgroundColor;
  final Color? progressForegroundColor;
  final Color? progressBorderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final responsiveScale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.buildingTabletScale,
      desktop: PlaygroundSizes.buildingDesktopScale,
    );

    final double effectiveWidth = width * responsiveScale;
    final double effectiveHeight = height * responsiveScale;

    final accent = accentColor ?? AppColors.primary;
    final floatShadowColor = isDark
        ? AppColors.darkBackground.withValues(alpha: 0.55)
        : AppColors.darkBackground.withValues(alpha: 0.30);

    final double opacity = _resolveOpacity();

    final Widget scaledSprite = SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: opacity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: floatShadowColor,
                      blurRadius: PlaygroundSizes.buildingShadowBlur,
                      offset: PlaygroundSizes.buildingShadowOffset,
                    ),
                  ],
                ),
                child: sprite,
              ),
            ),
          ),
          if (visual.showProgress)
            Positioned(
              right: PlaygroundSizes.buildingProgressOffsetX,
              top: PlaygroundSizes.buildingProgressOffsetY,
              child: Opacity(
                opacity: opacity,
                child: BuildingProgress(
                  progress: visual.progress,
                  kind: visual.progressKind,
                  level: visual.level,
                  backgroundColor: progressBackgroundColor,
                  foregroundColor: progressForegroundColor,
                  borderColor: progressBorderColor,
                ),
              ),
            ),
          if (visual.showLabel)
            BuildingLabel(
              title: visual.title,
              subtitle: visual.subtitle,
              placement: visual.labelPlacement,
              emphasis: visual.labelEmphasis,
              backgroundColor: labelBackgroundColor,
              foregroundColor: labelForegroundColor,
              accentColor: accent,
            ),
        ],
      ),
    );

    final Widget content = RepaintBoundary(
      child: _BuildingFloat(
        enabled:
            visual.state == BuildingState.unlocked ||
            visual.state == BuildingState.current ||
            visual.state == BuildingState.premium,
        child: scaledSprite,
      ),
    );

    return Semantics(
      label: _resolveSemanticLabel(),
      button: visual.isInteractive && onTap != null,
      enabled: visual.isInteractive,
      child: _BuildingHitArea(
        hitSize: hitSize,
        enabled: visual.isInteractive && onTap != null,
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedScale(
          scale: 1.0,
          duration: PlaygroundBuildingDurations.tapFeedback,
          curve: PlaygroundBuildingCurves.tap,
          child: content,
        ),
      ),
    );
  }

  double _resolveOpacity() {
    switch (visual.state) {
      case BuildingState.locked:
        return PlaygroundBuildingOpacity.locked;
      case BuildingState.completed:
      case BuildingState.premium:
      case BuildingState.unlocked:
      case BuildingState.current:
        return 1.0;
    }
  }

  String _resolveSemanticLabel() {
    switch (visual.state) {
      case BuildingState.locked:
        return PlaygroundStrings.buildingSemanticLocked;
      case BuildingState.unlocked:
        return PlaygroundStrings.buildingSemanticUnlocked;
      case BuildingState.current:
        return PlaygroundStrings.buildingSemanticCurrent;
      case BuildingState.completed:
        return PlaygroundStrings.buildingSemanticCompleted;
      case BuildingState.premium:
        return PlaygroundStrings.buildingSemanticPremium;
    }
  }
}

class _BuildingFloat extends StatefulWidget {
  const _BuildingFloat({required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  State<_BuildingFloat> createState() => _BuildingFloatState();
}

class _BuildingFloatState extends State<_BuildingFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: PlaygroundBuildingDurations.idleParallax,
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled && !_reduceMotion()) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void didUpdateWidget(covariant _BuildingFloat old) {
    super.didUpdateWidget(old);
    if (widget.enabled != old.enabled) {
      if (widget.enabled && !_reduceMotion()) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0.5;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _reduceMotion() {
    final query =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    return query.disableAnimations;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final amplitude =
            PlaygroundSizes.buildingIdleBreathMax -
            PlaygroundSizes.buildingIdleBreathMin;
        final scale = PlaygroundSizes.buildingIdleBreathMin + (t * amplitude);
        return Transform.translate(
          offset: Offset(
            0,
            -PlaygroundSizes.buildingBaseOffsetY * 0.05 * (t - 0.5) * 2,
          ),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: widget.child,
    );
  }
}

class _BuildingHitArea extends StatefulWidget {
  const _BuildingHitArea({
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
  State<_BuildingHitArea> createState() => _BuildingHitAreaState();
}

class _BuildingHitAreaState extends State<_BuildingHitArea> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed && widget.enabled
        ? PlaygroundSizes.buildingScalePressed
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
          curve: PlaygroundBuildingCurves.tap,
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
