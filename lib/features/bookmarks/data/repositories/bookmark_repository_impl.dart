import 'dart:developer' as developer;

import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_filter.dart';
import '../../domain/enums/bookmark_item_type.dart';
import '../../domain/enums/bookmark_sort.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_datasource.dart';
import '../datasources/bookmark_remote_datasource.dart';
import '../models/bookmark_model.dart';

/// Concrete [BookmarkRepository] with remote-first local fallback.
class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl({
    required this.local,
    this.remote,
    this.preferRemote = false,
  });

  final BookmarkLocalDataSource local;
  final BookmarkRemoteDataSource? remote;
  final bool preferRemote;

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
      final String id = local.findId(
            type: entity.itemType,
            itemId: entity.itemId,
          ) ??
          '${entity.itemType.name}_${entity.itemId}';
      final DateTime now = entity.createdAt ?? DateTime.now();
      final BookmarkModel model = BookmarkModel.fromEntity(
        entity.copyWith(
          id: id,
          createdAt: now,
          updatedAt: now,
        ),
      );
      local.writeOne(model);
      _safePush();
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> removeBookmark(String id) async {
    try {
      final bool removed = local.removeOne(id);
      if (!removed) {
        return const Result<void>.success(null);
      }
      _safePush();
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
      local.clear();
      _safePush();
      return const Result<void>.success(null);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> sync() async {
    try {
      if (preferRemote && remote != null) {
        try {
          await remote!.pull();
        } catch (e, st) {
          // Remote isn't wired yet; surface as offline (still success).
          developer.log(
            'Bookmark sync fell back to local: $e',
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

  void _safePush() {
    final BookmarkRemoteDataSource? r = remote;
    if (r == null) return;
    Future<void>(() async {
      try {
        await r.push(local.readAll());
      } catch (e, st) {
        developer.log(
          'Bookmark push failed (best-effort): $e',
          error: e,
          stackTrace: st,
          name: 'BookmarkRepository',
        );
      }
    });
  }

  List<BookmarkEntity> _entities(List<BookmarkModel> rows) {
    return List<BookmarkEntity>.unmodifiable(
      rows.map((BookmarkModel row) => row.toEntity()),
    );
  }
}