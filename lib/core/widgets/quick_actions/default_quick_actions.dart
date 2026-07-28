import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_strings.dart';
import '../../../router.dart';
import 'quick_action_tile.dart';

/// Bundles the callback contract the [CustomBottomNavigation] needs in
/// order to render both a notification button and a quick-actions
/// trigger, while keeping the widget itself dependency-free from
/// router / strings.
class BottomBarCallbacks {
  const BottomBarCallbacks({
    required this.onNotificationTap,
    required this.onQuickActions,
    this.openRoute,
  });

  final VoidCallback onNotificationTap;
  final VoidCallback onQuickActions;

  /// Optional helper that resolves a route name to a navigation call.
  /// Lives on this helper so consumers can plug in their own router
  /// without forcing [CustomBottomNavigation] to import `go_router`.
  final void Function(String routeName)? openRoute;
}

/// Default factory that resolves a fresh list of [QuickActionItem]s
/// every time the user opens the sheet — counting how many notifications
/// are pending in the process so badges stay accurate.
///
/// The [router] argument accepts a route name (any `AppRoutes.*` value)
/// and uses the supplied [BottomBarCallbacks.openRoute] to navigate.
List<QuickActionItem> defaultQuickActions({
  int unreadNotifications = 0,
  required BottomBarCallbacks callbacks,
  void Function(String routeName)? navigate,
}) {
  void Function(String) nav = navigate ?? callbacks.openRoute ?? (_) {};

  return <QuickActionItem>[
    QuickActionItem(
      id: 'continue_learning',
      label: AppStrings.continueLearning,
      icon: AppIcons.play,
      onTap: () {
        nav(AppRoutes.review);
      },
    ),
    QuickActionItem(
      id: 'daily_quiz',
      label: AppStrings.dailyQuiz,
      icon: Icons.quiz_rounded,
      onTap: () {
        nav(AppRoutes.quizOverview);
      },
    ),
    QuickActionItem(
      id: 'mock_test',
      label: AppStrings.mockTest,
      icon: Icons.assignment_rounded,
      onTap: () {
        nav(AppRoutes.quizOverview);
      },
    ),
    QuickActionItem(
      id: 'guidebook',
      label: AppStrings.quickActionGuidebook,
      icon: AppIcons.book,
      onTap: () {
        nav(AppRoutes.lessons);
      },
    ),
    QuickActionItem(
      id: 'ai_tutor',
      label: AppStrings.aiTutor,
      icon: AppIcons.sparkle,
      onTap: () {
        nav(AppRoutes.aiTutor);
      },
    ),
    QuickActionItem(
      id: 'bookmarks',
      label: AppStrings.bookmarks,
      icon: AppIcons.bookmark,
      onTap: () {
        nav(AppRoutes.bookmarks);
      },
    ),
    QuickActionItem(
      id: 'notes',
      label: AppStrings.notesTitle,
      icon: AppIcons.notes,
      onTap: () {
        nav(AppRoutes.notes);
      },
    ),
    QuickActionItem(
      id: 'weak_topics',
      label: AppStrings.weakTopics,
      icon: AppIcons.target,
      onTap: () {
        nav(AppRoutes.quizWeakTopics);
      },
    ),
    QuickActionItem(
      id: 'leaderboard',
      label: AppStrings.leaderboard,
      icon: AppIcons.trophy,
      onTap: () {
        nav(AppRoutes.leaderboard);
      },
    ),
    QuickActionItem(
      id: 'notifications',
      label: AppStrings.notifications,
      icon: AppIcons.notification,
      badgeCount: unreadNotifications,
      onTap: callbacks.onNotificationTap,
    ),
    QuickActionItem(
      id: 'profile',
      label: AppStrings.profile,
      icon: AppIcons.profile,
      onTap: () {
        nav(AppRoutes.profile);
      },
    ),
    QuickActionItem(
      id: 'settings',
      label: AppStrings.settings,
      icon: AppIcons.settings,
      onTap: () {
        nav(AppRoutes.profile);
      },
    ),
    QuickActionItem(
      id: 'streak',
      label: 'Streak',
      icon: AppIcons.streak,
      onTap: () {
        nav(AppRoutes.streak);
      },
    ),
    QuickActionItem(
      id: 'missions',
      label: 'Missions',
      icon: AppIcons.mission,
      onTap: () {
        nav(AppRoutes.missions);
      },
    ),
    QuickActionItem(
      id: 'search',
      label: AppStrings.search,
      icon: AppIcons.search,
      onTap: () {
        nav(AppRoutes.search);
      },
    ),
    QuickActionItem(
      id: 'rewards',
      label: 'Rewards',
      icon: AppIcons.gem,
      onTap: () {
        nav(AppRoutes.rewards);
      },
    ),
  ];
}
