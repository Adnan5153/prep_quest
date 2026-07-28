import '../../../../shared/typedefs/result.dart';
import '../enums/bookmark_item_type.dart';
import '../repositories/bookmark_repository.dart';

/// Synchronously-ish checks whether a given `(type, itemId)` pair is bookmarked.
class IsBookmarked {
  const IsBookmarked(this._repository);
  final BookmarkRepository _repository;
  Future<Result<bool>> call({
    required BookmarkItemType type,
    required String itemId,
  }) =>
      _repository.isBookmarked(type: type, itemId: itemId);
}