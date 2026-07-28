import '../../../../shared/typedefs/result.dart';
import '../entities/trending_search_entity.dart';
import '../repositories/search_repository.dart';

/// Returns the current top-N trending searches.
class GetTrendingSearches {
  const GetTrendingSearches(this._repository);
  final SearchRepository _repository;

  Future<Result<List<TrendingSearchEntity>>> call({int limit = 8}) =>
      _repository.getTrendingSearches(limit: limit);
}