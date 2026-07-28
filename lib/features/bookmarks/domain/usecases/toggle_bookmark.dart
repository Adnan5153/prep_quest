import '../../../../shared/typedefs/result.dart';
import '../entities/bookmark_entity.dart';
import '../repositories/bookmark_repository.dart';

/// Toggles the bookmark state for the given [BookmarkEntity].
///
/// If a bookmark already exists for the same `(itemType, itemId)`
/// pair, it is removed and the [BookmarkEntity.empty] sentinel is
/// returned. Otherwise the new bookmark is persisted and returned.
class ToggleBookmark {
  const ToggleBookmark(this._repository);
  final BookmarkRepository _repository;

  Future<Result<BookmarkEntity>> call(BookmarkEntity entity) async {
    final Result<String?> lookupResult = await _repository.findBookmarkId(
      type: entity.itemType,
      itemId: entity.itemId,
    );
    if (lookupResult.isFailure) {
      return Result.failure(lookupResult.failureOrNull!);
    }
    final String? existingId = lookupResult.valueOrNull;
    if (existingId != null) {
      final Result<void> removeResult =
          await _repository.removeBookmark(existingId);
      if (removeResult.isFailure) {
        return Result.failure(removeResult.failureOrNull!);
      }
      return const Result<BookmarkEntity>.success(BookmarkEntity.empty());
    }
    return _repository.addBookmark(entity);
  }
}