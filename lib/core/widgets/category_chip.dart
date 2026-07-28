import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

// Reusable category chip used throughout the application.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    this.onTap,
    this.selected = false,
    this.enabled = true,
    this.filled = true,
    this.leading,
    this.trailing,
    this.count,
    this.backgroundColor,
    this.selectedColor,
    this.borderColor,
    this.textColor,
    this.selectedTextColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    ),
    this.borderRadius = AppRadius.pill,
  });

  final String label;

  final VoidCallback? onTap;

  final bool selected;
  final bool enabled;
  final bool filled;

  final Widget? leading;
  final Widget? trailing;

  final int? count;

  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? selectedTextColor;

  final EdgeInsetsGeometry padding;

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool clickable = enabled && onTap != null;

    final Color fillColor = selected
        ? (selectedColor ?? AppColors.primary)
        : filled
        ? (backgroundColor ?? theme.colorScheme.surfaceContainerHighest)
        : Colors.transparent;

    final Color foregroundColor = selected
        ? (selectedTextColor ?? Colors.white)
        : (textColor ?? theme.colorScheme.onSurface);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: clickable ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: padding,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: selected
                  ? (selectedColor ?? AppColors.primary)
                  : (borderColor ?? theme.colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ],

              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (count != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: .2)
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    count.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],

              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
