import '../../../../shared/typedefs/result.dart';
import '../repositories/bookmark_repository.dart';

/// Removes a single bookmark by id.
class RemoveBookmark {
  const RemoveBookmark(this._repository);
  final BookmarkRepository _repository;
  Future<Result<void>> call(String id) => _repository.removeBookmark(id);
}