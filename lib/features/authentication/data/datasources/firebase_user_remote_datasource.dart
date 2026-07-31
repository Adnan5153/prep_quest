import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import 'user_remote_datasource.dart';

/// Firestore implementation of [UserRemoteDataSource].
///
/// Owns the `users/{uid}` top-level document. All auth flows funnel
/// through here so the document layout and merge semantics live in
/// exactly one place; the profile feature, Cloud Functions, and admin
/// tooling can subscribe to [watchUser] for realtime updates.
class FirestoreUserRemoteDataSource implements UserRemoteDataSource {
  const FirestoreUserRemoteDataSource();

  FirebaseFirestore get _firestore =>
      FirebaseConfig.firestore ??
      (throw StateError('Firestore is not configured.'));

  bool get _enabled => FirebaseConfig.isPlatformConfigured;

  DocumentReference<Map<String, dynamic>> _doc(String uid) {
    return _firestore.collection(FirestoreKeys.users).doc(uid);
  }

  @override
  Future<UserEntity> ensureUserDocument({
    required String uid,
    required Map<String, dynamic> seed,
    required Map<String, dynamic> merge,
  }) async {
    if (!_enabled) {
      return _modelFromMap(<String, dynamic>{
        'uid': uid,
        ...seed,
        ...merge,
      });
    }
    final DocumentReference<Map<String, dynamic>> ref = _doc(uid);
    DocumentSnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await ref.get();
    } catch (_) {
      snapshot = await _upsertSeed(ref, seed, merge);
      return _modelFromMap(snapshot.data() ?? <String, dynamic>{});
    }
    if (!snapshot.exists) {
      snapshot = await _upsertSeed(ref, seed, merge);
      return _modelFromMap(snapshot.data() ?? <String, dynamic>{});
    }
    // Apply the merge patch so district / phoneNumber / displayName /
    // examTrack updates persist. Errors propagate so callers learn about
    // permission / network failures instead of seeing stale Firestore
    // state.
    if (merge.isNotEmpty) {
      await ref.set(merge, SetOptions(merge: true));
    }
    final DocumentSnapshot<Map<String, dynamic>> refreshed =
        await ref.get();
    return _modelFromMap(<String, dynamic>{
      'id': uid,
      ...?refreshed.data(),
    });
  }

  @override
  Future<void> mergeUserDocument({
    required String uid,
    required Map<String, dynamic> patch,
  }) async {
    if (!_enabled || patch.isEmpty) return;
    try {
      await _doc(uid).set(patch, SetOptions(merge: true));
    } catch (_) {/* best-effort merge — auth still works offline */}
  }

  @override
  Stream<UserEntity?> watchUser(String uid) async* {
    if (!_enabled) {
      yield null;
      return;
    }
    yield await fetchUser(uid);
    yield* _doc(uid)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snap) {
      if (!snap.exists || snap.data() == null) return null;
      return _modelFromMap(snap.data()!);
    });
  }

  @override
  Future<UserEntity?> fetchUser(String uid) async {
    if (!_enabled) return null;
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _doc(uid).get();
    if (!snapshot.exists) return null;
    return _modelFromMap(snapshot.data() ?? <String, dynamic>{});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _upsertSeed(
    DocumentReference<Map<String, dynamic>> ref,
    Map<String, dynamic> seed,
    Map<String, dynamic> merge,
  ) async {
    await ref.set(seed, SetOptions(merge: true));
    if (merge.isNotEmpty) {
      await ref.set(merge, SetOptions(merge: true));
    }
    return ref.get();
  }

  UserEntity _modelFromMap(Map<String, dynamic> data) {
    final String uid = data['uid'] as String? ??
        (data['id'] as String? ?? '');
    return UserModel.fromMap(<String, dynamic>{'id': uid, ...data}, uid)
        .toEntity();
  }
}
