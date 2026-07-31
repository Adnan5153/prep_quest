/// Centralized Firebase configuration values used during bootstrap.
///
/// Anything that varies per build flavor / deployment should live here so
/// feature code never duplicates environment checks.
class FirebaseConstants {
  const FirebaseConstants._();

  /// Cloud Storage bucket the app reads / writes from. Defaults to the
  /// `DefaultFirebaseOptions` storage bucket; override per flavor if a
  /// dedicated bucket is required.
  static const String defaultStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: '',
  );

  /// Cloud Functions region used for AI Tutor and other server-side
  /// endpoints. Override when deploying outside `us-central1`.
  static const String functionsRegion = String.fromEnvironment(
    'FIREBASE_FUNCTIONS_REGION',
    defaultValue: 'us-central1',
  );

  /// Default values for every typed feature flag / tuning key referenced
  /// by [RemoteConfigService]. Acts as the canonical source of truth —
  /// the previous Firebase Remote Config override layer was removed
  /// because the underlying plugin was incompatible with the project's
  /// Kotlin Gradle setup.
  static const Map<String, Object> remoteConfigDefaults =
      <String, Object>{
    // ---- Feature flags ----
    'flag_leaderboard_enabled': true,
    'flag_mock_test_enabled': true,
    'flag_ai_tutor_enabled': true,
    'flag_subscription_enabled': false,
    'flag_weakness_tracker_enabled': true,
    'flag_maintenance_mode': false,

    // ---- Quiz settings ----
    'quiz_default_time_per_question_seconds': 30,
    'quiz_passing_score_percent': 60,
    'quiz_max_questions_per_session': 20,

    // ---- Reward balancing ----
    'reward_xp_per_correct_answer': 10,
    'reward_xp_per_completed_lesson': 50,
    'reward_coins_per_correct_answer': 1,
    'reward_coins_per_completed_lesson': 5,
    'reward_streak_bonus_multiplier': 1.5,

    // ---- AI config ----
    'ai_max_conversation_turns': 20,
    'ai_response_token_limit': 1024,
    'ai_temperature': 0.4,

    // ---- App version ----
    'app_minimum_supported_version': '1.0.0',
    'app_force_update_below': '1.0.0',
  };
}
