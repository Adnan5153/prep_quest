import '../../../../shared/typedefs/result.dart';
import '../entities/review_question_entity.dart';
import '../entities/review_session_entity.dart';

/// Contract that the presentation layer consumes. The data layer
/// implements this in [ReviewRepositoryImpl].
abstract class ReviewRepository {
  Future<Result<List<ReviewSessionEntity>>> getAllReviewSessions();

  Future<Result<ReviewSessionEntity?>> getReviewSessionById(String sessionId);

  Future<Result<List<ReviewQuestionEntity>>> getBookmarkedQuestions();

  Future<Result<List<ReviewQuestionEntity>>> getRecentQuestions({int limit});

  Future<Result<List<ReviewQuestionEntity>>> getQuestionsForFilter(
    ReviewFilter filter,
  );

  Future<Result<String>> getAiExplanationForQuestion(String questionId);

  Future<Result<bool>> toggleBookmark(String questionId);

  Future<Result<bool>> isBookmarked(String questionId);
}