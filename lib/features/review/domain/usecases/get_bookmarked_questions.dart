import '../../../../shared/typedefs/result.dart';
import '../entities/review_question_entity.dart';
import '../repositories/review_repository.dart';

class GetBookmarkedQuestions {
  const GetBookmarkedQuestions(this._repository);

  final ReviewRepository _repository;

  Future<Result<List<ReviewQuestionEntity>>> call() {
    return _repository.getBookmarkedQuestions();
  }
}