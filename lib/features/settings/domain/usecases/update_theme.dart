import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Updates only the theme preference while leaving the rest untouched.
class UpdateTheme {
  const UpdateTheme(this._repository);

  final SettingsRepository _repository;

  Future<SettingsEntity> call(AppThemeMode mode) async {
    final SettingsEntity current = await _repository.getSettings();
    return _repository.saveSettings(current.copyWith(themeMode: mode));
  }
}