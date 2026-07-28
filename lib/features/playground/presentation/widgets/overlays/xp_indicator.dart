import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../../../../core/widgets/xp_progress_bar.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';

class XpVisual {
  const XpVisual({
    required this.totalXp,
    required this.userLevel,
    required this.xpInLevel,
    required this.xpForNextLevel,
    this.gainDelta = 0,
    this.isAnimatingGain = false,
  });

  final int totalXp;
  final int userLevel;
  final int xpInLevel;
  final int xpForNextLevel;
  final int gainDelta;
  final bool isAnimatingGain;

  double get progress {
    if (xpForNextLevel <= 0) return 0;
    return (xpInLevel / xpForNextLevel).clamp(0.0, 1.0);
  }
}

class XpIndicator extends StatelessWidget {
  const XpIndicator({
    super.key,
    required this.visual,
    this.onTap,
    this.heroTag = 'hud-xp-indicator',
  });

  final XpVisual visual;
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
        label:
            '${PlaygroundStrings.xpProgressSemantic}: ${visual.xpInLevel} of ${visual.xpForNextLevel}',
        value: '${(visual.progress * 100).round()}%',
        button: onTap != null,
        enabled: true,
        container: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: PlaygroundSizes.hudIndicatorMinWidth * scale,
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
                children: [
                  Hero(
                    tag: heroTag,
                    child: _HudSurface(
                      isDark: isDark,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _LevelBadge(level: visual.userLevel, scale: scale),
                            SizedBox(
                              width: PlaygroundSizes.hudInnerGap * scale,
                            ),
                            SizedBox(
                              width:
                                  PlaygroundSizes.hudIndicatorMinWidth * scale,
                              child: XPProgressBar(
                                currentXP: visual.xpInLevel,
                                requiredXP: visual.xpForNextLevel > 0
                                    ? visual.xpForNextLevel
                                    : 1,
                                currentLevel: visual.userLevel,
                                nextLevel: visual.userLevel + 1,
                                progress: visual.progress,
                                variant: XPProgressBarVariant.compact,
                                showLevel: false,
                                showXPText: true,
                                showPercentage: false,
                                showIcon: false,
                                showAnimation: true,
                                showGlow: visual.isAnimatingGain,
                                padding: EdgeInsets.zero,
                                progressColor: PlaygroundColors.xp,
                                animationDuration:
                                    PlaygroundDurations.hudValueTween,
                                animationCurve: PlaygroundCurves.hudEase,
                                semanticLabel:
                                    PlaygroundStrings.xpProgressSemantic,
                                labelStyle: theme.textTheme.labelSmall
                                    ?.copyWith(
                                      color: isDark
                                          ? AppColors.darkOnSurface
                                          : AppColors.lightOnSurface,
                                      fontWeight: FontWeight.w700,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (visual.isAnimatingGain && visual.gainDelta > 0)
                    Positioned(
                      right: -PlaygroundSizes.hudGainPillOffsetX,
                      top: PlaygroundSizes.hudGainPillOffsetY,
                      child: _GainPill(delta: visual.gainDelta),
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

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level, required this.scale});

  final int level;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: AppSizes.minTapTarget * scale,
      height: AppSizes.minTapTarget * scale,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [PlaygroundColors.xp, AppColors.buildingGold],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: PlaygroundColors.xp.withValues(alpha: 0.35),
            blurRadius: PlaygroundSizes.hudBottomShadowBlur,
            offset: PlaygroundSizes.hudBottomShadowOffset,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.xp,
            size: PlaygroundSizes.hudIconSize * scale,
            color: AppColors.darkOnSurface,
          ),
          Text(
            '$level',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.darkOnSurface,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
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

class _GainPill extends StatelessWidget {
  const _GainPill({required this.delta});

  final int delta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: '${PlaygroundStrings.xpGainSemanticTemplate}: +$delta',
      liveRegion: true,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: PlaygroundSizes.hudGainPillWidth,
          minHeight: PlaygroundSizes.hudGainPillHeight,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: PlaygroundColors.xp,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: [
            BoxShadow(
              color: PlaygroundColors.xp.withValues(alpha: 0.4),
              blurRadius: PlaygroundSizes.hudBottomShadowBlur,
              offset: PlaygroundSizes.hudBottomShadowOffset,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '+$delta ${PlaygroundStrings.xpLabel}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.darkOnSurface,
            fontWeight: FontWeight.w800,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}
