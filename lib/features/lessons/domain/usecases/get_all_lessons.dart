import '../../../../shared/typedefs/result.dart';
import '../entities/lesson_entity.dart';
import '../repositories/lesson_repository.dart';

class GetAllLessons {
  const GetAllLessons(this._repository);

  final LessonRepository _repository;

  Future<Result<List<LessonEntity>>> call() {
    return _repository.getAllLessons();
  }
}