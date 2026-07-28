import '../../../../shared/typedefs/result.dart';
import '../entities/review_question_entity.dart';
import '../repositories/review_repository.dart';

class GetRecentQuestions {
  const GetRecentQuestions(this._repository, {this.defaultLimit = 20});

  final ReviewRepository _repository;
  final int defaultLimit;

  Future<Result<List<ReviewQuestionEntity>>> call({int? limit}) {
    return _repository.getRecentQuestions(
      limit: limit ?? defaultLimit,
    );
  }
}