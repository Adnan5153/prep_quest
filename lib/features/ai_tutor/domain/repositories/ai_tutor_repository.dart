import '../../../../shared/typedefs/result.dart';
import '../entities/ai_response_entity.dart';
import '../entities/conversation.dart';
import '../entities/flashcard.dart';
import '../entities/generated_question.dart';
import '../entities/study_plan.dart';

/// Contract that the presentation layer consumes. The data layer
/// implements this in `AiTutorRepositoryImpl`.
abstract class AiTutorRepository {
  Future<Result<AIResponseEntity>> generateHint({
    required String questionId,
    required String questionText,
    String? userAnswer,
  });

  Future<Result<AIResponseEntity>> generateExplanation({
    required String questionId,
    required String questionText,
    required String correctAnswer,
    String? userAnswer,
  });

  Future<Result<AIResponseEntity>> simplifyConcept({
    required String topic,
    String? gradeLevel,
  });

  Future<Result<FlashcardDeck>> generateFlashcards({
    required String topic,
    int count,
    FlashcardDifficulty difficulty,
  });

  Future<Result<AIResponseEntity>> generateSummary({
    required String lessonId,
    String? lessonTitle,
  });

  Future<Result<StudyPlan>> generateStudyPlan({
    required String subject,
    required int daysAhead,
    int minutesPerDay,
  });

  Future<Result<GeneratedQuestionSet>> generateQuestions({
    required String topic,
    int count,
    GeneratedQuestionDifficulty difficulty,
  });

  Future<Result<List<Conversation>>> loadConversationHistory();

  Future<Result<Conversation>> loadConversationById(String conversationId);

  Future<Result<Conversation>> saveConversation(Conversation conversation);

  Future<Result<List<PromptEntry>>> loadPromptHistory();

  Future<Result<PromptEntry>> savePromptEntry(PromptEntry entry);

  Future<Result<List<Conversation>>> loadRecentSessions({int limit});

  Future<Result<bool>> togglePromptFavorite(String promptId);

  Future<Result<bool>> deleteConversation(String conversationId);
}