import 'package:flutter/material.dart';

/// User-selectable theme preference.
enum AppThemeMode { system, light, dark }

/// Locales the application currently ships with.
enum AppLanguage { english, bengali }

extension AppLanguageX on AppLanguage {
  /// BCP-47 code used by the [MaterialApp.locale] resolution chain.
  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.bengali:
        return const Locale('bn');
    }
  }

  /// Human-readable name (English).
  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.bengali:
        return 'বাংলা';
    }
  }
}

extension AppThemeModeX on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.system:
        return 'Follow system';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  ThemeMode get materialMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

/// Subset of push-notification toggles surfaced on the Notifications screen.
class NotificationPreferences {
  const NotificationPreferences({
    this.pushEnabled = true,
    this.streakReminders = true,
    this.dailyQuizReminder = true,
    this.weeklyDigest = false,
    this.achievementAlerts = true,
  });

  final bool pushEnabled;
  final bool streakReminders;
  final bool dailyQuizReminder;
  final bool weeklyDigest;
  final bool achievementAlerts;

  NotificationPreferences copyWith({
    bool? pushEnabled,
    bool? streakReminders,
    bool? dailyQuizReminder,
    bool? weeklyDigest,
    bool? achievementAlerts,
  }) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      streakReminders: streakReminders ?? this.streakReminders,
      dailyQuizReminder: dailyQuizReminder ?? this.dailyQuizReminder,
      weeklyDigest: weeklyDigest ?? this.weeklyDigest,
      achievementAlerts: achievementAlerts ?? this.achievementAlerts,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'push_enabled': pushEnabled,
        'streak_reminders': streakReminders,
        'daily_quiz_reminder': dailyQuizReminder,
        'weekly_digest': weeklyDigest,
        'achievement_alerts': achievementAlerts,
      };

  factory NotificationPreferences.fromMap(Map<String, dynamic> map) {
    return NotificationPreferences(
      pushEnabled: map['push_enabled'] as bool? ?? true,
      streakReminders: map['streak_reminders'] as bool? ?? true,
      dailyQuizReminder: map['daily_quiz_reminder'] as bool? ?? true,
      weeklyDigest: map['weekly_digest'] as bool? ?? false,
      achievementAlerts: map['achievement_alerts'] as bool? ?? true,
    );
  }
}

/// Privacy & data-sharing controls.
class PrivacyPreferences {
  const PrivacyPreferences({
    this.analyticsEnabled = true,
    this.crashReportsEnabled = true,
    this.personalisedRecommendations = true,
    this.shareProgressOnLeaderboard = true,
    this.allowAitutorMemory = true,
  });

  final bool analyticsEnabled;
  final bool crashReportsEnabled;
  final bool personalisedRecommendations;
  final bool shareProgressOnLeaderboard;
  final bool allowAitutorMemory;

  PrivacyPreferences copyWith({
    bool? analyticsEnabled,
    bool? crashReportsEnabled,
    bool? personalisedRecommendations,
    bool? shareProgressOnLeaderboard,
    bool? allowAitutorMemory,
  }) {
    return PrivacyPreferences(
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReportsEnabled: crashReportsEnabled ?? this.crashReportsEnabled,
      personalisedRecommendations:
          personalisedRecommendations ?? this.personalisedRecommendations,
      shareProgressOnLeaderboard:
          shareProgressOnLeaderboard ?? this.shareProgressOnLeaderboard,
      allowAitutorMemory: allowAitutorMemory ?? this.allowAitutorMemory,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'analytics_enabled': analyticsEnabled,
        'crash_reports_enabled': crashReportsEnabled,
        'personalised_recommendations': personalisedRecommendations,
        'share_progress_on_leaderboard': shareProgressOnLeaderboard,
        'allow_ai_tutor_memory': allowAitutorMemory,
      };

  factory PrivacyPreferences.fromMap(Map<String, dynamic> map) {
    return PrivacyPreferences(
      analyticsEnabled: map['analytics_enabled'] as bool? ?? true,
      crashReportsEnabled: map['crash_reports_enabled'] as bool? ?? true,
      personalisedRecommendations:
          map['personalised_recommendations'] as bool? ?? true,
      shareProgressOnLeaderboard:
          map['share_progress_on_leaderboard'] as bool? ?? true,
      allowAitutorMemory: map['allow_ai_tutor_memory'] as bool? ?? true,
    );
  }
}

/// Accessibility knobs that influence UI behaviour at runtime.
class AccessibilityPreferences {
  const AccessibilityPreferences({
    this.textScale = 1.0,
    this.highContrast = false,
    this.reduceMotion = false,
    this.hapticsEnabled = true,
  });

  final double textScale;
  final bool highContrast;
  final bool reduceMotion;
  final bool hapticsEnabled;

  AccessibilityPreferences copyWith({
    double? textScale,
    bool? highContrast,
    bool? reduceMotion,
    bool? hapticsEnabled,
  }) {
    return AccessibilityPreferences(
      textScale: textScale ?? this.textScale,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'text_scale': textScale,
        'high_contrast': highContrast,
        'reduce_motion': reduceMotion,
        'haptics_enabled': hapticsEnabled,
      };

  factory AccessibilityPreferences.fromMap(Map<String, dynamic> map) {
    return AccessibilityPreferences(
      textScale: (map['text_scale'] as num?)?.toDouble() ?? 1.0,
      highContrast: map['high_contrast'] as bool? ?? false,
      reduceMotion: map['reduce_motion'] as bool? ?? false,
      hapticsEnabled: map['haptics_enabled'] as bool? ?? true,
    );
  }
}

/// Immutable snapshot of all user-tunable settings. The data layer is
/// responsible for serialising/deserialising this to local storage.
class SettingsEntity {
  const SettingsEntity({
    required this.themeMode,
    required this.language,
    required this.notifications,
    required this.privacy,
    required this.accessibility,
    this.firstSyncAtIso,
  });

  final AppThemeMode themeMode;
  final AppLanguage language;
  final NotificationPreferences notifications;
  final PrivacyPreferences privacy;
  final AccessibilityPreferences accessibility;

  /// Optional timestamp captured the first time the user opened the
  /// settings screen. Used to drive the welcome banner in the UI.
  final String? firstSyncAtIso;

  /// Sensible defaults for a freshly installed device.
  factory SettingsEntity.defaults() {
    return const SettingsEntity(
      themeMode: AppThemeMode.system,
      language: AppLanguage.english,
      notifications: NotificationPreferences(),
      privacy: PrivacyPreferences(),
      accessibility: AccessibilityPreferences(),
    );
  }

  SettingsEntity copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    NotificationPreferences? notifications,
    PrivacyPreferences? privacy,
    AccessibilityPreferences? accessibility,
    String? firstSyncAtIso,
  }) {
    return SettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      accessibility: accessibility ?? this.accessibility,
      firstSyncAtIso: firstSyncAtIso ?? this.firstSyncAtIso,
    );
  }
}