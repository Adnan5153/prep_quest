import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

// Represents a single drawer menu item.
class DrawerMenuItem {
  const DrawerMenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.selected = false,
    this.trailing,
    this.badge,
    this.enabled = true,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? trailing;
  final String? badge;
  final bool enabled;
}

// Reusable application drawer.
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.items,
    this.userName = 'Guest User',
    this.userEmail = 'guest@example.com',
    this.headerIcon = Icons.person,
    this.headerBackgroundColor,
    this.showHeader = true,
    this.showFooter = true,
    this.footerText = 'PrepQuest',
    this.footerIcon = Icons.school,
    this.width = 300,
  });

  final List<DrawerMenuItem> items;

  final String userName;
  final String userEmail;

  final IconData headerIcon;

  final bool showHeader;
  final bool showFooter;

  final String footerText;
  final IconData footerIcon;

  final double width;

  final Color? headerBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      width: width,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (showHeader)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: headerBackgroundColor ?? AppColors.primary,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,
                      child: Icon(
                        headerIcon,
                        color: AppColors.primary,
                        size: AppSizes.iconLg,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      userName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      userEmail,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: _DrawerTile(item: item),
                  );
                },
              ),
            ),
            if (showFooter)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      footerIcon,
                      size: AppSizes.iconSm,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(footerText, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Individual drawer tile.
class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.item});

  final DrawerMenuItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedColor = AppColors.primary;

    return Material(
      color: item.selected
          ? selectedColor.withValues(alpha: .12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: item.enabled ? item.onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: item.selected
                    ? selectedColor
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: item.selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: item.selected ? selectedColor : null,
                  ),
                ),
              ),
              if (item.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    item.badge!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              if (item.trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                item.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
