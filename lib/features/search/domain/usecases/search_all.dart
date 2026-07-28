import '../../../../shared/typedefs/result.dart';
import '../entities/search_item_entity.dart';
import '../enums/search_category.dart';
import '../repositories/search_repository.dart';

/// Searches every category in [categories] for [query].
class SearchAll {
  const SearchAll(this._repository);
  final SearchRepository _repository;

  Future<Result<List<SearchItemEntity>>> call(
    String query, {
    Set<SearchCategory> categories = const <SearchCategory>{},
  }) =>
      _repository.searchAll(query: query, categories: categories);
}