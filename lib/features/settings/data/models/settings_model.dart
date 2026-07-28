import '../../domain/entities/settings_entity.dart';

/// Data Transfer Object for [SettingsEntity]. The model owns the
/// (de)serialisation rules so the entity stays a plain Dart value type.
class SettingsModel {
  const SettingsModel({
    required this.themeMode,
    required this.language,
    required this.notifications,
    required this.privacy,
    required this.accessibility,
    this.firstSyncAtIso,
  });

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      themeMode: entity.themeMode,
      language: entity.language,
      notifications: entity.notifications,
      privacy: entity.privacy,
      accessibility: entity.accessibility,
      firstSyncAtIso: entity.firstSyncAtIso,
    );
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      themeMode: _parseTheme(map['theme_mode']),
      language: _parseLanguage(map['language']),
      notifications: NotificationPreferences.fromMap(
        Map<String, dynamic>.from(
          (map['notifications'] as Map?)?.cast<String, dynamic>() ??
              const <String, dynamic>{},
        ),
      ),
      privacy: PrivacyPreferences.fromMap(
        Map<String, dynamic>.from(
          (map['privacy'] as Map?)?.cast<String, dynamic>() ??
              const <String, dynamic>{},
        ),
      ),
      accessibility: AccessibilityPreferences.fromMap(
        Map<String, dynamic>.from(
          (map['accessibility'] as Map?)?.cast<String, dynamic>() ??
              const <String, dynamic>{},
        ),
      ),
      firstSyncAtIso: map['first_sync_at_iso'] as String?,
    );
  }

  final AppThemeMode themeMode;
  final AppLanguage language;
  final NotificationPreferences notifications;
  final PrivacyPreferences privacy;
  final AccessibilityPreferences accessibility;
  final String? firstSyncAtIso;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'theme_mode': themeMode.name,
      'language': language.name,
      'notifications': notifications.toMap(),
      'privacy': privacy.toMap(),
      'accessibility': accessibility.toMap(),
      'first_sync_at_iso': firstSyncAtIso,
    };
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      themeMode: themeMode,
      language: language,
      notifications: notifications,
      privacy: privacy,
      accessibility: accessibility,
      firstSyncAtIso: firstSyncAtIso,
    );
  }

  static AppThemeMode _parseTheme(Object? raw) {
    if (raw is String) {
      return AppThemeMode.values.firstWhere(
        (AppThemeMode mode) => mode.name == raw,
        orElse: () => AppThemeMode.system,
      );
    }
    return AppThemeMode.system;
  }

  static AppLanguage _parseLanguage(Object? raw) {
    if (raw is String) {
      return AppLanguage.values.firstWhere(
        (AppLanguage lang) => lang.name == raw,
        orElse: () => AppLanguage.english,
      );
    }
    return AppLanguage.english;
  }
}