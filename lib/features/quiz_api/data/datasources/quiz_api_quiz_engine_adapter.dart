import '../../../quiz_engine/data/datasources/quiz_remote_datasource.dart';
import '../../../quiz_engine/data/models/question_model.dart';
import '../../../quiz_engine/data/models/quiz_model.dart';
import '../../../quiz_engine/data/models/quiz_report_model.dart';
import '../../../quiz_engine/data/models/quiz_result_model.dart';
import '../../../quiz_engine/data/models/quiz_session_model.dart';
import '../../domain/entities/quiz_category_entity.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_question_model.dart';
import 'quiz_api_remote_datasource.dart';

/// Adapts a [QuizApiRemoteDataSource] (Quiz Hub) to the
/// [QuizRemoteDataSource] contract used by the quiz engine.
///
/// The Quiz Hub backend represents a "quiz" implicitly: a quiz is a
/// quiz id prefixed with `quizhub-` and the questions it contains
/// come from a category. This adapter:
///
///   1. Decodes the quiz id back to a category id,
///   2. Fetches the questions for that category,
///   3. Grades the session locally and returns a populated
///      [QuizResultModel].
///
/// For sessions whose quiz id is not a Quiz Hub synthesised id, the
/// adapter delegates to the supplied [fallback] so existing quizzes
/// keep working.
///
/// Phase 57b — the [fallback] parameter type is the abstract
/// [QuizRemoteDataSource] so production can wire a Firebase-backed
/// fallback while tests / offline builds keep wiring a mock fallback.
class QuizApiQuizEngineAdapter implements QuizRemoteDataSource {
  QuizApiQuizEngineAdapter({
    required QuizApiRemoteDataSource remote,
    required QuizRemoteDataSource fallback,
  }) : _remote = remote,
       _fallback = fallback;

  static const String _quizHubPrefix = 'quizhub-';

  /// Public accessor for the Quiz Hub quiz id prefix (`quizhub-`).
  ///
  /// Surfaced so presentation code (e.g. the Quiz Screen result
  /// submitter) can detect and strip the prefix without having to
  /// duplicate the magic string.
  static String get quizIdPrefix => _quizHubPrefix;

  final QuizApiRemoteDataSource _remote;
  final QuizRemoteDataSource _fallback;

  String? _categoryIdFor(String quizId) {
    if (!quizId.startsWith(_quizHubPrefix)) return null;
    return quizId.substring(_quizHubPrefix.length);
  }

  /// Builds a synthesised [QuizModel] for a Quiz Hub category id.
  ///
  /// The Quiz Hub API exposes *categories* and *questions*; it does
  /// not have a top-level "quiz" concept. The playground therefore
  /// launches a quiz by tapping a node — the node id becomes the
  /// category id and the adapter materialises a one-off quiz from the
  /// questions in that category.
  Future<QuizModel> _buildQuizForCategory(String categoryId) async {
    final QuizCategoryEntity? meta = await _safeCategory(categoryId);
    final List<QuizQuestionModel> questions = await _remote
        .listQuestionsForCategory(
          categoryId,
          const QuizQuestionQuery(page: 1, limit: 100),
        )
        .then((QuizQuestionPage page) => page.items)
        .catchError((Object _) => <QuizQuestionModel>[]);

    final String title = (meta?.name ?? '').trim().isNotEmpty
        ? meta!.name.trim()
        : 'Category $categoryId';
    final String description = (meta?.description ?? '').trim();

    final List<QuestionModel> domainQuestions = questions
        .map((QuizQuestionModel q) => _toQuestionModel(q))
        .toList(growable: false);

    return QuizModel(
      id: '$_quizHubPrefix$categoryId',
      title: title,
      subject: meta?.name ?? 'General',
      kindId: 'lessonPractice',
      difficultyId: 'medium',
      questions: domainQuestions,
      rewardXp: 25,
      rewardCoins: 10,
      tags: const <String>[],
      availableFromIso: DateTime.now().toIso8601String(),
      availableUntilIso: DateTime.now()
          .add(const Duration(days: 365))
          .toIso8601String(),
      description: description.isEmpty ? null : description,
      timeLimitSeconds: null,
      requiresLevel: 1,
      passingScorePercent: 60,
      negativeMarkingPercent: 0,
      shuffleQuestions: false,
      shuffleAnswers: false,
      allowSkip: true,
      allowReview: true,
      allowBookmark: true,
      isPremium: false,
      nodeId: categoryId,
    );
  }

  Future<QuizCategoryEntity?> _safeCategory(String categoryId) async {
    try {
      final QuizCategoryModel model = await _remote.getCategory(categoryId);
      return model.toEntity();
    } catch (_) {
      return null;
    }
  }

  QuestionModel _toQuestionModel(QuizQuestionModel q) {
    final List<AnswerModel> answers = <AnswerModel>[];
    for (int i = 0; i < q.options.length; i++) {
      answers.add(
        AnswerModel(
          id: '${q.id}-a$i',
          text: q.options[i],
          isCorrect: i == q.answerIndex,
        ),
      );
    }
    final List<String> correctIds = <String>[
      if (q.answerIndex >= 0 && q.answerIndex < q.options.length)
        '${q.id}-a${q.answerIndex}',
    ];
    return QuestionModel(
      id: q.id,
      quizId: '$_quizHubPrefix${q.categoryId}',
      typeId: 'singleChoice',
      prompt: q.prompt,
      answers: answers,
      correctAnswerIds: correctIds,
      difficulty: 'medium',
      tags: const <String>[],
      topic: '',
      points: q.mark <= 0 ? 1 : q.mark,
      imageUrl: null,
      hints: const <HintModel>[],
      explanation: null,
      mediaCaption: null,
      timeLimitSeconds: null,
    );
  }

