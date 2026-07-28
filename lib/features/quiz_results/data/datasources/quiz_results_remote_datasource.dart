import '../../../quiz_engine/domain/entities/quiz_entity.dart';
import '../../../quiz_engine/domain/entities/quiz_result_entity.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';

/// Abstract contract for the quiz results data source.
///
/// Implementations typically derive analytics from a quiz definition
/// already fetched by the Quiz Engine. The data source is therefore
/// intentionally thin — most logic lives in the pure `TopicAnalyzer`
/// utility.
abstract class QuizResultsRemoteDataSource {
  /// Fetches the canonical quiz definition for analytics.
  Future<QuizEntity?> fetchQuizDefinition(String quizId);

  /// Builds a [QuizResultEntity] for the supplied session.
  Future<QuizResultEntity> submitSession(QuizSessionEntity session);

  /// Begins a fresh retry session for the supplied quiz id.
  Future<QuizSessionEntity> startRetrySession(String quizId);
}
