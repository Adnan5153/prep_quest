import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Updates only the accessibility preferences while leaving the rest
/// untouched.
class UpdateAccessibility {
  const UpdateAccessibility(this._repository);

  final SettingsRepository _repository;

  Future<SettingsEntity> call(AccessibilityPreferences next) async {
    final SettingsEntity current = await _repository.getSettings();
    return _repository.saveSettings(current.copyWith(accessibility: next));
  }
}