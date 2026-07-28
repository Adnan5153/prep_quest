import '../../../quiz_engine/data/datasources/quiz_remote_datasource.dart';
import '../../../quiz_engine/data/models/quiz_model.dart';
import '../../../quiz_engine/data/models/quiz_session_model.dart';
import '../../../quiz_engine/domain/entities/quiz_entity.dart';
import '../../../quiz_engine/domain/entities/quiz_result_entity.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';
import '../../../quiz_engine/domain/entities/question_progress_entity.dart';
import 'quiz_results_remote_datasource.dart';

/// In-memory implementation that delegates to the existing
/// [QuizRemoteDataSource] for the canonical quiz definition and
/// session submission. Persists nothing across app restarts.
class MockQuizResultsRemoteDataSource implements QuizResultsRemoteDataSource {
  MockQuizResultsRemoteDataSource(this._quizSource);

  final QuizRemoteDataSource _quizSource;

  @override
  Future<QuizEntity?> fetchQuizDefinition(String quizId) async {
    final QuizModel? model = await _quizSource.fetchQuizById(quizId);
    return model?.toEntity();
  }

  @override
  Future<QuizResultEntity> submitSession(QuizSessionEntity session) async {
    final result = await _quizSource.submitQuizSession(
      _toSessionModel(session),
    );
    return result.toEntity();
  }

  @override
  Future<QuizSessionEntity> startRetrySession(String quizId) async {
    final QuizModel? model = await _quizSource.fetchQuizById(quizId);
    final QuizEntity? entity = model?.toEntity();
    if (entity == null) {
      throw StateError('Quiz not found: $quizId');
    }
    final List<String> order = List<String>.generate(
      entity.questions.length,
      (int i) => entity.questions[i].id,
    );
    return QuizSessionEntity(
      sessionId: 'session-${DateTime.now().microsecondsSinceEpoch}',
      quizId: quizId,
      startedAt: DateTime.now(),
      questionOrder: List<String>.unmodifiable(order),
      progress: const <String, QuestionProgressEntity>{},
      status: QuizSessionStatus.inProgress,
      flags: const <String>{},
      totalPausedSeconds: 0,
    );
  }

  static QuizSessionModel _toSessionModel(QuizSessionEntity session) {
    final Map<String, QuestionProgressModel> map =
        <String, QuestionProgressModel>{};
    session.progress.forEach((String key, QuestionProgressEntity value) {
      map[key] = QuestionProgressModel(
        questionId: value.questionId,
        selectedAnswerIds: List<String>.of(value.selectedAnswerIds),
        statusId: value.status.name,
        timeSpentSeconds: value.timeSpentSeconds,
        attemptCount: value.attemptCount,
        hintIdsRevealed: List<String>.of(value.hintIdsRevealed),
        isBookmarked: value.isBookmarked,
      );
    });
    return QuizSessionModel(
      sessionId: session.sessionId,
      quizId: session.quizId,
      startedAtIso: session.startedAt.toIso8601String(),
      completedAtIso: session.completedAt?.toIso8601String(),
      questionOrder: List<String>.of(session.questionOrder),
      progress: map,
      statusId: session.status.name,
      flags: Set<String>.of(session.flags),
      totalPausedSeconds: session.totalPausedSeconds,
      currentIndex: session.currentIndex,
    );
  }
}