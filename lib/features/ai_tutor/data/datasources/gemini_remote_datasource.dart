import 'dart:async';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/services/ai/ai_prompt_builder.dart';
import '../../../../core/services/ai/ai_response_parser.dart';
import '../../../../core/services/ai/ai_service.dart';
import '../models/ai_response_model.dart';
import '../models/conversation_model.dart';
import '../models/flashcard_model.dart';
import '../models/generated_question_model.dart';
import '../models/prompt_entry_model.dart';
import '../models/study_plan_model.dart';
import 'ai_tutor_remote_datasource.dart';

/// Gemini-backed implementation of [AiTutorRemoteDataSource].
///
/// Generation calls go through [AiService] (provider-agnostic) so the
/// same class can later be re-pointed at OpenAI / Claude / DeepSeek
/// by swapping the [AiService] binding in DI. Conversation / prompt
/// history are held in memory and seeded with a small set of
/// placeholder conversations so the chat UX remains testable end-to-end
/// until a real persistence layer lands — the datasource contract is
/// unchanged, so swapping the storage is also a one-line change.
class GeminiRemoteDataSource implements AiTutorRemoteDataSource {
  GeminiRemoteDataSource({
    required AiService service,
    AiPromptBuilder? promptBuilder,
    AiResponseParser? responseParser,
  })  : _service = service,
        _prompts = promptBuilder ?? const AiPromptBuilder(),
        _parser = responseParser ?? const AiResponseParser();

  final AiService _service;
  final AiPromptBuilder _prompts;
  final AiResponseParser _parser;

  final Map<String, ConversationModel> _conversations =
      <String, ConversationModel>{};
  final List<PromptEntryModel> _prompts2 = <PromptEntryModel>[];

  // ---------------------------------------------------------------------------
  // Hint / explanation / simplification / summary
  // ---------------------------------------------------------------------------

  @override
  Future<AIResponseModel> fetchHint({
    required String questionId,
    required String questionText,
    String? userAnswer,
  }) async {
    final AiRequest request = _prompts.buildHint(
      questionText: questionText,
      userAnswer: userAnswer,
    );
    return _completeJson(
      request: request,
      kindId: 'hint',
      defaultTitle: 'Hint',
      defaultBody: _fallbackHint(userAnswer),
      relatedQuestionId: questionId,
      relatedTopic: _topicFromPrompt(questionText),
      tags: const <String>['Hint'],
      toneId: 'hint',
    );
  }

  @override
  Future<AIResponseModel> fetchExplanation({
    required String questionId,
    required String questionText,
    required String correctAnswer,
    String? userAnswer,
  }) async {
    final AiRequest request = _prompts.buildExplanation(
      questionText: questionText,
      correctAnswer: correctAnswer,
      userAnswer: userAnswer,
    );
    return _completeJson(
      request: request,
      kindId: 'explanation',
      defaultTitle: 'Explanation',
      defaultBody: _fallbackExplanation(correctAnswer, userAnswer),
      relatedQuestionId: questionId,
      relatedTopic: _topicFromPrompt(questionText),
      tags: const <String>['Explanation'],
      toneId: 'insight',
    );
  }

  @override
  Future<AIResponseModel> fetchSimplification({
    required String topic,
    String? gradeLevel,
  }) async {
    final AiRequest request = _prompts.buildSimplification(
      topic: topic,
      gradeLevel: gradeLevel,
    );
    return _completeJson(
      request: request,
      kindId: 'simplification',
      defaultTitle: '$topic, simplified',
      subtitle: gradeLevel == null
          ? 'Plain-English explainer'
          : 'Adapted for $gradeLevel',
      defaultBody: _fallbackSimplify(topic),
      relatedTopic: topic,
      tags: const <String>['Simplify'],
      toneId: 'tip',
    );
  }

  @override
  Future<AIResponseModel> fetchSummary({
    required String lessonId,
    String? lessonTitle,
  }) async {
    final AiRequest request = _prompts.buildSummary(
      lessonId: lessonId,
      lessonTitle: lessonTitle,
    );
    return _completeJson(
      request: request,
      kindId: 'summary',
      defaultTitle: lessonTitle ?? 'Lesson summary',
      subtitle: '5-bullet recap',
      defaultBody: _fallbackSummary(),
      relatedLessonId: lessonId,
      tags: const <String>['Summary'],
      toneId: 'insight',
    );
  }

