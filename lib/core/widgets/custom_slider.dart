import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

// Reusable slider widget for settings, filters, quizzes and forms.
class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showValue = true,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.borderRadius = AppRadius.lg,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.valueFormatter,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;

  final ValueChanged<double>? onChanged;

  final String? title;
  final String? subtitle;

  final Widget? leading;
  final Widget? trailing;

  final bool showValue;
  final bool enabled;

  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;

  final double borderRadius;

  final EdgeInsetsGeometry padding;

  final String Function(double value)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final formattedValue = valueFormatter != null
        ? valueFormatter!(value)
        : value.toStringAsFixed(0);

    return Card(
      elevation: 0,
      color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || trailing != null)
              Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  if (title != null)
                    Expanded(
                      child: Text(title!, style: theme.textTheme.titleMedium),
                    ),
                  if (showValue)
                    Text(
                      formattedValue,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: activeColor ?? AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    trailing!,
                  ],
                ],
              ),

            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle!, style: theme.textTheme.bodySmall),
            ],

            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: activeColor ?? AppColors.primary,
                inactiveTrackColor:
                    inactiveColor ?? theme.colorScheme.outlineVariant,
                thumbColor: activeColor ?? AppColors.primary,
                overlayColor: (activeColor ?? AppColors.primary).withValues(
                  alpha: .15,
                ),
                valueIndicatorColor: activeColor ?? AppColors.primary,
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: divisions,
                label: showValue ? formattedValue : null,
                onChanged: enabled ? onChanged : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
