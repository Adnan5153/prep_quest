import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

/// A production-ready responsive image placeholder component.
///
/// This widget serves as a fallback for missing, loading, or failed images.
/// It intelligently adapts its layout based on the available constraints,
/// making it suitable for everything from small avatars to large banners.
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment = Alignment.center,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.assetImage,
    this.title,
    this.subtitle,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showBorder = true,
    this.showRetryButton = false,
    this.showLoading = false,
    this.loadingWidget,
    this.onRetry,
    this.fit = BoxFit.cover,
    this.aspectRatio,
    this.clipBehavior = Clip.antiAlias,
  });

  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry alignment;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String? assetImage;
  final String? title;
  final String? subtitle;
  final bool showTitle;
  final bool showSubtitle;
  final bool showBorder;
  final bool showRetryButton;
  final bool showLoading;
  final Widget? loadingWidget;
  final VoidCallback? onRetry;
  final BoxFit fit;
  final double? aspectRatio;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveBg =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    final Color effectiveBorderColor =
        borderColor ??
        (isDark
            ? AppColors.darkMuted.withValues(alpha: 0.2)
            : AppColors.lightMuted.withValues(alpha: 0.2));

    final Color effectiveIconColor =
        iconColor ?? (isDark ? AppColors.darkMuted : AppColors.lightMuted);

    final BorderRadiusGeometry effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppRadius.lg);

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final double availableHeight = constraints.maxHeight;

        final bool isVerySmall = availableWidth < 60 || availableHeight < 60;
        final bool canShowText = availableWidth > 120 && availableHeight > 100;

        return _PlaceholderContent(
          icon: icon ?? Icons.image_outlined,
          iconSize: iconSize ?? (isVerySmall ? 20.0 : 40.0),
          iconColor: effectiveIconColor,
          assetImage: assetImage,
          title: title,
          subtitle: subtitle,
          showTitle: showTitle && canShowText,
          showSubtitle: showSubtitle && canShowText && availableHeight > 130,
          showRetryButton: showRetryButton && canShowText,
          showLoading: showLoading,
          loadingWidget: loadingWidget,
          onRetry: onRetry,
          fit: fit,
        );
      },
    );

    if (aspectRatio != null) {
      content = AspectRatio(aspectRatio: aspectRatio!, child: content);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: effectiveRadius,
        border: showBorder
            ? Border.all(
                color: effectiveBorderColor,
                width: AppSizes.borderThin,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        clipBehavior: clipBehavior,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: content,
        ),
      ),
    );
  }
}

class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent({
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    this.assetImage,
    this.title,
    this.subtitle,
    required this.showTitle,
    required this.showSubtitle,
    required this.showRetryButton,
    required this.showLoading,
    this.loadingWidget,
    this.onRetry,
    required this.fit,
  });

  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String? assetImage;
  final String? title;
  final String? subtitle;
  final bool showTitle;
  final bool showSubtitle;
  final bool showRetryButton;
  final bool showLoading;
  final Widget? loadingWidget;
  final VoidCallback? onRetry;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (showLoading) {
      return Center(
        child:
            loadingWidget ??
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (assetImage != null)
          Flexible(
            child: Image.asset(
              assetImage!,
              fit: fit,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(icon, size: iconSize, color: iconColor),
            ),
          )
        else
          Icon(icon, size: iconSize, color: iconColor),
        if (showTitle && title != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (showSubtitle && subtitle != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
        if (showRetryButton && onRetry != null) ...[
          const SizedBox(height: AppSpacing.md),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}
