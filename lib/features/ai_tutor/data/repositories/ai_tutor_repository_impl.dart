import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/ai_response_entity.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/generated_question.dart';
import '../../domain/entities/study_plan.dart';
import '../../domain/repositories/ai_tutor_repository.dart';
import '../datasources/ai_tutor_local_datasource.dart';
import '../datasources/ai_tutor_remote_datasource.dart';
import '../models/ai_response_model.dart';
import '../models/conversation_model.dart';
import '../models/flashcard_model.dart';
import '../models/generated_question_model.dart';
import '../models/prompt_entry_model.dart';
import '../models/study_plan_model.dart';

/// Concrete repository that delegates to an [AiTutorRemoteDataSource].
///
/// All exceptions are mapped through [ErrorHandler.map] so callers see
/// a uniform [Failure] vocabulary. The default factory wires the
/// bundled in-memory mock so the app boots with seeded content.
class AiTutorRepositoryImpl implements AiTutorRepository {
  const AiTutorRepositoryImpl({required this._remote});

  /// Convenience factory that wires the bundled mock data source.
  factory AiTutorRepositoryImpl.withDefaults() {
    return AiTutorRepositoryImpl(remote: AiTutorLocalDataSource());
  }

  final AiTutorRemoteDataSource _remote;

  // ---------------------------------------------------------------------------
  // Generation
  // ---------------------------------------------------------------------------

  @override
  Future<Result<AIResponseEntity>> generateHint({
    required String questionId,
    required String questionText,
    String? userAnswer,
  }) async {
    try {
      final AIResponseModel model = await _remote.fetchHint(
        questionId: questionId,
        questionText: questionText,
        userAnswer: userAnswer,
      );
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<AIResponseEntity>> generateExplanation({
    required String questionId,
    required String questionText,
    required String correctAnswer,
    String? userAnswer,
  }) async {
    try {
      final AIResponseModel model = await _remote.fetchExplanation(
        questionId: questionId,
        questionText: questionText,
        correctAnswer: correctAnswer,
        userAnswer: userAnswer,
      );
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<AIResponseEntity>> simplifyConcept({
    required String topic,
    String? gradeLevel,
  }) async {
    try {
      final AIResponseModel model = await _remote.fetchSimplification(
        topic: topic,
        gradeLevel: gradeLevel,
      );
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<FlashcardDeck>> generateFlashcards({
    required String topic,
    int count = 10,
    FlashcardDifficulty difficulty = FlashcardDifficulty.medium,
  }) async {
    try {
      final FlashcardDeckModel model = await _remote.fetchFlashcards(
        topic: topic,
        count: count,
        difficultyId: difficulty.name,
      );
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<AIResponseEntity>> generateSummary({
    required String lessonId,
    String? lessonTitle,
  }) async {
    try {
      final AIResponseModel model = await _remote.fetchSummary(
        lessonId: lessonId,
        lessonTitle: lessonTitle,
      );
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<StudyPlan>> generateStudyPlan({
    required String subject,
    required int daysAhead,
    int minutesPerDay = 30,
  }) async {
    try {
      final StudyPlanModel model = await _remote.fetchStudyPlan(
        subject: subject,
        daysAhead: daysAhead,
        minutesPerDay: minutesPerDay,
      );
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<GeneratedQuestionSet>> generateQuestions({
    required String topic,
    int count = 10,
    GeneratedQuestionDifficulty difficulty = GeneratedQuestionDifficulty.medium,
  }) async {
    try {
      final GeneratedQuestionSetModel model = await _remote.fetchQuestions(
        topic: topic,
        count: count,
        difficultyId: difficulty.name,
      );
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  // History / persistence
  // ---------------------------------------------------------------------------

  @override
  Future<Result<List<Conversation>>> loadConversationHistory() async {
    try {
      final List<ConversationModel> models =
          await _remote.fetchConversations();
      return Result.success(
        List<Conversation>.unmodifiable(
          models.map((ConversationModel m) => m.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<Conversation>> loadConversationById(
    String conversationId,
  ) async {
    try {
      final ConversationModel model =
          await _remote.fetchConversationById(conversationId);
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<Conversation>> saveConversation(Conversation conversation) async {
    try {
      final ConversationModel model = await _remote.persistConversation(
        ConversationModel(
          id: conversation.id,
          title: conversation.title,
          subtitle: conversation.subtitle,
          messages: conversation.messages
              .map(
                (ConversationMessage m) => ConversationMessageModel(
                  id: m.id,
                  roleId: m.role.name,
                  content: m.content,
                  createdAtIso: m.createdAt.toIso8601String(),
                  relatedQuestionId: m.relatedQuestionId,
                  relatedLessonId: m.relatedLessonId,
                ),
              )
              .toList(growable: false),
          createdAtIso: conversation.createdAt.toIso8601String(),
          updatedAtIso: conversation.updatedAt.toIso8601String(),
          relatedQuestionId: conversation.relatedQuestionId,
          relatedLessonId: conversation.relatedLessonId,
          tags: conversation.tags,
        ),
      );
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<PromptEntry>>> loadPromptHistory() async {
    try {
      final List<PromptEntryModel> models =
          await _remote.fetchPromptHistory();
      return Result.success(
        List<PromptEntry>.unmodifiable(
          models.map((PromptEntryModel m) => m.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<PromptEntry>> savePromptEntry(PromptEntry entry) async {
    try {
      final PromptEntryModel stored = await _remote.persistPromptEntry(
        PromptEntryModel(
          id: entry.id,
          text: entry.text,
          createdAtIso: entry.createdAt.toIso8601String(),
          category: entry.category,
          tags: entry.tags,
          isFavorite: entry.isFavorite,
          response: AIResponseModel(
            id: entry.response.id,
            kindId: entry.response.kind.name,
            title: entry.response.title,
            body: entry.response.body,
            createdAtIso: entry.response.createdAt.toIso8601String(),
            toneId: entry.response.tone.name,
            subtitle: entry.response.subtitle,
            confidence: entry.response.confidence,
            relatedQuestionId: entry.response.relatedQuestionId,
            relatedLessonId: entry.response.relatedLessonId,
            relatedTopic: entry.response.relatedTopic,
            tags: entry.response.tags,
          ),
        ),
      );
      return Result.success(stored.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<Conversation>>> loadRecentSessions({
    int limit = 5,
  }) async {
    try {
      final List<ConversationModel> models =
          await _remote.fetchConversations();
      final List<Conversation> truncated = models
          .take(limit)
          .map((ConversationModel m) => m.toEntity())
          .toList(growable: false);
      return Result.success(List<Conversation>.unmodifiable(truncated));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<bool>> togglePromptFavorite(String promptId) async {
    try {
      final bool result = await _remote.togglePromptFavorite(promptId);
      return Result.success(result);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<bool>> deleteConversation(String conversationId) async {
    try {
      final bool result = await _remote.deleteConversation(conversationId);
      return Result.success(result);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }
}