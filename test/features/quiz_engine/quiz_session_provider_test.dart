import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/answer_entity.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/question_entity.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/quiz_entity.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/quiz_report_entity.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/quiz_result_entity.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/quiz_session_entity.dart';
import 'package:prep_quest/features/quiz_engine/domain/repositories/quiz_repository.dart';
import 'package:prep_quest/features/quiz_engine/domain/usecases/get_quiz_by_id.dart';
import 'package:prep_quest/features/quiz_engine/presentation/providers/quiz_providers.dart';
import 'package:prep_quest/features/quiz_engine/presentation/providers/quiz_session_provider.dart';
import 'package:prep_quest/shared/enums/question_type.dart';
import 'package:prep_quest/shared/typedefs/result.dart';

QuizEntity _stubQuiz() {
  final DateTime now = DateTime.now();
  return QuizEntity(
    id: 'quiz-1',
    title: 'Stub',
    subject: 'Stub',
    kind: QuizKind.lessonPractice,
    difficulty: QuizDifficulty.easy,
    questions: <QuestionEntity>[
      QuestionEntity(
        id: 'q0',
        quizId: 'quiz-1',
        type: QuestionType.singleChoice,
        prompt: 'Q0?',
        answers: const <AnswerEntity>[
          AnswerEntity(id: 'a0', text: 'A0', isCorrect: true),
          AnswerEntity(id: 'a1', text: 'A1'),
        ],
        correctAnswerIds: const <String>['a0'],
        difficulty: 'easy',
        tags: const <String>[],
        topic: 'topic',
        points: 1,
      ),
      QuestionEntity(
        id: 'q1',
        quizId: 'quiz-1',
        type: QuestionType.singleChoice,
        prompt: 'Q1?',
        answers: const <AnswerEntity>[
          AnswerEntity(id: 'a0', text: 'A0', isCorrect: true),
        ],
        correctAnswerIds: const <String>['a0'],
        difficulty: 'easy',
        tags: const <String>[],
        topic: 'topic',
        points: 1,
      ),
    ],
    rewardXp: 0,
    rewardCoins: 0,
    tags: const <String>[],
    availableFrom: now,
    availableUntil: now.add(const Duration(days: 1)),
  );
}

void main() {
  group('quizSessionControllerProvider', () {
    test('retains answered progress when the detail provider emits anew',
        () async {
      // Regression: the previous implementation used `ref.watch` on the
      // quiz detail provider, which caused the session family to be
      // re-evaluated every time the detail state changed. The fresh
      // evaluation wiped the per-question progress map, so the
      // results screen showed zero answers even after the user had
      // answered every question.
      final QuizEntity quiz = _stubQuiz();
      late final _DetailStubController detailStub;
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          getQuizByIdProvider.overrideWithValue(_NoopGetQuizById(quiz)),
          quizDetailControllerProvider('quiz-1').overrideWith(
            (Ref ref) {
              detailStub = _DetailStubController(
                ref.read(getQuizByIdProvider),
                'quiz-1',
                quiz,
              );
              return detailStub;
            },
          ),
        ],
      );
      addTearDown(container.dispose);

      // Prime the detail state to `ready` so the session provider
      // builds an initial session from the loaded quiz.
      await container
          .read(quizDetailControllerProvider('quiz-1').notifier)
          .load('quiz-1');

      final QuizSessionController controller = container.read(
        quizSessionControllerProvider('quiz-1').notifier,
      );
      // Selecting answers populates the session's progress map.
      controller.selectAnswer('q0', 'a0');
      controller.selectAnswer('q1', 'a0');

      final QuizSessionEntity before =
          container.read(quizSessionControllerProvider('quiz-1'));
      expect(before.progress, hasLength(2));

      // Force the detail provider to emit a brand-new state. The
      // family must NOT re-evaluate, so the controller identity (and
      // therefore its progress) must be untouched.
      detailStub.emitFresh();

      final QuizSessionEntity after =
          container.read(quizSessionControllerProvider('quiz-1'));
      expect(
        container.read(quizSessionControllerProvider('quiz-1').notifier),
        same(controller),
        reason:
            'Session controller must not be re-created when the detail provider emits.',
      );
      expect(after.progress, hasLength(2));
      expect(after.progress['q0']?.selectedAnswerIds, contains('a0'));
      expect(after.progress['q1']?.selectedAnswerIds, contains('a0'));
    });
  });
}

class _DetailStubController extends QuizDetailController {
  _DetailStubController(GetQuizById useCase, String quizId, QuizEntity quiz)
      : super(useCase, quizId) {
    state = QuizDetailState(
      quizId: quizId,
      status: QuizLoadStatus.ready,
      quiz: quiz,
    );
  }

  void emitFresh() {
    state = QuizDetailState(
      quizId: 'quiz-1',
      status: QuizLoadStatus.ready,
      quiz: null,
    );
  }
}

class _NoopGetQuizById extends GetQuizById {
  _NoopGetQuizById(this._quiz) : super(_NoopQuizRepository());

  final QuizEntity _quiz;

  @override
  Future<Result<QuizEntity?>> call(String id) async =>
      Result<QuizEntity?>.success(_quiz);
}

class _NoopQuizRepository implements QuizRepository {
  @override
  Future<Result<List<QuizEntity>>> getAllQuizzes() async =>
      Result<List<QuizEntity>>.success(const <QuizEntity>[]);

  @override
  Future<Result<QuizEntity?>> getQuizById(String id) async =>
      Result<QuizEntity?>.success(null);

  @override
  Future<Result<List<QuizEntity>>> getQuizzesForNode(String nodeId) async =>
      Result<List<QuizEntity>>.success(const <QuizEntity>[]);

  @override
  Future<Result<QuizResultEntity>> submitQuizSession(
    QuizSessionEntity session,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<String>>> getBookmarkedQuestionIds() async =>
      Result<List<String>>.success(const <String>[]);

  @override
  Future<Result<bool>> toggleQuestionBookmark(String questionId) async =>
      Result<bool>.success(false);

  @override
  Future<Result<QuizReportEntity>> reportQuestion({
    required String questionId,
    required String quizId,
    required QuizReportReason reason,
    required String note,
  }) async {
    throw UnimplementedError();
  }
}