import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// A collection of action buttons for the SliverAppBar.
class SliverAppBarActions extends StatelessWidget {
  const SliverAppBarActions({
    super.key,
    this.showSearch = false,
    this.showNotification = false,
    this.onSearchTap,
    this.onNotificationTap,
    this.customActions,
  });

  final bool showSearch;
  final bool showNotification;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final List<Widget>? customActions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...?customActions,
        if (showSearch)
          SliverActionButton(
            icon: Icons.search_rounded,
            tooltip: 'Search',
            onTap: onSearchTap ?? () {},
          ),
        if (showNotification)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SliverActionButton(
                  icon: Icons.notifications_rounded,
                  tooltip: 'Notifications',
                  onTap: onNotificationTap ?? () {},
                ),
                Positioned(
                  right: AppSpacing.sm,
                  top: AppSpacing.sm,
                  child: Container(
                    width: AppSpacing.sm,
                    height: AppSpacing.sm,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A circular glass-style action button for the SliverAppBar.
class SliverActionButton extends StatelessWidget {
  const SliverActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Tooltip(
        message: tooltip ?? '',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: onTap,
            child: Ink(
              width: AppSizes.minTapTarget,
              height: AppSizes.minTapTarget,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: Colors.white.withValues(alpha: .15)),
              ),
              child: Center(child: _SliverActionButtonIcon(icon: icon)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverActionButtonIcon extends StatelessWidget {
  const _SliverActionButtonIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: Colors.white, size: AppSizes.iconMd);
  }
}
