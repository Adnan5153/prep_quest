import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_strings.dart';
import 'features/authentication/presentation/providers/auth_providers.dart';
import 'features/authentication/presentation/screens/complete_profile/complete_profile_screen.dart';
import 'features/authentication/presentation/screens/splash/splash_screen.dart';
import 'features/authentication/presentation/screens/welcome/welcome_screen.dart';
import 'features/authentication/presentation/states/auth_state.dart';
import 'features/lessons/presentation/screens/lesson_detail_screen.dart';
import 'features/lessons/presentation/screens/lesson_examples_screen.dart';
import 'features/lessons/presentation/screens/lesson_overview_screen.dart';
import 'features/lessons/presentation/screens/lesson_reader_screen.dart';
import 'features/lessons/presentation/screens/lesson_summary_screen.dart';
import 'features/playground/presentation/screens/playground_screen.dart';
import 'features/playground/presentation/screens/level_screen.dart';
import 'features/playground/presentation/screens/challenge_screen.dart';
import 'features/playground/presentation/screens/boss_challenge_screen.dart';
import 'features/playground/presentation/screens/level_completed_screen.dart';
import 'features/playground/presentation/screens/world_map_screen.dart';
import 'features/profile/presentation/screens/achievement_history_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/profile/presentation/screens/settings_entry_screen.dart';
import 'features/profile/presentation/screens/statistics_screen.dart';
import 'features/profile/presentation/screens/subscription_screen.dart';
import 'features/subscription/presentation/screens/plan_comparison_screen.dart';
import 'features/subscription/presentation/screens/purchase_flow_screen.dart';
import 'features/subscription/presentation/screens/restore_purchase_screen.dart';
import 'features/subscription/presentation/screens/subscription_plans_screen.dart';
import 'features/gamification/presentation/screens/badge_collection_screen.dart';
import 'features/gamification/presentation/screens/daily_missions_screen.dart';
import 'features/gamification/presentation/screens/daily_rewards_screen.dart';
import 'features/gamification/presentation/screens/missions_hub_screen.dart';
import 'features/gamification/presentation/screens/reward_chest_screen.dart';
import 'features/gamification/presentation/screens/reward_history_screen.dart';
import 'features/gamification/presentation/screens/rewards_hub_screen.dart';
import 'features/gamification/presentation/screens/streak_screen.dart';
import 'features/gamification/presentation/screens/streak_calendar_screen.dart';
import 'features/gamification/presentation/screens/streak_recovery_screen.dart';
import 'features/leaderboard/presentation/screens/leaderboard_detail_screen.dart';
import 'features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'features/notifications/presentation/screens/notification_screen.dart';
import 'features/search/presentation/screens/search_screen.dart';
import 'features/bookmarks/presentation/screens/bookmarks_screen.dart';
import 'features/bookmarks/presentation/screens/bookmark_detail_screen.dart';
import 'features/notes/presentation/screens/notes_screen.dart';
import 'features/notes/presentation/screens/create_note_screen.dart';
import 'features/notes/presentation/screens/edit_note_screen.dart';
import 'features/notes/presentation/screens/note_detail_screen.dart';
import 'features/offline/presentation/screens/downloaded_lessons_screen.dart';
import 'features/offline/presentation/screens/downloaded_questions_screen.dart';
import 'features/offline/presentation/screens/offline_downloads_screen.dart';
import 'features/offline/presentation/screens/offline_storage_screen.dart';
import 'features/offline/presentation/screens/offline_sync_screen.dart';
import 'features/quiz_engine/presentation/screens/quiz_overview_screen.dart';
import 'features/quiz_engine/presentation/screens/quiz_pause_screen.dart';
import 'features/quiz_engine/presentation/screens/quiz_review_screen.dart';
import 'features/quiz_engine/presentation/screens/quiz_screen.dart';
import 'features/quiz_results/presentation/screens/performance_breakdown_screen.dart';
import 'features/quiz_results/presentation/screens/quiz_results_screen.dart';
import 'features/quiz_results/presentation/screens/weak_topics_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_chat_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_explain_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_flashcards_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_hint_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_history_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_questions_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_simplify_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_study_plan_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_summary_screen.dart';
import 'features/ai_tutor/presentation/screens/ai_tutor_screen.dart';
import 'features/review/presentation/screens/review_detail_screen.dart';
import 'features/review/presentation/screens/review_screen.dart';
import 'features/settings/presentation/screens/about_screen.dart';
import 'features/settings/presentation/screens/accessibility_settings_screen.dart';
import 'features/settings/presentation/screens/language_settings_screen.dart';
import 'features/settings/presentation/screens/notification_settings_screen.dart';
import 'features/settings/presentation/screens/privacy_settings_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/settings/presentation/screens/theme_settings_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart'
    as phase_eighteen show StatisticsScreen;
