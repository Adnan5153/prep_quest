import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/security/auth_precondition.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_filter.dart';
import '../../domain/enums/bookmark_item_type.dart';
import '../../domain/enums/bookmark_sort.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_datasource.dart';
import '../datasources/bookmark_remote_datasource.dart';
import '../models/bookmark_model.dart';

/// Concrete [BookmarkRepository] with Firestore-first behaviour and
/// an in-memory cache for offline reads + filter/sort/search queries.
///
/// Phase 46 — every write is forwarded to [BookmarkRemoteDataSource]
/// which delegates to [BookmarkService] (the single writer for the
/// `users/{uid}/bookmarks` subcollection). Realtime updates flow
/// back through [remoteStreamFactory] and overwrite the local cache
/// so the controller + widgets refresh without a manual pull.
///
/// Phase 51 — every mutating method enforces an authenticated
/// precondition via [AuthGuard] before delegating to the
/// remote data source. The local mirror still updates for
/// in-session responsiveness, but Firestore writes are blocked
/// for guests.
class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl({
    required this.local,
    required BookmarkRemoteDataSource remote,
    Stream<List<BookmarkModel>> Function()? remoteStreamFactory,
    this.preferRemote = true,
    required Ref ref,
  })  : _remote = remote,
        _remoteStreamFactory = remoteStreamFactory,
        _guard = AuthGuard(ref) {
    _subscribeToRemote();
  }

  final BookmarkLocalDataSource local;
  final BookmarkRemoteDataSource _remote;
  final Stream<List<BookmarkModel>> Function()? _remoteStreamFactory;
  final bool preferRemote;
  final AuthGuard _guard;

  StreamSubscription<List<BookmarkModel>>? _remoteSubscription;

  void _subscribeToRemote() {
    final Stream<List<BookmarkModel>> Function()? factory =
        _remoteStreamFactory;
    if (factory == null) return;
    _remoteSubscription = factory().listen(
      (List<BookmarkModel> rows) {
        local.writeAll(rows);
        developer.log(
          '[BookmarkRepository] remote snapshot: ${rows.length} rows',
          name: 'BookmarkRepository',
        );
      },
      onError: (Object e, StackTrace st) {
        developer.log(
          '[BookmarkRepository] remote stream error: $e',
          error: e,
          stackTrace: st,
          name: 'BookmarkRepository',
        );
      },
    );
  }

  @override
  Future<Result<List<BookmarkEntity>>> getBookmarks({
    BookmarkFilter filter = BookmarkFilter.all,
    BookmarkSort sort = BookmarkSort.newest,
    String? query,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final List<BookmarkModel> rows = local.query(
        filter: filter,
        sort: sort,
        search: query,
        offset: offset,
        limit: limit,
      );
      return Result.success(_entities(rows));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<BookmarkEntity>> addBookmark(BookmarkEntity entity) async {
    try {
      _guard.assertAuthenticated();
      final String id = BookmarkServiceLike.bookmarkId(
        type: entity.itemType,
        itemId: entity.itemId,
      );
      final DateTime now = entity.createdAt ?? DateTime.now();
      final BookmarkModel model = BookmarkModel.fromEntity(
        entity.copyWith(
          id: id,
          createdAt: now,
          updatedAt: now,
        ),
      );
      local.writeOne(model);
      final Result<String> remoteResult = await _remote.upsert(model);
      if (remoteResult.isFailure) {
        developer.log(
          '[BookmarkRepository] upsert failed (cache-only): '
          '${remoteResult.failureOrNull?.message}',
          name: 'BookmarkRepository',
        );
      }
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> removeBookmark(String id) async {
    try {
      _guard.assertAuthenticated();
      final bool removed = local.removeOne(id);
      if (removed) {
        final Result<bool> remoteResult = await _remote.removeById(id);
        if (remoteResult.isFailure) {
          developer.log(
            '[BookmarkRepository] remove failed (cache-only): '
            '${remoteResult.failureOrNull?.message}',
            name: 'BookmarkRepository',
          );
        }
      }
      return const Result<void>.success(null);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<bool>> isBookmarked({
    required BookmarkItemType type,
    required String itemId,
  }) async {
    try {
      return Result.success(local.isBookmarked(type: type, itemId: itemId));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<String?>> findBookmarkId({
    required BookmarkItemType type,
    required String itemId,
  }) async {
    try {
      return Result<String?>.success(
        local.findId(type: type, itemId: itemId),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> clearAll() async {
    try {
      _guard.assertAuthenticated();
      local.clear();
      final Result<int> remoteResult = await _remote.clearAll();
      if (remoteResult.isFailure) {
        developer.log(
          '[BookmarkRepository] clearAll failed (cache-only): '
          '${remoteResult.failureOrNull?.message}',
          name: 'BookmarkRepository',
        );
      }
      return const Result<void>.success(null);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> sync() async {
    try {
      _guard.assertAuthenticated();
      if (preferRemote) {
        try {
          final List<BookmarkModel> rows = await _remote.pull();
          if (rows.isNotEmpty || local.readAll(limit: 1).isEmpty) {
            local.writeAll(rows);
          }
        } catch (e, st) {
          // Realtime subscription will reconcile; surface as success.
          developer.log(
            'Bookmark sync fell back to local mirror: $e',
            error: e,
            stackTrace: st,
            name: 'BookmarkRepository',
          );
        }
      }
      return const Result<void>.success(null);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  List<BookmarkEntity> _entities(List<BookmarkModel> rows) {
    return List<BookmarkEntity>.unmodifiable(
      rows.map((BookmarkModel row) => row.toEntity()),
    );
  }

  /// Cancels the realtime Firestore subscription. Called from
  /// `ref.onDispose` in the provider.
  void cancelRemoteSubscription() {
    _remoteSubscription?.cancel();
    _remoteSubscription = null;
  }
}

/// Thin facade so the repository can build the deterministic id
/// without importing the core service file (which lives outside the
/// feature). The implementation delegates to [BookmarkService].
class BookmarkServiceLike {
  const BookmarkServiceLike._();

  static String bookmarkId({
    required BookmarkItemType type,
    required String itemId,
  }) {
    return '${type.name}_$itemId';
  }
}
