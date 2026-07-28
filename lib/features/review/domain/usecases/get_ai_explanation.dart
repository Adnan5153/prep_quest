import '../../../../shared/typedefs/result.dart';
import '../repositories/review_repository.dart';

/// Fetches a richer AI-authored explanation for a question.
class GetAiExplanation {
  const GetAiExplanation(this._repository);

  final ReviewRepository _repository;

  Future<Result<String>> call(String questionId) {
    return _repository.getAiExplanationForQuestion(questionId);
  }
}