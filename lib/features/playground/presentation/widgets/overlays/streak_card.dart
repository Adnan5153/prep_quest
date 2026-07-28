import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import '../painters/streak_card_painter.dart';

class StreakVisual {
  const StreakVisual({
    required this.days,
    this.isAtRisk = false,
    this.milestoneReached = false,
  });

  final int days;
  final bool isAtRisk;
  final bool milestoneReached;
}

class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.visual,
    this.onTap,
    this.heroTag = 'hud-streak-card',
  });

  final StreakVisual visual;
  final VoidCallback? onTap;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.hudTabletScale,
      desktop: PlaygroundSizes.hudDesktopScale,
    );

    return RepaintBoundary(
      child: Semantics(
        label: visual.isAtRisk
            ? PlaygroundStrings.streakAtRiskSemantic
            : '${visual.days} ${PlaygroundStrings.streakDayLabel}',
        button: onTap != null,
        enabled: true,
        container: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: AppSizes.minTapTarget * scale,
            minHeight: PlaygroundSizes.hudIndicatorMinHeight * scale,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: AnimatedScale(
              scale: 1.0,
              duration: WidgetConstants.pressAnimationDuration,
              curve: PlaygroundCurves.hudEase,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Hero(
                    tag: heroTag,
                    child: Opacity(
                      opacity: visual.isAtRisk
                          ? PlaygroundOpacity.streakAtRisk
                          : 1.0,
                      child: _HudSurface(
                        isDark: isDark,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: PlaygroundSizes.streakFlameSize * scale,
                                height: PlaygroundSizes.streakFlameSize * scale,
                                child: _FlamePainter(
                                  base: PlaygroundColors.streak,
                                  highlight: AppColors.sparkleGold,
                                  isAtRisk: visual.isAtRisk,
                                ),
                              ),
                              SizedBox(
                                width: PlaygroundSizes.hudInnerGap * scale,
                              ),
                              Text(
                                '${visual.days}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkOnSurface
                                      : AppColors.lightOnSurface,
                                  fontWeight: FontWeight.w800,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (visual.milestoneReached)
                    Positioned(
                      top: -AppSpacing.xs,
                      right: -AppSpacing.xs,
                      child: Semantics(
                        label: PlaygroundStrings.streakMilestoneSemantic,
                        child: Container(
                          width: AppSizes.iconSm,
                          height: AppSizes.iconSm,
                          decoration: BoxDecoration(
                            color: AppColors.sparkleGold,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.darkBackground,
                              width: WidgetConstants.outlineThickness,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.star_rounded,
                            size: AppSizes.iconXs,
                            color: AppColors.darkOnSurface,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HudSurface extends StatelessWidget {
  const _HudSurface({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.darkSurface.withValues(
            alpha: PlaygroundSizes.hudGlassDarkAlpha,
          )
        : AppColors.lightSurface.withValues(
            alpha: PlaygroundSizes.hudGlassLightAlpha,
          );
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.06);

    return ClipRRect(
      borderRadius: BorderRadius.circular(PlaygroundSizes.hudBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: PlaygroundSizes.hudBlurSigma,
          sigmaY: PlaygroundSizes.hudBlurSigma,
        ),
        child: Container(
          padding: PlaygroundSizes.hudSurfacePadding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              PlaygroundSizes.hudBorderRadius,
            ),
            border: Border.all(
              color: borderColor,
              width: WidgetConstants.outlineThickness,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBackground.withValues(alpha: 0.10),
                blurRadius: PlaygroundSizes.hudBottomShadowBlur,
                offset: PlaygroundSizes.hudBottomShadowOffset,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _FlamePainter extends StatefulWidget {
  const _FlamePainter({
    required this.base,
    required this.highlight,
    required this.isAtRisk,
  });

  final Color base;
  final Color highlight;
  final bool isAtRisk;

  @override
  State<_FlamePainter> createState() => _FlamePainterState();
}

class _FlamePainterState extends State<_FlamePainter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: PlaygroundDurations.streakPulse,
    );
    if (!_reduceMotion()) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 0.5;
    }
  }

  bool _reduceMotion() {
    final query =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    return query.disableAnimations;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: StreakFlamePainter(
            phase: _controller.value,
            base: widget.base,
            highlight: widget.highlight,
            isAtRisk: widget.isAtRisk,
          ),
        );
      },
    );
  }
}
