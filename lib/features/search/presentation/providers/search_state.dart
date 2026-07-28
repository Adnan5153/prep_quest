import 'package:flutter/foundation.dart';

import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_item_entity.dart';
import '../../domain/entities/trending_search_entity.dart';
import '../../domain/enums/search_category.dart';

enum SearchStatus { initial, loading, ready, error }

@immutable
class SearchViewState {
  const SearchViewState({
    required this.status,
    required this.query,
    required this.selectedCategory,
    required this.resultsByCategory,
    required this.recent,
    required this.trending,
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final SearchCategory selectedCategory;

  /// Per-category result cache. Populated once per search query and
  /// re-used when the user toggles the category filter.
  final Map<SearchCategory, List<SearchItemEntity>> resultsByCategory;

  final List<RecentSearchEntity> recent;
  final List<TrendingSearchEntity> trending;

  final String? errorMessage;

  bool get hasQuery => query.trim().isNotEmpty;

  bool get hasAnyResults =>
      resultsByCategory.values.any((List<SearchItemEntity> rows) => rows.isNotEmpty);

  List<SearchItemEntity> get visibleResults {
    if (selectedCategory == SearchCategory.all) {
      return List<SearchItemEntity>.unmodifiable(
        resultsByCategory.values.expand((List<SearchItemEntity> rows) => rows),
      );
    }
    return resultsByCategory[selectedCategory] ??
        const <SearchItemEntity>[];
  }

  Map<SearchCategory, int> get resultCounts {
    return <SearchCategory, int>{
      for (final MapEntry<SearchCategory, List<SearchItemEntity>> entry
          in resultsByCategory.entries)
        entry.key: entry.value.length,
    };
  }

  SearchViewState copyWith({
    SearchStatus? status,
    String? query,
    bool clearQuery = false,
    SearchCategory? selectedCategory,
    Map<SearchCategory, List<SearchItemEntity>>? resultsByCategory,
    List<RecentSearchEntity>? recent,
    List<TrendingSearchEntity>? trending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SearchViewState(
      status: status ?? this.status,
      query: clearQuery ? '' : (query ?? this.query),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      resultsByCategory: resultsByCategory ?? this.resultsByCategory,
      recent: recent ?? this.recent,
      trending: trending ?? this.trending,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static const SearchViewState initial = SearchViewState(
    status: SearchStatus.initial,
    query: '',
    selectedCategory: SearchCategory.all,
    resultsByCategory: <SearchCategory, List<SearchItemEntity>>{},
    recent: <RecentSearchEntity>[],
    trending: <TrendingSearchEntity>[],
  );
}