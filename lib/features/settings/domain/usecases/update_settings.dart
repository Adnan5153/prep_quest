import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Persists a full [SettingsEntity]. Useful for tests and for use cases
/// that need to mutate multiple fields atomically (e.g. importing a
/// settings bundle).
class UpdateSettings {
  const UpdateSettings(this._repository);

  final SettingsRepository _repository;

  Future<SettingsEntity> call(SettingsEntity settings) =>
      _repository.saveSettings(settings);
}