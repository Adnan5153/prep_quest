import '../../../../shared/typedefs/result.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuizById {
  const GetQuizById(this._repository);

  final QuizRepository _repository;

  Future<Result<QuizEntity?>> call(String id) {
    return _repository.getQuizById(id);
  }
}
