import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/ai/ai_prompt_builder.dart';
import '../../../../core/services/ai/ai_response_parser.dart';
import '../../../../core/services/ai/ai_service.dart';
import '../../../../core/services/ai/gemini_ai_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/ai_tutor_remote_datasource.dart';
import '../../data/datasources/gemini_remote_datasource.dart';
import '../../data/repositories/ai_tutor_repository_impl.dart';
import '../../domain/entities/ai_response_entity.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/generated_question.dart';
import '../../domain/entities/study_plan.dart';
import '../../domain/repositories/ai_tutor_repository.dart';
import '../../domain/usecases/generate_flashcards.dart';
import '../../domain/usecases/generate_hint.dart';
import '../../domain/usecases/generate_questions.dart';
import '../../domain/usecases/generate_study_plan.dart';
import '../../domain/usecases/generate_summary.dart';
import '../../domain/usecases/save_conversation.dart';

// ---------------------------------------------------------------------------
// Core service providers
// ---------------------------------------------------------------------------

/// Provider-agnostic AI service. The default binding is Gemini; flip
/// the override in tests / app bootstrap to plug in OpenAI / Claude /
/// DeepSeek without touching the data or presentation layers.
final Provider<AiService> aiServiceProvider = Provider<AiService>((Ref ref) {
  return GeminiAiService();
});

final Provider<AiPromptBuilder> aiPromptBuilderProvider =
    Provider<AiPromptBuilder>((Ref ref) => const AiPromptBuilder());

final Provider<AiResponseParser> aiResponseParserProvider =
    Provider<AiResponseParser>((Ref ref) => const AiResponseParser());

// ---------------------------------------------------------------------------
// Data sources & repository providers
// ---------------------------------------------------------------------------

/// Gemini-backed implementation of [AiTutorRemoteDataSource].
///
/// Seeds deterministic conversations and prompts so the chat UX has
/// content immediately. The service / parser / prompt-builder are
/// all injected, which keeps every dependency explicit and makes the
/// datasource straightforward to test with stubs.
final Provider<AiTutorRemoteDataSource> aiTutorRemoteDataSourceProvider =
    Provider<AiTutorRemoteDataSource>((Ref ref) {
  return GeminiRemoteDataSource(
    service: ref.watch(aiServiceProvider),
    promptBuilder: ref.watch(aiPromptBuilderProvider),
    responseParser: ref.watch(aiResponseParserProvider),
  );
});

/// Single repository for the AI Tutor feature.
final Provider<AiTutorRepository> aiTutorRepositoryProvider =
    Provider<AiTutorRepository>((Ref ref) {
  return AiTutorRepositoryImpl(
    remote: ref.watch(aiTutorRemoteDataSourceProvider),
  );
});

// ---------------------------------------------------------------------------
// Use case providers
// ---------------------------------------------------------------------------

final Provider<GenerateHint> generateHintProvider =
    Provider<GenerateHint>((Ref ref) {
  return GenerateHint(ref.watch(aiTutorRepositoryProvider));
});

final Provider<GenerateExplanation> generateExplanationProvider =
    Provider<GenerateExplanation>((Ref ref) {
  return GenerateExplanation(ref.watch(aiTutorRepositoryProvider));
});

final Provider<SimplifyConcept> simplifyConceptProvider =
    Provider<SimplifyConcept>((Ref ref) {
  return SimplifyConcept(ref.watch(aiTutorRepositoryProvider));
});

final Provider<ExplainTopic> explainTopicProvider =
    Provider<ExplainTopic>((Ref ref) {
  return ExplainTopic(ref.watch(aiTutorRepositoryProvider));
});

final Provider<GenerateSummary> generateSummaryProvider =
    Provider<GenerateSummary>((Ref ref) {
  return GenerateSummary(ref.watch(aiTutorRepositoryProvider));
});

final Provider<GenerateFlashcards> generateFlashcardsProvider =
    Provider<GenerateFlashcards>((Ref ref) {
  return GenerateFlashcards(ref.watch(aiTutorRepositoryProvider));
});

final Provider<GenerateStudyPlan> generateStudyPlanProvider =
    Provider<GenerateStudyPlan>((Ref ref) {
  return GenerateStudyPlan(ref.watch(aiTutorRepositoryProvider));
});

