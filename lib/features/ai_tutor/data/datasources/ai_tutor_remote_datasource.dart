import '../models/ai_response_model.dart';
import '../models/conversation_model.dart';
import '../models/flashcard_model.dart';
import '../models/generated_question_model.dart';
import '../models/prompt_entry_model.dart';
import '../models/study_plan_model.dart';

/// Remote data source contract for the AI Tutor.
///
/// The current production codebase has no backend wired for AI, so the
/// mock implementation in `AiTutorLocalDataSource` implements this
/// interface. When a real backend lands, add a Firebase / network-backed
/// implementation here.
abstract class AiTutorRemoteDataSource {
  Future<AIResponseModel> fetchHint({
    required String questionId,
    required String questionText,
    String? userAnswer,
  });

  Future<AIResponseModel> fetchExplanation({
    required String questionId,
    required String questionText,
    required String correctAnswer,
    String? userAnswer,
  });

  Future<AIResponseModel> fetchSimplification({
    required String topic,
    String? gradeLevel,
  });

  Future<FlashcardDeckModel> fetchFlashcards({
    required String topic,
    required int count,
    required String difficultyId,
  });

  Future<AIResponseModel> fetchSummary({
    required String lessonId,
    String? lessonTitle,
  });

  Future<StudyPlanModel> fetchStudyPlan({
    required String subject,
    required int daysAhead,
    required int minutesPerDay,
  });

  Future<GeneratedQuestionSetModel> fetchQuestions({
    required String topic,
    required int count,
    required String difficultyId,
  });

  Future<List<ConversationModel>> fetchConversations();

  Future<ConversationModel> fetchConversationById(String id);

  Future<ConversationModel> persistConversation(ConversationModel conversation);

  Future<List<PromptEntryModel>> fetchPromptHistory();

  Future<PromptEntryModel> persistPromptEntry(PromptEntryModel entry);

  Future<bool> togglePromptFavorite(String promptId);

  Future<bool> deleteConversation(String conversationId);
}