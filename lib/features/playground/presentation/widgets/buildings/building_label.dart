import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';

enum BuildingLabelPlacement { below, above }

enum BuildingLabelEmphasis { normal, strong, subtle }

class BuildingLabel extends StatelessWidget {
  const BuildingLabel({
    super.key,
    required this.title,
    this.subtitle,
    this.placement = BuildingLabelPlacement.below,
    this.emphasis = BuildingLabelEmphasis.normal,
    this.maxWidth = PlaygroundSizes.buildingLabelMaxWidth,
    this.isVisible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.accentColor,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final BuildingLabelPlacement placement;
  final BuildingLabelEmphasis emphasis;
  final double maxWidth;
  final bool isVisible;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? accentColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveMaxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: maxWidth,
      tablet: maxWidth + AppSpacing.md,
      desktop: maxWidth + AppSpacing.xxl,
    );

    final titleFontSize = ResponsiveBuilder.value<double>(
      context,
      mobile: AppSizes.iconSm - 4,
      tablet: AppSizes.iconSm - 2,
      desktop: AppSizes.iconSm,
    );

    final bg =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final fg =
        foregroundColor ??
        (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface);
    final accent = accentColor ?? AppColors.primary;

    final double verticalOffset =
        PlaygroundSizes.buildingLabelGap +
        (subtitle != null && subtitle!.isNotEmpty
            ? AppSpacing.xxl
            : AppSpacing.lg);

    final Positioned positioned = placement == BuildingLabelPlacement.below
        ? Positioned(
            left: 0,
            right: 0,
            bottom: -verticalOffset,
            child: _buildContent(
              context: context,
              theme: theme,
              bg: bg,
              fg: fg,
              accent: accent,
              effectiveMaxWidth: effectiveMaxWidth,
              titleFontSize: titleFontSize,
            ),
          )
        : Positioned(
            left: 0,
            right: 0,
            top: -verticalOffset,
            child: _buildContent(
              context: context,
              theme: theme,
              bg: bg,
              fg: fg,
              accent: accent,
              effectiveMaxWidth: effectiveMaxWidth,
              titleFontSize: titleFontSize,
            ),
          );

    return SizedBox(
      width: 0,
      height: 0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [positioned],
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required ThemeData theme,
    required Color bg,
    required Color fg,
    required Color accent,
    required double effectiveMaxWidth,
    required double titleFontSize,
  }) {
    return Center(
      child: Semantics(
        label: semanticLabel ?? title,
        container: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
          child: Container(
            padding: PlaygroundSizes.buildingLabelPadding,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: accent.withValues(alpha: 0.25),
                width: WidgetConstants.outlineThickness,
              ),
              boxShadow: emphasis == BuildingLabelEmphasis.strong
                  ? [
                      BoxShadow(
                        color: AppColors.darkBackground.withValues(alpha: 0.45),
                        blurRadius: PlaygroundSizes.buildingShadowBlur,
                        offset: PlaygroundSizes.buildingShadowOffset,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.isEmpty
                      ? PlaygroundStrings.buildingLabelFallback
                      : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: _resolveTitleStyle(
                    theme: theme,
                    fg: fg,
                    emphasis: emphasis,
                    fontSize: titleFontSize,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: _resolveSubtitleStyle(theme: theme, fg: fg),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _resolveTitleStyle({
    required ThemeData theme,
    required Color fg,
    required BuildingLabelEmphasis emphasis,
    required double fontSize,
  }) {
    final base =
        theme.textTheme.labelLarge ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    switch (emphasis) {
      case BuildingLabelEmphasis.normal:
        return base.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        );
      case BuildingLabelEmphasis.strong:
        return base.copyWith(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: fontSize + 1,
        );
      case BuildingLabelEmphasis.subtle:
        return base.copyWith(
          color: fg.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
          fontSize: fontSize - 1,
        );
    }
  }

  TextStyle _resolveSubtitleStyle({
    required ThemeData theme,
    required Color fg,
  }) {
    final base =
        theme.textTheme.labelSmall ??
        const TextStyle(fontSize: 10, fontWeight: FontWeight.w500);
    return base.copyWith(
      color: fg.withValues(alpha: 0.7),
      fontWeight: FontWeight.w500,
    );
  }
}
