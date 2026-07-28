import 'dart:async';

/// In-memory cache facade with TTL support.
///
/// Used by the offline module to persist download metadata, sync
/// queues, and storage snapshots between app launches. A persistent
/// backend (Hive, SharedPreferences) can be swapped in without
/// touching the public surface.
class CacheService {
  CacheService({Duration? defaultTtl})
      : _defaultTtl = defaultTtl ?? const Duration(hours: 6);

  final Duration _defaultTtl;
  final Map<String, _CacheEntry<dynamic>> _store =
      <String, _CacheEntry<dynamic>>{};

  /// Writes a value with the default TTL.
  Future<void> put<T>(String key, T value) =>
      putWithTtl<T>(key, value, _defaultTtl);

  /// Writes a value with a custom TTL.
  Future<void> putWithTtl<T>(
    String key,
    T value,
    Duration ttl,
  ) async {
    _store[key] = _CacheEntry<T>(
      value: value,
      expiresAt: DateTime.now().add(ttl),
    );
  }

  /// Reads a value, returns null if missing or expired.
  Future<T?> get<T>(String key) async {
    final _CacheEntry<dynamic>? entry = _store[key];
    if (entry == null) return null;
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _store.remove(key);
      return null;
    }
    return entry.value as T;
  }

  /// Removes a single key.
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  /// Wipes everything.
  Future<void> clear() async {
    _store.clear();
  }

  /// Approximate size of the cache (number of entries).
  int get length => _store.length;
}

class _CacheEntry<T> {
  _CacheEntry({required this.value, required this.expiresAt});

  final T value;
  final DateTime expiresAt;
}