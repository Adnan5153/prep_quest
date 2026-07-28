import '../../../../shared/typedefs/result.dart';
import '../entities/bookmark_entity.dart';
import '../enums/bookmark_filter.dart';
import '../enums/bookmark_sort.dart';
import '../repositories/bookmark_repository.dart';

/// Reads (and optionally filters / sorts / searches / paginates) the
/// stored bookmark list.
class GetBookmarks {
  const GetBookmarks(this._repository);
  final BookmarkRepository _repository;

  Future<Result<List<BookmarkEntity>>> call({
    BookmarkFilter filter = BookmarkFilter.all,
    BookmarkSort sort = BookmarkSort.newest,
    String? query,
    int offset = 0,
    int limit = 20,
  }) =>
      _repository.getBookmarks(
        filter: filter,
        sort: sort,
        query: query,
        offset: offset,
        limit: limit,
      );
}