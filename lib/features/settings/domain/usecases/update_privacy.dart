import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Updates only the privacy preferences while leaving the rest
/// untouched.
class UpdatePrivacy {
  const UpdatePrivacy(this._repository);

  final SettingsRepository _repository;

  Future<SettingsEntity> call(PrivacyPreferences next) async {
    final SettingsEntity current = await _repository.getSettings();
    return _repository.saveSettings(current.copyWith(privacy: next));
  }
}