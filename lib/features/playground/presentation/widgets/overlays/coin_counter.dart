import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';

class CoinVisual {
  const CoinVisual({
    required this.balance,
    this.gainDelta = 0,
    this.isAnimatingGain = false,
  });

  final int balance;
  final int gainDelta;
  final bool isAnimatingGain;
}

class CoinCounter extends StatelessWidget {
  const CoinCounter({
    super.key,
    required this.visual,
    this.onTap,
    this.heroTag = 'hud-coin-counter',
  });

  final CoinVisual visual;
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
        label: '${PlaygroundStrings.coinSemantic}: ${visual.balance}',
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
                    child: _HudSurface(
                      isDark: isDark,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              AppIcons.xp,
                              size: PlaygroundSizes.coinIconSize * scale,
                              color: PlaygroundColors.coin,
                            ),
                            SizedBox(
                              width: PlaygroundSizes.hudInnerGap * scale,
                            ),
                            AnimatedSwitcher(
                              duration: PlaygroundDurations.hudValueSwap,
                              switchInCurve: PlaygroundCurves.hudEase,
                              switchOutCurve: PlaygroundCurves.hudEase,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.25),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                '${visual.balance}',
                                key: ValueKey<int>(visual.balance),
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
      label: '${PlaygroundStrings.coinGainSemanticTemplate}: +$delta',
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
          color: PlaygroundColors.coin,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: [
            BoxShadow(
              color: PlaygroundColors.coin.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '+$delta',
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
