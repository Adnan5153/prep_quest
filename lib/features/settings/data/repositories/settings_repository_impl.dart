import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/auth_precondition.dart';
import '../../../../core/services/settings_service.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

/// Default [SettingsRepository] backed by [SettingsLocalDataSource]
/// with a Firestore mirror for the notification-preferences slice
/// (Phase 48).
///
/// Phase 51 — `saveSettings` enforces an authenticated precondition
/// via [AuthGuard] before mirroring to Firestore. The local cache
/// write still succeeds for guests so the in-session UI reflects the
/// change; only the remote mirror is gated.
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(
    this._localDataSource, {
    SettingsService? settingsService,
    String Function()? uidProvider,
    Ref? ref,
  })  : _settingsService = settingsService,
        _uidProvider = uidProvider,
        _guard = ref == null ? null : AuthGuard(ref);

  final SettingsLocalDataSource _localDataSource;
  final SettingsService? _settingsService;
  final String Function()? _uidProvider;
  final AuthGuard? _guard;

  @override
  Future<SettingsEntity> getSettings() async {
    final SettingsModel model = await _localDataSource.read();
    return model.toEntity();
  }

  @override
  Future<SettingsEntity> saveSettings(SettingsEntity settings) async {
    _guard?.assertAuthenticated();
    final SettingsModel model = SettingsModel.fromEntity(settings);
    final SettingsModel written = await _localDataSource.write(model);
    final SettingsService? service = _settingsService;
    final String Function()? uidProvider = _uidProvider;
    if (service != null && uidProvider != null) {
      final String uid = uidProvider();
      if (uid.isNotEmpty) {
        final bool ok = await service.saveNotificationPreferences(
          uid: uid,
          model: written,
        );
        if (!ok) {
          developer.log(
            '[SettingsRepository] notification-preferences mirror failed '
            '(cache-only).',
            name: 'SettingsRepository',
          );
        }
      }
    }
    return written.toEntity();
  }

  @override
  Future<bool> hasSeenSettings() => _localDataSource.hasWritten();
}