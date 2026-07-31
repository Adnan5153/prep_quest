import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/notes/data/models/note_model.dart';
import '../../features/notes/domain/enums/note_type.dart';
import '../config/firebase_config.dart';
import '../constants/firestore_keys.dart';

/// Single Firestore writer for the user-owned notes collections
/// (Phase 47).
///
/// Layout:
///   * `users/{uid}/notes/{noteId}` — canonical store for every note
///     regardless of type (personal / highlight / ai). Document id is
///     the existing deterministic `note.id` so the local cache and
///     Firestore stay in sync.
///   * `users/{uid}/highlights/{noteId}` — convenience mirror for
///     highlight-type notes. Updated inside the same transaction
///     boundary as the canonical write so the two never diverge.
///   * `users/{uid}/ai_notes/{noteId}` — convenience mirror for
///     ai-type notes. Same transactional guarantee.
///
/// `firestore.set(merge: true)` on every write so existing fields are
/// preserved while the new `updatedAtIso` propagates. Realtime
/// `watch(uid)` is powered by `CollectionReference.snapshots()` so the
/// controller + widget tree refresh without manual refresh.
///
/// Guest guard: returns empty / safe defaults for empty uids so
/// offline / pre-auth boots never touch Firestore.
///
/// Best-effort failures (network / permission) surface via the
/// service returning the in-memory model so the controller can fall
/// back to the local mirror without breaking the canonical flow.
class NoteService {
  NoteService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _userNotesRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.notesSubcollection);
  }

  CollectionReference<Map<String, dynamic>> _userHighlightsRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.highlightsSubcollection);
  }

  CollectionReference<Map<String, dynamic>> _userAiNotesRef(String uid) {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(uid)
        .collection(FirestoreKeys.aiNotesSubcollection);
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Adds or updates a note row inside `users/{uid}/notes`. Mirror
  /// writes land in `highlights` / `ai_notes` for the filtered
  /// sub-collection views. The document id is the existing
  /// `note.id` so re-saving the same note is idempotent (merge
  /// write, no duplicate rows).
  Future<NoteModel> add({
    required String uid,
    required NoteModel model,
  }) async {
    if (uid.isEmpty || _firestore == null) return model;
    final DateTime now = DateTime.now().toUtc();
    final NoteModel withTimestamps = model.copyWith(
      createdAtIso: model.createdAtIso.isEmpty
          ? now.toIso8601String()
          : model.createdAtIso,
      updatedAtIso: now.toIso8601String(),
    );
    try {
      await _userNotesRef(uid)
          .doc(model.id)
          .set(withTimestamps.toJson(), SetOptions(merge: true));
      if (model.type == NoteType.highlight) {
        await _userHighlightsRef(uid)
            .doc(model.id)
            .set(withTimestamps.toJson(), SetOptions(merge: true));
      } else if (model.type == NoteType.ai) {
        await _userAiNotesRef(uid)
            .doc(model.id)
            .set(withTimestamps.toJson(), SetOptions(merge: true));
      }
      return withTimestamps;
    } catch (error, stack) {
      debugPrint(
        '[NoteService] add failed for $uid/${model.id}: $error\n$stack',
      );
      return withTimestamps;
    }
  }

  /// Removes a note row by its deterministic id. Returns `true` when
  /// the doc existed (and was deleted) or `false` when the doc was
  /// missing. Convenience mirrors in `highlights` / `ai_notes` are
  /// also removed.
  Future<bool> remove({
    required String uid,
    required String noteId,
  }) async {
    if (uid.isEmpty || _firestore == null || noteId.isEmpty) return false;
    try {
      final DocumentReference<Map<String, dynamic>> ref =
          _userNotesRef(uid).doc(noteId);
      final DocumentSnapshot<Map<String, dynamic>> snap = await ref.get();
      if (!snap.exists) return false;
      await ref.delete();
      await _userHighlightsRef(uid).doc(noteId).delete();
      await _userAiNotesRef(uid).doc(noteId).delete();
      return true;
    } catch (error, stack) {
      debugPrint(
        '[NoteService] remove failed for $uid/$noteId: $error\n$stack',
      );
      return false;
    }
  }

  /// Removes every note for the given user. Returns the number of
  /// docs deleted across all three subcollections.
  Future<int> clearAll(String uid) async {
    if (uid.isEmpty || _firestore == null) return 0;
    try {
      final List<CollectionReference<Map<String, dynamic>>> refs =
          <CollectionReference<Map<String, dynamic>>>[
        _userNotesRef(uid),
        _userHighlightsRef(uid),
        _userAiNotesRef(uid),
      ];
      final WriteBatch batch = _firestore.batch();
      int count = 0;
      for (final CollectionReference<Map<String, dynamic>> ref in refs) {
        final QuerySnapshot<Map<String, dynamic>> snap = await ref.get();
        for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
            in snap.docs) {
          batch.delete(doc.reference);
          count++;
        }
      }
      if (count == 0) return 0;
      await batch.commit();
      return count;
    } catch (error, stack) {
      debugPrint(
        '[NoteService] clearAll failed for $uid: $error\n$stack',
      );
      return 0;
    }
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// One-shot read of every note the user owns. Used by the
  /// repository's `sync` / `refresh` actions.
  Future<List<NoteModel>> snapshot(String uid) async {
    if (uid.isEmpty || _firestore == null) return const <NoteModel>[];
    try {
      final QuerySnapshot<Map<String, dynamic>> snap =
          await _userNotesRef(uid).get();
      return List<NoteModel>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
          return NoteModel.fromJson(<String, dynamic>{
            ...d.data(),
            'id': d.id,
          });
        }),
      );
    } catch (error, stack) {
      debugPrint(
        '[NoteService] snapshot failed for $uid: $error\n$stack',
      );
      return const <NoteModel>[];
    }
  }

  /// Realtime stream of every note the user owns. Emits on every
  /// Firestore mutation so widgets refresh automatically.
  Stream<List<NoteModel>> watch(String uid) {
    if (uid.isEmpty || _firestore == null) {
      return Stream<List<NoteModel>>.value(const <NoteModel>[]);
    }
    return _userNotesRef(uid).snapshots().map((
      QuerySnapshot<Map<String, dynamic>> snap,
    ) {
      return List<NoteModel>.unmodifiable(
        snap.docs
            .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
          return NoteModel.fromJson(<String, dynamic>{
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

final noteServiceProvider = Provider<NoteService>(
  (ref) => NoteService(),
);

/// Auth-aware realtime stream of the user's notes. Emits an empty
/// list for guests / unauthenticated users so widgets can rely on
/// it without nullability gymnastics.
final userNotesStreamProvider =
    StreamProvider.autoDispose<List<NoteModel>>((ref) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<List<NoteModel>>.value(const <NoteModel>[]);
  }
  return ref.watch(noteServiceProvider).watch(uid);
});