import 'features/widget_builder/presentation/screens/widget_builder_screen.dart';

/// Top-level route names. Centralising them prevents string typos when
/// navigating from feature code.
abstract class AppRoutes {
  static const String root = '/';
  static const String widgetBuilder = '/widget-builder';
  static const String playground = '/playground';

  // Profile feature
  static const String profile = '/profile';

  // Gamification feature flows
  static const String rewards = '/rewards';
  static const String rewardsDaily = '/rewards/daily';
  static const String rewardsBadges = '/rewards/badges';
  static const String rewardsHistory = '/rewards/history';
  static const String rewardsChest = '/rewards/chest';
  static const String missions = '/missions';
  static const String missionsDaily = '/missions/daily';
  static const String missionsWeekly = '/missions/weekly';
  static const String missionsMonthly = '/missions/monthly';

  // Streak flows
  static const String streak = '/streak';
  static const String streakCalendar = '/streak/calendar';
  static const String streakRecovery = '/streak/recovery';

  // Leaderboard flows
  static const String leaderboard = '/leaderboard';
  static const String leaderboardDetail = '/leaderboard/:scope';

  // Notifications flow
  static const String notifications = '/notifications';

  // Global search
  static const String search = '/search';

  // Bookmarks hub
  static const String bookmarks = '/bookmarks';

  // Notes hub
  static const String notes = '/notes';
  static const String noteCreate = '/notes/create';
  static const String noteEdit = '/notes/edit';
  static const String noteDetail = '/notes/detail';

  // Playground feature flows
  static const String level = '/playground/level';
  static const String challenge = '/playground/challenge';
  static const String bossChallenge = '/playground/boss';
  static const String levelCompleted = '/playground/level-completed';
  static const String worldMap = '/playground/map';

  // Lessons feature flows
  static const String lessons = '/lessons';
  static const String lessonDetail = '/lessons/detail';
  static const String lessonReader = '/lessons/reader';
  static const String lessonExamples = '/lessons/examples';
  static const String lessonSummary = '/lessons/summary';

  // Quiz Engine flows
  static const String quizOverview = '/quiz/overview';
  static const String quizPlay = '/quiz/play';
  static const String quizReview = '/quiz/review';
  static const String quizResult = '/quiz/result';
  static const String quizPause = '/quiz/pause';

  // Quiz Results flows
  static const String quizWeakTopics = '/quiz/weak-topics';
  static const String quizPerformanceBreakdown = '/quiz/performance-breakdown';

  // Review flows
  static const String review = '/review';
  static const String reviewDetail = '/review/detail';

  // Statistics flow
  static const String statistics = '/statistics';

  // Settings hub + sub-routes
  static const String settings = '/settings';
  static const String settingsTheme = '/settings/theme';
  static const String settingsLanguage = '/settings/language';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsPrivacy = '/settings/privacy';
  static const String settingsAccessibility = '/settings/accessibility';
  static const String settingsAbout = '/settings/about';

  // Profile sub-routes
  static const String profileAchievements = '/profile/achievements';
  static const String profileStatistics = '/profile/statistics';
  static const String profileSubscription = '/profile/subscription';
  static const String profileSettings = '/profile/settings';

