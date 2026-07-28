import '../../../../shared/typedefs/result.dart';
import '../entities/review_question_entity.dart';
import '../entities/review_session_entity.dart';
import '../repositories/review_repository.dart';

/// Fetches every persisted review session, newest first.
class GetAllReviewSessions {
  const GetAllReviewSessions(this._repository);

  final ReviewRepository _repository;

  Future<Result<List<ReviewSessionEntity>>> call() {
    return _repository.getAllReviewSessions();
  }
}

/// Fetches a single review session by id.
class GetReviewSessionById {
  const GetReviewSessionById(this._repository);

  final ReviewRepository _repository;

  Future<Result<ReviewSessionEntity?>> call(String sessionId) {
    return _repository.getReviewSessionById(sessionId);
  }
}

/// Returns the flattened question list scoped to a [ReviewFilter].
class GetQuestionsForFilter {
  const GetQuestionsForFilter(this._repository);

  final ReviewRepository _repository;

  Future<Result<List<ReviewQuestionEntity>>> call(ReviewFilter filter) {
    return _repository.getQuestionsForFilter(filter);
  }
}