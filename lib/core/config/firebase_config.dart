import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Centralised accessors for the live Firebase services.
///
/// Every feature that touches Firestore reads through this class so
/// feature code never imports `package:firebase_*` directly. The
/// accessors are null-safe — features must check [isPlatformConfigured]
/// before calling [firestore] to remain test-friendly (e.g. when the
/// Firebase platform plugin isn't initialised in unit tests).
///
/// `Firebase.initializeApp(...)` is invoked from
/// `lib/core/config/app_config.dart`'s `bootstrap` method (Phase 31
/// foundation). Until that has run, [isPlatformConfigured] returns
/// `false` and every accessor that returns a Firebase service returns
/// `null`. The behaviour matches the Phase 35 contract documented in
/// `docs/backendconnection/backend.mermaid`.
class FirebaseConfig {
  const FirebaseConfig._();

  /// Whether [Firebase.initializeApp] has run successfully on the
  /// current isolate. Unit tests and hot-reload sessions that start
  /// without bootstrapping Firebase will see this return `false`.
  static bool get isPlatformConfigured {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Returns the live [FirebaseFirestore] instance, or `null` if
  /// Firebase has not been initialised.
  static FirebaseFirestore? get firestore {
    if (!isPlatformConfigured) return null;
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }
}
