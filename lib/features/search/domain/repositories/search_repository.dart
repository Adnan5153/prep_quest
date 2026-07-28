import '../../../../shared/typedefs/result.dart';
import '../entities/recent_search_entity.dart';
import '../entities/search_item_entity.dart';
import '../entities/trending_search_entity.dart';
import '../enums/search_category.dart';

/// Storage contract for the global Search feature.
abstract class SearchRepository {
  Future<Result<List<SearchItemEntity>>> searchAll({
    required String query,
    Set<SearchCategory> categories = const <SearchCategory>{},
  });

  Future<Result<List<SearchItemEntity>>> searchByCategory({
    required String query,
    required SearchCategory category,
  });

  Future<Result<List<RecentSearchEntity>>> getRecentSearches({int limit = 10});

  Future<Result<void>> saveRecentSearch(RecentSearchEntity entry);

  Future<Result<void>> clearRecentSearches();

  Future<Result<List<TrendingSearchEntity>>> getTrendingSearches({int limit = 8});
}