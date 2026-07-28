import '../../../../shared/typedefs/result.dart';
import '../entities/bookmark_entity.dart';
import '../enums/bookmark_filter.dart';
import '../enums/bookmark_item_type.dart';
import '../enums/bookmark_sort.dart';

/// Storage contract for the Bookmarks feature.
abstract class BookmarkRepository {
  Future<Result<List<BookmarkEntity>>> getBookmarks({
    BookmarkFilter filter,
    BookmarkSort sort,
    String? query,
    int offset,
    int limit,
  });

  Future<Result<BookmarkEntity>> addBookmark(BookmarkEntity entity);

  Future<Result<void>> removeBookmark(String id);

  Future<Result<bool>> isBookmarked({
    required BookmarkItemType type,
    required String itemId,
  });

  Future<Result<String?>> findBookmarkId({
    required BookmarkItemType type,
    required String itemId,
  });

  Future<Result<void>> clearAll();

  Future<Result<void>> sync();
}