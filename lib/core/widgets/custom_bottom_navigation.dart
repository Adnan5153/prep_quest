import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../../router.dart';
import 'notification_badge.dart';
import 'quick_actions/default_quick_actions.dart';
import 'quick_actions/quick_action_tile.dart';
import 'quick_actions/quick_actions_sheet.dart';

/// Reusable bottom navigation bar used throughout the application.
///
/// The classic behaviour (current index, [items] list, [onTap] callback)
/// is preserved verbatim. Optional [notificationBadgeCount],
/// [onNotificationTap], [onQuickActions], and [quickActionsBuilder]
/// extend the bar with a leading bell icon and a trailing quick-actions
/// launcher without breaking existing call sites.
class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.notificationBadgeCount = 0,
    this.onNotificationTap,
    this.onQuickActions,
    this.quickActionsBuilder,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  /// Unread notifications to surface on the bell badge.
  final int notificationBadgeCount;

  /// Tap handler for the notification bell.
  final VoidCallback? onNotificationTap;

  /// Tap handler for the quick-actions button. If both
  /// [onQuickActions] and [quickActionsBuilder] are provided, the builder
  /// wins — letting callers render a custom sheet (e.g. analytics-driven).
  final VoidCallback? onQuickActions;

  /// Optional callback to fully replace the default sheet contents.
  /// Receives the BuildContext and is expected to invoke [QuickActionsSheet.show]
  /// (or any other navigation surface) directly.
  final void Function(BuildContext context)? quickActionsBuilder;

  bool get _hasNotificationButton => onNotificationTap != null;
  bool get _hasQuickActionsButton =>
      onQuickActions != null || quickActionsBuilder != null;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        height: AppSizes.bottomNavHeight,
        margin: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: AppSpacing.lg,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Row(
            children: <Widget>[
              if (_hasNotificationButton)
                _SideButton(
                  tooltip: AppStrings.notificationTooltip,
                  onTap: onNotificationTap,
                  icon: AppIcons.notification,
                  badgeCount: notificationBadgeCount,
                ),
              Expanded(
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: onTap,
                  items: items,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor:
                      theme.colorScheme.onSurfaceVariant,
                  selectedIconTheme: const IconThemeData(
                    size: AppSizes.iconMd,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    size: AppSizes.iconMd,
                  ),
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  showUnselectedLabels: true,
                ),
              ),
              if (_hasQuickActionsButton)
                _SideButton(
                  tooltip: AppStrings.quickActionsTooltip,
                  onTap: () {
                    if (quickActionsBuilder != null) {
                      quickActionsBuilder!(context);
                      return;
                    }
                    onQuickActions?.call();
                  },
                  icon: Icons.bolt_rounded,
                  badgeCount: 0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable side-pill button shown on either edge of the bottom bar.
class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.tooltip,
    required this.onTap,
    required this.icon,
    required this.badgeCount,
  });

  final String tooltip;
  final VoidCallback? onTap;
  final IconData icon;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Tooltip(
        message: tooltip,
        child: InkResponse(
          onTap: onTap,
          radius: AppSizes.minTapTarget / 2,
          child: SizedBox(
            width: AppSizes.minTapTarget,
            height: AppSizes.minTapTarget,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: AppSizes.iconMd,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: NotificationBadge(count: badgeCount),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper entry-point that bundles the quick-actions sheet invocation
/// using the default action catalog. Consumers wire this directly to
/// [CustomBottomNavigation.quickActionsBuilder].
void openDefaultQuickActionsSheet(
  BuildContext context, {
  int unreadNotifications = 0,
  BottomBarCallbacks? callbacks,
  void Function(String routeName)? navigate,
}) {
  final BottomBarCallbacks resolved =
      callbacks ?? BottomBarCallbacks(onNotificationTap: () {}, onQuickActions: () {});
  final List<QuickActionItem> actions = defaultQuickActions(
    unreadNotifications: unreadNotifications,
    callbacks: resolved,
    navigate: navigate,
  );
  QuickActionsSheet.show(
    context,
    actions: actions,
    title: AppStrings.quickActions,
    subtitle: AppStrings.quickActionsSubtitle,
  );
}

/// The four canonical bottom-nav tabs used throughout the app.
///
/// Sharing this list (instead of inlining it per screen) is what keeps
/// the bar visually and behaviorally identical wherever it appears.
const List<BottomNavigationBarItem> kDefaultBottomNavItems =
    <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.explore_outlined),
    activeIcon: Icon(Icons.explore),
    label: 'Play',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.menu_book_outlined),
    activeIcon: Icon(Icons.menu_book),
    label: 'Learn',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.quiz_outlined),
    activeIcon: Icon(Icons.quiz),
    label: 'Quiz',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline),
    activeIcon: Icon(Icons.person),
    label: 'Profile',
  ),
];

/// Canonical navigation policy for [kDefaultBottomNavItems].
///
/// Centralised so that every screen wired to the bottom nav sends the
/// same tap to the same destination. Pass [currentIndex] to avoid
/// re-navigating to the route the caller already sits on.
void onDefaultBottomNavTap(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.goNamed(AppRoutes.playground);
      return;
    case 1:
      context.goNamed(AppRoutes.lessons);
      return;
    case 2:
      context.goNamed(AppRoutes.quizOverview);
      return;
    case 3:
      context.goNamed(AppRoutes.profile);
      return;
  }
}
