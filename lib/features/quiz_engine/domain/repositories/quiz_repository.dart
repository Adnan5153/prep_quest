import '../../../../shared/typedefs/result.dart';
import '../entities/quiz_entity.dart';
import '../entities/quiz_report_entity.dart';
import '../entities/quiz_result_entity.dart';
import '../entities/quiz_session_entity.dart';

/// Domain-level contract every quiz repository must satisfy.
///
/// The repository is the only boundary the application/presentation
/// layer talks to. Concrete implementations live in
/// `data/repositories/`, which may delegate to a remote data source
/// (Firestore once wired) and/or a local cache (Hive/SQLite).
abstract class QuizRepository {
  /// Returns every quiz available to the player.
  Future<Result<List<QuizEntity>>> getAllQuizzes();

  /// Returns quizzes linked to a Playground node id.
  Future<Result<List<QuizEntity>>> getQuizzesForNode(String nodeId);

  /// Returns a single quiz by id, or `null` if it does not exist.
  Future<Result<QuizEntity?>> getQuizById(String id);

  /// Persists the final session for a quiz and returns the computed
  /// result. The data source is responsible for grading and producing
  /// the [QuizResultEntity].
  Future<Result<QuizResultEntity>> submitQuizSession(
    QuizSessionEntity session,
  );

  /// Returns the bookmarked question ids for the current user.
  Future<Result<List<String>>> getBookmarkedQuestionIds();

  /// Toggles a bookmark for a question and returns the new state.
  Future<Result<bool>> toggleQuestionBookmark(String questionId);

  /// Reports a question with the supplied reason and free-form note.
  Future<Result<QuizReportEntity>> reportQuestion({
    required String questionId,
    required String quizId,
    required QuizReportReason reason,
    required String note,
  });
}