final Provider<GenerateQuestions> generateQuestionsProvider =
    Provider<GenerateQuestions>((Ref ref) {
  return GenerateQuestions(ref.watch(aiTutorRepositoryProvider));
});

final Provider<SaveConversation> saveConversationProvider =
    Provider<SaveConversation>((Ref ref) {
  return SaveConversation(ref.watch(aiTutorRepositoryProvider));
});

final Provider<LoadConversationHistory> loadConversationHistoryProvider =
    Provider<LoadConversationHistory>((Ref ref) {
  return LoadConversationHistory(ref.watch(aiTutorRepositoryProvider));
});

final Provider<LoadConversationById> loadConversationByIdProvider =
    Provider<LoadConversationById>((Ref ref) {
  return LoadConversationById(ref.watch(aiTutorRepositoryProvider));
});

final Provider<LoadRecentSessions> loadRecentSessionsProvider =
    Provider<LoadRecentSessions>((Ref ref) {
  return LoadRecentSessions(ref.watch(aiTutorRepositoryProvider));
});

final Provider<LoadPromptHistory> loadPromptHistoryProvider =
    Provider<LoadPromptHistory>((Ref ref) {
  return LoadPromptHistory(ref.watch(aiTutorRepositoryProvider));
});

final Provider<SavePromptEntry> savePromptEntryProvider =
    Provider<SavePromptEntry>((Ref ref) {
  return SavePromptEntry(ref.watch(aiTutorRepositoryProvider));
});

final Provider<TogglePromptFavorite> togglePromptFavoriteProvider =
    Provider<TogglePromptFavorite>((Ref ref) {
  return TogglePromptFavorite(ref.watch(aiTutorRepositoryProvider));
});

final Provider<DeleteConversation> deleteConversationProvider =
    Provider<DeleteConversation>((Ref ref) {
  return DeleteConversation(ref.watch(aiTutorRepositoryProvider));
});

// ---------------------------------------------------------------------------
// Shared load status enum (used by every generator controller)
// ---------------------------------------------------------------------------

enum AiTutorLoadStatus { idle, initial, loading, ready, error }

// ---------------------------------------------------------------------------
// Provider 1 — Hint controller (per-question, by id)
// ---------------------------------------------------------------------------

@immutable
class AiHintState {
  const AiHintState({required this.status, this.hint, this.errorMessage});

  final AiTutorLoadStatus status;
  final AIResponseEntity? hint;
  final String? errorMessage;

  AiHintState copyWith({
    AiTutorLoadStatus? status,
    AIResponseEntity? hint,
    String? errorMessage,
  }) {
    return AiHintState(
      status: status ?? this.status,
      hint: hint ?? this.hint,
      errorMessage: errorMessage,
    );
  }

  static const AiHintState initial =
      AiHintState(status: AiTutorLoadStatus.idle);
}

class AiHintController extends StateNotifier<AiHintState> {
  AiHintController(this._useCase) : super(AiHintState.initial);

  final GenerateHint _useCase;

