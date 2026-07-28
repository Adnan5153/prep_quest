import '../../../../shared/typedefs/result.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';
import '../entities/quiz_performance_entity.dart';
import '../repositories/quiz_results_repository.dart';

/// Use case wrapping the repository call to build a [QuizPerformanceEntity].
class GetQuizPerformance {
  GetQuizPerformance(this._repository);

  final QuizResultsRepository _repository;

  Future<Result<QuizPerformanceEntity>> call({
    required String quizId,
    required QuizSessionEntity session,
  }) {
    return _repository.getQuizPerformance(quizId: quizId, session: session);
  }
}
