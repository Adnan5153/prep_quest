import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

/// A production-ready responsive section header widget.
///
/// Displays a [title], optional [subtitle], and one or more [actions].
/// This is the standard section header used throughout the application.
class TitleWithAction extends StatelessWidget {
  const TitleWithAction({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions,
    this.actionText,
    this.actionIcon,
    this.onActionPressed,
    this.titleStyle,
    this.subtitleStyle,
    this.actionStyle,
    this.alignment = Alignment.centerLeft,
    this.padding,
    this.margin,
    this.spacing = AppSpacing.sm,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.showDivider = false,
    this.dividerColor,
    this.dividerThickness = 1.0,
    this.backgroundColor,
    this.borderRadius,
    this.maxLines = 1,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget>? actions;
  final String? actionText;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final ButtonStyle? actionStyle;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final bool showDivider;
  final Color? dividerColor;
  final double dividerThickness;
  final Color? backgroundColor;
  final double? borderRadius;
  final int maxLines;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.xs),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isNarrow = constraints.maxWidth < 240;

          if (isNarrow) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      SizedBox(width: spacing),
                    ],
                    Expanded(child: _buildTitleSection(theme, isDark)),
                  ],
                ),
                if (actions != null ||
                    actionText != null ||
                    actionIcon != null ||
                    trailing != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _buildActions(theme),
                ],
                if (showDivider) ...[
                  const SizedBox(height: AppSpacing.md),
                  Divider(
                    height: 0,
                    thickness: dividerThickness,
                    color: dividerColor ?? theme.dividerColor,
                  ),
                ],
              ],
            );
          }

          Widget header = Row(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              if (leading != null) ...[leading!, SizedBox(width: spacing)],
              Expanded(child: _buildTitleSection(theme, isDark)),
              if (actions != null ||
                  actionText != null ||
                  actionIcon != null ||
                  trailing != null) ...[
                SizedBox(width: spacing),
                _buildActions(theme),
              ],
            ],
          );

          if (showDivider) {
            header = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                const SizedBox(height: AppSpacing.md),
                Divider(
                  height: 0,
                  thickness: dividerThickness,
                  color: dividerColor ?? theme.dividerColor,
                ),
              ],
            );
          }

          return header;
        },
      ),
    );
  }

  Widget _buildTitleSection(ThemeData theme, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: semanticLabel ?? title,
          style:
              titleStyle ??
              theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            subtitle!,
            maxLines: maxLines + 1,
            overflow: TextOverflow.ellipsis,
            style:
                subtitleStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions(ThemeData theme) {
    if (trailing != null) return trailing!;

    if (actions != null) {
      return Row(mainAxisSize: MainAxisSize.min, children: actions!);
    }

    if (actionIcon != null && actionText == null) {
      return IconButton(
        onPressed: onActionPressed,
        icon: Icon(actionIcon),
        style: actionStyle,
        color: theme.colorScheme.primary,
        iconSize: AppSizes.iconMd,
      );
    }

    if (actionText != null) {
      return TextButton(
        onPressed: onActionPressed,
        style: actionStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(actionText!),
            if (actionIcon != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(actionIcon, size: 16),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
