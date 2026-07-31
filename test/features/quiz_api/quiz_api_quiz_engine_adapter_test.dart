import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/features/quiz_api/data/datasources/quiz_api_quiz_engine_adapter.dart';
import 'package:prep_quest/features/quiz_api/data/datasources/quiz_api_remote_datasource.dart';
import 'package:prep_quest/features/quiz_api/data/models/quiz_category_model.dart';
import 'package:prep_quest/features/quiz_api/data/models/quiz_pagination_model.dart';
import 'package:prep_quest/features/quiz_api/data/models/quiz_question_model.dart';
import 'package:prep_quest/features/quiz_engine/data/datasources/mock_quiz_remote_datasource.dart';
import 'package:prep_quest/features/quiz_engine/data/models/quiz_result_model.dart';
import 'package:prep_quest/features/quiz_engine/data/models/quiz_session_model.dart';

class _StubHubRemote implements QuizApiRemoteDataSource {
  _StubHubRemote(this._category, this._questions);

  final QuizCategoryModel _category;
  final List<QuizQuestionModel> _questions;

  @override
  Future<({List<QuizCategoryModel> items, QuizPaginationModel pagination})>
      listCategories(QuizCategoryQuery query) async {
    return (
      items: <QuizCategoryModel>[_category],
      pagination: QuizPaginationModel.fromJson(<String, dynamic>{
        'page': 1,
        'limit': 1,
        'totalItems': 1,
        'totalPages': 1,
        'hasNext': false,
        'hasPrevious': false,
      }),
    );
  }

  @override
  Future<QuizCategoryModel> getCategory(String id) async => _category;

  @override
  Future<QuizCategoryModel> createCategory({
    required String name,
    String? description,
  }) async =>
      _category;

  @override
  Future<QuizCategoryModel> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async =>
      _category;

  @override
  Future<void> deleteCategory(String id) async {}

  @override
  Future<({List<QuizQuestionModel> items, QuizPaginationModel pagination})>
      listQuestionsForCategory(String categoryId, QuizQuestionQuery query) async {
    return (
      items: _questions,
      pagination: QuizPaginationModel.fromJson(<String, dynamic>{
        'page': 1,
        'limit': _questions.length,
        'totalItems': _questions.length,
        'totalPages': 1,
        'hasNext': false,
        'hasPrevious': false,
      }),
    );
  }

  @override
  Future<QuizQuestionModel> createQuestion({
    required String categoryId,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<QuizQuestionModel>> getRandomQuestions({
    required String categoryId,
    int count = 10,
  }) async =>
      _questions;

  @override
  Future<QuizQuestionModel> getQuestion(String id) async =>
      _questions.firstWhere((q) => q.id == id);

  @override
  Future<QuizQuestionModel> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteQuestion(String id) async {}

  @override
  Future<int> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  }) async =>
      ids.length;

  @override
  Future<int> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  }) async =>
      questions.length;

  @override
  Future<List<int>> exportQuestions({
    required String categoryId,
    String format = 'json',
  }) async =>
      <int>[1, 2, 3];
}

class _AlwaysEmptyFallback extends MockQuizRemoteDataSource {
  _AlwaysEmptyFallback() : super(latency: Duration.zero);

  @override
  Future<QuizResultModel> submitQuizSession(QuizSessionModel session) async {
    // Simulate the legacy fallback that doesn't know about Quiz Hub
    // quiz ids: it always returns 0 correct/0 incorrect/0 skipped.
    return const QuizResultModel(
      sessionId: 's',
      quizId: 'quizhub-2',
      scorePercent: 0,
      totalPoints: 0,
      earnedPoints: 0,
      correctCount: 0,
      incorrectCount: 0,
      skippedCount: 0,
      timeSpentSeconds: 0,
      passed: false,
      rewardXp: 0,
      rewardCoins: 0,
      questionResults: <String, bool>{},
      difficultyId: 'easy',
    );
  }
}

QuizCategoryModel _category() => QuizCategoryModel(
      id: '2',
      name: 'General Knowledge',
      description: null,
    );

List<QuizQuestionModel> _questions() => <QuizQuestionModel>[
      QuizQuestionModel(
        id: '126',
        categoryId: '2',
        prompt: 'Q1',
        options: const <String>['A', 'B', 'C', 'D'],
        answerIndex: 2,
        mark: 10,
      ),
      QuizQuestionModel(
        id: '125',
        categoryId: '2',
        prompt: 'Q2',
        options: const <String>['A', 'B'],
        answerIndex: 0,
        mark: 10,
      ),
    ];

