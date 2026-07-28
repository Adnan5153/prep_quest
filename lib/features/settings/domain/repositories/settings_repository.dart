import '../entities/settings_entity.dart';

/// Contract the Settings use cases depend on. The data layer provides a
/// mock implementation now and can swap in a Firebase/Hive backed
/// implementation later without touching presentation code.
abstract class SettingsRepository {
  /// Returns the persisted [SettingsEntity], or the platform defaults if
  /// the user has not yet customised anything.
  Future<SettingsEntity> getSettings();

  /// Persists a new copy of the supplied settings.
  Future<SettingsEntity> saveSettings(SettingsEntity settings);

  /// Convenience used by the splash router to know whether the user has
  /// already interacted with the settings screens at least once.
  Future<bool> hasSeenSettings();
}