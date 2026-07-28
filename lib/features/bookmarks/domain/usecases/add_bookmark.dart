import '../../../../shared/typedefs/result.dart';
import '../entities/bookmark_entity.dart';
import '../repositories/bookmark_repository.dart';

/// Persists a new [BookmarkEntity] in the local store.
class AddBookmark {
  const AddBookmark(this._repository);
  final BookmarkRepository _repository;
  Future<Result<BookmarkEntity>> call(BookmarkEntity entity) =>
      _repository.addBookmark(entity);
}