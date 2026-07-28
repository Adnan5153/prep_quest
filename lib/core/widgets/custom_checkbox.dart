import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

// Reusable animated checkbox widget used throughout the application.
class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.enabled = true,
    this.showBorder = true,
    this.showBackground = true,
    this.isError = false,
    this.checkboxFirst = true,
    this.size = AppSizes.iconMd,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.backgroundColor,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  final String? title;
  final String? subtitle;

  final bool enabled;
  final bool showBorder;
  final bool showBackground;
  final bool isError;
  final bool checkboxFirst;

  final double size;

  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final Color? backgroundColor;

  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool clickable = enabled && onChanged != null;

    final Widget checkbox = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value
            ? (activeColor ?? AppColors.primary)
            : (showBackground
                  ? backgroundColor ?? theme.colorScheme.surfaceContainerHighest
                  : Colors.transparent),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: showBorder
            ? Border.all(
                color: isError
                    ? AppColors.error
                    : value
                    ? (activeColor ?? AppColors.primary)
                    : borderColor ?? theme.colorScheme.outline,
              )
            : null,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: value
            ? Icon(
                Icons.check,
                key: const ValueKey(true),
                size: size * .70,
                color: checkColor ?? Colors.white,
              )
            : const SizedBox.shrink(key: ValueKey(false)),
      ),
    );

    final Widget textSection = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) Text(title!, style: theme.textTheme.bodyLarge),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(subtitle!, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: clickable ? () => onChanged!(!value) : null,
      child: Padding(
        padding: contentPadding,
        child: Row(
          children: checkboxFirst
              ? [checkbox, const SizedBox(width: AppSpacing.md), textSection]
              : [textSection, const SizedBox(width: AppSpacing.md), checkbox],
        ),
      ),
    );
  }
}
