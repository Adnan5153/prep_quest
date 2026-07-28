import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/bookmark_local_datasource.dart';
import '../../data/datasources/bookmark_remote_datasource.dart';
import '../../data/repositories/bookmark_repository_impl.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_filter.dart';
import '../../domain/enums/bookmark_item_type.dart';
import '../../domain/enums/bookmark_sort.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/usecases/add_bookmark.dart';
import '../../domain/usecases/clear_bookmarks.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../domain/usecases/is_bookmarked.dart';
import '../../domain/usecases/remove_bookmark.dart';
import '../../domain/usecases/sync_bookmarks.dart';
import '../../domain/usecases/toggle_bookmark.dart';
import 'bookmark_filter_provider.dart';
import 'bookmark_state.dart';

final bookmarkLocalDataSourceProvider = Provider<BookmarkLocalDataSource>(
  (Ref ref) => BookmarkLocalDataSource(),
);

final bookmarkRemoteDataSourceProvider = Provider<BookmarkRemoteDataSource>(
  (Ref ref) => const BookmarkRemoteDataSource(),
);

final bookmarkRepositoryProvider = Provider<BookmarkRepository>(
  (Ref ref) => BookmarkRepositoryImpl(
    local: ref.watch(bookmarkLocalDataSourceProvider),
    remote: ref.watch(bookmarkRemoteDataSourceProvider),
  ),
);

final addBookmarkUseCaseProvider = Provider<AddBookmark>(
  (Ref ref) => AddBookmark(ref.watch(bookmarkRepositoryProvider)),
);

final removeBookmarkUseCaseProvider = Provider<RemoveBookmark>(
  (Ref ref) => RemoveBookmark(ref.watch(bookmarkRepositoryProvider)),
);

final toggleBookmarkUseCaseProvider = Provider<ToggleBookmark>(
  (Ref ref) => ToggleBookmark(ref.watch(bookmarkRepositoryProvider)),
);

final isBookmarkedUseCaseProvider = Provider<IsBookmarked>(
  (Ref ref) => IsBookmarked(ref.watch(bookmarkRepositoryProvider)),
);

final getBookmarksUseCaseProvider = Provider<GetBookmarks>(
  (Ref ref) => GetBookmarks(ref.watch(bookmarkRepositoryProvider)),
);

final clearBookmarksUseCaseProvider = Provider<ClearBookmarks>(
  (Ref ref) => ClearBookmarks(ref.watch(bookmarkRepositoryProvider)),
);

final syncBookmarksUseCaseProvider = Provider<SyncBookmarks>(
  (Ref ref) => SyncBookmarks(ref.watch(bookmarkRepositoryProvider)),
);

/// Owns the Bookmarks screen lifecycle + the universal toggle button.
class BookmarkController extends StateNotifier<BookmarksViewState> {
  BookmarkController({
    required GetBookmarks getBookmarks,
    required RemoveBookmark removeBookmark,
    required ToggleBookmark toggleBookmark,
    required ClearBookmarks clearBookmarks,
    required SyncBookmarks syncBookmarks,
    required Ref ref,
  })  : _getBookmarks = getBookmarks,
        _removeBookmark = removeBookmark,
        _toggleBookmark = toggleBookmark,
        _clearBookmarks = clearBookmarks,
        _syncBookmarks = syncBookmarks,
        _ref = ref,
        super(BookmarksViewState.initial);

  final GetBookmarks _getBookmarks;
  final RemoveBookmark _removeBookmark;
  final ToggleBookmark _toggleBookmark;
  final ClearBookmarks _clearBookmarks;
  final SyncBookmarks _syncBookmarks;
  final Ref _ref;

  /// Fires transient feedback whenever a toggle completes.
  final StreamController<BookmarkFeedback> _feedback =
      StreamController<BookmarkFeedback>.broadcast();
  Stream<BookmarkFeedback> get feedback => _feedback.stream;

