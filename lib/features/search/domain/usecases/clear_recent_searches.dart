import '../../../../shared/typedefs/result.dart';
import '../repositories/search_repository.dart';

/// Clears the persistent recent-search history.
class ClearRecentSearches {
  const ClearRecentSearches(this._repository);
  final SearchRepository _repository;

  Future<Result<void>> call() => _repository.clearRecentSearches();
}