import '../../../../shared/typedefs/result.dart';
import '../entities/recent_search_entity.dart';
import '../repositories/search_repository.dart';

/// Returns the most recent search entries (most-recent first).
class GetRecentSearches {
  const GetRecentSearches(this._repository);
  final SearchRepository _repository;

  Future<Result<List<RecentSearchEntity>>> call({int limit = 10}) =>
      _repository.getRecentSearches(limit: limit);
}