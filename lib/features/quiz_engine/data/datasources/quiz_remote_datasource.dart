import '../models/quiz_model.dart';
import '../models/quiz_report_model.dart';
import '../models/quiz_result_model.dart';
import '../models/quiz_session_model.dart';

/// Abstract contract every quiz remote data source must satisfy.
abstract class QuizRemoteDataSource {
  Future<List<QuizModel>> fetchAllQuizzes();
  Future<List<QuizModel>> fetchQuizzesForNode(String nodeId);
  Future<QuizModel?> fetchQuizById(String id);
  Future<QuizResultModel> submitQuizSession(QuizSessionModel session);
  Future<List<String>> fetchBookmarkedQuestionIds();
  Future<bool> toggleBookmark(String questionId);
  Future<QuizReportModel> submitReport({
    required String questionId,
    required String quizId,
    required String reasonId,
    required String note,
  });
}
