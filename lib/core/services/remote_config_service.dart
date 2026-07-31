import 'package:flutter/foundation.dart';

import '../constants/firebase_constants.dart';

/// Typed accessor for feature flags and runtime tuning values.
///
/// Historically backed by Firebase Remote Config. To avoid pulling in
/// the `firebase_remote_config` plugin (which ships a native Android
/// Kotlin dependency that fails the Flutter Gradle build on
/// incremental cache resets) the service now resolves every key from
/// the bundled defaults in [FirebaseConstants.remoteConfigDefaults].
///
/// When remote-config-backed overrides are reintroduced, the read
/// helpers below should keep the same public surface so feature code
/// stays untouched.
class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService instance = RemoteConfigService._();

  /// Look up a value in the bundled defaults. The accessor mirrors the
  /// historical Remote Config API so swapping the implementation later
  /// does not require any feature-side changes.
  T _read<T>(String key, T fallback) {
    final Object? value = FirebaseConstants.remoteConfigDefaults[key];
    if (value is T) return value;
    if (kDebugMode) {
      debugPrint(
        '[RemoteConfigService] missing or mistyped default for $key '
        '(expected $T, got ${value.runtimeType}); using fallback=$fallback',
      );
    }
    return fallback;
  }

  /// Manually triggers a fetch + activate.
  ///
  /// No-op in the local-only implementation. Kept for API compatibility
  /// so existing call-sites (e.g. pull-to-refresh) continue to work.
  Future<void> refresh() async {}

  // ---- Feature flags --------------------------------------------------------

  bool get isLeaderboardEnabled =>
      _read<bool>('flag_leaderboard_enabled', true);
  bool get isMockTestEnabled => _read<bool>('flag_mock_test_enabled', true);
  bool get isAiTutorEnabled => _read<bool>('flag_ai_tutor_enabled', true);
  bool get isSubscriptionEnabled =>
      _read<bool>('flag_subscription_enabled', false);
  bool get isWeaknessTrackerEnabled =>
      _read<bool>('flag_weakness_tracker_enabled', true);
  bool get isMaintenanceMode => _read<bool>('flag_maintenance_mode', false);

  // ---- Quiz settings --------------------------------------------------------

  int get defaultTimePerQuestionSeconds =>
      _read<int>('quiz_default_time_per_question_seconds', 30);

  int get passingScorePercent =>
      _read<int>('quiz_passing_score_percent', 60);

  int get maxQuestionsPerSession =>
      _read<int>('quiz_max_questions_per_session', 20);

  // ---- Reward balancing -----------------------------------------------------

  int get xpPerCorrectAnswer =>
      _read<int>('reward_xp_per_correct_answer', 10);
  int get xpPerCompletedLesson =>
      _read<int>('reward_xp_per_completed_lesson', 50);
  int get coinsPerCorrectAnswer =>
      _read<int>('reward_coins_per_correct_answer', 1);
  int get coinsPerCompletedLesson =>
      _read<int>('reward_coins_per_completed_lesson', 5);
  double get streakBonusMultiplier =>
      _read<double>('reward_streak_bonus_multiplier', 1.5);

  // ---- AI config ------------------------------------------------------------

  int get aiMaxConversationTurns =>
      _read<int>('ai_max_conversation_turns', 20);
  int get aiResponseTokenLimit =>
      _read<int>('ai_response_token_limit', 1024);
  double get aiTemperature => _read<double>('ai_temperature', 0.4);

  // ---- App version ----------------------------------------------------------

  String get minimumSupportedVersion =>
      _read<String>('app_minimum_supported_version', '1.0.0');

  String get forceUpdateBelow =>
      _read<String>('app_force_update_below', '1.0.0');
}
