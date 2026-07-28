import '../models/ai_response_model.dart';
import '../models/conversation_model.dart';
import '../models/flashcard_model.dart';
import '../models/generated_question_model.dart';
import '../models/prompt_entry_model.dart';
import '../models/study_plan_model.dart';
import 'ai_tutor_remote_datasource.dart';

/// In-memory implementation of [AiTutorRemoteDataSource].
///
/// Seeds a deterministic dataset so every AI Tutor screen has realistic
/// content immediately. When the real backend is wired, add a network
/// implementation that satisfies the same contract.
class AiTutorLocalDataSource implements AiTutorRemoteDataSource {
  AiTutorLocalDataSource();

  final List<ConversationModel> _conversations = <ConversationModel>[];
  final List<PromptEntryModel> _prompts = <PromptEntryModel>[];
  bool _seeded = false;

  Future<void> _ensureSeeded() async {
    if (_seeded) return;
    _conversations.addAll(_seedConversations());
    _prompts.addAll(_seedPrompts());
    _seeded = true;
  }

  // ---------------------------------------------------------------------------
  // Hint / explanation / simplification / summary
  // ---------------------------------------------------------------------------

  @override
  Future<AIResponseModel> fetchHint({
    required String questionId,
    required String questionText,
    String? userAnswer,
  }) async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 360));
    final String hintBody = userAnswer == null || userAnswer.isEmpty
        ? 'Think about the principle behind the question first. Ask '
            'yourself what rule the question is testing, then scan the '
            'options for the one that satisfies that rule.'
        : 'Your guess "$userAnswer" is a strong candidate. Before you '
            'lock it in, eliminate options that violate the core rule '
            'behind the question.';
    return AIResponseModel(
      id: 'hint-$questionId-${DateTime.now().millisecondsSinceEpoch}',
      kindId: 'hint',
      title: 'Hint',
      body: hintBody,
      createdAtIso: DateTime.now().toIso8601String(),
      toneId: 'hint',
      confidence: 0.78,
      relatedQuestionId: questionId,
      relatedTopic: _topicFromPrompt(questionText),
      tags: const <String>['Hint', 'BCS'],
    );
  }

  @override
  Future<AIResponseModel> fetchExplanation({
    required String questionId,
    required String questionText,
    required String correctAnswer,
    String? userAnswer,
  }) async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 380));
    final String body = userAnswer == null || userAnswer.isEmpty
        ? 'The correct answer is "$correctAnswer". The question is '
            'testing your ability to reason through the underlying '
            'principle, not just memorize a fact. Apply the rule to a '
            'fresh example to make the pattern stick for the BCS exam.'
        : 'You answered "$userAnswer". The correct answer is '
            '"$correctAnswer". Walk through the principle step-by-step, '
            'eliminate options that violate the rule, and lock in the '
            'option that survives every test.';
    return AIResponseModel(
      id: 'explain-$questionId-${DateTime.now().millisecondsSinceEpoch}',
      kindId: 'explanation',
      title: 'Explanation',
      body: body,
      createdAtIso: DateTime.now().toIso8601String(),
      toneId: 'insight',
      confidence: 0.91,
      relatedQuestionId: questionId,
      relatedTopic: _topicFromPrompt(questionText),
      tags: const <String>['Explanation', 'BCS'],
    );
  }

  @override
  Future<AIResponseModel> fetchSimplification({
    required String topic,
    String? gradeLevel,
  }) async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 340));
    return AIResponseModel(
      id: 'simplify-$topic-${DateTime.now().millisecondsSinceEpoch}',
      kindId: 'simplification',
      title: '$topic, simplified',
      subtitle: gradeLevel == null
          ? 'Plain-English explainer'
          : 'Adapted for $gradeLevel',
      body: 'Imagine $topic as a story: every term has a cause, every '
          'cause has an effect, and the rule is the bridge between them. '
          'Once the rule is clear, every example becomes a tiny replay '
          'of the same story with different characters. Memorise the '
          'bridge, not the characters.',
      createdAtIso: DateTime.now().toIso8601String(),
      toneId: 'tip',
      confidence: 0.82,
      relatedTopic: topic,
      tags: const <String>['Simplify', 'Concept'],
    );
  }

  @override
  Future<AIResponseModel> fetchSummary({
    required String lessonId,
    String? lessonTitle,
  }) async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 360));
    return AIResponseModel(
      id: 'summary-$lessonId-${DateTime.now().millisecondsSinceEpoch}',
      kindId: 'summary',
      title: lessonTitle ?? 'Lesson summary',
      subtitle: '5-bullet recap',
      body: '• The lesson opens with a single core principle.\n'
          '• Two real-world anchors make the principle memorable.\n'
          '• Three worked examples reinforce the rule from different angles.\n'
          '• One common pitfall is explicitly named and avoided.\n'
          '• Five practice questions close the loop and expose weak spots.',
      createdAtIso: DateTime.now().toIso8601String(),
      toneId: 'insight',
      confidence: 0.86,
      relatedLessonId: lessonId,
      tags: const <String>['Summary'],
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
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 340));
    final List<FlashcardModel> cards = List<FlashcardModel>.generate(
      count,
      (int i) => FlashcardModel(
        id: 'fc-$topic-$i',
        deckId: 'deck-$topic',
        front: 'What is the key idea behind ${_coreNoun(topic)} #$i?',
        back: 'Idea #$i: ${_coreNoun(topic)} is governed by a single rule '
            'that you can spot in 80% of BCS questions on this topic. '
            'State the rule out loud, then map it onto a fresh example.',
        topic: topic,
        difficultyId: difficultyId,
        hint: 'Look at the worked example before flipping the card.',
        tags: <String>[topic, 'BCS'],
      ),
      growable: false,
    );
    return FlashcardDeckModel(
      id: 'deck-$topic',
      title: '$topic — Rapid Review',
      subtitle: '$count cards',
      description: 'Spaced-repetition deck covering the core ideas.',
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
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 360));
    final List<StudyDayModel> days = <StudyDayModel>[];
    int totalMinutes = 0;
    for (int d = 0; d < daysAhead; d++) {
      final List<StudyTaskModel> tasks = <StudyTaskModel>[
        StudyTaskModel(
          id: 'plan-$subject-$d-task-1',
          title: 'Warm-up: review previous mistakes',
          description: 'Open the Review module and tackle two questions '
              'you got wrong yesterday.',
          estimatedMinutes: (minutesPerDay * 0.15).round(),
          kindId: 'review',
          relatedTopic: subject,
        ),
        StudyTaskModel(
          id: 'plan-$subject-$d-task-2',
          title: 'Core lesson: $subject fundamentals',
          estimatedMinutes: (minutesPerDay * 0.45).round(),
          kindId: 'lesson',
          relatedTopic: subject,
        ),
        StudyTaskModel(
          id: 'plan-$subject-$d-task-3',
          title: 'Practice set',
          description: '15 mixed-difficulty questions with active recall.',
          estimatedMinutes: (minutesPerDay * 0.30).round(),
          kindId: 'practice',
          relatedTopic: subject,
        ),
        StudyTaskModel(
          id: 'plan-$subject-$d-task-4',
          title: 'Flashcard reinforcement',
          estimatedMinutes: (minutesPerDay * 0.10).round(),
          kindId: 'flashcards',
          relatedTopic: subject,
        ),
      ];
      final int dailyMinutes =
          tasks.fold<int>(0, (int sum, StudyTaskModel t) => sum + t.estimatedMinutes);
      totalMinutes += dailyMinutes;
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
      description: 'Balanced mix of review, core lesson, practice, and '
          'spaced repetition.',
      subject: subject,
      days: days,
      totalMinutes: totalMinutes,
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
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 360));
    final List<GeneratedQuestionModel> questions = <GeneratedQuestionModel>[];
    for (int i = 0; i < count; i++) {
      questions.add(GeneratedQuestionModel(
        id: 'gq-$topic-$i',
        prompt:
            'Sample $topic question #$i — apply the core rule to pick the '
                'most defensible option.',
        options: <GeneratedQuestionOptionModel>[
          GeneratedQuestionOptionModel(id: 'gq-$topic-$i-a', text: 'Option A — plausible but misses the rule'),
          GeneratedQuestionOptionModel(id: 'gq-$topic-$i-b', text: 'Option B — the rule-aligned answer', isCorrect: true),
          GeneratedQuestionOptionModel(id: 'gq-$topic-$i-c', text: 'Option C — common distractor'),
          GeneratedQuestionOptionModel(id: 'gq-$topic-$i-d', text: 'Option D — out of scope'),
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
      subtitle: '$count questions',
      subject: topic,
      questions: questions,
      createdAtIso: DateTime.now().toIso8601String(),
    );
  }

  // ---------------------------------------------------------------------------
  // Conversation history
  // ---------------------------------------------------------------------------

  @override
  Future<List<ConversationModel>> fetchConversations() async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final List<ConversationModel> ordered = List<ConversationModel>.of(_conversations)
      ..sort((ConversationModel a, ConversationModel b) =>
          b.updatedAtIso.compareTo(a.updatedAtIso));
    return List<ConversationModel>.unmodifiable(ordered);
  }

  @override
  Future<ConversationModel> fetchConversationById(String id) async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 140));
    for (final ConversationModel c in _conversations) {
      if (c.id == id) return c;
    }
    throw StateError('Conversation $id not found');
  }

  @override
  Future<ConversationModel> persistConversation(
    ConversationModel conversation,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final int idx = _conversations.indexWhere(
      (ConversationModel c) => c.id == conversation.id,
    );
    if (idx == -1) {
      _conversations.add(conversation);
    } else {
      _conversations[idx] = conversation;
    }
    return conversation;
  }

  @override
  Future<bool> deleteConversation(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final int before = _conversations.length;
    _conversations.removeWhere((ConversationModel c) => c.id == id);
    return _conversations.length < before;
  }

  // ---------------------------------------------------------------------------
  // Prompt history
  // ---------------------------------------------------------------------------

  @override
  Future<List<PromptEntryModel>> fetchPromptHistory() async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final List<PromptEntryModel> ordered = List<PromptEntryModel>.of(_prompts)
      ..sort((PromptEntryModel a, PromptEntryModel b) =>
          b.createdAtIso.compareTo(a.createdAtIso));
    return List<PromptEntryModel>.unmodifiable(ordered);
  }

  @override
  Future<PromptEntryModel> persistPromptEntry(PromptEntryModel entry) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final int idx = _prompts.indexWhere(
      (PromptEntryModel p) => p.id == entry.id,
    );
    if (idx == -1) {
      _prompts.add(entry);
    } else {
      _prompts[idx] = entry;
    }
    return entry;
  }

  @override
  Future<bool> togglePromptFavorite(String promptId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final int idx =
        _prompts.indexWhere((PromptEntryModel p) => p.id == promptId);
    if (idx == -1) return false;
    _prompts[idx] = _prompts[idx].copyWith(
      isFavorite: !_prompts[idx].isFavorite,
    );
    return _prompts[idx].isFavorite;
  }

  // ---------------------------------------------------------------------------
  // Helpers
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

  String _coreNoun(String topic) {
    return topic;
  }

  List<ConversationModel> _seedConversations() {
    final DateTime now = DateTime.now();
    return <ConversationModel>[
      ConversationModel(
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
            createdAtIso:
                now.subtract(const Duration(days: 1)).toIso8601String(),
            relatedLessonId: 'lesson-tense-1',
          ),
          ConversationMessageModel(
            id: 'm-2',
            roleId: 'assistant',
            content: 'Use it for an action that started in the past and '
                'is still happening now, or for the effect of a recent '
                'ongoing activity. Structure: have been + -ing.',
            createdAtIso: now
                .subtract(const Duration(days: 1, seconds: 5))
                .toIso8601String(),
          ),
          ConversationMessageModel(
            id: 'm-3',
            roleId: 'user',
            content: 'Can I use it with stative verbs?',
            createdAtIso: now
                .subtract(const Duration(hours: 23))
                .toIso8601String(),
          ),
          ConversationMessageModel(
            id: 'm-4',
            roleId: 'assistant',
            content: 'No — stative verbs (know, like, own) typically '
                'don\'t pair with continuous tenses. Use simple or '
                'perfect forms instead.',
            createdAtIso: now
                .subtract(const Duration(hours: 22))
                .toIso8601String(),
          ),
        ],
      ),
      ConversationModel(
        id: 'conv-seed-2',
        title: 'Percentages walk-through',
        subtitle: 'Mathematics',
        createdAtIso: now
            .subtract(const Duration(days: 3))
            .toIso8601String(),
        updatedAtIso: now
            .subtract(const Duration(days: 2, hours: 4))
            .toIso8601String(),
        relatedLessonId: 'lesson-percent-1',
        tags: const <String>['Math', 'Percentages'],
        messages: <ConversationMessageModel>[
          ConversationMessageModel(
            id: 'm-2-1',
            roleId: 'user',
            content: 'A number increases 20% then decreases 20%. What '
                'is the net change?',
            createdAtIso: now
                .subtract(const Duration(days: 3))
                .toIso8601String(),
          ),
          ConversationMessageModel(
            id: 'm-2-2',
            roleId: 'assistant',
            content: '1.20 × 0.80 = 0.96 — that\'s a 4% decrease. The '
                'order of multiplication matters: decrease is applied '
                'to the already-increased value, so the loss is bigger '
                'than the gain in absolute terms.',
            createdAtIso: now
                .subtract(const Duration(days: 3, seconds: 4))
                .toIso8601String(),
          ),
        ],
      ),
    ];
  }

  List<PromptEntryModel> _seedPrompts() {
    final DateTime now = DateTime.now();
    return <PromptEntryModel>[
      PromptEntryModel(
        id: 'prompt-seed-1',
        text: 'Explain articles in English with 3 worked examples.',
        createdAtIso: now
            .subtract(const Duration(hours: 6))
            .toIso8601String(),
        category: 'English',
        tags: const <String>['English', 'Articles'],
        isFavorite: true,
        response: AIResponseModel(
          id: 'prompt-resp-1',
          kindId: 'general',
          title: 'Articles — quick primer',
          body: '• Use "a" before consonant sounds, "an" before vowel '
              'sounds.\n• Use "the" when the noun is specific.\n• Use '
              '"the" with superlatives and unique items.',
          createdAtIso: now
              .subtract(const Duration(hours: 6))
              .toIso8601String(),
          toneId: 'tip',
          tags: const <String>['English', 'Articles'],
        ),
      ),
      PromptEntryModel(
        id: 'prompt-seed-2',
        text: 'Quiz me on Bangladesh geography.',
        createdAtIso:
            now.subtract(const Duration(days: 2)).toIso8601String(),
        category: 'Bangladesh Affairs',
        tags: const <String>['Geography'],
        response: AIResponseModel(
          id: 'prompt-resp-2',
          kindId: 'general',
          title: 'Bangladesh geography — 5 quick prompts',
          body: '1. Name the three largest rivers.\n'
              '2. Which division borders India and Myanmar?\n'
              '3. What is the elevation range of the Chittagong Hill Tracts?\n'
              '4. Name two major ports.\n'
              '5. Which district has the Sundarbans?',
          createdAtIso:
              now.subtract(const Duration(days: 2)).toIso8601String(),
          toneId: 'insight',
          tags: const <String>['Geography'],
        ),
      ),
    ];
  }
}