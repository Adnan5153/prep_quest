import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_report_entity.dart';
import '../../domain/entities/quiz_result_entity.dart';
import '../../domain/entities/quiz_session_entity.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_remote_datasource.dart';
import '../models/quiz_session_model.dart';

class QuizRepositoryImpl implements QuizRepository {
  const QuizRepositoryImpl(this._remote);

  final QuizRemoteDataSource _remote;

  @override
  Future<Result<List<QuizEntity>>> getAllQuizzes() async {
    try {
      final models = await _remote.fetchAllQuizzes();
      return Result.success(
        models.map((m) => m.toEntity()).toList(growable: false),
      );
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<List<QuizEntity>>> getQuizzesForNode(String nodeId) async {
    try {
      final models = await _remote.fetchQuizzesForNode(nodeId);
      return Result.success(
        models.map((m) => m.toEntity()).toList(growable: false),
      );
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizEntity?>> getQuizById(String id) async {
    try {
      final model = await _remote.fetchQuizById(id);
      return Result.success(model?.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizResultEntity>> submitQuizSession(
    QuizSessionEntity session,
  ) async {
    try {
      final model = await _remote.submitQuizSession(_toSessionModel(session));
      return Result.success(model.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<List<String>>> getBookmarkedQuestionIds() async {
    try {
      final ids = await _remote.fetchBookmarkedQuestionIds();
      return Result.success(List<String>.unmodifiable(ids));
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<bool>> toggleQuestionBookmark(String questionId) async {
    try {
      final added = await _remote.toggleBookmark(questionId);
      return Result.success(added);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizReportEntity>> reportQuestion({
    required String questionId,
    required String quizId,
    required QuizReportReason reason,
    required String note,
  }) async {
    try {
      final model = await _remote.submitReport(
        questionId: questionId,
        quizId: quizId,
        reasonId: reason.name,
        note: note,
      );
      return Result.success(model.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  static QuizSessionModel _toSessionModel(QuizSessionEntity session) {
    final Map<String, QuestionProgressModel> map = <String, QuestionProgressModel>{};
    session.progress.forEach((String key, value) {
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
