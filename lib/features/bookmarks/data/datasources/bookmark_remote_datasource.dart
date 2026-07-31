import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/services/bookmark_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/enums/bookmark_item_type.dart';
import '../models/bookmark_model.dart';

/// Firestore-backed bookmark source of truth (Phase 46).
///
/// All writes go through [BookmarkService] which owns the
/// `users/{uid}/bookmarks/{bookmarkId}` collection and uses
/// deterministic ids so re-toggling the same `(type, itemId)` is
/// idempotent.
///
/// `pull()` / `push()` are preserved so the existing repository
/// contract keeps compiling; internally they delegate to
/// [BookmarkService] one-shot reads and merge-writes so the local
/// cache mirrors Firestore after every [sync].
class BookmarkRemoteDataSource {
  BookmarkRemoteDataSource({
    required this.service,
    required this.uidProvider,
  });

  /// Single writer service — owns the canonical Firestore schema.
  final BookmarkService service;

  /// Resolves the authenticated uid (empty string = guest).
  final String Function() uidProvider;

  /// One-shot read used by `BookmarkRepositoryImpl.sync()` to seed
  /// the local cache from Firestore.
  Future<List<BookmarkModel>> pull() async {
    final String uid = uidProvider();
    if (uid.isEmpty) return const <BookmarkModel>[];
    final List<BookmarkModel> rows = await service.snapshot(uid);
    return List<BookmarkModel>.unmodifiable(rows);
  }

  /// Push is a no-op for the canonical Firestore flow — every write
  /// is already persisted by [BookmarkService] inside the
  /// repository. We keep the signature so the contract stays intact
  /// for tests + legacy callers and forward a best-effort reconcile
  /// (the local mirror is authoritative for the UI).
  Future<void> push(List<BookmarkModel> items) async {
    final String uid = uidProvider();
    if (uid.isEmpty || items.isEmpty) return;
    try {
      for (final BookmarkModel model in items) {
        await service.add(uid: uid, model: model);
      }
    } catch (error, stack) {
      debugPrint(
        '[BookmarkRemoteDataSource] push reconcile failed: $error\n$stack',
      );
    }
  }

  /// Per-item upsert used by `BookmarkRepositoryImpl.addBookmark`.
  /// Returns the deterministic id so the local cache can mirror it.
  Future<Result<String>> upsert(BookmarkModel model) async {
    final String uid = uidProvider();
    if (uid.isEmpty) {
      return Result<String>.success(model.id);
    }
    final BookmarkModel persisted = await service.add(uid: uid, model: model);
    return Result<String>.success(persisted.id);
  }

  /// Per-item delete used by `BookmarkRepositoryImpl.removeBookmark`.
  /// Returns `true` when the doc existed (and was deleted).
  Future<Result<bool>> removeById(String id) async {
    final String uid = uidProvider();
    if (uid.isEmpty || id.isEmpty) return const Result<bool>.success(false);
    final bool removed = await service.removeById(uid: uid, id: id);
    return Result<bool>.success(removed);
  }

  /// Per-item delete used by `BookmarkRepositoryImpl.removeEntity`.
  Future<Result<bool>> remove({
    required BookmarkItemType type,
    required String itemId,
  }) async {
    final String uid = uidProvider();
    if (uid.isEmpty || itemId.isEmpty) return const Result<bool>.success(false);
    final bool removed = await service.remove(uid: uid, type: type, itemId: itemId);
    return Result<bool>.success(removed);
  }

  /// Wipes every bookmark for the current user.
  Future<Result<int>> clearAll() async {
    final String uid = uidProvider();
    if (uid.isEmpty) return const Result<int>.success(0);
    final int count = await service.clearAll(uid);
    return Result<int>.success(count);
  }
}
