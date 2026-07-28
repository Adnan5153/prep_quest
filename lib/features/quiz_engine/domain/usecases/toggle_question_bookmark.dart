import '../../../../shared/typedefs/result.dart';
import '../repositories/quiz_repository.dart';

class GetBookmarkedQuestionIds {
  const GetBookmarkedQuestionIds(this._repository);

  final QuizRepository _repository;

  Future<Result<List<String>>> call() {
    return _repository.getBookmarkedQuestionIds();
  }
}

class ToggleQuestionBookmark {
  const ToggleQuestionBookmark(this._repository);

  final QuizRepository _repository;

  Future<Result<bool>> call(String questionId) {
    return _repository.toggleQuestionBookmark(questionId);
  }
}
