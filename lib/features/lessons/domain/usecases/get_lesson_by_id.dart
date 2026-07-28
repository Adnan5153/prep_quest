import '../../../../shared/typedefs/result.dart';
import '../entities/lesson_entity.dart';
import '../repositories/lesson_repository.dart';

class GetLessonById {
  const GetLessonById(this._repository);

  final LessonRepository _repository;

  Future<Result<LessonEntity?>> call(String id) {
    return _repository.getLessonById(id);
  }
}