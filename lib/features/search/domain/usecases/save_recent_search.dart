import '../../../../shared/typedefs/result.dart';
import '../entities/recent_search_entity.dart';
import '../repositories/search_repository.dart';

/// Persists a single [RecentSearchEntity].
class SaveRecentSearch {
  const SaveRecentSearch(this._repository);
  final SearchRepository _repository;

  Future<Result<void>> call(RecentSearchEntity entry) =>
      _repository.saveRecentSearch(entry);
}