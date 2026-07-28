import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/search_local_datasource.dart';
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_item_entity.dart';
import '../../domain/entities/trending_search_entity.dart';
import '../../domain/enums/search_category.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/clear_recent_searches.dart';
import '../../domain/usecases/get_recent_searches.dart';
import '../../domain/usecases/get_trending_searches.dart';
import '../../domain/usecases/save_recent_search.dart';
import '../../domain/usecases/search_all.dart';
import '../../domain/usecases/search_by_category.dart';
import 'search_state.dart';

final searchLocalDataSourceProvider = Provider<SearchLocalDataSource>(
  (ref) => SearchLocalDataSource(),
);

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>(
  (ref) => const SearchRemoteDataSource(),
);

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepositoryImpl(
    local: ref.watch(searchLocalDataSourceProvider),
    remote: ref.watch(searchRemoteDataSourceProvider),
  ),
);

final searchAllUseCaseProvider = Provider<SearchAll>(
  (ref) => SearchAll(ref.watch(searchRepositoryProvider)),
);

final searchByCategoryUseCaseProvider = Provider<SearchByCategory>(
  (ref) => SearchByCategory(ref.watch(searchRepositoryProvider)),
);

final getRecentSearchesUseCaseProvider = Provider<GetRecentSearches>(
  (ref) => GetRecentSearches(ref.watch(searchRepositoryProvider)),
);

final saveRecentSearchUseCaseProvider = Provider<SaveRecentSearch>(
  (ref) => SaveRecentSearch(ref.watch(searchRepositoryProvider)),
);

final clearRecentSearchesUseCaseProvider = Provider<ClearRecentSearches>(
  (ref) => ClearRecentSearches(ref.watch(searchRepositoryProvider)),
);

final getTrendingSearchesUseCaseProvider = Provider<GetTrendingSearches>(
  (ref) => GetTrendingSearches(ref.watch(searchRepositoryProvider)),
);

/// Owns the search lifecycle: hydrate (recents + trending), debounced
/// query, category filter, and recent-history writes.
class SearchController extends StateNotifier<SearchViewState> {
  SearchController({
    required SearchAll searchAll,
    required GetRecentSearches getRecentSearches,
    required SaveRecentSearch saveRecentSearch,
    required ClearRecentSearches clearRecentSearches,
    required GetTrendingSearches getTrendingSearches,
    required DateTime Function() clock,
  })  : _searchAll = searchAll,
        _getRecentSearches = getRecentSearches,
        _saveRecentSearch = saveRecentSearch,
        _clearRecentSearches = clearRecentSearches,
        _getTrendingSearches = getTrendingSearches,
        _clock = clock,
        super(SearchViewState.initial);

  final SearchAll _searchAll;
  final GetRecentSearches _getRecentSearches;
  final SaveRecentSearch _saveRecentSearch;
  final ClearRecentSearches _clearRecentSearches;
  final GetTrendingSearches _getTrendingSearches;
  final DateTime Function() _clock;

  /// Loads the trending + recents lists. Called once from `initState`.
  Future<void> hydrate() async {
    final Result<List<TrendingSearchEntity>> trendingResult =
        await _getTrendingSearches();
    if (!mounted) return;
    trendingResult.fold(
      onFailure: (_) {},
      onSuccess: (List<TrendingSearchEntity> rows) {
        state = state.copyWith(trending: rows);
      },
    );
    final Result<List<RecentSearchEntity>> recentResult =
        await _getRecentSearches();
    if (!mounted) return;
    recentResult.fold(
      onFailure: (_) {},
      onSuccess: (List<RecentSearchEntity> rows) {
        state = state.copyWith(recent: rows);
      },
    );
  }

  /// Triggered by the field's `onChanged`. Updates `state.query`
  /// immediately and lets the debouncer schedule the actual search.
  void onQueryChanged(String query) {
    state = state.copyWith(query: query);
  }

  /// Triggered by debounce or by submit. Runs the search and rebuilds
  /// the per-category cache. If [query] is empty, results are cleared.
  Future<void> runSearch({String? query}) async {
    final String next = (query ?? state.query).trim();
    state = state.copyWith(
      query: next,
      status: SearchStatus.loading,
      clearError: true,
    );

    if (next.isEmpty) {
      state = state.copyWith(
        resultsByCategory: const <SearchCategory, List<SearchItemEntity>>{},
        status: SearchStatus.ready,
      );
      return;
    }

    final Result<List<SearchItemEntity>> result =
        await _searchAll(next, categories: const <SearchCategory>{});
    if (!mounted) return;
    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          status: SearchStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (List<SearchItemEntity> rows) {
        state = state.copyWith(
          status: SearchStatus.ready,
          resultsByCategory: _groupByCategory(rows),
          clearError: true,
        );
      },
    );
  }

  /// Switches the visible category. Pure client-side filter against
  /// the already-cached [resultsByCategory].
  void onCategorySelected(SearchCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Replaces the field text and runs a fresh search. Used by recent
  /// and trending chip taps.
  Future<void> fillAndSearch(String query) async {
    state = state.copyWith(query: query);
    await runSearch(query: query);
  }

  /// Records that the user tapped [item]. Persists the current query to
  /// recents. Returns the item so the caller can navigate to it.
  Future<SearchItemEntity> onItemOpened(SearchItemEntity item) async {
    final String query = state.query.trim();
    if (query.isNotEmpty) {
      final RecentSearchEntity entry = RecentSearchEntity(
        query: query,
        queriedAtIso: _clock().toIso8601String(),
        categoryAtTime: state.selectedCategory == SearchCategory.all
            ? null
            : state.selectedCategory,
      );
      await _saveRecentSearch(entry);
      if (!mounted) return item;
      final Result<List<RecentSearchEntity>> recentResult =
          await _getRecentSearches();
      if (!mounted) return item;
      recentResult.fold(
        onFailure: (_) {},
        onSuccess: (List<RecentSearchEntity> rows) {
          state = state.copyWith(recent: rows);
        },
      );
    }
    return item;
  }

  Future<void> clearRecent() async {
    final Result<void> result = await _clearRecentSearches();
    if (!mounted) return;
    result.fold(
      onFailure: (_) {},
      onSuccess: (_) {
        state = state.copyWith(recent: const <RecentSearchEntity>[]);
      },
    );
  }

  Map<SearchCategory, List<SearchItemEntity>> _groupByCategory(
    List<SearchItemEntity> rows,
  ) {
    final Map<SearchCategory, List<SearchItemEntity>> grouped =
        <SearchCategory, List<SearchItemEntity>>{};
    for (final SearchItemEntity row in rows) {
      grouped.putIfAbsent(row.category, () => <SearchItemEntity>[]).add(row);
    }
    return grouped;
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchViewState>(
  (ref) => SearchController(
    searchAll: ref.watch(searchAllUseCaseProvider),
    getRecentSearches: ref.watch(getRecentSearchesUseCaseProvider),
    saveRecentSearch: ref.watch(saveRecentSearchUseCaseProvider),
    clearRecentSearches: ref.watch(clearRecentSearchesUseCaseProvider),
    getTrendingSearches: ref.watch(getTrendingSearchesUseCaseProvider),
    clock: DateTime.now,
  ),
);