  /// Initial load + filter/sort/query changes funnel through this.
  Future<void> hydrate({int offset = 0, int limit = 20}) async {
    final BookmarkFilter filter = _ref.read(bookmarkFilterProvider);
    final BookmarkSort sort = _ref.read(bookmarkSortProvider);
    final String query = _ref.read(bookmarkFilterProvider).name.isEmpty
        ? state.query
        : state.query;
    if (offset == 0) {
      state = state.copyWith(
        status: BookmarksStatus.loading,
        clearError: true,
      );
    } else {
      state = state.copyWith(status: BookmarksStatus.loadingMore);
    }
    final Result<List<BookmarkEntity>> result = await _getBookmarks(
      filter: filter,
      sort: sort,
      query: query.trim().isEmpty ? null : query.trim(),
      offset: offset,
      limit: limit,
    );
    if (!mounted) return;
    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          status: BookmarksStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (List<BookmarkEntity> rows) {
        final List<BookmarkEntity> combined = offset == 0
            ? List<BookmarkEntity>.unmodifiable(rows)
            : List<BookmarkEntity>.unmodifiable(<BookmarkEntity>[...state.items, ...rows]);
        state = state.copyWith(
          status: BookmarksStatus.ready,
          items: combined,
          hasMore: rows.length >= limit,
          clearError: true,
        );
      },
    );
  }

  /// Pull-to-refresh entry. Calls [SyncBookmarks] best-effort then
  /// re-hydrates the first page.
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await _syncBookmarks();
    state = state.copyWith(isRefreshing: false);
    await hydrate(offset: 0);
  }

  /// Re-fetch the next page when the user reaches the end of the list.
  Future<void> loadMore({int limit = 20}) async {
    if (!state.hasMore) return;
    if (state.status == BookmarksStatus.loadingMore) return;
    await hydrate(offset: state.items.length, limit: limit);
  }

  /// Re-runs the active query when the filter dropdown changes.
  Future<void> onFilterChanged(BookmarkFilter filter) async {
    _ref.read(bookmarkFilterProvider.notifier).state = filter;
    state = state.copyWith(filter: filter);
    await hydrate(offset: 0);
  }

  /// Re-runs the active query when the sort dropdown changes.
  Future<void> onSortChanged(BookmarkSort sort) async {
    _ref.read(bookmarkSortProvider.notifier).state = sort;
    state = state.copyWith(sort: sort);
    await hydrate(offset: 0);
  }

  /// Updates the active query string. Triggers a debounced re-hydrate
  /// from the screen that owns the [Debouncer].
  void onQueryChanged(String query) {
    state = state.copyWith(query: query);
  }

  /// Resolves the query against the data layer; called from the
  /// screen's debouncer.
  Future<void> runSearch({String? query}) async {
    state = state.copyWith(query: query ?? state.query);
    await hydrate(offset: 0);
  }

  /// Toggles a bookmark state. Emits feedback for the screen/widget.
  Future<bool> toggle(BookmarkEntity entity) async {
    final Result<BookmarkEntity> result = await _toggleBookmark(entity);
    return result.fold(
      onFailure: (Failure failure) {
        _feedback.add(BookmarkFeedback(
          message: failure.message,
          isAdded: false,
        ));
        return false;
      },
      onSuccess: (BookmarkEntity row) {
        final bool added = !row.isEmpty;
        _feedback.add(BookmarkFeedback(
          message: added ? 'Bookmark saved' : 'Bookmark removed',
          isAdded: added,
        ));
        // Refresh the underlying list so the BookmarksScreen (if mounted)
        // reflects the change. If the controller is in offline mode and
        // adds succeeded, keep offlineMode as-is.
        if (added && state.status == BookmarksStatus.ready) {
          hydrate(offset: 0);
        } else if (!added && state.status == BookmarksStatus.ready) {
          hydrate(offset: 0);
        }
        return added;
      },
    );
  }

  /// Synchronous fast-path used by the [bookmarkIdsProvider].
  bool isBookmarkedSync({
    required BookmarkItemType type,
    required String itemId,
  }) {
    return _ref.read(bookmarkLocalDataSourceProvider).isBookmarked(
          type: type,
          itemId: itemId,
        );
  }

  /// Removes a single bookmark by id.
  Future<void> removeById(String id) async {
    final Result<void> result = await _removeBookmark(id);
    if (result.isFailure) {
      _feedback.add(BookmarkFeedback(
        message: result.failureOrNull?.message ?? 'Could not remove bookmark',
        isAdded: false,
      ));
    } else {
      _feedback.add(const BookmarkFeedback(
        message: 'Bookmark removed',
        isAdded: false,
      ));
      if (state.status == BookmarksStatus.ready) {
        await hydrate(offset: 0);
      }
    }
  }

  /// Removes a bookmark represented by [entity], resolving its persisted id.
  Future<void> removeEntity(BookmarkEntity entity) async {
    final String? id = _ref.read(bookmarkLocalDataSourceProvider).findId(
          type: entity.itemType,
          itemId: entity.itemId,
        );
    if (id == null) return;
    await removeById(id);
  }

  /// Wipes every bookmark. Re-hydrates so the screen re-renders empty.
  Future<void> clearAll() async {
    final Result<void> result = await _clearBookmarks();
    if (!mounted) return;
    if (result.isFailure) {
      state = state.copyWith(
        errorMessage: result.failureOrNull?.message,
      );
      return;
    }
    state = state.copyWith(items: const <BookmarkEntity>[]);
    await hydrate(offset: 0);
  }

  @override
  void dispose() {
    _feedback.close();
    super.dispose();
  }
}

final bookmarkControllerProvider =
    StateNotifierProvider<BookmarkController, BookmarksViewState>(
  (Ref ref) => BookmarkController(
    getBookmarks: ref.watch(getBookmarksUseCaseProvider),
    removeBookmark: ref.watch(removeBookmarkUseCaseProvider),
    toggleBookmark: ref.watch(toggleBookmarkUseCaseProvider),
    clearBookmarks: ref.watch(clearBookmarksUseCaseProvider),
    syncBookmarks: ref.watch(syncBookmarksUseCaseProvider),
    ref: ref,
  ),
);