import 'package:flutter/foundation.dart';

import '../../../../core/services/note_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../models/note_model.dart';

/// Firestore-backed note source of truth (Phase 47).
///
/// All writes go through [NoteService] which owns the
/// `users/{uid}/notes/{noteId}` collection (plus the convenience
/// `highlights` / `ai_notes` mirrors).
///
/// `pull()` / `push()` are preserved so the existing repository
/// contract keeps compiling; internally they delegate to
/// [NoteService] one-shot reads and merge-writes so the local cache
/// mirrors Firestore after every [sync].
class NotesRemoteDatasource {
  NotesRemoteDatasource({
    required this.service,
    required this.uidProvider,
  });

  final NoteService service;

  /// Resolves the authenticated uid (empty string = guest).
  final String Function() uidProvider;

  /// One-shot read used by `NotesRepositoryImpl.sync()` to seed the
  /// local cache from Firestore.
  Future<List<NoteModel>> pull() async {
    final String uid = uidProvider();
    if (uid.isEmpty) return const <NoteModel>[];
    return service.snapshot(uid);
  }

  /// Push is a no-op for the canonical Firestore flow — every write
  /// is already persisted by [NoteService] inside the repository.
  /// We keep the signature so the contract stays intact for tests +
  /// legacy callers.
  Future<void> push(List<NoteModel> items) async {
    final String uid = uidProvider();
    if (uid.isEmpty || items.isEmpty) return;
    try {
      for (final NoteModel model in items) {
        await service.add(uid: uid, model: model);
      }
    } catch (error, stack) {
      debugPrint(
        '[NotesRemoteDatasource] push reconcile failed: $error\n$stack',
      );
    }
  }

  /// Per-item upsert used by `NotesRepositoryImpl.createNote` and
  /// `updateNote`. Returns the persisted model so the local cache
  /// can mirror the canonical updatedAtIso.
  Future<Result<NoteModel>> upsert(NoteModel model) async {
    final String uid = uidProvider();
    if (uid.isEmpty) return Result<NoteModel>.success(model);
    final NoteModel persisted = await service.add(uid: uid, model: model);
    return Result<NoteModel>.success(persisted);
  }

  /// Per-item delete used by `NotesRepositoryImpl.deleteNote`.
  /// Returns `true` when the doc existed (and was deleted).
  Future<Result<bool>> removeById(String id) async {
    final String uid = uidProvider();
    if (uid.isEmpty || id.isEmpty) return const Result<bool>.success(false);
    final bool removed = await service.remove(uid: uid, noteId: id);
    return Result<bool>.success(removed);
  }

  /// Wipes every note (and the highlights / ai_notes mirrors) for
  /// the current user.
  Future<Result<int>> clearAll() async {
    final String uid = uidProvider();
    if (uid.isEmpty) return const Result<int>.success(0);
    final int count = await service.clearAll(uid);
    return Result<int>.success(count);
  }
}
