import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';

enum NodeLabelPlacement { below, above }

enum NodeLabelEmphasis { normal, strong, subtle }

class NodeLabel extends StatelessWidget {
  const NodeLabel({
    super.key,
    required this.title,
    this.subtitle,
    this.placement = NodeLabelPlacement.below,
    this.emphasis = NodeLabelEmphasis.normal,
    this.maxWidth = PlaygroundSizes.nodeLabelMaxWidth,
    this.isVisible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final NodeLabelPlacement placement;
  final NodeLabelEmphasis emphasis;
  final double maxWidth;
  final bool isVisible;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveMaxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: maxWidth,
      tablet: maxWidth + 24,
      desktop: maxWidth + 48,
    );

    final titleFontSize = ResponsiveBuilder.value<double>(
      context,
      mobile: 12,
      tablet: 13,
      desktop: 14,
    );

    final bg =
        backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final fg =
        foregroundColor ??
        (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface);

    final double bottomOffset =
        PlaygroundSizes.nodeLabelGap +
        (subtitle != null && subtitle!.isNotEmpty ? 36 : 22);

    return SizedBox(
      width: 0,
      height: 0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: -bottomOffset,
            child: AnimatedSize(
              duration: PlaygroundDurations.labelFade,
              curve: PlaygroundCurves.stateEase,
              child: Center(
                child: Semantics(
                  label: semanticLabel ?? title,
                  container: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
                    child: Container(
                      padding: PlaygroundSizes.nodeLabelPadding,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: fg.withValues(alpha: 0.12),
                          width: WidgetConstants.outlineThickness,
                        ),
                        boxShadow: emphasis == NodeLabelEmphasis.strong
                            ? const [
                                BoxShadow(
                                  color: AppColors.darkBackground,
                                  blurRadius: PlaygroundSizes.nodeShadowBlur,
                                  offset: PlaygroundSizes.nodeShadowOffset,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title.isEmpty
                                ? PlaygroundStrings.nodeLabelFallback
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
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: _resolveSubtitleStyle(
                                  theme: theme,
                                  fg: fg,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _resolveTitleStyle({
    required ThemeData theme,
    required Color fg,
    required NodeLabelEmphasis emphasis,
    required double fontSize,
  }) {
    final base =
        theme.textTheme.labelMedium ??
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    switch (emphasis) {
      case NodeLabelEmphasis.normal:
        return base.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        );
      case NodeLabelEmphasis.strong:
        return base.copyWith(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: fontSize + 1,
        );
      case NodeLabelEmphasis.subtle:
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
