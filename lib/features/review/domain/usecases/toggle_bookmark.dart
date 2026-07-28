import '../../../../shared/typedefs/result.dart';
import '../repositories/review_repository.dart';

/// Toggles the bookmark state of a question.
///
/// Returns `true` when the question is now bookmarked, `false`
/// when the bookmark was removed.
class ToggleBookmark {
  const ToggleBookmark(this._repository);

  final ReviewRepository _repository;

  Future<Result<bool>> call(String questionId) {
    return _repository.toggleBookmark(questionId);
  }
}