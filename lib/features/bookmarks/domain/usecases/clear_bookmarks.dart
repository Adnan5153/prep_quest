import '../../../../shared/typedefs/result.dart';
import '../repositories/bookmark_repository.dart';

/// Wipes every stored bookmark (used by the Bookmarks screen "Clear"
/// action and by tests).
class ClearBookmarks {
  const ClearBookmarks(this._repository);
  final BookmarkRepository _repository;
  Future<Result<void>> call() => _repository.clearAll();
}