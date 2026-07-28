import '../../../../shared/typedefs/result.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';
import '../repositories/quiz_results_repository.dart';

/// Use case wrapping the repository call to start a fresh retry session.
class RetryQuiz {
  RetryQuiz(this._repository);

  final QuizResultsRepository _repository;

  Future<Result<QuizSessionEntity>> call(String quizId) {
    return _repository.startRetry(quizId);
  }
}