  // Subscription feature flows
  static const String subscriptionPlans = '/subscription';
  static const String subscriptionComparison = '/subscription/comparison';
  static const String subscriptionPurchase = '/subscription/purchase';
  static const String subscriptionRestore = '/subscription/restore';

  // AI Tutor flows
  static const String aiTutor = '/ai-tutor';
  static const String aiTutorHint = '/ai-tutor/hint';
  static const String aiTutorExplain = '/ai-tutor/explain';
  static const String aiTutorSimplify = '/ai-tutor/simplify';
  static const String aiTutorSummary = '/ai-tutor/summary';
  static const String aiTutorFlashcards = '/ai-tutor/flashcards';
  static const String aiTutorStudyPlan = '/ai-tutor/study-plan';
  static const String aiTutorQuestions = '/ai-tutor/questions';
  static const String aiTutorChat = '/ai-tutor/chat';
  static const String aiTutorHistory = '/ai-tutor/history';

  // Offline flows
  static const String offlineDownloads = '/offline/downloads';
  static const String offlineLessons = '/offline/lessons';
  static const String offlineQuestions = '/offline/questions';
  static const String offlineStorage = '/offline/storage';
  static const String offlineSync = '/offline/sync';

  // Authentication flow
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String completeProfile = '/complete-profile';
}

/// Paths that an unauthenticated visitor is allowed to access.
///
/// Collapsed to just the welcome screen — the rest of the auth flow
/// (login, register, phone OTP, email verification) has been
/// replaced by the single Google Sign-In CTA on
/// [AppRoutes.welcome].
const List<String> _unauthenticatedPaths = <String>[
  AppRoutes.welcome,
];

