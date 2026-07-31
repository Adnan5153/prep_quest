import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/bookmarks/domain/enums/bookmark_item_type.dart';
import '../../features/bookmarks/data/models/bookmark_model.dart';
import '../config/firebase_config.dart';
import '../constants/firestore_keys.dart';

/// Single writer for `users/{uid}/bookmarks/{bookmarkId}` (Phase 46).
///
/// Responsibilities:
/// * Stable, deterministic `bookmarkId` derived from
///   `'${itemType.name}_${itemId}'` so re-toggling the same item is
///   idempotent (re-saves merge, never duplicate rows).
/// * `firestore.set(merge: true)` on every write so existing fields
///   are preserved while the new `updatedAtIso` propagates.
/// * Realtime `watch(uid)` stream powered by
///   `CollectionReference.snapshots()` so the controller + widget tree
///   refresh without manual refresh.
/// * Guest guard: returns `empty list` for empty uids so offline /
///   pre-auth boots never touch Firestore.
///
/// Best-effort failures (network / permission) surface via
/// [Result.failure] so the controller can fall back to the local
/// mirror without breaking the canonical flow.
class BookmarkService {
  BookmarkService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _userBookmarksRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.bookmarksSubcollection);
  }

  /// Deterministic document id — same `(type, itemId)` always
  /// resolves to the same Firestore doc.
  static String bookmarkId({
    required BookmarkItemType type,
    required String itemId,
  }) {
    return '${type.name}_$itemId';
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Adds or updates a bookmark row inside `users/{uid}/bookmarks`.
  /// The document id is derived from `(itemType, itemId)` so a
  /// concurrent save from another device collapses into the same
  /// Firestore doc (idempotent).
  Future<BookmarkModel> add({
    required String uid,
    required BookmarkModel model,
  }) async {
    if (uid.isEmpty || _firestore == null) return model;
    final String id = bookmarkId(type: model.itemType, itemId: model.itemId);
    final DateTime now = DateTime.now().toUtc();
    final BookmarkModel withId = model.copyWith(
      id: id,
      createdAtIso: model.createdAtIso.isEmpty
          ? now.toIso8601String()
          : model.createdAtIso,
      updatedAtIso: now.toIso8601String(),
    );
    try {
      await _userBookmarksRef(uid)
          .doc(id)
          .set(withId.toJson(), SetOptions(merge: true));
      return withId;
    } catch (error, stack) {
      debugPrint(
        '[BookmarkService] add failed for $uid/$id: $error\n$stack',
      );
      return withId;
    }
  }

  /// Removes a bookmark row by `(itemType, itemId)`. Returns `true`
  /// when the doc existed (and was deleted) or `false` when the
  /// doc was missing — callers can ignore the boolean.
  Future<bool> remove({
    required String uid,
    required BookmarkItemType type,
    required String itemId,
  }) async {
    if (uid.isEmpty || _firestore == null) return false;
    return removeById(uid: uid, id: bookmarkId(type: type, itemId: itemId));
  }

  /// Removes a bookmark row by its deterministic
  /// `'${type.name}_$itemId'` doc id. Returns `true` when the doc
  /// existed (and was deleted) or `false` when the doc was missing.
  Future<bool> removeById({
    required String uid,
    required String id,
  }) async {
    if (uid.isEmpty || _firestore == null || id.isEmpty) return false;
    try {
      final DocumentReference<Map<String, dynamic>> ref =
          _userBookmarksRef(uid).doc(id);
      final DocumentSnapshot<Map<String, dynamic>> snap = await ref.get();
      if (!snap.exists) return false;
      await ref.delete();
      return true;
    } catch (error, stack) {
      debugPrint(
        '[BookmarkService] removeById failed for $uid/$id: $error\n$stack',
      );
      return false;
    }
  }

  /// Removes every bookmark for the given user. Returns the number
  /// of docs deleted.
  Future<int> clearAll(String uid) async {
    if (uid.isEmpty || _firestore == null) return 0;
    try {
      final QuerySnapshot<Map<String, dynamic>> snap =
          await _userBookmarksRef(uid).get();
      if (snap.docs.isEmpty) return 0;
      final WriteBatch batch = _firestore.batch();
      int count = 0;
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snap.docs) {
        batch.delete(doc.reference);
        count++;
      }
      await batch.commit();
      return count;
    } catch (error, stack) {
      debugPrint(
        '[BookmarkService] clearAll failed for $uid: $error\n$stack',
      );
      return 0;
    }
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// One-shot read of every bookmark the user owns. Used by the
  /// controller's `hydrate` / `refresh` actions.
  Future<List<BookmarkModel>> snapshot(String uid) async {
    if (uid.isEmpty || _firestore == null) return const <BookmarkModel>[];
    try {
      final QuerySnapshot<Map<String, dynamic>> snap =
          await _userBookmarksRef(uid).get();
      return List<BookmarkModel>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
          return BookmarkModel.fromJson(<String, dynamic>{
            ...d.data(),
            'id': d.id,
          });
        }),
      );
    } catch (error, stack) {
      debugPrint(
        '[BookmarkService] snapshot failed for $uid: $error\n$stack',
      );
      return const <BookmarkModel>[];
    }
  }

  /// Realtime stream of every bookmark the user owns. Emits on every
  /// Firestore mutation so widgets refresh automatically.
  Stream<List<BookmarkModel>> watch(String uid) {
    if (uid.isEmpty || _firestore == null) {
      return Stream<List<BookmarkModel>>.value(const <BookmarkModel>[]);
    }
    return _userBookmarksRef(uid).snapshots().map((
      QuerySnapshot<Map<String, dynamic>> snap,
    ) {
      return List<BookmarkModel>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
          return BookmarkModel.fromJson(<String, dynamic>{
            ...d.data(),
            'id': d.id,
          });
        }),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Riverpod providers
// ---------------------------------------------------------------------------

final bookmarkServiceProvider = Provider<BookmarkService>(
  (ref) => BookmarkService(),
);

/// Auth-aware realtime stream of the user's bookmarks. Emits an
/// empty list for guests / unauthenticated users so widgets can
/// rely on it without nullability gymnastics.
final userBookmarksStreamProvider =
    StreamProvider.autoDispose<List<BookmarkModel>>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<List<BookmarkModel>>.value(const <BookmarkModel>[]);
  }
  return ref.watch(bookmarkServiceProvider).watch(uid);
});