import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';

/// Wraps a group of related tiles (e.g. "Account", "Notifications")
/// inside a single glass card. Provides an optional title and inset
/// dividers between tiles.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    ),
    this.showDividers = false,
  });

  final List<Widget> children;
  final String? title;
  final String? subtitle;
  final EdgeInsetsGeometry padding;
  final bool showDividers;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                title!,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
          GlassCard(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildChildrenWithDividers(context),
              ),
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
              ),
              child: Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildChildrenWithDividers(BuildContext context) {
    if (!showDividers || children.isEmpty) return children;
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i != children.length - 1) {
        result.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
            color:
                Theme.of(context).dividerColor.withValues(alpha: 0.4),
          ),
        );
      }
    }
    return result;
  }
}