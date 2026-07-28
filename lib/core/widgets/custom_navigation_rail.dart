import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';

// Model representing a single navigation rail destination.
class CustomNavigationRailDestination {
  const CustomNavigationRailDestination({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.badge,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final String? badge;
  final bool enabled;
}

// Reusable navigation rail for tablet and desktop layouts.
class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = false,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.minWidth = 72,
    this.extendedWidth = 240,
    this.groupAlignment = -1,
  });

  final List<CustomNavigationRailDestination> destinations;

  final int selectedIndex;

  final ValueChanged<int> onDestinationSelected;

  final bool extended;

  final Widget? leading;

  final Widget? trailing;

  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  final double minWidth;
  final double extendedWidth;
  final double groupAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selected = selectedColor ?? AppColors.primary;

    final unselected = unselectedColor ?? theme.colorScheme.onSurfaceVariant;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: extended ? extendedWidth : minWidth,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: NavigationRail(
        extended: extended,
        selectedIndex: selectedIndex,
        minWidth: minWidth,
        scrollable: true,
        minExtendedWidth: extendedWidth,
        groupAlignment: groupAlignment,
        backgroundColor: Colors.transparent,
        leading: leading,
        trailing: trailing,
        selectedIconTheme: IconThemeData(
          color: selected,
          size: AppSizes.iconMd,
        ),
        unselectedIconTheme: IconThemeData(
          color: unselected,
          size: AppSizes.iconMd,
        ),
        selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
          color: selected,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
          color: unselected,
        ),
        onDestinationSelected: onDestinationSelected,
        destinations: destinations.asMap().entries.map((entry) {
          final item = entry.value;

          return NavigationRailDestination(
            disabled: item.enabled == false,
            icon: _NavigationIcon(icon: item.icon, badge: item.badge),
            selectedIcon: _NavigationIcon(
              icon: item.selectedIcon ?? item.icon,
              badge: item.badge,
            ),
            label: Text(item.label),
          );
        }).toList(),
      ),
    );
  }
}

// Navigation icon with optional badge.
class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon({required this.icon, this.badge});

  final IconData icon;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    if (badge == null) {
      return Icon(icon);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        Positioned(
          right: -8,
          top: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              badge!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