  /// Loads a quiz by its category id.
  ///
  /// Surfaced outside the [QuizRemoteDataSource] contract so the
  /// playground can hop directly from a tapped node to a ready-to-play
  /// quiz without having to compose a synthetic quiz id first.
  Future<QuizModel> fetchQuizByCategoryId(String categoryId) {
    return _buildQuizForCategory(categoryId);
  }

  /// Returns the canonical quiz id for a Quiz Hub category id.
  static String quizIdForCategory(String categoryId) =>
      '$_quizHubPrefix$categoryId';

  /// Whether [quizId] is a Quiz Hub synthesised identifier.
  static bool isQuizHubId(String quizId) => quizId.startsWith(_quizHubPrefix);

  @override
  Future<QuizResultModel> submitQuizSession(QuizSessionModel session) async {
    final String? categoryId = _categoryIdFor(session.quizId);
    if (categoryId == null) {
      return _fallback.submitQuizSession(session);
    }

    final List<QuizQuestionModel> questions = await _remote.getRandomQuestions(
      categoryId: categoryId,
      count: session.questionOrder.length,
    );

    final Map<String, QuizQuestionModel> byId = <String, QuizQuestionModel>{
      for (final QuizQuestionModel q in questions) q.id: q,
    };

    final Map<String, bool> results = <String, bool>{};
    int correct = 0;
    int incorrect = 0;
    int skipped = 0;
    int earned = 0;
    int total = 0;

    for (final String qid in session.questionOrder) {
      final QuizQuestionModel? q = byId[qid];
      if (q == null) {
        // Question was removed from the category mid-session — count
        // as skipped so the totals still line up.
        skipped += 1;
        continue;
      }
      total += q.mark;
      final QuestionProgressModel? progress = session.progress[qid];
      if (progress == null || progress.selectedAnswerIds.isEmpty) {
        skipped += 1;
        results[qid] = false;
        continue;
      }
      final bool isRight = _isAnswerCorrect(q, progress);
      results[qid] = isRight;
      if (isRight) {
        correct += 1;
        earned += q.mark;
      } else {
        incorrect += 1;
      }
    }

    final int scorePercent = total == 0
        ? 0
        : ((earned.clamp(0, total) / total) * 100).toInt();

    // Phase 38 contract: the Quiz Hub `mark` field is the per-question
    // XP reward. A correct answer credits `q.mark` XP, a wrong/skipped
    // answer credits nothing. Therefore the session's rewardXp is the
    // sum of marks for every correct answer (`earned`). The flat
    // legacy "quiz.rewardXp" reward model used by the in-memory
    // mock fallback still applies for non-Quiz-Hub ids; that path
    // resolves above via `await _fallback.submitQuizSession(session)`.
    final int rewardXp = earned.clamp(0, total);

    return QuizResultModel(
      sessionId: session.sessionId,
      quizId: session.quizId,
      scorePercent: scorePercent,
      totalPoints: total,
      earnedPoints: earned.clamp(0, total),
      correctCount: correct,
      incorrectCount: incorrect,
      skippedCount: skipped,
      timeSpentSeconds: 0,
      passed: scorePercent >= 60,
      rewardXp: rewardXp,
      rewardCoins: 0,
      questionResults: results,
      difficultyId: 'easy',
      completedAtIso: DateTime.now().toIso8601String(),
    );
  }

  bool _isAnswerCorrect(
    QuizQuestionModel question,
    QuestionProgressModel progress,
  ) {
    // The Quiz Hub answer ids are synthetic — `<questionId>-a<index>` —
    // so we can recover the chosen option index from the last segment.
    for (final String answerId in progress.selectedAnswerIds) {
      final int dashIndex = answerId.lastIndexOf('-a');
      if (dashIndex < 0) continue;
      final String tail = answerId.substring(dashIndex + 2);
      final int? index = int.tryParse(tail);
      if (index != null && index == question.answerIndex) {
        return true;
      }
    }
    return false;
  }

  // The remaining methods of [QuizRemoteDataSource] are not exercised
  // by Quiz Hub-backed quizzes, so we forward everything to the
  // fallback so callers don't have to special-case Quiz Hub ids.
  @override
  Future<List<QuizModel>> fetchAllQuizzes() => _fallback.fetchAllQuizzes();

  @override
  Future<List<QuizModel>> fetchQuizzesForNode(String nodeId) =>
      _fallback.fetchQuizzesForNode(nodeId);

  @override
  Future<QuizModel?> fetchQuizById(String id) async {
    final String? categoryId = _categoryIdFor(id);
    if (categoryId == null) {
      return _fallback.fetchQuizById(id);
    }
    return _buildQuizForCategory(categoryId);
  }

  @override
  Future<List<String>> fetchBookmarkedQuestionIds() =>
      _fallback.fetchBookmarkedQuestionIds();

  @override
  Future<bool> toggleBookmark(String questionId) =>
      _fallback.toggleBookmark(questionId);

  @override
  Future<QuizReportModel> submitReport({
    required String questionId,
    required String quizId,
    required String reasonId,
    required String note,
  }) => _fallback.submitReport(
    questionId: questionId,
    quizId: quizId,
    reasonId: reasonId,
    note: note,
  );
}
