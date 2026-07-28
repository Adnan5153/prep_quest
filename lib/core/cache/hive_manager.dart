import 'package:hive_flutter/hive_flutter.dart';

/// Lifecycle manager for the Hive runtime.
///
/// Responsibilities:
///   1. Initialize the underlying Hive engine via [Hive.initFlutter],
///      which transparently picks the right directory for each platform
///      (mobile uses the application documents directory; web uses
///      IndexedDB).
///   2. Register every TypeAdapter the app needs. Registration is
///      idempotent — repeated calls during hot-restart are safe.
///   3. Expose typed boxes via [openBox] so call sites read like
///      `await HiveManager.instance.openBox<OfflineItemModel>('items')`
///      and get a real [Box] back.
///
/// The manager is intentionally a thin wrapper. Application code should
/// never call [Hive.openBox] directly — going through the manager keeps
/// registration + initialization ordering in one place.
class HiveManager {
  HiveManager._();

  static final HiveManager instance = HiveManager._();

  bool _initialized = false;

  /// Whether [initialize] has already run successfully.
  bool get isInitialized => _initialized;

  /// Initializes Hive and registers adapters.
  ///
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> initialize({
    List<AdapterRegistrar> registrars = const <AdapterRegistrar>[],
  }) async {
    if (_initialized) return;

    await Hive.initFlutter();

    for (final AdapterRegistrar registrar in registrars) {
      registrar();
    }

    _initialized = true;
  }

  /// Registers a single TypeAdapter. Use inside [initialize] registrars
  /// or during early bootstrap before any box is opened.
  static void registerAdapter<T>(int typeId, TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter<T>(adapter);
    }
  }

  /// Returns the already-open box with [name], or throws if it hasn't
  /// been opened yet. Prefer [openBox] at startup.
  Box<T> box<T>(String name) {
    if (!Hive.isBoxOpen(name)) {
      throw StateError(
        'Box "$name" has not been opened yet. Call HiveManager.openBox first.',
      );
    }
    return Hive.box<T>(name);
  }

  /// Asynchronously opens the box with [name]. Idempotent.
  Future<Box<T>> openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return Hive.openBox<T>(name);
  }

  /// Closes the named box (no-op if it isn't open).
  Future<void> closeBox(String name) async {
    if (Hive.isBoxOpen(name)) {
      await Hive.box(name).close();
    }
  }

  /// Closes every box — call on logout / sign-out to clear user data.
  Future<void> closeAll() async {
    await Hive.close();
    _initialized = false;
  }
}

/// Function signature for adapter registration callbacks passed to
/// [HiveManager.initialize].
typedef AdapterRegistrar = void Function();