import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../../quiz_engine/data/datasources/mock_quiz_remote_datasource.dart';
import '../../../quiz_engine/data/datasources/quiz_remote_datasource.dart';
import '../../domain/entities/review_question_entity.dart';
import '../../domain/entities/review_session_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_local_datasource.dart';
import '../datasources/review_remote_datasource.dart';
import '../models/review_question_model.dart';
import '../models/review_session_model.dart';

/// Concrete repository that delegates to a [ReviewRemoteDataSource]
/// and the shared quiz mock for bookmark state. All exceptions are
/// mapped through [ErrorHandler.map] so callers see a uniform
/// [Failure] vocabulary.
class ReviewRepositoryImpl implements ReviewRepository {
  const ReviewRepositoryImpl({
    required ReviewRemoteDataSource remote,
    required QuizRemoteDataSource quizSource,
  })  : _remote = remote,
        _quizSource = quizSource;

  /// Convenience factory that wires the bundled mock data sources.
  factory ReviewRepositoryImpl.withDefaults() {
    return ReviewRepositoryImpl(
      remote: ReviewLocalDataSource(),
      quizSource: MockQuizRemoteDataSource(),
    );
  }

  final ReviewRemoteDataSource _remote;
  final QuizRemoteDataSource _quizSource;

  @override
  Future<Result<List<ReviewSessionEntity>>> getAllReviewSessions() async {
    try {
      final List<ReviewSessionModel> models = await _remote.fetchAllSessions();
      return Result.success(
        List<ReviewSessionEntity>.unmodifiable(
          models.map((ReviewSessionModel m) => m.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<ReviewSessionEntity?>> getReviewSessionById(
    String sessionId,
  ) async {
    try {
      final ReviewSessionModel? model = await _remote.fetchSessionById(sessionId);
      if (model == null) {
        return const Result<ReviewSessionEntity?>.success(null);
      }
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<ReviewQuestionEntity>>> getBookmarkedQuestions() async {
    try {
      final List<String> ids = await _quizSource.fetchBookmarkedQuestionIds();
      final List<ReviewSessionModel> all = await _remote.fetchAllSessions();
      final Set<String> idSet = ids.toSet();
      final List<ReviewQuestionEntity> bookmarked = <ReviewQuestionEntity>[];
      for (final ReviewSessionModel session in all) {
        for (final ReviewQuestionModel q in session.questions) {
          if (idSet.contains(q.question.id) || q.isBookmarked) {
            bookmarked.add(q.toEntity());
          }
        }
      }
      return Result.success(List<ReviewQuestionEntity>.unmodifiable(bookmarked));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<ReviewQuestionEntity>>> getRecentQuestions({
    int limit = 20,
  }) async {
    try {
      final List<ReviewSessionModel> all = await _remote.fetchAllSessions();
      final List<ReviewQuestionEntity> flat = <ReviewQuestionEntity>[];
      for (final ReviewSessionModel session in all) {
        for (final ReviewQuestionModel q in session.questions) {
          flat.add(q.toEntity());
        }
      }
      flat.sort(
        (ReviewQuestionEntity a, ReviewQuestionEntity b) =>
            b.attemptedAt.compareTo(a.attemptedAt),
      );
      return Result.success(
        List<ReviewQuestionEntity>.unmodifiable(
          flat.take(limit).toList(growable: false),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<ReviewQuestionEntity>>> getQuestionsForFilter(
    ReviewFilter filter,
  ) async {
    try {
      final List<ReviewSessionModel> all = await _remote.fetchAllSessions();
      final List<ReviewQuestionEntity> flat = <ReviewQuestionEntity>[];
      for (final ReviewSessionModel session in all) {
        for (final ReviewQuestionModel q in session.questions) {
          final ReviewQuestionEntity entity = q.toEntity();
          switch (filter) {
            case ReviewFilter.all:
              flat.add(entity);
              break;
            case ReviewFilter.correct:
              if (entity.wasCorrect) flat.add(entity);
              break;
            case ReviewFilter.incorrect:
              if (!entity.wasCorrect && entity.hasAnswered) flat.add(entity);
              break;
            case ReviewFilter.bookmarked:
              if (entity.isBookmarked) flat.add(entity);
              break;
          }
        }
      }
      flat.sort(
        (ReviewQuestionEntity a, ReviewQuestionEntity b) =>
            b.attemptedAt.compareTo(a.attemptedAt),
      );
      return Result.success(List<ReviewQuestionEntity>.unmodifiable(flat));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<String>> getAiExplanationForQuestion(String questionId) async {
    try {
      final String explanation = await _remote.fetchAiExplanation(questionId);
      return Result.success(explanation);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<bool>> toggleBookmark(String questionId) async {
    try {
      final bool added = await _quizSource.toggleBookmark(questionId);
      return Result.success(added);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<bool>> isBookmarked(String questionId) async {
    try {
      final List<String> ids = await _quizSource.fetchBookmarkedQuestionIds();
      return Result.success(ids.contains(questionId));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }
}