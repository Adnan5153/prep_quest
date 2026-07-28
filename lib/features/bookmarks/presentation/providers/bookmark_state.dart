import 'package:flutter/foundation.dart';

import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_filter.dart';
import '../../domain/enums/bookmark_sort.dart';

enum BookmarksStatus { initial, loading, ready, loadingMore, error }

/// Top-level state for the Bookmarks screen + the toggle button.
@immutable
class BookmarksViewState {
  const BookmarksViewState({
    required this.status,
    required this.items,
    required this.filter,
    required this.sort,
    required this.hasMore,
    required this.errorMessage,
    this.query = '',
    this.offlineMode = false,
    this.isRefreshing = false,
  });

  final BookmarksStatus status;
  final List<BookmarkEntity> items;
  final BookmarkFilter filter;
  final BookmarkSort sort;
  final String query;
  final String? errorMessage;
  final bool hasMore;
  final bool offlineMode;
  final bool isRefreshing;

  /// Number of items currently rendered. Used for the category-chip badges.
  int get filteredCount => items.length;

  /// True when there's at least one item to render.
  bool get hasResults => items.isNotEmpty;

  /// True when the user has no bookmarks at all (ignores active filters).
  bool get isEmpty =>
      items.isEmpty && filter == BookmarkFilter.all && query.trim().isEmpty;

  BookmarksViewState copyWith({
    BookmarksStatus? status,
    List<BookmarkEntity>? items,
    BookmarkFilter? filter,
    BookmarkSort? sort,
    String? query,
    String? errorMessage,
    bool clearError = false,
    bool? hasMore,
    bool? offlineMode,
    bool? isRefreshing,
  }) {
    return BookmarksViewState(
      status: status ?? this.status,
      items: items ?? this.items,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      query: query ?? this.query,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasMore: hasMore ?? this.hasMore,
      offlineMode: offlineMode ?? this.offlineMode,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  static const BookmarksViewState initial = BookmarksViewState(
    status: BookmarksStatus.initial,
    items: <BookmarkEntity>[],
    filter: BookmarkFilter.all,
    sort: BookmarkSort.newest,
    hasMore: true,
    errorMessage: null,
  );
}

/// Transient "we just toggled" feedback surfaced to widgets.
@immutable
class BookmarkFeedback {
  const BookmarkFeedback({required this.message, required this.isAdded});
  final String message;
  final bool isAdded;
}