  // ---------------------------------------------------------------------------
  // Flashcards
  // ---------------------------------------------------------------------------

  @override
  Future<FlashcardDeckModel> fetchFlashcards({
    required String topic,
    required int count,
    required String difficultyId,
  }) async {
    final AiRequest request = _prompts.buildFlashcards(
      topic: topic,
      count: count,
      difficultyId: difficultyId,
    );
    final AiResponse response = await _service.complete(request);
    final AiParsedResponse parsed = _parser.parse(response.body);
    if (parsed.usedFallback || parsed.parsedJson == null) {
      return _fallbackFlashcards(topic, count, difficultyId);
    }
    final Map<String, dynamic> json = parsed.parsedJson!;
    final List<dynamic> rawCards =
        json['cards'] is List ? json['cards'] as List : const <dynamic>[];
    final String deckId = 'deck-$topic';
    final List<FlashcardModel> cards = <FlashcardModel>[];
    for (int i = 0; i < rawCards.length; i++) {
      final dynamic raw = rawCards[i];
      if (raw is! Map<String, dynamic>) continue;
      cards.add(FlashcardModel(
        id: '$deckId-$i',
        deckId: deckId,
        front: _stringOr(raw['front'], 'Concept #$i'),
        back: _stringOr(raw['back'], 'Definition pending.'),
        topic: topic,
        difficultyId: difficultyId,
        hint: raw['hint'] is String ? raw['hint'] as String : null,
        tags: <String>[topic, 'AI'],
      ));
    }
    if (cards.isEmpty) {
      return _fallbackFlashcards(topic, count, difficultyId);
    }
    return FlashcardDeckModel(
      id: deckId,
      title: _stringOr(json['title'], '$topic — Rapid Review'),
      subtitle: '${cards.length} cards',
      description: _stringOr(json['description'], 'Spaced-repetition deck.'),
      topic: topic,
      cards: cards,
      createdAtIso: DateTime.now().toIso8601String(),
    );
  }

  // ---------------------------------------------------------------------------
  // Study plan
  // ---------------------------------------------------------------------------

  @override
  Future<StudyPlanModel> fetchStudyPlan({
    required String subject,
    required int daysAhead,
    required int minutesPerDay,
  }) async {
    final AiRequest request = _prompts.buildStudyPlan(
      subject: subject,
      daysAhead: daysAhead,
      minutesPerDay: minutesPerDay,
    );
    final AiResponse response = await _service.complete(request);
    final AiParsedResponse parsed = _parser.parse(response.body);
    if (parsed.usedFallback || parsed.parsedJson == null) {
      return _fallbackStudyPlan(subject, daysAhead, minutesPerDay);
    }
    final Map<String, dynamic> json = parsed.parsedJson!;
    final List<dynamic> rawDays =
        json['days'] is List ? json['days'] as List : const <dynamic>[];
    final List<StudyDayModel> days = <StudyDayModel>[];
    int totalMinutes = 0;
    for (int d = 0; d < rawDays.length; d++) {
      final dynamic rawDay = rawDays[d];
      if (rawDay is! Map<String, dynamic>) continue;
      final List<dynamic> rawTasks =
          rawDay['tasks'] is List ? rawDay['tasks'] as List : const <dynamic>[];
      final List<StudyTaskModel> tasks = <StudyTaskModel>[];
      for (int t = 0; t < rawTasks.length; t++) {
        final dynamic rawTask = rawTasks[t];
        if (rawTask is! Map<String, dynamic>) continue;
        final int minutes = _intOr(rawTask['minutes'], 10);
        totalMinutes += minutes;
        tasks.add(StudyTaskModel(
          id: 'plan-$subject-$d-$t',
          title: _stringOr(rawTask['title'], 'Task'),
          description: rawTask['description'] is String
              ? rawTask['description'] as String
              : null,
          estimatedMinutes: minutes,
          kindId: _studyKindId(rawTask['kind']),
          relatedTopic: subject,
        ));
      }
      days.add(StudyDayModel(
        id: 'plan-$subject-$d',
        dayLabel: _stringOr(rawDay['label'], 'Day ${d + 1}'),
        tasks: tasks,
      ));
    }
    if (days.isEmpty) {
      return _fallbackStudyPlan(subject, daysAhead, minutesPerDay);
    }
    return StudyPlanModel(
      id: 'plan-$subject',
      title: _stringOr(json['title'], '$subject — plan'),
      subtitle: '${minutesPerDay}m / day',
      description: _stringOr(json['description'],
          'Balanced mix of review, lesson, practice, and spaced repetition.'),
      subject: subject,
      days: days,
      totalMinutes: _intOr(json['totalMinutes'], totalMinutes),
      createdAtIso: DateTime.now().toIso8601String(),
    );
  }

