import '../../../../shared/typedefs/result.dart';
import '../entities/search_item_entity.dart';
import '../enums/search_category.dart';
import '../repositories/search_repository.dart';

/// Searches a single [SearchCategory] for [query].
class SearchByCategory {
  const SearchByCategory(this._repository);
  final SearchRepository _repository;

  Future<Result<List<SearchItemEntity>>> call({
    required String query,
    required SearchCategory category,
  }) =>
      _repository.searchByCategory(query: query, category: category);
}