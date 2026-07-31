import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/settings/data/models/settings_model.dart';
import '../config/firebase_config.dart';
import '../constants/firestore_keys.dart';

/// Firestore writer for the user-owned settings subcollection
/// (Phase 48).
///
/// Layout:
///   * `users/{uid}/settings/{docId}` — one doc per settings slice.
///     Today the only slice is
///     `notification_preferences` (keyed by
///     [FirestoreKeys.notificationPreferencesDoc]) — the broader
///     theme / language / accessibility / privacy settings continue
///     to live on-device and don't need a backend mirror.
///
/// Best-effort failures (network / permission) surface via
/// `debugPrint` + safe returns so the controller can fall back to
/// the local mirror without breaking the canonical flow.
class SettingsService {
  SettingsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  DocumentReference<Map<String, dynamic>> _prefsRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.settingsSubcollection)
        .doc(FirestoreKeys.notificationPreferencesDoc);
  }

  /// Persists the notification-preferences slice of [SettingsModel]
  /// under `users/{uid}/settings/notification_preferences`. Merge
  /// write so unrelated sub-keys (if added later) are preserved.
  Future<bool> saveNotificationPreferences({
    required String uid,
    required SettingsModel model,
  }) async {
    if (uid.isEmpty || _firestore == null) return false;
    try {
      final Map<String, dynamic> payload = <String, dynamic>{
        'notifications': model.notifications.toMap(),
        'updatedAtIso': DateTime.now().toUtc().toIso8601String(),
      };
      await _prefsRef(uid).set(payload, SetOptions(merge: true));
      return true;
    } catch (error, stack) {
      debugPrint(
        '[SettingsService] saveNotificationPreferences failed for $uid: '
        '$error\n$stack',
      );
      return false;
    }
  }

  /// Reads the notification-preferences slice. Returns `null` when
  /// no doc exists yet (fresh device) or Firestore is unreachable.
  Future<Map<String, dynamic>?> loadNotificationPreferences(String uid) async {
    if (uid.isEmpty || _firestore == null) return null;
    try {
      final DocumentSnapshot<Map<String, dynamic>> snap =
          await _prefsRef(uid).get();
      if (!snap.exists) return null;
      return snap.data();
    } catch (error, stack) {
      debugPrint(
        '[SettingsService] loadNotificationPreferences failed for $uid: '
        '$error\n$stack',
      );
      return null;
    }
  }

  /// Realtime stream of the notification-preferences slice. Emits on
  /// every Firestore mutation so the controller can react (e.g.
  /// another device toggled push reminders).
  Stream<Map<String, dynamic>?> watchNotificationPreferences(String uid) {
    if (uid.isEmpty || _firestore == null) {
      return Stream<Map<String, dynamic>?>.value(null);
    }
    return _prefsRef(uid).snapshots().map((
      DocumentSnapshot<Map<String, dynamic>> snap,
    ) {
      return snap.exists ? snap.data() : null;
    });
  }
}

final settingsServiceProvider = Provider<SettingsService>(
  (ref) => SettingsService(),
);

/// Auth-aware realtime stream of the user's notification
/// preferences. Emits `null` for guests / unauthenticated users so
/// widgets can rely on it without nullability gymnastics.
final userNotificationPreferencesStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>?>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<Map<String, dynamic>?>.value(null);
  }
  return ref.watch(settingsServiceProvider).watchNotificationPreferences(uid);
});