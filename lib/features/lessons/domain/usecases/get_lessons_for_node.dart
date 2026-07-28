import '../../../../shared/typedefs/result.dart';
import '../entities/lesson_entity.dart';
import '../repositories/lesson_repository.dart';

class GetLessonsForNode {
  const GetLessonsForNode(this._repository);

  final LessonRepository _repository;

  Future<Result<List<LessonEntity>>> call(String nodeId) {
    return _repository.getLessonsForNode(nodeId);
  }
}