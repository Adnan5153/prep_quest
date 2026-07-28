import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import 'settings_tile.dart';

/// Settings row whose trailing slot is a [Switch]. Optional [subtitle]
/// is shown beneath the title.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      enabled: enabled,
      onTap: enabled && onChanged != null
          ? () => onChanged?.call(!value)
          : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeThumbColor: colors.primary,
      ),
    );
  }
}

/// Tile that uses an iOS-style checkbox instead of a switch. Useful for
/// dense lists where a [Switch] feels too heavy.
class SettingsCheckboxTile extends StatelessWidget {
  const SettingsCheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      enabled: enabled,
      onTap: enabled && onChanged != null
          ? () => onChanged?.call(!value)
          : null,
      trailing: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: AppSizes.iconMd,
        height: AppSizes.iconMd,
        decoration: BoxDecoration(
          color: value ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: value
                ? colors.primary
                : colors.outline.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: value
            ? const Icon(Icons.check, size: AppSizes.iconSm, color: Colors.white)
            : null,
      ),
    );
  }
}