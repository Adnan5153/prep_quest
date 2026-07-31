/// Firestore collection / document keys.
///
/// Centralized so renaming a collection is a one-file change. Keys are
/// referenced from `lib/features/<feature>/data/datasources` and from the
/// Cloud Functions under `functions/src`.
class FirestoreKeys {
  const FirestoreKeys._();

  // ----- Top-level collections -----
  static const String users = 'users';
  static const String subscriptions = 'subscriptions';
  static const String subjects = 'subjects';
  static const String chapters = 'chapters';
  static const String questions = 'questions';
  static const String mockTests = 'mock_tests';
  static const String testAttempts = 'test_attempts';
  static const String answers = 'answers';
  static const String aiTutorLogs = 'ai_tutor_logs';
  static const String weaknessProfiles = 'weakness_profiles';
  static const String gamificationState = 'gamification_state';
  static const String achievements = 'achievements';
  static const String rewards = 'rewards';
  static const String leaderboardEntries = 'leaderboard_entries';
  static const String adminLogs = 'admin_logs';
  static const String analyticsEvents = 'analytics_events';
  static const String categories = 'categories';

  // ----- users/{uid}/* subcollections -----
  static const String progressionSubcollection = 'progression';
  static const String studyStatsSubcollection = 'study_stats';
  static const String statisticsSubcollection = 'statistics';
  static const String streakSubcollection = 'streak';
  static const String playgroundSubcollection = 'playground';
  static const String quizSessionsSubcollection = 'quiz_sessions';
  static const String quizHistorySubcollection = 'quiz_history';
  static const String categoryProgressSubcollection = 'category_progress';
  static const String profileSubcollection = 'profile';
  static const String appUserSubcollection = 'app_user';
  static const String coinLedgerSubcollection = 'coin_ledger';
  static const String missionProgressSubcollection = 'mission_progress';
  static const String categoryStatisticsSubcollection = 'category_statistics';
  static const String bookmarksSubcollection = 'bookmarks';
  static const String notesSubcollection = 'notes';
  static const String highlightsSubcollection = 'highlights';
  static const String aiNotesSubcollection = 'ai_notes';
  static const String notificationsSubcollection = 'notifications';
  static const String fcmTokensSubcollection = 'fcm_tokens';
  static const String settingsSubcollection = 'settings';
  static const String leaderboardEntriesSubcollection = 'leaderboard_entries';
  static const String notificationPreferencesDoc = 'notification_preferences';
  static const String subscriptionSubcollection = 'subscription';
  static const String searchRecentSubcollection = 'search_recent';

  // ----- Top-level content collections -----
  static const String quizzesCollection = 'quizzes';
  static const String lessonsCollection = 'lessons';
  static const String contentManifestsCollection = 'content_manifests';
  static const String searchIndexCollection = 'search_index';
  static const String subscriptionPlansCollection = 'subscription_plans';

  // ----- Shared document ids -----
  static const String currentDocId = 'current';
}