  // ---------------------------------------------------------------------------
  // Generated questions
  // ---------------------------------------------------------------------------

  @override
  Future<GeneratedQuestionSetModel> fetchQuestions({
    required String topic,
    required int count,
    required String difficultyId,
  }) async {
    final AiRequest request = _prompts.buildQuestions(
      topic: topic,
      count: count,
      difficultyId: difficultyId,
    );
    final AiResponse response = await _service.complete(request);
    final AiParsedResponse parsed = _parser.parse(response.body);
    if (parsed.usedFallback || parsed.parsedJson == null) {
      return _fallbackQuestions(topic, count, difficultyId);
    }
    final Map<String, dynamic> json = parsed.parsedJson!;
    final List<dynamic> rawQuestions = json['questions'] is List
        ? json['questions'] as List
        : const <dynamic>[];
    final List<GeneratedQuestionModel> questions = <GeneratedQuestionModel>[];
    for (int i = 0; i < rawQuestions.length; i++) {
      final dynamic raw = rawQuestions[i];
      if (raw is! Map<String, dynamic>) continue;
      final List<dynamic> rawOptions = raw['options'] is List
          ? raw['options'] as List
          : const <dynamic>[];
      final String correctId =
          _stringOr(raw['correctOptionId'], 'a').toLowerCase();
      final List<GeneratedQuestionOptionModel> options =
          <GeneratedQuestionOptionModel>[];
      final List<String> correctIds = <String>[];
      for (final dynamic rawOpt in rawOptions) {
        if (rawOpt is! Map<String, dynamic>) continue;
        final String id = _stringOr(rawOpt['id'], 'opt-$i').toLowerCase();
        options.add(GeneratedQuestionOptionModel(
          id: 'gq-$topic-$i-$id',
          text: _stringOr(rawOpt['text'], ''),
          isCorrect: id == correctId,
        ));
        if (id == correctId) correctIds.add('gq-$topic-$i-$id');
      }
      if (options.length != 4 || correctIds.isEmpty) continue;
      questions.add(GeneratedQuestionModel(
        id: 'gq-$topic-$i',
        prompt: _stringOr(raw['prompt'], 'Practice question #$i'),
        options: options,
        correctAnswerIds: List<String>.unmodifiable(correctIds),
        topic: topic,
        explanation: _stringOr(raw['explanation'], ''),
        difficultyId: difficultyId,
      ));
    }
    if (questions.isEmpty) {
      return _fallbackQuestions(topic, count, difficultyId);
    }
    return GeneratedQuestionSetModel(
      id: 'gqset-$topic',
      title: _stringOr(json['title'], 'Practice set — $topic'),
      subtitle: '${questions.length} questions',
      subject: topic,
      questions: questions,
      createdAtIso: DateTime.now().toIso8601String(),
    );
  }

  // ---------------------------------------------------------------------------
  // Conversations
  // ---------------------------------------------------------------------------

  @override
  Future<List<ConversationModel>> fetchConversations() async {
    _ensureSeeded();
    final List<ConversationModel> ordered = _conversations.values.toList()
      ..sort((ConversationModel a, ConversationModel b) =>
          b.updatedAtIso.compareTo(a.updatedAtIso));
    return List<ConversationModel>.unmodifiable(ordered);
  }

  @override
  Future<ConversationModel> fetchConversationById(String id) async {
    _ensureSeeded();
    final ConversationModel? existing = _conversations[id];
    if (existing != null) return existing;
    throw RemoteException('Conversation $id not found', code: 'not-found');
  }

  @override
  Future<ConversationModel> persistConversation(
    ConversationModel conversation,
  ) async {
    _conversations[conversation.id] = conversation;
    return conversation;
  }

  @override
  Future<bool> deleteConversation(String conversationId) async {
    return _conversations.remove(conversationId) != null;
  }

