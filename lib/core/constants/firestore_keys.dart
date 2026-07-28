/// Firestore collection / document keys.
///
/// Centralized so renaming a collection is a one-file change. Keys are
/// referenced from `lib/features/<feature>/data/datasources` and from the
/// Cloud Functions under `functions/src`.
class FirestoreKeys {
  const FirestoreKeys._();

  // ----- Collections -----
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
}
