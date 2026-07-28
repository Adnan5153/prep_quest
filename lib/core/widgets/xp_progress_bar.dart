import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import 'widget_constants.dart';

/// Predefined visual variants for [XPProgressBar].
enum XPProgressBarVariant {
  linear,
  rounded,
  gradient,
  glass,
  glowing,
  minimal,
  compact,
}

/// A highly reusable, responsive XP Progress Bar widget.
///
/// Represents level progression and experience points in a modern
/// gamified style.
class XPProgressBar extends StatelessWidget {
  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.requiredXP,
    this.currentLevel = 1,
    this.nextLevel = 2,
    this.title,
    this.subtitle,
    this.height,
    this.width,
    this.progress,
    this.backgroundColor,
    this.progressColor,
    this.gradient,
    this.showPercentage = true,
    this.showLevel = true,
    this.showXPText = true,
    this.showAnimation = true,
    this.showGlow = false,
    this.showIcon = true,
    this.icon = Icons.bolt_rounded,
    this.padding,
    this.margin,
    this.borderRadius,
    this.animationDuration,
    this.animationCurve,
    this.labelStyle,
    this.progressStyle,
    this.semanticLabel,
    this.variant = XPProgressBarVariant.rounded,
  });

  final int currentXP;
  final int requiredXP;
  final int currentLevel;
  final int nextLevel;
  final String? title;
  final String? subtitle;
  final double? height;
  final double? width;
  final double? progress;
  final Color? backgroundColor;
  final Color? progressColor;
  final Gradient? gradient;
  final bool showPercentage;
  final bool showLevel;
  final bool showXPText;
  final bool showAnimation;
  final bool showGlow;
  final bool showIcon;
  final IconData icon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final TextStyle? labelStyle;
  final TextStyle? progressStyle;
  final String? semanticLabel;
  final XPProgressBarVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double effectiveProgress =
        progress ?? (currentXP / requiredXP).clamp(0.0, 1.0);
    final double effectiveHeight =
        height ??
        (variant == XPProgressBarVariant.compact
            ? 8.0
            : WidgetConstants.linearProgressHeight * 2);

    final Color effectiveProgressColor = progressColor ?? AppColors.accent;
    final Color effectiveBgColor =
        backgroundColor ??
        (variant == XPProgressBarVariant.glass
            ? Colors.white.withValues(alpha: 0.1)
            : (isDark ? AppColors.darkSurface : AppColors.lightSurface));

    return Semantics(
      label:
          semanticLabel ??
          'Level $currentLevel progression: $currentXP of $requiredXP XP',
      value: '${(effectiveProgress * 100).toInt()}%',
      child: Container(
        width: width,
        margin: margin,
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (variant != XPProgressBarVariant.minimal &&
                variant != XPProgressBarVariant.compact)
              _buildHeader(theme, isDark),
            if (title != null && variant == XPProgressBarVariant.minimal)
              _buildMinimalHeader(theme, isDark),

            _buildProgressBar(
              context,
              theme,
              effectiveHeight,
              effectiveBgColor,
              effectiveProgressColor,
              effectiveProgress,
            ),

            if (variant != XPProgressBarVariant.compact)
              const SizedBox(height: AppSpacing.xs),

            if (showXPText || showPercentage)
              _buildFooter(theme, effectiveProgressColor, effectiveProgress),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (showIcon) ...[
                  Icon(icon, size: 20, color: AppColors.accent),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Level Progress',
                      style:
                          labelStyle ??
                          theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (showLevel) _buildLevelBadge(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildMinimalHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        title!,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLevelBadge(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Lvl $currentLevel',
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    ThemeData theme,
    double height,
    Color bgColor,
    Color progressColor,
    double progress,
  ) {
    final double radius =
        borderRadius ??
        (variant == XPProgressBarVariant.linear ? 0 : AppRadius.pill);

    Widget bar = Stack(
      children: [
        // Track
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius),
            border: variant == XPProgressBarVariant.glass
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  )
                : null,
          ),
        ),
        // Progress
        TweenAnimationBuilder<double>(
          duration: showAnimation
              ? (animationDuration ?? WidgetConstants.normalAnimationDuration)
              : Duration.zero,
          curve: animationCurve ?? WidgetConstants.easeInOutCurve,
          tween: Tween<double>(begin: 0, end: progress),
          builder: (context, value, child) {
            return FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: gradient == null ? progressColor : null,
                  gradient:
                      (variant == XPProgressBarVariant.gradient ||
                          gradient != null)
                      ? (gradient ??
                            const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ))
                      : null,
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow:
                      (showGlow || variant == XPProgressBarVariant.glowing)
                      ? [
                          BoxShadow(
                            color: progressColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          },
        ),
      ],
    );

    if (variant == XPProgressBarVariant.glass) {
      bar = ClipRRect(borderRadius: BorderRadius.circular(radius), child: bar);
    }

    return bar;
  }

  Widget _buildFooter(ThemeData theme, Color color, double progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showXPText)
          Text(
            '$currentXP / $requiredXP XP',
            style:
                progressStyle ??
                theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodySmall?.color,
                ),
          ),
        if (showPercentage)
          Text(
            '${(progress * 100).toInt()}%',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
      ],
    );
  }
}
