import '../../../../shared/typedefs/result.dart';
import '../entities/ai_response_entity.dart';
import '../repositories/ai_tutor_repository.dart';

/// Asks the tutor to produce a single hint for a quiz question.
class GenerateHint {
  const GenerateHint(this._repository);

  final AiTutorRepository _repository;

  Future<Result<AIResponseEntity>> call({
    required String questionId,
    required String questionText,
    String? userAnswer,
  }) {
    return _repository.generateHint(
      questionId: questionId,
      questionText: questionText,
      userAnswer: userAnswer,
    );
  }
}

/// Asks the tutor to explain why an answer is correct.
class GenerateExplanation {
  const GenerateExplanation(this._repository);

  final AiTutorRepository _repository;

  Future<Result<AIResponseEntity>> call({
    required String questionId,
    required String questionText,
    required String correctAnswer,
    String? userAnswer,
  }) {
    return _repository.generateExplanation(
      questionId: questionId,
      questionText: questionText,
      correctAnswer: correctAnswer,
      userAnswer: userAnswer,
    );
  }
}

/// Asks the tutor to simplify a concept for a target audience.
class SimplifyConcept {
  const SimplifyConcept(this._repository);

  final AiTutorRepository _repository;

  Future<Result<AIResponseEntity>> call({
    required String topic,
    String? gradeLevel,
  }) {
    return _repository.simplifyConcept(
      topic: topic,
      gradeLevel: gradeLevel,
    );
  }
}

/// Asks the tutor to explain a topic independently of a question.
class ExplainTopic {
  const ExplainTopic(this._repository);

  final AiTutorRepository _repository;

  Future<Result<AIResponseEntity>> call({
    required String topic,
    String? gradeLevel,
  }) {
    return _repository.simplifyConcept(
      topic: topic,
      gradeLevel: gradeLevel,
    );
  }
}