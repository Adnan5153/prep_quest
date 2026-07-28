import 'dart:async';

/// Encrypted key-value storage facade.
///
/// Mirrors the surface of `flutter_secure_storage` so the offline
/// module's secrets-handling code stays portable. The current
/// implementation is an in-memory store; integrate the real plugin
/// before shipping.
class SecureStorage {
  SecureStorage();

  final Map<String, String> _values = <String, String>{};

  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }

  Future<String?> read({required String key}) async => _values[key];

  Future<void> delete({required String key}) async {
    _values.remove(key);
  }

  Future<void> deleteAll() async {
    _values.clear();
  }

  Future<bool> containsKey({required String key}) async =>
      _values.containsKey(key);
}