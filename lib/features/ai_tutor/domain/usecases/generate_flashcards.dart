import '../../../../shared/typedefs/result.dart';
import '../entities/flashcard.dart';
import '../repositories/ai_tutor_repository.dart';

/// Generates a deck of flashcards for a topic at a given difficulty.
class GenerateFlashcards {
  const GenerateFlashcards(this._repository);

  final AiTutorRepository _repository;

  Future<Result<FlashcardDeck>> call({
    required String topic,
    int count = 10,
    FlashcardDifficulty difficulty = FlashcardDifficulty.medium,
  }) {
    return _repository.generateFlashcards(
      topic: topic,
      count: count,
      difficulty: difficulty,
    );
  }
}