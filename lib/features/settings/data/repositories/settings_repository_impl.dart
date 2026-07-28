import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

/// Default [SettingsRepository] backed by [SettingsLocalDataSource].
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<SettingsEntity> getSettings() async {
    final SettingsModel model = await _localDataSource.read();
    return model.toEntity();
  }

  @override
  Future<SettingsEntity> saveSettings(SettingsEntity settings) async {
    final SettingsModel model = SettingsModel.fromEntity(settings);
    final SettingsModel written = await _localDataSource.write(model);
    return written.toEntity();
  }

  @override
  Future<bool> hasSeenSettings() => _localDataSource.hasWritten();
}