  // ---------------------------------------------------------------------------
  // Prompts
  // ---------------------------------------------------------------------------

  @override
  Future<List<PromptEntryModel>> fetchPromptHistory() async {
    _ensureSeeded();
    final List<PromptEntryModel> ordered = List<PromptEntryModel>.of(_prompts2)
      ..sort((PromptEntryModel a, PromptEntryModel b) =>
          b.createdAtIso.compareTo(a.createdAtIso));
    return List<PromptEntryModel>.unmodifiable(ordered);
  }

  @override
  Future<PromptEntryModel> persistPromptEntry(PromptEntryModel entry) async {
    final int idx =
        _prompts2.indexWhere((PromptEntryModel p) => p.id == entry.id);
    if (idx == -1) {
      _prompts2.add(entry);
    } else {
      _prompts2[idx] = entry;
    }
    return entry;
  }

  @override
  Future<bool> togglePromptFavorite(String promptId) async {
    final int idx =
        _prompts2.indexWhere((PromptEntryModel p) => p.id == promptId);
    if (idx == -1) return false;
    _prompts2[idx] = _prompts2[idx].copyWith(
      isFavorite: !_prompts2[idx].isFavorite,
    );
    return _prompts2[idx].isFavorite;
  }

  // ---------------------------------------------------------------------------
  // Helpers — request completion
  // ---------------------------------------------------------------------------

