import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';

class EnergyVisual {
  const EnergyVisual({
    required this.remaining,
    required this.max,
    this.rechargeSecondsRemaining,
    this.isAnimatingRefill = false,
  });

  final int remaining;
  final int max;
  final int? rechargeSecondsRemaining;
  final bool isAnimatingRefill;

  bool get isDepleted => remaining <= 0;
  bool get isAtRisk => !isDepleted && max > 0 && remaining <= max ~/ 4;
  double get progress => max <= 0 ? 0 : (remaining / max).clamp(0.0, 1.0);
}

class EnergyIndicator extends StatelessWidget {
  const EnergyIndicator({
    super.key,
    required this.visual,
    this.onTap,
    this.heroTag = 'hud-energy-indicator',
  });

  final EnergyVisual visual;
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

    final semanticsLabel = visual.isDepleted
        ? PlaygroundStrings.heartsDepletedSemantic
        : visual.isAtRisk
        ? PlaygroundStrings.heartsAtRiskSemantic
        : '${PlaygroundStrings.heartsLabel}: ${visual.remaining}';

    return RepaintBoundary(
      child: Semantics(
        label: semanticsLabel,
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
                      opacity: visual.isDepleted
                          ? PlaygroundOpacity.heartsLow
                          : 1.0,
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
                                size: PlaygroundSizes.heartIconSize * scale,
                                color: visual.isDepleted
                                    ? PlaygroundColors.heartsEmpty
                                    : PlaygroundColors.hearts,
                              ),
                              SizedBox(
                                width: PlaygroundSizes.hudInnerGap * scale,
                              ),
                              Text(
                                '${visual.remaining}',
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
                              if (visual.rechargeSecondsRemaining != null) ...[
                                SizedBox(width: AppSpacing.xs * scale),
                                Text(
                                  _formatCountdown(
                                    visual.rechargeSecondsRemaining!,
                                  ),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkMuted
                                        : AppColors.lightMuted,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (visual.isAtRisk)
                    Positioned(
                      top: PlaygroundSizes.hudVerticalPadding,
                      right: PlaygroundSizes.hudVerticalPadding,
                      child: _PulsingDot(color: PlaygroundColors.hearts),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCountdown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = remainder.toString().padLeft(2, '0');
    return '$mm:$ss';
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

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});

  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: PlaygroundDurations.heartsLowPulse,
    );
    final reduceMotion = _reduceMotion();
    if (!reduceMotion) {
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
        final pulse = 0.4 + 0.6 * _controller.value;
        return Container(
          width: PlaygroundSizes.hudNotificationDotSize,
          height: PlaygroundSizes.hudNotificationDotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: pulse),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: pulse * 0.6),
                blurRadius: 6,
              ),
            ],
          ),
        );
      },
    );
  }
}