/// Builds the application's [GoRouter].
///
/// The router listens to [authRouterRefreshProvider] so every auth
/// state change re-runs the redirect logic and keeps the URL in sync
/// with the user's session.
GoRouter createAppRouter({ValueNotifier<int>? refreshListenable}) {
  final ValueNotifier<int> listenable =
      refreshListenable ?? ValueNotifier<int>(0);

  return GoRouter(
    initialLocation: AppRoutes.root,
    debugLogDiagnostics: false,
    refreshListenable: listenable,
    redirect: (BuildContext context, GoRouterState state) {
      final String path = state.uri.path;
      if (path.isEmpty) return AppRoutes.splash;

      // The splash screen drives the initial decision.
      if (path == AppRoutes.splash) return null;

      // We don't have the auth state in scope here (the router is a
      // plain provider-less builder), so consult the global hook the
      // controller maintains via [authRouterRefreshProvider]. The
      // provider is registered with the same `ValueNotifier` instance
      // returned below in `createAppRouter` so the router reacts to
      // every change.
      final AuthState auth = AuthRouterBridge.lastSeenState;

      if (auth.status == AuthStatus.unknown) {
        return AppRoutes.splash;
      }

      final bool isUnauthenticatedPath =
          _unauthenticatedPaths.contains(path);

      switch (auth.status) {
        case AuthStatus.unknown:
          return AppRoutes.splash;
        case AuthStatus.unauthenticated:
          if (!isUnauthenticatedPath) return AppRoutes.welcome;
          return null;
        case AuthStatus.profileIncomplete:
          if (path != AppRoutes.completeProfile) {
            return AppRoutes.completeProfile;
          }
          return null;
        case AuthStatus.emailVerificationRequired:
          // Defensive fallback — Google sign-in always returns a
          // verified email so this status is unreachable in practice,
          // but the redirect lands on the profile-completion screen
          // (which surfaces the verification UI as a banner if needed)
          // rather than spinning forever on a missing route.
          if (path != AppRoutes.completeProfile) {
            return AppRoutes.completeProfile;
          }
          return null;
        case AuthStatus.authenticated:
          if (isUnauthenticatedPath) {
            return AppRoutes.playground;
          }
          return null;
      }
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.root,
        redirect: (BuildContext context, GoRouterState state) =>
            AppRoutes.splash,
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        name: AppRoutes.welcome,
        builder: (BuildContext context, GoRouterState state) =>
            const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.completeProfile,
        name: AppRoutes.completeProfile,
        builder: (BuildContext context, GoRouterState state) =>
            const CompleteProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.widgetBuilder,
        name: AppRoutes.widgetBuilder,
        builder: (BuildContext context, GoRouterState state) {
          return const WidgetBuilderScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.playground,
        name: AppRoutes.playground,
        builder: (BuildContext context, GoRouterState state) {
          return const PlaygroundScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.worldMap,
        name: AppRoutes.worldMap,
        builder: (BuildContext context, GoRouterState state) {
          return const WorldMapScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.level,
        name: AppRoutes.level,
        redirect: (BuildContext context, GoRouterState state) {
          final String? nodeId = state.uri.queryParameters['nodeId'];
          return (nodeId == null || nodeId.isEmpty)
              ? AppRoutes.playground
              : null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final String nodeId = state.uri.queryParameters['nodeId'] ?? '';
          return LevelScreen(nodeId: nodeId);
        },
      ),
      GoRoute(
        path: AppRoutes.challenge,
        name: AppRoutes.challenge,
        redirect: (BuildContext context, GoRouterState state) {
          final String? nodeId = state.uri.queryParameters['nodeId'];
          return (nodeId == null || nodeId.isEmpty)
              ? AppRoutes.playground
              : null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final String nodeId = state.uri.queryParameters['nodeId'] ?? '';
          return ChallengeScreen(nodeId: nodeId);
        },
      ),
      GoRoute(
        path: AppRoutes.bossChallenge,
        name: AppRoutes.bossChallenge,
        redirect: (BuildContext context, GoRouterState state) {
          final String? nodeId = state.uri.queryParameters['nodeId'];
          return (nodeId == null || nodeId.isEmpty)
              ? AppRoutes.playground
              : null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final String nodeId = state.uri.queryParameters['nodeId'] ?? '';
          return BossChallengeScreen(nodeId: nodeId);
        },
      ),
      GoRoute(
        path: AppRoutes.levelCompleted,
        name: AppRoutes.levelCompleted,
        redirect: (BuildContext context, GoRouterState state) {
          final String? nodeId = state.uri.queryParameters['nodeId'];
          return (nodeId == null || nodeId.isEmpty)
              ? AppRoutes.playground
              : null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final String nodeId = state.uri.queryParameters['nodeId'] ?? '';
          return LevelCompletedScreen(nodeId: nodeId);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profile,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.profileAchievements,
        name: AppRoutes.profileAchievements,
        builder: (BuildContext context, GoRouterState state) {
          return const AchievementHistoryScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.profileStatistics,
        name: AppRoutes.profileStatistics,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileStatisticsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.profileSubscription,
        name: AppRoutes.profileSubscription,
        builder: (BuildContext context, GoRouterState state) {
          return const SubscriptionScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.profileSettings,
        name: AppRoutes.profileSettings,
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsEntryScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.rewards,
        name: AppRoutes.rewards,
        builder: (BuildContext context, GoRouterState state) {
          return const RewardsHubScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.rewardsDaily,
        name: AppRoutes.rewardsDaily,
        builder: (BuildContext context, GoRouterState state) {
          return const DailyRewardsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.rewardsBadges,
        name: AppRoutes.rewardsBadges,
        builder: (BuildContext context, GoRouterState state) {
          return const BadgeCollectionScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.rewardsHistory,
        name: AppRoutes.rewardsHistory,
        builder: (BuildContext context, GoRouterState state) {
          return const RewardHistoryScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.rewardsChest,
        name: AppRoutes.rewardsChest,
        builder: (BuildContext context, GoRouterState state) {
          return const RewardChestScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.missions,
        name: AppRoutes.missions,
        builder: (BuildContext context, GoRouterState state) {
          return const MissionsHubScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.missionsDaily,
        name: AppRoutes.missionsDaily,
        builder: (BuildContext context, GoRouterState state) {
          return const DailyMissionsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.missionsWeekly,
        name: AppRoutes.missionsWeekly,
        builder: (BuildContext context, GoRouterState state) {
          return const WeeklyMissionsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.missionsMonthly,
        name: AppRoutes.missionsMonthly,
        builder: (BuildContext context, GoRouterState state) {
          return const MonthlyMissionsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.streak,
        name: AppRoutes.streak,
        builder: (BuildContext context, GoRouterState state) {
          return const StreakScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.streakCalendar,
        name: AppRoutes.streakCalendar,
        builder: (BuildContext context, GoRouterState state) {
          return const StreakCalendarScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.streakRecovery,
        name: AppRoutes.streakRecovery,
        builder: (BuildContext context, GoRouterState state) {
          return const StreakRecoveryScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.leaderboard,
        name: AppRoutes.leaderboard,
        builder: (BuildContext context, GoRouterState state) {
          return const LeaderboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.leaderboardDetail,
        name: AppRoutes.leaderboardDetail,
        builder: (BuildContext context, GoRouterState state) {
          final String scope = state.pathParameters['scope'] ?? 'friends';
          return LeaderboardDetailScreen(scope: scope);
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRoutes.notifications,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.search,
        name: AppRoutes.search,
        builder: (BuildContext context, GoRouterState state) {
          return const SearchScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.bookmarks,
        name: AppRoutes.bookmarks,
        builder: (BuildContext context, GoRouterState state) {
          final String? route = state.uri.queryParameters['route'];
          if (route == null) return const BookmarksScreen();
          final Map<String, String> params = <String, String>{
            for (final MapEntry<String, String> e
                in state.uri.queryParameters.entries)
              if (e.key != 'route') e.key: e.value,
          };
          return BookmarkDetailScreen(
            forwardRoute: route,
            params: params,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notes,
        name: AppRoutes.notes,
        builder: (BuildContext context, GoRouterState state) =>
            const NotesScreen(),
      ),
      GoRoute(
        path: AppRoutes.noteCreate,
        name: AppRoutes.noteCreate,
        builder: (BuildContext context, GoRouterState state) =>
            const CreateNoteScreen(),
      ),
      GoRoute(
        path: AppRoutes.noteEdit,
        name: AppRoutes.noteEdit,
        builder: (BuildContext context, GoRouterState state) {
          final String id = state.uri.queryParameters['id'] ?? '';
          return EditNoteScreen(noteId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.noteDetail,
        name: AppRoutes.noteDetail,
        builder: (BuildContext context, GoRouterState state) {
          final String id = state.uri.queryParameters['id'] ?? '';
          return NoteDetailScreen(noteId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.lessons,
        name: AppRoutes.lessons,
        builder: (BuildContext context, GoRouterState state) {
          final String? nodeId = state.uri.queryParameters['nodeId'];
          return LessonOverviewScreen(nodeId: nodeId);
        },
      ),
      GoRoute(
        path: AppRoutes.lessonDetail,
        name: AppRoutes.lessonDetail,
        builder: (BuildContext context, GoRouterState state) {
          final String lessonId =
              state.uri.queryParameters['lessonId'] ?? '';
          return LessonDetailScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: AppRoutes.lessonReader,
        name: AppRoutes.lessonReader,
        builder: (BuildContext context, GoRouterState state) {
          final String lessonId =
              state.uri.queryParameters['lessonId'] ?? '';
          return LessonReaderScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: AppRoutes.lessonExamples,
        name: AppRoutes.lessonExamples,
        builder: (BuildContext context, GoRouterState state) {
          final String lessonId =
              state.uri.queryParameters['lessonId'] ?? '';
          return LessonExamplesScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: AppRoutes.lessonSummary,
        name: AppRoutes.lessonSummary,
        builder: (BuildContext context, GoRouterState state) {
          final String lessonId =
              state.uri.queryParameters['lessonId'] ?? '';
          return LessonSummaryScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: AppRoutes.quizOverview,
        name: AppRoutes.quizOverview,
        builder: (BuildContext context, GoRouterState state) {
          final String? nodeId = state.uri.queryParameters['nodeId'];
          return QuizOverviewScreen(nodeId: nodeId);
        },
      ),
      GoRoute(
        path: AppRoutes.quizPlay,
        name: AppRoutes.quizPlay,
        builder: (BuildContext context, GoRouterState state) {
          final String quizId =
              state.uri.queryParameters['quizId'] ?? '';
          return QuizScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: AppRoutes.quizReview,
        name: AppRoutes.quizReview,
        builder: (BuildContext context, GoRouterState state) {
          final String quizId =
              state.uri.queryParameters['quizId'] ?? '';
          return QuizReviewScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: AppRoutes.quizResult,
        name: AppRoutes.quizResult,
        builder: (BuildContext context, GoRouterState state) {
          final String quizId =
              state.uri.queryParameters['quizId'] ?? '';
          return QuizResultsScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: AppRoutes.quizPause,
        name: AppRoutes.quizPause,
        builder: (BuildContext context, GoRouterState state) {
          final String quizId =
              state.uri.queryParameters['quizId'] ?? '';
          return QuizPauseScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: AppRoutes.quizWeakTopics,
        name: AppRoutes.quizWeakTopics,
        builder: (BuildContext context, GoRouterState state) {
          final String quizId =
              state.uri.queryParameters['quizId'] ?? '';
          return WeakTopicsScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: AppRoutes.quizPerformanceBreakdown,
        name: AppRoutes.quizPerformanceBreakdown,
        builder: (BuildContext context, GoRouterState state) {
          final String quizId =
              state.uri.queryParameters['quizId'] ?? '';
          return PerformanceBreakdownScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: AppRoutes.review,
        name: AppRoutes.review,
        builder: (BuildContext context, GoRouterState state) {
          return const ReviewScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.reviewDetail,
        name: AppRoutes.reviewDetail,
        builder: (BuildContext context, GoRouterState state) {
          final String questionId =
              state.uri.queryParameters['questionId'] ?? '';
          final String? quizId = state.uri.queryParameters['quizId'];
          return ReviewDetailScreen(
            questionId: questionId,
            quizId: quizId,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.aiTutor,
        name: AppRoutes.aiTutor,
        builder: (BuildContext context, GoRouterState state) =>
            const AiTutorScreen(),
      ),
      GoRoute(
        path: AppRoutes.statistics,
        name: AppRoutes.statistics,
        builder: (BuildContext context, GoRouterState state) =>
            const phase_eighteen.StatisticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsTheme,
        name: AppRoutes.settingsTheme,
        builder: (BuildContext context, GoRouterState state) =>
            const ThemeSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsLanguage,
        name: AppRoutes.settingsLanguage,
        builder: (BuildContext context, GoRouterState state) =>
            const LanguageSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsNotifications,
        name: AppRoutes.settingsNotifications,
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsPrivacy,
        name: AppRoutes.settingsPrivacy,
        builder: (BuildContext context, GoRouterState state) =>
            const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsAccessibility,
        name: AppRoutes.settingsAccessibility,
        builder: (BuildContext context, GoRouterState state) =>
            const AccessibilitySettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsAbout,
        name: AppRoutes.settingsAbout,
        builder: (BuildContext context, GoRouterState state) =>
            const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscriptionPlans,
        name: AppRoutes.subscriptionPlans,
        builder: (BuildContext context, GoRouterState state) =>
            const SubscriptionPlansScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscriptionComparison,
        name: AppRoutes.subscriptionComparison,
        builder: (BuildContext context, GoRouterState state) =>
            const PlanComparisonScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscriptionPurchase,
        name: AppRoutes.subscriptionPurchase,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, String>? extra =
              state.extra is Map<String, String>
                  ? state.extra as Map<String, String>
                  : null;
          return PurchaseFlowScreen(
            planId: extra?['planId'],
            providerCode: extra?['providerCode'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.subscriptionRestore,
        name: AppRoutes.subscriptionRestore,
        builder: (BuildContext context, GoRouterState state) =>
            const RestorePurchaseScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiTutorHint,
        name: AppRoutes.aiTutorHint,
        builder: (BuildContext context, GoRouterState state) {
          final String? questionId = state.uri.queryParameters['questionId'];
          return AiHintScreen(questionId: questionId);
        },
      ),
      GoRoute(
        path: AppRoutes.aiTutorExplain,
        name: AppRoutes.aiTutorExplain,
        builder: (BuildContext context, GoRouterState state) =>
            const AiExplainScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiTutorSimplify,
        name: AppRoutes.aiTutorSimplify,
        builder: (BuildContext context, GoRouterState state) =>
            const AiSimplifyScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiTutorSummary,
        name: AppRoutes.aiTutorSummary,
        builder: (BuildContext context, GoRouterState state) =>
            const AiSummaryScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiTutorFlashcards,
        name: AppRoutes.aiTutorFlashcards,
        builder: (BuildContext context, GoRouterState state) =>
            const AiFlashcardsScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiTutorStudyPlan,
        name: AppRoutes.aiTutorStudyPlan,
        builder: (BuildContext context, GoRouterState state) =>
            const AiStudyPlanScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiTutorQuestions,
        name: AppRoutes.aiTutorQuestions,
        builder: (BuildContext context, GoRouterState state) =>
            const AiQuestionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiTutorChat,
        name: AppRoutes.aiTutorChat,
        builder: (BuildContext context, GoRouterState state) {
          final String? conversationId =
              state.uri.queryParameters['conversationId'];
          return AiChatScreen(conversationId: conversationId);
        },
      ),
      GoRoute(
        path: AppRoutes.aiTutorHistory,
        name: AppRoutes.aiTutorHistory,
        builder: (BuildContext context, GoRouterState state) =>
            const AiHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.offlineDownloads,
        name: AppRoutes.offlineDownloads,
        builder: (BuildContext context, GoRouterState state) =>
            const OfflineDownloadsScreen(),
      ),
      GoRoute(
        path: AppRoutes.offlineLessons,
        name: AppRoutes.offlineLessons,
        builder: (BuildContext context, GoRouterState state) =>
            const DownloadedLessonsScreen(),
      ),
      GoRoute(
        path: AppRoutes.offlineQuestions,
        name: AppRoutes.offlineQuestions,
        builder: (BuildContext context, GoRouterState state) =>
            const DownloadedQuestionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.offlineStorage,
        name: AppRoutes.offlineStorage,
        builder: (BuildContext context, GoRouterState state) =>
            const OfflineStorageScreen(),
      ),
      GoRoute(
        path: AppRoutes.offlineSync,
        name: AppRoutes.offlineSync,
        builder: (BuildContext context, GoRouterState state) =>
            const OfflineSyncScreen(),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.appName)),
        body: Center(
          child: Text(
            'Route not found: ${state.uri}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    },
  );
}

/// Static holder for the most recent [AuthState]. The
/// [authRouterRefreshProvider] calls [emit] whenever the state
/// changes; the router redirect reads [lastSeenState] on every
/// invocation.
///
/// This indirection is necessary because `GoRouter.redirect` runs
/// outside a Riverpod `BuildContext`, so providers cannot be
/// consumed directly.
class AuthRouterBridge {
  AuthRouterBridge._();

  static AuthState _state = const AuthState.unknown();
  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);

  static AuthState get lastSeenState => _state;

  static void emit(AuthState state) {
    _state = state;
    refresh.value++;
  }
}