  Future<AIResponseModel> _completeJson({
    required AiRequest request,
    required String kindId,
    required String defaultTitle,
    String? subtitle,
    required String defaultBody,
    String? relatedQuestionId,
    String? relatedLessonId,
    String? relatedTopic,
    required List<String> tags,
    required String toneId,
  }) async {
    final DateTime started = DateTime.now();
    final String model = request.model ?? _service.defaultModel;
    String body = defaultBody;
    Map<String, dynamic>? parsedJson;
    try {
      final AiResponse response = await _service.complete(request);
      final AiParsedResponse parsed = _parser.parse(response.body);
      if (parsed.bodyText.isNotEmpty) body = parsed.bodyText;
      parsedJson = parsed.parsedJson;
    } on RemoteException {
      body = defaultBody;
      parsedJson = null;
    }
    final String title = parsedJson != null && parsedJson['title'] is String
        ? parsedJson['title'] as String
        : defaultTitle;
    final String? computedSubtitle = parsedJson != null &&
            parsedJson['subtitle'] is String
        ? parsedJson['subtitle'] as String
        : subtitle;
    final String computedTone =
        parsedJson != null && parsedJson['tone'] is String
            ? parsedJson['tone'] as String
            : toneId;
    final double? confidence =
        parsedJson != null && parsedJson['confidence'] is num
            ? (parsedJson['confidence'] as num).toDouble()
            : null;
    return AIResponseModel(
      id: '$kindId-${started.millisecondsSinceEpoch}',
      kindId: kindId,
      title: title,
      subtitle: computedSubtitle,
      body: body,
      createdAtIso: started.toIso8601String(),
      toneId: computedTone,
      confidence: confidence,
      model: model,
      tags: tags,
      relatedQuestionId: relatedQuestionId,
      relatedLessonId: relatedLessonId,
      relatedTopic: relatedTopic,
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers — fallback bodies (used when the model is unreachable)
  // ---------------------------------------------------------------------------

  String _fallbackHint(String? userAnswer) {
    if (userAnswer == null || userAnswer.isEmpty) {
      return 'Identify the principle the question is testing, then scan '
          'the options for the one that satisfies it.';
    }
    return 'Your guess "$userAnswer" is a strong candidate. Cross-check '
        'it against the underlying rule before you lock it in.';
  }

  String _fallbackExplanation(String correctAnswer, String? userAnswer) {
    if (userAnswer == null || userAnswer.isEmpty) {
      return 'The correct answer is "$correctAnswer". The question is '
          'testing the underlying rule — apply it to a fresh example to '
          'lock the pattern in.';
    }
    return 'You answered "$userAnswer". The correct answer is '
        '"$correctAnswer". Walk through the rule, eliminate options that '
        'violate it, and lock in the surviving option.';
  }

  String _fallbackSimplify(String topic) {
    return 'Imagine $topic as a story: every term has a cause, every '
        'cause has an effect, and the rule is the bridge between them. '
        'Once the rule is clear, every example becomes a tiny replay of '
        'the same story with different characters.';
  }

  String _fallbackSummary() {
    return '• The lesson opens with a single core principle.\n'
        '• Two real-world anchors make the principle memorable.\n'
        '• Three worked examples reinforce the rule from different angles.\n'
        '• One common pitfall is explicitly named and avoided.\n'
        '• Five practice questions close the loop and expose weak spots.';
  }

  FlashcardDeckModel _fallbackFlashcards(
    String topic,
    int count,
    String difficultyId,
  ) {
    final String deckId = 'deck-$topic';
    final List<FlashcardModel> cards = List<FlashcardModel>.generate(
      count,
      (int i) => FlashcardModel(
        id: '$deckId-$i',
        deckId: deckId,
        front: 'Key idea behind $topic #$i',
        back: 'Idea #$i: $topic is governed by a single rule you can '
            'spot in most exam questions. State the rule out loud, then '
            'map it onto a fresh example.',
        topic: topic,
        difficultyId: difficultyId,
        hint: 'Look at the worked example before flipping the card.',
        tags: <String>[topic, 'AI'],
      ),
      growable: false,
    );
    return FlashcardDeckModel(
      id: deckId,
      title: '$topic — Rapid Review',
      subtitle: '${cards.length} cards',
      description: 'Spaced-repetition deck covering the core ideas.',
      topic: topic,
      cards: cards,
      createdAtIso: DateTime.now().toIso8601String(),
    );
  }

  StudyPlanModel _fallbackStudyPlan(
    String subject,
    int daysAhead,
    int minutesPerDay,
  ) {
    final List<StudyDayModel> days = <StudyDayModel>[];
    int totalMinutes = 0;
    for (int d = 0; d < daysAhead; d++) {
      final List<StudyTaskModel> tasks = <StudyTaskModel>[
        StudyTaskModel(
          id: 'plan-$subject-$d-1',
          title: 'Warm-up: review previous mistakes',
          description:
              'Open the Review module and tackle two questions you got wrong.',
          estimatedMinutes: (minutesPerDay * 0.15).round(),
          kindId: 'review',
          relatedTopic: subject,
        ),
        StudyTaskModel(
          id: 'plan-$subject-$d-2',
          title: 'Core lesson: $subject fundamentals',
          estimatedMinutes: (minutesPerDay * 0.45).round(),
          kindId: 'lesson',
          relatedTopic: subject,
        ),
        StudyTaskModel(
          id: 'plan-$subject-$d-3',
          title: 'Practice set',
          description: '15 mixed-difficulty questions with active recall.',
          estimatedMinutes: (minutesPerDay * 0.30).round(),
          kindId: 'practice',
          relatedTopic: subject,
        ),
        StudyTaskModel(
          id: 'plan-$subject-$d-4',
          title: 'Flashcard reinforcement',
          estimatedMinutes: (minutesPerDay * 0.10).round(),
          kindId: 'flashcards',
          relatedTopic: subject,
        ),
      ];
      totalMinutes += tasks.fold<int>(
        0,
        (int sum, StudyTaskModel t) => sum + t.estimatedMinutes,
      );
      days.add(StudyDayModel(
        id: 'plan-$subject-$d',
        dayLabel: 'Day ${d + 1}',
        tasks: tasks,
      ));
    }
    return StudyPlanModel(
      id: 'plan-$subject',
      title: '$subject — $daysAhead-day plan',
      subtitle: '${minutesPerDay}m / day',
      description:
          'Balanced mix of review, core lesson, practice, and spaced repetition.',
      subject: subject,
      days: days,
      totalMinutes: totalMinutes,
      createdAtIso: DateTime.now().toIso8601String(),
    );
  }

  GeneratedQuestionSetModel _fallbackQuestions(
    String topic,
    int count,
    String difficultyId,
  ) {
    final List<GeneratedQuestionModel> questions = <GeneratedQuestionModel>[];
    for (int i = 0; i < count; i++) {
      questions.add(GeneratedQuestionModel(
        id: 'gq-$topic-$i',
        prompt:
            'Sample $topic question #$i — apply the core rule to pick the most defensible option.',
        options: <GeneratedQuestionOptionModel>[
          GeneratedQuestionOptionModel(
              id: 'gq-$topic-$i-a', text: 'Option A — plausible but misses the rule'),
          GeneratedQuestionOptionModel(
              id: 'gq-$topic-$i-b',
              text: 'Option B — the rule-aligned answer',
              isCorrect: true),
          GeneratedQuestionOptionModel(
              id: 'gq-$topic-$i-c', text: 'Option C — common distractor'),
          GeneratedQuestionOptionModel(
              id: 'gq-$topic-$i-d', text: 'Option D — out of scope'),
        ],
        correctAnswerIds: <String>['gq-$topic-$i-b'],
        topic: topic,
        explanation: 'Eliminate options A, C, and D by testing each '
            'against the rule. Option B is the only one that survives.',
        difficultyId: difficultyId,
      ));
    }
    return GeneratedQuestionSetModel(
      id: 'gqset-$topic',
      title: 'Practice set — $topic',
      subtitle: '${questions.length} questions',
      subject: topic,
      questions: questions,
      createdAtIso: DateTime.now().toIso8601String(),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers — small parsers
  // ---------------------------------------------------------------------------

  String _topicFromPrompt(String text) {
    final String lowered = text.toLowerCase();
    if (lowered.contains('river') || lowered.contains('padma')) {
      return 'Geography';
    }
    if (lowered.contains('tense') || lowered.contains('article')) {
      return 'English Grammar';
    }
    if (lowered.contains('percent') || lowered.contains('algebra')) {
      return 'Mathematics';
    }
    return 'General';
  }

  String _studyKindId(Object? raw) {
    final String value = raw is String ? raw : '';
    for (final String kind in const <String>[
      'lesson',
      'practice',
      'review',
      'mockTest',
      'flashcards',
      'rest'
    ]) {
      if (value == kind) return kind;
    }
    return 'practice';
  }

  String _stringOr(Object? value, String fallback) {
    return value is String && value.isNotEmpty ? value : fallback;
  }

  int _intOr(Object? value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  void _ensureSeeded() {
    if (_conversations.isNotEmpty) return;
    final DateTime now = DateTime.now();
    _conversations['conv-seed-1'] = ConversationModel(
      id: 'conv-seed-1',
      title: 'Tense review — present perfect continuous',
      subtitle: 'English Grammar',
      createdAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
      updatedAtIso: now.subtract(const Duration(hours: 22)).toIso8601String(),
      relatedLessonId: 'lesson-tense-1',
      tags: const <String>['English', 'Tenses'],
      messages: <ConversationMessageModel>[
        ConversationMessageModel(
          id: 'm-1',
          roleId: 'user',
          content: 'When do I use present perfect continuous?',
          createdAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
          relatedLessonId: 'lesson-tense-1',
        ),
        ConversationMessageModel(
          id: 'm-2',
          roleId: 'assistant',
          content: 'Use it for an action that started in the past and is '
              'still happening now, or for the effect of a recent ongoing '
              'activity. Structure: have been + -ing.',
          createdAtIso:
              now.subtract(const Duration(days: 1, seconds: 5)).toIso8601String(),
        ),
      ],
    );
    _conversations['conv-seed-2'] = ConversationModel(
      id: 'conv-seed-2',
      title: 'Percentages walk-through',
      subtitle: 'Mathematics',
      createdAtIso: now.subtract(const Duration(days: 3)).toIso8601String(),
      updatedAtIso: now.subtract(const Duration(days: 2, hours: 4)).toIso8601String(),
      relatedLessonId: 'lesson-percent-1',
      tags: const <String>['Math', 'Percentages'],
      messages: <ConversationMessageModel>[
        ConversationMessageModel(
          id: 'm-2-1',
          roleId: 'user',
          content:
              'A number increases 20% then decreases 20%. What is the net change?',
          createdAtIso:
              now.subtract(const Duration(days: 3)).toIso8601String(),
        ),
        ConversationMessageModel(
          id: 'm-2-2',
          roleId: 'assistant',
          content: '1.20 × 0.80 = 0.96 — that\'s a 4% decrease. The order '
              'of multiplication matters: the decrease is applied to the '
              'already-increased value, so the loss is bigger than the gain '
              'in absolute terms.',
          createdAtIso:
              now.subtract(const Duration(days: 3, seconds: 4)).toIso8601String(),
        ),
      ],
    );
  }
}
