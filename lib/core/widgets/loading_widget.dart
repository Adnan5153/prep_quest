import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_assets.dart';

/// Enum for different loader types supported by [LoadingWidget].
enum LoaderType { circular, linear, lottie, custom }

/// A highly customizable and responsive loading widget for Prep Quest.
///
/// Supports various loader types, optional titles, subtitles, and progress.
/// Automatically adapts to light and dark themes.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.title,
    this.subtitle,
    this.progress,
    this.showProgress = false,
    this.loaderType = LoaderType.lottie,
    this.loaderWidget,
    this.backgroundColor,
    this.loaderColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.margin,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.borderRadius,
    this.showPercentage = true,
    this.useLottie = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final String? title;
  final String? subtitle;
  final double? progress;
  final bool showProgress;
  final LoaderType loaderType;
  final Widget? loaderWidget;
  final Color? backgroundColor;
  final Color? loaderColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry alignment;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final bool showPercentage;
  final bool useLottie;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveLoaderColor = loaderColor ?? theme.colorScheme.primary;

    return Center(
      child: AnimatedContainer(
        duration: animationDuration,
        width: width,
        height: height,
        margin: margin,
        padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
        alignment: alignment,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoader(context, effectiveLoaderColor),
            if (title != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                title!,
                textAlign: TextAlign.center,
                style:
                    titleStyle ??
                    theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
              ),
            ],
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style:
                    subtitleStyle ??
                    theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                    ),
              ),
            ],
            if (showProgress && (loaderType != LoaderType.linear)) ...[
              const SizedBox(height: AppSpacing.lg),
              _ProgressContent(
                progress: progress,
                color: effectiveLoaderColor,
                showPercentage: showPercentage,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoader(BuildContext context, Color color) {
    switch (loaderType) {
      case LoaderType.lottie:
        if (useLottie) {
          return SizedBox(
            height: 100,
            width: 100,
            child: Lottie.asset(
              AppAssets.loaderLottie,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  _buildCircularLoader(color),
            ),
          );
        }
        return _buildCircularLoader(color);
      case LoaderType.circular:
        return _buildCircularLoader(color);
      case LoaderType.linear:
        return _buildLinearLoader(color);
      case LoaderType.custom:
        return loaderWidget ?? _buildCircularLoader(color);
    }
  }

  Widget _buildCircularLoader(Color color) {
    return CircularProgressIndicator(
      value: progress,
      valueColor: AlwaysStoppedAnimation<Color>(color),
      strokeWidth: 3,
    );
  }

  Widget _buildLinearLoader(Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: AppSizes.borderThick,
          ),
        ),
        if (showPercentage) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${((progress ?? 0) * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({
    this.progress,
    required this.color,
    required this.showPercentage,
  });

  final double? progress;
  final Color color;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    if (!showPercentage) return const SizedBox.shrink();

    final int percentage = ((progress ?? 0) * 100).toInt();

    return Text(
      '$percentage%',
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
    );
  }
}
