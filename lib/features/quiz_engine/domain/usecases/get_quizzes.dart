import '../../../../shared/typedefs/result.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuizzes {
  const GetQuizzes(this._repository);

  final QuizRepository _repository;

  Future<Result<List<QuizEntity>>> call() {
    return _repository.getAllQuizzes();
  }
}

class GetQuizzesForNode {
  const GetQuizzesForNode(this._repository);

  final QuizRepository _repository;

  Future<Result<List<QuizEntity>>> call(String nodeId) {
    return _repository.getQuizzesForNode(nodeId);
  }
}
