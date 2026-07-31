import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/security/auth_precondition.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_item_entity.dart';
import '../../domain/entities/trending_search_entity.dart';
import '../../domain/enums/search_category.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_remote_datasource.dart';
import '../models/recent_search_model.dart';
import '../models/search_item_model.dart';
import '../models/trending_search_model.dart';

/// Concrete [SearchRepository] with remote-first local fallback.
///
/// Until Firestore is wired, `preferRemote` stays `false` and `remote`
/// stays `null`. The async signatures + `_readAll` chain are kept so a
/// later swap is purely a constructor change.
///
/// Phase 51 — mutating methods (`saveRecentSearch`,
/// `clearRecentSearches`) enforce an authenticated precondition via
/// [AuthGuard] before delegating to the remote data source.
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({
    required this.local,
    this.remote,
    this.preferRemote = false,
    this.maxRecentEntries = 20,
    required Ref ref,
  }) : _guard = AuthGuard(ref);

  final SearchLocalDataSource local;
  final SearchRemoteDataSource? remote;
  final bool preferRemote;
  final AuthGuard _guard;

  /// Maximum persisted recent-search entries (most-recent wins).
  final int maxRecentEntries;

  @override
  Future<Result<List<SearchItemEntity>>> searchAll({
    required String query,
    Set<SearchCategory> categories = const <SearchCategory>{},
  }) async {
    try {
      final List<SearchItemModel> rows = local.searchItems(query, categories);
      return Result.success(_items(rows));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<SearchItemEntity>>> searchByCategory({
    required String query,
    required SearchCategory category,
  }) async {
    try {
      final List<SearchItemModel> rows =
          local.searchItems(query, <SearchCategory>{category});
      return Result.success(_items(rows));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<RecentSearchEntity>>> getRecentSearches({
    int limit = 10,
  }) async {
    try {
      final List<RecentSearchModel> rows = local.readRecent(limit: limit);
      return Result.success(
        List<RecentSearchEntity>.unmodifiable(
          rows.map((RecentSearchModel r) => r.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> saveRecentSearch(RecentSearchEntity entry) async {
    try {
      _guard.assertAuthenticated();
      final List<RecentSearchModel> existing = local.readRecent(limit: 50);
      final String normalizedQuery = entry.query.trim();
      final List<RecentSearchModel> deduped = existing
          .where((RecentSearchModel r) =>
              r.query.toLowerCase() != normalizedQuery.toLowerCase())
          .toList();
      deduped.insert(
        0,
        RecentSearchModel.fromEntity(entry.copyWith(query: normalizedQuery)),
      );
      final List<RecentSearchModel> trimmed =
          deduped.take(maxRecentEntries).toList(growable: false);
      local.writeRecent(trimmed);
      return Result.success(null);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<void>> clearRecentSearches() async {
    try {
      _guard.assertAuthenticated();
      local.writeRecent(const <RecentSearchModel>[]);
      return Result.success(null);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<TrendingSearchEntity>>> getTrendingSearches({
    int limit = 8,
  }) async {
    try {
      final List<TrendingSearchModel> rows = local.readTrending(limit: limit);
      return Result.success(
        List<TrendingSearchEntity>.unmodifiable(
          rows.map((TrendingSearchModel r) => r.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  List<SearchItemEntity> _items(List<SearchItemModel> rows) {
    return List<SearchItemEntity>.unmodifiable(
      rows.map((SearchItemModel row) => row.toEntity()),
    );
  }
}