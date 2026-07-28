import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

// Reusable animated radio button for forms, quizzes, and settings.
class CustomRadio<T> extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
    this.inactiveColor,
    this.textColor,
    this.enabled = true,
    this.showBackground = true,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    this.contentSpacing = AppSpacing.md,
    this.radioSize = 22,
    this.borderRadius = AppRadius.lg,
    this.trailing,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  final String? title;
  final String? subtitle;

  final Color? activeColor;
  final Color? inactiveColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  final bool enabled;
  final bool showBackground;

  final double radioSize;
  final double borderRadius;
  final double contentSpacing;

  final EdgeInsetsGeometry padding;

  final Widget? trailing;

  bool get selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color active = activeColor ?? AppColors.primary;
    final Color inactive = inactiveColor ?? theme.colorScheme.outline;

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: enabled ? () => onChanged?.call(value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: padding,
        decoration: BoxDecoration(
          color: showBackground
              ? (selected
                    ? active.withValues(alpha: .08)
                    : backgroundColor ??
                          theme.colorScheme.surfaceContainerHighest)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: selected
                ? active
                : borderColor ?? theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: radioSize,
              height: radioSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: selected ? active : inactive,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: selected
                    ? Center(
                        key: const ValueKey('selected'),
                        child: Container(
                          width: radioSize * .45,
                          height: radioSize * .45,
                          decoration: BoxDecoration(
                            color: active,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : const SizedBox(key: ValueKey('unselected')),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(subtitle!, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.md),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
