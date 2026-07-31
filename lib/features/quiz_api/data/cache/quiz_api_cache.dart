import 'dart:convert';

import '../../../../core/cache/hive_manager.dart';
import '../../../../core/services/cache_service.dart';

/// TTL-bounded cache for the Quiz Hub REST API responses.
///
/// Stores raw `Map<String, dynamic>` payloads (the shape the backend
/// returns) so the cache stays decoupled from the DTO ↔ entity mapping
/// in the repository layer.
///
/// Cache keys are namespaced (`quizhub:categories:list:p1:l20:q''` etc.)
/// so query parameters drive cache identity and unrelated endpoints
/// can't share entries.
class QuizApiCache {
  QuizApiCache({
    CacheService? memory,
    Duration? listTtl,
    Duration? itemTtl,
    HiveManager? hive,
    bool usePersistent = true,
  })  : _memory = memory ?? CacheService(),
        _listTtl = listTtl ?? const Duration(minutes: 10),
        _itemTtl = itemTtl ?? const Duration(minutes: 30),
        _hive = hive ?? HiveManager.instance,
        _usePersistent = usePersistent;

  final CacheService _memory;
  final Duration _listTtl;
  final Duration _itemTtl;
  final HiveManager _hive;
  final bool _usePersistent;

  static const String _boxName = 'quizhub_cache_v1';

  String categoryListKey(int page, int limit, String? search) =>
      'quizhub:categories:list:p$page:l$limit:q${search ?? ''}';

  String categoryItemKey(String id) => 'quizhub:categories:item:$id';

  String questionListKey(String categoryId, int page, int limit, String? search) =>
      'quizhub:questions:$categoryId:list:p$page:l$limit:q${search ?? ''}';

  String questionItemKey(String id) => 'quizhub:questions:item:$id';

  Future<void> _ensureBox() async {
    if (!_usePersistent) return;
    if (!_hive.isInitialized) return;
    await _hive.openBox<String>(_boxName);
  }

  Future<void> _writePersistent(String key, Map<String, dynamic> value) async {
    if (!_usePersistent) return;
    if (!_hive.isInitialized) return;
    await _ensureBox();
    await _hive.box<String>(_boxName).put(
      key,
      jsonEncode(<String, dynamic>{
        't': DateTime.now().toIso8601String(),
        'v': value,
      }),
    );
  }

  Map<String, dynamic>? _readPersistent(String key) {
    if (!_usePersistent) return null;
    if (!_hive.isInitialized) return null;
    final String? raw = _hive.box<String>(_boxName).get(key);
    if (raw == null) return null;
    try {
      final dynamic decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final dynamic value = decoded['v'];
        if (value is Map<String, dynamic>) return value;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> putCategoryList({
    required String key,
    required Map<String, dynamic> value,
  }) =>
      _put(key, value, _listTtl);

  Future<Map<String, dynamic>?> getCategoryList({required String key}) =>
      _get(key);

  Future<void> putCategoryItem({
    required String key,
    required Map<String, dynamic> value,
  }) =>
      _put(key, value, _itemTtl);

  Future<Map<String, dynamic>?> getCategoryItem({required String key}) =>
      _get(key);

  Future<void> putQuestionList({
    required String key,
    required Map<String, dynamic> value,
  }) =>
      _put(key, value, _listTtl);

  Future<Map<String, dynamic>?> getQuestionList({required String key}) =>
      _get(key);

  Future<void> putQuestionItem({
    required String key,
    required Map<String, dynamic> value,
  }) =>
      _put(key, value, _itemTtl);

  Future<Map<String, dynamic>?> getQuestionItem({required String key}) =>
      _get(key);

  Future<void> invalidate(String key) async {
    await _memory.remove(key);
    if (_usePersistent && _hive.isInitialized) {
      await _hive.box<String>(_boxName).delete(key);
    }
  }

  Future<void> clear() async {
    await _memory.clear();
    if (_usePersistent && _hive.isInitialized) {
      await _hive.box<String>(_boxName).clear();
    }
  }

  Future<void> _put(String key, Map<String, dynamic> value, Duration ttl) async {
    await _memory.putWithTtl<String>(key, jsonEncode(value), ttl);
    await _writePersistent(key, value);
  }

  Future<Map<String, dynamic>?> _get(String key) async {
    final String? fromMemory = await _memory.get<String>(key);
    if (fromMemory != null) {
      final dynamic decoded = jsonDecode(fromMemory);
      if (decoded is Map<String, dynamic>) return decoded;
    }
    return _readPersistent(key);
  }
}
