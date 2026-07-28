import '../../../../shared/typedefs/result.dart';
import '../entities/generated_question.dart';
import '../repositories/ai_tutor_repository.dart';

/// Generates practice questions on a topic at a given difficulty.
class GenerateQuestions {
  const GenerateQuestions(this._repository);

  final AiTutorRepository _repository;

  Future<Result<GeneratedQuestionSet>> call({
    required String topic,
    int count = 5,
    GeneratedQuestionDifficulty difficulty = GeneratedQuestionDifficulty.medium,
  }) {
    return _repository.generateQuestions(
      topic: topic,
      count: count,
      difficulty: difficulty,
    );
  }
}