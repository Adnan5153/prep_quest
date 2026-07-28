import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import 'settings_tile.dart';

/// Settings row that pushes a new screen when tapped. Visualised with
/// a chevron and an optional [valueLabel] (e.g. "English", "System").
class SettingsNavigationTile extends StatelessWidget {
  const SettingsNavigationTile({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.valueLabel,
    this.leading,
    this.leadingIcon,
    this.leadingColor,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final String? valueLabel;
  final Widget? leading;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget? resolvedLeading = leading ??
        (leadingIcon != null
            ? _IconBubble(icon: leadingIcon!, color: leadingColor)
            : null);

    return SettingsTile(
      title: title,
      subtitle: subtitle,
      leading: resolvedLeading,
      enabled: enabled,
      onTap: enabled ? onTap : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (valueLabel != null) ...<Widget>[
            Flexible(
              child: Text(
                valueLabel!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.65),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Icon(
            Icons.chevron_right_rounded,
            size: AppSizes.iconMd,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, this.color});

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color tint = color ?? colors.primary;
    return Container(
      width: AppSizes.iconLg,
      height: AppSizes.iconLg,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: tint, size: AppSizes.iconMd),
    );
  }
}