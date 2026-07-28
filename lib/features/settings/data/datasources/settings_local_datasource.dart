import 'dart:async';

import 'package:flutter/services.dart';

import '../../domain/entities/settings_entity.dart';
import '../models/settings_model.dart';

/// Local persistence surface for the Settings feature.
///
/// The current implementation is an in-memory mock that simulates a
/// SharedPreferences / Hive box round-trip. The contract it exposes
/// (`read`/`write`/`hasWritten`) is the same one a real on-device
/// implementation will use, so swapping the implementation later is a
/// one-file change.
abstract class SettingsLocalDataSource {
  Future<SettingsModel> read();
  Future<SettingsModel> write(SettingsModel model);
  Future<bool> hasWritten();
}

class MockSettingsLocalDataSource implements SettingsLocalDataSource {
  MockSettingsLocalDataSource();

  SettingsModel? _cache;

  static const MethodChannel _channel =
      MethodChannel('prep_quest/settings');

  @override
  Future<SettingsModel> read() async {
    try {
      final Map<Object?, Object?>? raw =
          await _channel.invokeMapMethod<Object?, Object?>('read');
      if (raw != null) {
        return SettingsModel.fromMap(
          raw.map((Object? k, Object? v) =>
              MapEntry<String, dynamic>(k.toString(), v)),
        );
      }
    } on MissingPluginException {
      // Fall through to in-memory cache when the platform channel is
      // unavailable (most desktop tests, headless tests).
    } on PlatformException {
      // Treat platform failures as "no settings yet" rather than as a
      // hard error — the user simply has the defaults.
    }
    return _cache ?? SettingsModel.fromEntity(SettingsEntity.defaults());
  }

  @override
  Future<SettingsModel> write(SettingsModel model) async {
    _cache = model;
    try {
      await _channel.invokeMethod<void>('write', model.toMap());
    } on MissingPluginException {
      // No-op: cache is the source of truth in mock mode.
    } on PlatformException {
      // No-op for the same reason.
    }
    return model;
  }

  @override
  Future<bool> hasWritten() async {
    if (_cache != null) return true;
    try {
      final bool? wrote =
          await _channel.invokeMethod<bool>('hasWritten');
      return wrote ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}