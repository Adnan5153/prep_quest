import '../../../../shared/typedefs/result.dart';
import '../entities/quiz_result_entity.dart';
import '../entities/quiz_session_entity.dart';
import '../repositories/quiz_repository.dart';

class SubmitQuizSession {
  const SubmitQuizSession(this._repository);

  final QuizRepository _repository;

  Future<Result<QuizResultEntity>> call(QuizSessionEntity session) {
    return _repository.submitQuizSession(session);
  }
}
