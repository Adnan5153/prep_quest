import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Returns the persisted [SettingsEntity]. Falls back to platform
/// defaults when no settings have been written yet.
class GetSettings {
  const GetSettings(this._repository);

  final SettingsRepository _repository;

  Future<SettingsEntity> call() => _repository.getSettings();
}