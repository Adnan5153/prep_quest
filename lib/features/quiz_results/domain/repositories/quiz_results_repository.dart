import '../../../../shared/typedefs/result.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';
import '../entities/quiz_performance_entity.dart';

/// Abstract gateway for the quiz results feature.
abstract class QuizResultsRepository {
  /// Builds a [QuizPerformanceEntity] from a freshly submitted session.
  Future<Result<QuizPerformanceEntity>> getQuizPerformance({
    required String quizId,
    required QuizSessionEntity session,
  });

  /// Provides a fresh session for the retry flow.
  Future<Result<QuizSessionEntity>> startRetry(String quizId);
}
