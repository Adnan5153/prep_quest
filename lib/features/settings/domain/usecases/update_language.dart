import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Updates only the language preference while leaving the rest untouched.
class UpdateLanguage {
  const UpdateLanguage(this._repository);

  final SettingsRepository _repository;

  Future<SettingsEntity> call(AppLanguage language) async {
    final SettingsEntity current = await _repository.getSettings();
    return _repository.saveSettings(current.copyWith(language: language));
  }
}