  Future<void> generate({
    required String questionId,
    required String questionText,
    String? userAnswer,
  }) async {
    if (state.status == AiTutorLoadStatus.loading) return;
    state = state.copyWith(
      status: AiTutorLoadStatus.loading,
      hint: null,
    );
    final Result<AIResponseEntity> result = await _useCase(
      questionId: questionId,
      questionText: questionText,
      userAnswer: userAnswer,
    );
    result.fold(
      onFailure: (failure) {
        state = AiHintState(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (AIResponseEntity value) {
        state = AiHintState(
          status: AiTutorLoadStatus.ready,
          hint: value,
        );
      },
    );
  }

  void reset() {
    state = AiHintState.initial;
  }
}

final StateNotifierProviderFamily<AiHintController, AiHintState, String>
    aiHintControllerProvider =
    StateNotifierProvider.family<AiHintController, AiHintState, String>(
        (Ref ref, String questionId) {
  return AiHintController(ref.watch(generateHintProvider));
});

// ---------------------------------------------------------------------------
// Provider 2 — Generator controller (explanation / simplification / summary)
// ---------------------------------------------------------------------------

@immutable
class AiResponseState {
  const AiResponseState({
    required this.status,
    this.response,
    this.errorMessage,
  });

  final AiTutorLoadStatus status;
  final AIResponseEntity? response;
  final String? errorMessage;

  AiResponseState copyWith({
    AiTutorLoadStatus? status,
    AIResponseEntity? response,
    String? errorMessage,
  }) {
    return AiResponseState(
      status: status ?? this.status,
      response: response ?? this.response,
      errorMessage: errorMessage,
    );
  }

  static const AiResponseState initial =
      AiResponseState(status: AiTutorLoadStatus.idle);
}

class AiResponseController extends StateNotifier<AiResponseState> {
  AiResponseController({
    required GenerateExplanation? explanationUseCase,
    required SimplifyConcept? simplifyUseCase,
    required GenerateSummary? summaryUseCase,
    required ExplainTopic? explainTopicUseCase,
  })  : _explanationUseCase = explanationUseCase,
        _simplifyUseCase = simplifyUseCase,
        _summaryUseCase = summaryUseCase,
        _explainTopicUseCase = explainTopicUseCase,
        super(AiResponseState.initial);

  final GenerateExplanation? _explanationUseCase;
  final SimplifyConcept? _simplifyUseCase;
  final GenerateSummary? _summaryUseCase;
  final ExplainTopic? _explainTopicUseCase;

  Future<void> generateExplanation({
    required String questionId,
    required String questionText,
    required String correctAnswer,
    String? userAnswer,
  }) async {
    final GenerateExplanation? useCase = _explanationUseCase;
    if (useCase == null) return;
    if (state.status == AiTutorLoadStatus.loading) return;
    state = state.copyWith(status: AiTutorLoadStatus.loading, response: null);
    final Result<AIResponseEntity> result = await useCase(
      questionId: questionId,
      questionText: questionText,
      correctAnswer: correctAnswer,
      userAnswer: userAnswer,
    );
    result.fold(
      onFailure: (failure) {
        state = AiResponseState(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (AIResponseEntity value) {
        state = AiResponseState(
          status: AiTutorLoadStatus.ready,
          response: value,
        );
      },
    );
  }

  Future<void> simplify({required String topic, String? gradeLevel}) async {
    final SimplifyConcept? useCase = _simplifyUseCase;
    if (useCase == null) return;
    if (state.status == AiTutorLoadStatus.loading) return;
    state = state.copyWith(status: AiTutorLoadStatus.loading, response: null);
    final Result<AIResponseEntity> result =
        await useCase(topic: topic, gradeLevel: gradeLevel);
    result.fold(
      onFailure: (failure) {
        state = AiResponseState(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (AIResponseEntity value) {
        state = AiResponseState(
          status: AiTutorLoadStatus.ready,
          response: value,
        );
      },
    );
  }

  Future<void> explainTopic({required String topic}) async {
    final ExplainTopic? useCase = _explainTopicUseCase;
    if (useCase == null) return;
    if (state.status == AiTutorLoadStatus.loading) return;
    state = state.copyWith(status: AiTutorLoadStatus.loading, response: null);
    final Result<AIResponseEntity> result = await useCase(topic: topic);
    result.fold(
      onFailure: (failure) {
        state = AiResponseState(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (AIResponseEntity value) {
        state = AiResponseState(
          status: AiTutorLoadStatus.ready,
          response: value,
        );
      },
    );
  }

  Future<void> summarise({
    required String lessonId,
    String? lessonTitle,
  }) async {
    final GenerateSummary? useCase = _summaryUseCase;
    if (useCase == null) return;
    if (state.status == AiTutorLoadStatus.loading) return;
    state = state.copyWith(status: AiTutorLoadStatus.loading, response: null);
    final Result<AIResponseEntity> result =
        await useCase(lessonId: lessonId, lessonTitle: lessonTitle);
    result.fold(
      onFailure: (failure) {
        state = AiResponseState(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (AIResponseEntity value) {
        state = AiResponseState(
          status: AiTutorLoadStatus.ready,
          response: value,
        );
      },
    );
  }

  void reset() {
    state = AiResponseState.initial;
  }
}

/// Family keyed by an enum so each consumer (explanation, simplify,
/// summary, topic) gets its own controller instance.
enum AiResponseKind2 { explanation, simplify, summary, topic }

final StateNotifierProviderFamily<AiResponseController, AiResponseState,
        AiResponseKind2>
    aiResponseControllerProvider =
    StateNotifierProvider.family<AiResponseController, AiResponseState,
        AiResponseKind2>((Ref ref, AiResponseKind2 kind) {
  switch (kind) {
    case AiResponseKind2.explanation:
      return AiResponseController(
        explanationUseCase: ref.watch(generateExplanationProvider),
        simplifyUseCase: null,
        summaryUseCase: null,
        explainTopicUseCase: null,
      );
    case AiResponseKind2.simplify:
      return AiResponseController(
        explanationUseCase: null,
        simplifyUseCase: ref.watch(simplifyConceptProvider),
        summaryUseCase: null,
        explainTopicUseCase: null,
      );
    case AiResponseKind2.summary:
      return AiResponseController(
        explanationUseCase: null,
        simplifyUseCase: null,
        summaryUseCase: ref.watch(generateSummaryProvider),
        explainTopicUseCase: null,
      );
    case AiResponseKind2.topic:
      return AiResponseController(
        explanationUseCase: null,
        simplifyUseCase: null,
        summaryUseCase: null,
        explainTopicUseCase: ref.watch(explainTopicProvider),
      );
  }
});

// ---------------------------------------------------------------------------
// Provider 3 — Content generator (flashcards / study plan / questions)
// ---------------------------------------------------------------------------

@immutable
class AiContentState {
  const AiContentState({
    required this.status,
    this.flashcards,
    this.studyPlan,
    this.questions,
    this.errorMessage,
  });

  final AiTutorLoadStatus status;
  final FlashcardDeck? flashcards;
  final StudyPlan? studyPlan;
  final GeneratedQuestionSet? questions;
  final String? errorMessage;

  AiContentState copyWith({
    AiTutorLoadStatus? status,
    FlashcardDeck? flashcards,
    StudyPlan? studyPlan,
    GeneratedQuestionSet? questions,
    String? errorMessage,
  }) {
    return AiContentState(
      status: status ?? this.status,
      flashcards: flashcards ?? this.flashcards,
      studyPlan: studyPlan ?? this.studyPlan,
      questions: questions ?? this.questions,
      errorMessage: errorMessage,
    );
  }

  static const AiContentState initial =
      AiContentState(status: AiTutorLoadStatus.idle);
}

class AiContentController extends StateNotifier<AiContentState> {
  AiContentController({
    required GenerateFlashcards? flashcardsUseCase,
    required GenerateStudyPlan? studyPlanUseCase,
    required GenerateQuestions? questionsUseCase,
  })  : _flashcardsUseCase = flashcardsUseCase,
        _studyPlanUseCase = studyPlanUseCase,
        _questionsUseCase = questionsUseCase,
        super(AiContentState.initial);

  final GenerateFlashcards? _flashcardsUseCase;
  final GenerateStudyPlan? _studyPlanUseCase;
  final GenerateQuestions? _questionsUseCase;

  Future<void> generateFlashcards({
    required String topic,
    required int count,
    required FlashcardDifficulty difficulty,
  }) async {
    final GenerateFlashcards? useCase = _flashcardsUseCase;
    if (useCase == null) return;
    if (state.status == AiTutorLoadStatus.loading) return;
    state = AiContentState(status: AiTutorLoadStatus.loading);
    final Result<FlashcardDeck> result = await useCase(
      topic: topic,
      count: count,
      difficulty: difficulty,
    );
    result.fold(
      onFailure: (failure) {
        state = AiContentState(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (FlashcardDeck value) {
        state = AiContentState(
          status: AiTutorLoadStatus.ready,
          flashcards: value,
        );
      },
    );
  }

  Future<void> generateStudyPlan({
    required String subject,
    required int daysAhead,
    required int minutesPerDay,
  }) async {
    final GenerateStudyPlan? useCase = _studyPlanUseCase;
    if (useCase == null) return;
    if (state.status == AiTutorLoadStatus.loading) return;
    state = AiContentState(status: AiTutorLoadStatus.loading);
    final Result<StudyPlan> result = await useCase(
      subject: subject,
      daysAhead: daysAhead,
      minutesPerDay: minutesPerDay,
    );
    result.fold(
      onFailure: (failure) {
        state = AiContentState(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (StudyPlan value) {
        state = AiContentState(
          status: AiTutorLoadStatus.ready,
          studyPlan: value,
        );
      },
    );
  }

  Future<void> generateQuestions({
    required String topic,
    required int count,
    required GeneratedQuestionDifficulty difficulty,
  }) async {
    final GenerateQuestions? useCase = _questionsUseCase;
    if (useCase == null) return;
    if (state.status == AiTutorLoadStatus.loading) return;
    state = AiContentState(status: AiTutorLoadStatus.loading);
    final Result<GeneratedQuestionSet> result = await useCase(
      topic: topic,
      count: count,
      difficulty: difficulty,
    );
    result.fold(
      onFailure: (failure) {
        state = AiContentState(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (GeneratedQuestionSet value) {
        state = AiContentState(
          status: AiTutorLoadStatus.ready,
          questions: value,
        );
      },
    );
  }

  void reset() {
    state = AiContentState.initial;
  }
}

enum AiContentKind { flashcards, studyPlan, questions }

final StateNotifierProviderFamily<AiContentController, AiContentState,
        AiContentKind>
    aiContentControllerProvider =
    StateNotifierProvider.family<AiContentController, AiContentState,
        AiContentKind>((Ref ref, AiContentKind kind) {
  switch (kind) {
    case AiContentKind.flashcards:
      return AiContentController(
        flashcardsUseCase: ref.watch(generateFlashcardsProvider),
        studyPlanUseCase: null,
        questionsUseCase: null,
      );
    case AiContentKind.studyPlan:
      return AiContentController(
        flashcardsUseCase: null,
        studyPlanUseCase: ref.watch(generateStudyPlanProvider),
        questionsUseCase: null,
      );
    case AiContentKind.questions:
      return AiContentController(
        flashcardsUseCase: null,
        studyPlanUseCase: null,
        questionsUseCase: ref.watch(generateQuestionsProvider),
      );
  }
});

// ---------------------------------------------------------------------------
// Provider 4 — Chat controller (per-conversation)
// ---------------------------------------------------------------------------

@immutable
class AiChatState {
  const AiChatState({
    required this.status,
    required this.conversation,
    this.errorMessage,
  });

  final AiTutorLoadStatus status;
  final Conversation conversation;
  final String? errorMessage;

  AiChatState copyWith({
    AiTutorLoadStatus? status,
    Conversation? conversation,
    String? errorMessage,
  }) {
    return AiChatState(
      status: status ?? this.status,
      conversation: conversation ?? this.conversation,
      errorMessage: errorMessage,
    );
  }

  static AiChatState seed() {
    final DateTime now = DateTime.now();
    return AiChatState(
      status: AiTutorLoadStatus.idle,
      conversation: Conversation(
        id: 'conv-${now.millisecondsSinceEpoch}',
        title: 'New conversation',
        createdAt: now,
        updatedAt: now,
        messages: const <ConversationMessage>[],
      ),
    );
  }
}

class AiChatController extends StateNotifier<AiChatState> {
  AiChatController({
    required LoadConversationById loadById,
    required SaveConversation saveUseCase,
    Conversation? initial,
  })  : _loadById = loadById,
        _save = saveUseCase,
        super(
          initial != null
              ? AiChatState(
                  status: AiTutorLoadStatus.ready,
                  conversation: initial,
                )
              : AiChatState.seed(),
        );

  final LoadConversationById _loadById;
  final SaveConversation _save;

  bool get isBusy => state.status == AiTutorLoadStatus.loading;

  Future<void> load(String conversationId) async {
    state = state.copyWith(status: AiTutorLoadStatus.loading);
    final Result<Conversation> result = await _loadById(conversationId);
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: AiTutorLoadStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (Conversation value) {
        state = AiChatState(
          status: AiTutorLoadStatus.ready,
          conversation: value,
        );
      },
    );
  }

  /// Simulates an assistant turn for an inline reply. In production
  /// this would call the backend; here it produces a deterministic
  /// response so the chat UX is testable end-to-end.
  Future<void> sendUserMessage(String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final DateTime now = DateTime.now();
    final ConversationMessage userMessage = ConversationMessage(
      id: 'm-${now.millisecondsSinceEpoch}',
      role: ConversationRole.user,
      content: trimmed,
      createdAt: now,
    );
    final Conversation updated = state.conversation.copyWith(
      messages: <ConversationMessage>[
        ...state.conversation.messages,
        userMessage,
      ],
      updatedAt: now,
      title: state.conversation.messages.isEmpty ? trimmed : state.conversation.title,
    );
    state = state.copyWith(conversation: updated);
    await _save(updated);

    state = state.copyWith(status: AiTutorLoadStatus.loading);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final String reply = _composeReply(trimmed);
    final ConversationMessage assistantMessage = ConversationMessage(
      id: 'm-${now.millisecondsSinceEpoch + 1}',
      role: ConversationRole.assistant,
      content: reply,
      createdAt: DateTime.now(),
    );
    final Conversation finalConv = updated.copyWith(
      messages: <ConversationMessage>[...updated.messages, assistantMessage],
      updatedAt: DateTime.now(),
    );
    state = AiChatState(
      status: AiTutorLoadStatus.ready,
      conversation: finalConv,
    );
    await _save(finalConv);
  }

  void clear() {
    state = AiChatState.seed();
  }

  String _composeReply(String prompt) {
    final String lower = prompt.toLowerCase();
    if (lower.contains('tense') || lower.contains('grammar')) {
      return 'Quick grammar hint: isolate the time marker first, then '
          'pick the tense that fits. Want me to walk through an example?';
    }
    if (lower.contains('percent') || lower.contains('math')) {
      return 'Percent trick: convert to a decimal (divide by 100), '
          'then multiply in the order the problem states.';
    }
    return 'Got it. I will respond in the chat in the real backend; '
        'for now, the rest of the UI is wired up — try sending another '
        'message to see the typing indicator and persistence flow.';
  }
}

/// Family provider — each conversation id gets its own controller.
final StateNotifierProviderFamily<AiChatController, AiChatState, String>
    aiChatControllerProvider =
    StateNotifierProvider.family<AiChatController, AiChatState, String>(
        (Ref ref, String conversationId) {
  return AiChatController(
    loadById: ref.watch(loadConversationByIdProvider),
    saveUseCase: ref.watch(saveConversationProvider),
  );
});

/// Convenience: a fresh (empty) conversation controller for new chats.
final StateNotifierProvider<AiChatController, AiChatState>
    aiNewChatControllerProvider =
    StateNotifierProvider<AiChatController, AiChatState>((Ref ref) {
  return AiChatController(
    loadById: ref.watch(loadConversationByIdProvider),
    saveUseCase: ref.watch(saveConversationProvider),
  );
});

// ---------------------------------------------------------------------------
// Provider 5 — History controller (conversations + prompts + favorites)
// ---------------------------------------------------------------------------

@immutable
class AiHistoryState {
  const AiHistoryState({
    required this.status,
    required this.conversations,
    required this.prompts,
    required this.recentSessions,
    this.errorMessage,
  });

  final AiTutorLoadStatus status;
  final List<Conversation> conversations;
  final List<PromptEntry> prompts;
  final List<Conversation> recentSessions;
  final String? errorMessage;

  AiHistoryState copyWith({
    AiTutorLoadStatus? status,
    List<Conversation>? conversations,
    List<PromptEntry>? prompts,
    List<Conversation>? recentSessions,
    String? errorMessage,
  }) {
    return AiHistoryState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      prompts: prompts ?? this.prompts,
      recentSessions: recentSessions ?? this.recentSessions,
      errorMessage: errorMessage,
    );
  }

  static const AiHistoryState initial = AiHistoryState(
    status: AiTutorLoadStatus.idle,
    conversations: <Conversation>[],
    prompts: <PromptEntry>[],
    recentSessions: <Conversation>[],
  );
}

class AiHistoryController extends StateNotifier<AiHistoryState> {
  AiHistoryController({
    required LoadConversationHistory loadHistory,
    required LoadPromptHistory loadPrompts,
    required LoadRecentSessions loadRecent,
    required SavePromptEntry savePrompt,
    required TogglePromptFavorite toggleFavorite,
    required DeleteConversation deleteConv,
  })  : _loadHistory = loadHistory,
        _loadPrompts = loadPrompts,
        _loadRecent = loadRecent,
        _savePrompt = savePrompt,
        _toggleFavorite = toggleFavorite,
        _deleteConv = deleteConv,
        super(AiHistoryState.initial);

  final LoadConversationHistory _loadHistory;
  final LoadPromptHistory _loadPrompts;
  final LoadRecentSessions _loadRecent;
  final SavePromptEntry _savePrompt;
  final TogglePromptFavorite _toggleFavorite;
  final DeleteConversation _deleteConv;

  Future<void> load({int recentLimit = 5}) async {
    if (state.status == AiTutorLoadStatus.loading) return;
    state = state.copyWith(status: AiTutorLoadStatus.loading);
    final Result<List<Conversation>> historyResult = await _loadHistory();
    final Result<List<PromptEntry>> promptsResult = await _loadPrompts();
    final Result<List<Conversation>> recentResult =
        await _loadRecent(limit: recentLimit);
    final String? error = historyResult.isFailure
        ? historyResult.failureOrNull?.message
        : promptsResult.isFailure
            ? promptsResult.failureOrNull?.message
            : null;
    state = AiHistoryState(
      status: error == null ? AiTutorLoadStatus.ready : AiTutorLoadStatus.error,
      conversations: historyResult.valueOrNull ?? const <Conversation>[],
      prompts: promptsResult.valueOrNull ?? const <PromptEntry>[],
      recentSessions: recentResult.valueOrNull ?? const <Conversation>[],
      errorMessage: error,
    );
  }

  Future<void> toggleFavorite(String promptId) async {
    final List<PromptEntry> previous =
        List<PromptEntry>.of(state.prompts);
    final List<PromptEntry> optimistic = List<PromptEntry>.of(state.prompts);
    final int idx = optimistic.indexWhere((PromptEntry p) => p.id == promptId);
    if (idx == -1) return;
    optimistic[idx] = optimistic[idx].copyWith(
      isFavorite: !optimistic[idx].isFavorite,
    );
    state = state.copyWith(prompts: List<PromptEntry>.unmodifiable(optimistic));

    final Result<bool> result = await _toggleFavorite(promptId);
    result.fold(
      onFailure: (_) {
        state = state.copyWith(
          prompts: List<PromptEntry>.unmodifiable(previous),
        );
      },
      onSuccess: (bool isFav) {
        final List<PromptEntry> next = List<PromptEntry>.of(state.prompts);
        final int i = next.indexWhere((PromptEntry p) => p.id == promptId);
        if (i != -1) {
          next[i] = next[i].copyWith(isFavorite: isFav);
        }
        state = state.copyWith(prompts: List<PromptEntry>.unmodifiable(next));
      },
    );
  }

  Future<void> deleteConversation(String id) async {
    final List<Conversation> previous = List<Conversation>.of(state.conversations);
    final List<Conversation> optimistic = List<Conversation>.of(state.conversations)
      ..removeWhere((Conversation c) => c.id == id);
    state = state.copyWith(
      conversations: List<Conversation>.unmodifiable(optimistic),
    );
    final Result<bool> result = await _deleteConv(id);
    result.fold(
      onFailure: (_) {
        state = state.copyWith(
          conversations: List<Conversation>.unmodifiable(previous),
        );
      },
      onSuccess: (_) {
        // state already updated optimistically.
      },
    );
  }

  Future<void> savePrompt(PromptEntry entry) async {
    final Result<PromptEntry> result = await _savePrompt(entry);
    result.fold(
      onFailure: (_) {/* swallow — UI keeps the in-memory copy */},
      onSuccess: (PromptEntry saved) {
        final List<PromptEntry> next = <PromptEntry>[saved, ...state.prompts];
        state = state.copyWith(
          prompts: List<PromptEntry>.unmodifiable(next),
        );
      },
    );
  }
}

final StateNotifierProvider<AiHistoryController, AiHistoryState>
    aiHistoryControllerProvider =
    StateNotifierProvider<AiHistoryController, AiHistoryState>((Ref ref) {
  return AiHistoryController(
    loadHistory: ref.watch(loadConversationHistoryProvider),
    loadPrompts: ref.watch(loadPromptHistoryProvider),
    loadRecent: ref.watch(loadRecentSessionsProvider),
    savePrompt: ref.watch(savePromptEntryProvider),
    toggleFavorite: ref.watch(togglePromptFavoriteProvider),
    deleteConv: ref.watch(deleteConversationProvider),
  );
});