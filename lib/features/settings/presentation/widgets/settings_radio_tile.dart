import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';

/// Single-select radio tile. Wraps [SettingsRadioTile] style rows so
/// the user can choose between mutually exclusive options (e.g. theme
/// mode, language).
class SettingsRadioTile<T> extends StatelessWidget {
  const SettingsRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.subtitle,
    this.leadingIcon,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final T value;
  final T? groupValue;
  final IconData? leadingIcon;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool selected = _isSelected;
    final ColorScheme colors = theme.colorScheme;

    return Material(
      color: selected
          ? colors.primary.withValues(alpha: 0.06)
          : Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => onChanged?.call(value) : null,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (leadingIcon != null) ...<Widget>[
                Icon(
                  leadingIcon,
                  color: selected ? colors.primary : AppColors.lightMuted,
                  size: AppSizes.iconMd,
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w600,
                        color: enabled
                            ? theme.colorScheme.onSurface
                            : AppColors.lightMuted,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.lightMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? colors.primary
                        : colors.outline.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: AppSizes.iconSm - 4,
                  height: AppSizes.iconSm - 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selected ? colors.primary : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}