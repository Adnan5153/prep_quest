import '../../../../shared/typedefs/result.dart';
import '../entities/ai_response_entity.dart';
import '../repositories/ai_tutor_repository.dart';

/// Summarises a lesson (or topic) into a digestible study summary.
class GenerateSummary {
  const GenerateSummary(this._repository);

  final AiTutorRepository _repository;

  Future<Result<AIResponseEntity>> call({
    required String lessonId,
    String? lessonTitle,
  }) {
    return _repository.generateSummary(
      lessonId: lessonId,
      lessonTitle: lessonTitle,
    );
  }
}