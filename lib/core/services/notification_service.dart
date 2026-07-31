import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/notifications/data/models/notification_model.dart';
import '../config/firebase_config.dart';
import '../constants/firestore_keys.dart';

/// Single Firestore writer for the user-owned notifications + FCM
/// token registration (Phase 48).
///
/// Layout:
///   * `users/{uid}/notifications/{notificationId}` — canonical inbox
///     for every notification. Document id is auto-generated unless
///     the caller supplies one (Cloud Functions do so for
///     deterministic cross-device dedup).
///   * `users/{uid}/fcm_tokens/{deviceId}` — one doc per registered
///     device. Supports multiple devices per user (phone + tablet).
///     `deviceId` is a stable per-install identifier surfaced by the
///     platform's FCM SDK (or a hash fallback when the SDK is not
///     wired yet).
///
/// `firestore.set(merge: true)` on every write so existing fields are
/// preserved while the new state propagates. Realtime
/// `watch(uid)` is powered by `CollectionReference.snapshots()` so
/// the controller + widget tree refresh without manual refresh.
///
/// Guest guard: returns empty / safe defaults for empty uids so
/// offline / pre-auth boots never touch Firestore.
///
/// Best-effort failures (network / permission) surface via
/// `debugPrint` + safe returns so the controller can fall back to
/// the local mirror without breaking the canonical flow.
class NotificationService {
  NotificationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _userNotificationsRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.notificationsSubcollection);
  }

  CollectionReference<Map<String, dynamic>> _userTokensRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.fcmTokensSubcollection);
  }

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  /// Adds or updates a notification row inside
  /// `users/{uid}/notifications`. Auto-generates a document id when
  /// [NotificationModel.id] is empty; otherwise merges into the
  /// existing row (idempotent for deterministic ids).
  Future<NotificationModel> upsert({
    required String uid,
    required NotificationModel model,
  }) async {
    if (uid.isEmpty || _firestore == null) return model;
    final DateTime now = DateTime.now().toUtc();
    final String docId = model.id.isEmpty
        ? _userNotificationsRef(uid).doc().id
        : model.id;
    final NotificationModel persisted = NotificationModel(
      id: docId,
      title: model.title,
      message: model.message,
      createdAtIso:
          model.createdAtIso.isEmpty ? now.toIso8601String() : model.createdAtIso,
      routeName: model.routeName,
      isRead: model.isRead,
      type: model.type,
      imageUrl: model.imageUrl,
      deepLink: model.deepLink,
      priority: model.priority,
      expiresAtIso: model.expiresAtIso,
      payload: model.payload,
    );
    try {
      await _userNotificationsRef(uid)
          .doc(docId)
          .set(persisted.toJson(), SetOptions(merge: true));
      return persisted;
    } catch (error, stack) {
      debugPrint(
        '[NotificationService] upsert failed for $uid/$docId: $error\n$stack',
      );
      return persisted;
    }
  }

  /// Marks a single notification as read.
  Future<bool> markAsRead({
    required String uid,
    required String notificationId,
  }) async {
    if (uid.isEmpty || _firestore == null || notificationId.isEmpty) {
      return false;
    }
    try {
      await _userNotificationsRef(uid)
          .doc(notificationId)
          .set(<String, dynamic>{'isRead': true}, SetOptions(merge: true));
      return true;
    } catch (error, stack) {
      debugPrint(
        '[NotificationService] markAsRead failed for $uid/$notificationId: '
        '$error\n$stack',
      );
      return false;
    }
  }

  /// Marks every notification as read via a WriteBatch. Returns the
  /// count actually flipped.
  Future<int> markAllAsRead(String uid) async {
    if (uid.isEmpty || _firestore == null) return 0;
    try {
      final QuerySnapshot<Map<String, dynamic>> snap =
          await _userNotificationsRef(uid).get();
      if (snap.docs.isEmpty) return 0;
      final WriteBatch batch = _firestore.batch();
      int count = 0;
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snap.docs) {
        final Map<String, dynamic> data = doc.data();
        if (data['isRead'] == true) continue;
        batch.set(doc.reference, <String, dynamic>{'isRead': true},
            SetOptions(merge: true));
        count++;
      }
      if (count == 0) return 0;
      await batch.commit();
      return count;
    } catch (error, stack) {
      debugPrint(
        '[NotificationService] markAllAsRead failed for $uid: $error\n$stack',
      );
      return 0;
    }
  }

  /// Removes a single notification by id. Returns `true` when the
  /// doc existed (and was deleted).
  Future<bool> remove({
    required String uid,
    required String notificationId,
  }) async {
    if (uid.isEmpty || _firestore == null || notificationId.isEmpty) {
      return false;
    }
    try {
      final DocumentReference<Map<String, dynamic>> ref =
          _userNotificationsRef(uid).doc(notificationId);
      final DocumentSnapshot<Map<String, dynamic>> snap = await ref.get();
      if (!snap.exists) return false;
      await ref.delete();
      return true;
    } catch (error, stack) {
      debugPrint(
        '[NotificationService] remove failed for $uid/$notificationId: '
        '$error\n$stack',
      );
      return false;
    }
  }

  /// One-shot read of every notification the user owns. Used by the
  /// repository's `sync` / `refresh` actions.
  Future<List<NotificationModel>> snapshot(String uid) async {
    if (uid.isEmpty || _firestore == null) return const <NotificationModel>[];
    try {
      final QuerySnapshot<Map<String, dynamic>> snap =
          await _userNotificationsRef(uid).get();
      return List<NotificationModel>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
          return NotificationModel.fromJson(<String, dynamic>{
            ...d.data(),
            'id': d.id,
          });
        }),
      );
    } catch (error, stack) {
      debugPrint(
        '[NotificationService] snapshot failed for $uid: $error\n$stack',
      );
      return const <NotificationModel>[];
    }
  }

  /// Realtime stream of every notification the user owns. Emits on
  /// every Firestore mutation so widgets refresh automatically.
  Stream<List<NotificationModel>> watch(String uid) {
    if (uid.isEmpty || _firestore == null) {
      return Stream<List<NotificationModel>>.value(const <NotificationModel>[]);
    }
    return _userNotificationsRef(uid).snapshots().map((
      QuerySnapshot<Map<String, dynamic>> snap,
    ) {
      return List<NotificationModel>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
          return NotificationModel.fromJson(<String, dynamic>{
            ...d.data(),
            'id': d.id,
          });
        }),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // FCM token registration
  // ---------------------------------------------------------------------------

  /// Registers (or refreshes) a device's FCM token inside
  /// `users/{uid}/fcm_tokens/{deviceId}`. Idempotent: re-registering
  /// the same token just merges `lastSeenAtIso`. Multiple devices
  /// per user are supported.
  Future<bool> registerToken({
    required String uid,
    required String deviceId,
    required String token,
    String? platform,
    Map<String, dynamic>? metadata,
  }) async {
    if (uid.isEmpty || _firestore == null) return false;
    if (deviceId.isEmpty || token.isEmpty) return false;
    try {
      final Map<String, dynamic> payload = <String, dynamic>{
        'token': token,
        'platform': platform ?? 'unknown',
        'registeredAtIso': DateTime.now().toUtc().toIso8601String(),
        'lastSeenAtIso': DateTime.now().toUtc().toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      };
      await _userTokensRef(uid)
          .doc(deviceId)
          .set(payload, SetOptions(merge: true));
      return true;
    } catch (error, stack) {
      debugPrint(
        '[NotificationService] registerToken failed for $uid/$deviceId: '
        '$error\n$stack',
      );
      return false;
    }
  }

  /// Removes a device token (sign-out cleanup). Returns `true` when
  /// the doc existed (and was deleted).
  Future<bool> unregisterToken({
    required String uid,
    required String deviceId,
  }) async {
    if (uid.isEmpty || _firestore == null || deviceId.isEmpty) return false;
    try {
      final DocumentReference<Map<String, dynamic>> ref =
          _userTokensRef(uid).doc(deviceId);
      final DocumentSnapshot<Map<String, dynamic>> snap = await ref.get();
      if (!snap.exists) return false;
      await ref.delete();
      return true;
    } catch (error, stack) {
      debugPrint(
        '[NotificationService] unregisterToken failed for $uid/$deviceId: '
        '$error\n$stack',
      );
      return false;
    }
  }

  /// Realtime stream of the user's registered device tokens. Used by
  /// the FCM bootstrap to detect token rotation events.
  Stream<List<Map<String, dynamic>>> watchTokens(String uid) {
    if (uid.isEmpty || _firestore == null) {
      return Stream<List<Map<String, dynamic>>>.value(
        const <Map<String, dynamic>>[],
      );
    }
    return _userTokensRef(uid).snapshots().map((
      QuerySnapshot<Map<String, dynamic>> snap,
    ) {
      return List<Map<String, dynamic>>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) =>
                <String, dynamic>{'deviceId': d.id, ...d.data()}),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------
}

// ---------------------------------------------------------------------------
// Riverpod providers
// ---------------------------------------------------------------------------

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

/// Auth-aware realtime stream of the user's notifications. Emits an
/// empty list for guests / unauthenticated users so widgets can rely
/// on it without nullability gymnastics.
final userNotificationsStreamProvider =
    StreamProvider.autoDispose<List<NotificationModel>>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<List<NotificationModel>>.value(const <NotificationModel>[]);
  }
  return ref.watch(notificationServiceProvider).watch(uid);
});