void main() {
  group('QuizApiQuizEngineAdapter.submitQuizSession', () {
    test(
        'grades a Quiz Hub-backed session locally so correct answers are '
        'recognised instead of being lost to the empty fallback', () async {
      final adapter = QuizApiQuizEngineAdapter(
        remote: _StubHubRemote(_category(), _questions()),
        fallback: _AlwaysEmptyFallback(),
      );

      // User answers 126 correctly (option index 2 -> '126-a2') and
      // 125 incorrectly (option index 0 is correct; user picked a1).
      final session = QuizSessionModel(
        sessionId: 'session-1',
        quizId: 'quizhub-2',
        startedAtIso: DateTime.now().toIso8601String(),
        completedAtIso: DateTime.now().toIso8601String(),
        questionOrder: const <String>['126', '125'],
        progress: <String, QuestionProgressModel>{
          '126': const QuestionProgressModel(
            questionId: '126',
            selectedAnswerIds: <String>['126-a2'],
            statusId: 'answered',
            timeSpentSeconds: 5,
            attemptCount: 1,
            hintIdsRevealed: <String>[],
            isBookmarked: false,
          ),
          '125': const QuestionProgressModel(
            questionId: '125',
            selectedAnswerIds: <String>['125-a1'],
            statusId: 'answered',
            timeSpentSeconds: 5,
            attemptCount: 1,
            hintIdsRevealed: <String>[],
            isBookmarked: false,
          ),
        },
        statusId: 'completed',
        flags: const <String>{},
        totalPausedSeconds: 0,
        currentIndex: 1,
      );

      final result = await adapter.submitQuizSession(session);
      expect(result.correctCount, 1);
      expect(result.incorrectCount, 1);
      expect(result.skippedCount, 0);
      expect(result.totalPoints, 20);
      expect(result.earnedPoints, 10);
      expect(result.scorePercent, 50);
      // Phase 38 contract: XP earned equals the sum of marks for
      // correct answers (10 for q126, 0 for q125) — same as earnedPoints.
      expect(result.rewardXp, 10);
      expect(result.questionResults['126'], isTrue);
      expect(result.questionResults['125'], isFalse);
    });

    test(
        'rewards XP equal to the API mark for every correct answer and '
        'zero XP for skipped / incorrect answers', () async {
      final adapter = QuizApiQuizEngineAdapter(
        remote: _StubHubRemote(_category(), _questions()),
        fallback: _AlwaysEmptyFallback(),
      );
      // Session answers q126 correctly (mark=10) and leaves q125 blank.
      final session = QuizSessionModel(
        sessionId: 'session-xp',
        quizId: 'quizhub-2',
        startedAtIso: DateTime.now().toIso8601String(),
        completedAtIso: DateTime.now().toIso8601String(),
        questionOrder: const <String>['126', '125'],
        progress: const <String, QuestionProgressModel>{
          '126': QuestionProgressModel(
            questionId: '126',
            selectedAnswerIds: <String>['126-a2'],
            statusId: 'answered',
            timeSpentSeconds: 0,
            attemptCount: 1,
            hintIdsRevealed: <String>[],
            isBookmarked: false,
          ),
        },
        statusId: 'completed',
        flags: const <String>{},
        totalPausedSeconds: 0,
        currentIndex: 1,
      );

      final result = await adapter.submitQuizSession(session);
      expect(result.correctCount, 1);
      expect(result.skippedCount, 1);
      expect(result.incorrectCount, 0);
      expect(result.totalPoints, 20);
      expect(result.earnedPoints, 10);
      // XP = marks for correct answers = 10.
      expect(result.rewardXp, 10);
    });

    test(
        'reports unanswered questions as skipped rather than graded as '
        'incorrect', () async {
      final adapter = QuizApiQuizEngineAdapter(
        remote: _StubHubRemote(_category(), _questions()),
        fallback: _AlwaysEmptyFallback(),
      );
      final session = QuizSessionModel(
        sessionId: 'session-2',
        quizId: 'quizhub-2',
        startedAtIso: DateTime.now().toIso8601String(),
        completedAtIso: DateTime.now().toIso8601String(),
        questionOrder: const <String>['126', '125'],
        progress: const <String, QuestionProgressModel>{
          '126': QuestionProgressModel(
            questionId: '126',
            selectedAnswerIds: <String>['126-a2'],
            statusId: 'answered',
            timeSpentSeconds: 0,
            attemptCount: 1,
            hintIdsRevealed: <String>[],
            isBookmarked: false,
          ),
        },
        statusId: 'completed',
        flags: const <String>{},
        totalPausedSeconds: 0,
        currentIndex: 1,
      );

      final result = await adapter.submitQuizSession(session);
      expect(result.correctCount, 1);
      expect(result.incorrectCount, 0);
      expect(result.skippedCount, 1);
      expect(result.questionResults['125'], isFalse);
    });

    test(
        'falls through to the fallback when the quiz id is not Quiz Hub '
        'synthesised', () async {
      final adapter = QuizApiQuizEngineAdapter(
        remote: _StubHubRemote(_category(), _questions()),
        fallback: _AlwaysEmptyFallback(),
      );
      final session = QuizSessionModel(
        sessionId: 'session-3',
        quizId: 'quiz-bangladesh-basics',
        startedAtIso: DateTime.now().toIso8601String(),
        completedAtIso: DateTime.now().toIso8601String(),
        questionOrder: const <String>[],
        progress: const <String, QuestionProgressModel>{},
        statusId: 'completed',
        flags: const <String>{},
        totalPausedSeconds: 0,
        currentIndex: 0,
      );
      final result = await adapter.submitQuizSession(session);
      expect(result.correctCount, 0);
      expect(result.totalPoints, 0);
    });
  });
}
