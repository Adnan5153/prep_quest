import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Updates only the notification preferences while leaving the rest
/// untouched. Pass any combination of fields; omitted fields keep
/// their current value.
class UpdateNotifications {
  const UpdateNotifications(this._repository);

  final SettingsRepository _repository;

  Future<SettingsEntity> call(NotificationPreferences next) async {
    final SettingsEntity current = await _repository.getSettings();
    return _repository.saveSettings(current.copyWith(notifications: next));
  }
}