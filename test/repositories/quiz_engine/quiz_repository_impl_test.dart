import 'package:prep_quest/core/errors/failures.dart';
import 'package:prep_quest/features/quiz_engine/data/datasources/mock_quiz_remote_datasource.dart';
import 'package:prep_quest/features/quiz_engine/data/datasources/quiz_remote_datasource.dart';
import 'package:prep_quest/features/quiz_engine/data/models/quiz_model.dart';
import 'package:prep_quest/features/quiz_engine/data/models/quiz_report_model.dart';
import 'package:prep_quest/features/quiz_engine/data/models/quiz_result_model.dart';
import 'package:prep_quest/features/quiz_engine/data/models/quiz_session_model.dart';
import 'package:prep_quest/features/quiz_engine/data/repositories/quiz_repository_impl.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/question_progress_entity.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/quiz_report_entity.dart';
import 'package:prep_quest/features/quiz_engine/domain/entities/quiz_session_entity.dart';
import 'package:flutter_test/flutter_test.dart';

class _ThrowingQuizDataSource implements QuizRemoteDataSource {
  const _ThrowingQuizDataSource(this.error);
  final Object error;
  Never _throw() => throw error;

  @override
  Future<List<QuizModel>> fetchAllQuizzes() async => _throw();
  @override
  Future<List<QuizModel>> fetchQuizzesForNode(String nodeId) async => _throw();
  @override
  Future<QuizModel?> fetchQuizById(String id) async => _throw();
  @override
  Future<List<String>> fetchBookmarkedQuestionIds() async => _throw();
  @override
  Future<bool> toggleBookmark(String questionId) async => _throw();
  @override
  Future<QuizResultModel> submitQuizSession(QuizSessionModel session) async =>
      _throw();
  @override
  Future<QuizReportModel> submitReport({
    required String questionId,
    required String quizId,
    required String reasonId,
    required String note,
  }) async =>
      _throw();
}

void main() {
  late MockQuizRemoteDataSource dataSource;
  late QuizRepositoryImpl repository;

  setUp(() {
    dataSource = MockQuizRemoteDataSource(latency: Duration.zero);
    repository = QuizRepositoryImpl(dataSource);
  });

  test('getAllQuizzes converts models to entities', () async {
    final result = await repository.getAllQuizzes();

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, hasLength(5));
    expect(result.valueOrNull!.first.id, 'quiz-bangladesh-basics');
    expect(result.valueOrNull!.first.questions, isNotEmpty);
  });

  test('getQuizzesForNode filters by node id', () async {
    final result = await repository.getQuizzesForNode('cat-grammar');

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, hasLength(1));
    expect(result.valueOrNull!.every((quiz) => quiz.nodeId == 'cat-grammar'),
        isTrue);
  });

  test('getQuizById returns matching quiz and null for missing id', () async {
    final found = await repository.getQuizById('quiz-bangladesh-basics');
    final missing = await repository.getQuizById('does-not-exist');

    expect(found.valueOrNull?.title, 'Bangladesh Affairs: Basics');
    expect(missing.isSuccess, isTrue);
    expect(missing.valueOrNull, isNull);
  });

  test('toggleQuestionBookmark is stateful and ids are unmodifiable', () async {
    final first = await repository.toggleQuestionBookmark('q-bd-1');
    final ids = await repository.getBookmarkedQuestionIds();
    final second = await repository.toggleQuestionBookmark('q-bd-1');

    expect(first.valueOrNull, isTrue);
    expect(ids.valueOrNull, contains('q-bd-1'));
    expect(() => ids.valueOrNull!.add('other'), throwsA(isA<UnsupportedError>()));
    expect(second.valueOrNull, isFalse);
  });

  test('submitQuizSession converts entity to model and scores answers', () async {
    final QuizSessionEntity session = QuizSessionEntity(
      sessionId: 'session-1',
      quizId: 'quiz-bangladesh-basics',
      startedAt: DateTime.utc(2025, 1, 1),
      questionOrder: const <String>['q-bd-1'],
      progress: const <String, QuestionProgressEntity>{
        'q-bd-1': QuestionProgressEntity(
          questionId: 'q-bd-1',
          selectedAnswerIds: <String>['a-bd-1-3'],
          status: QuestionProgressStatus.answered,
          timeSpentSeconds: 10,
          attemptCount: 1,
          hintIdsRevealed: <String>[],
          isBookmarked: false,
        ),
      },
      status: QuizSessionStatus.completed,
      flags: const <String>{},
      totalPausedSeconds: 0,
    );

    final result = await repository.submitQuizSession(session);

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull?.correctCount, 1);
    expect(result.valueOrNull?.quizId, session.quizId);
  });

  test('reportQuestion forwards fields and maps reason', () async {
    final result = await repository.reportQuestion(
      questionId: 'q-bd-1',
      quizId: 'quiz-bangladesh-basics',
      reason: QuizReportReason.typo,
      note: 'Typo in prompt',
    );

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull?.reason, QuizReportReason.typo);
    expect(result.valueOrNull?.note, 'Typo in prompt');
  });

  test('datasource latency delays a fetch', () async {
    final delayed = MockQuizRemoteDataSource(
      latency: const Duration(milliseconds: 30),
    );
    final Stopwatch watch = Stopwatch()..start();
    await delayed.fetchAllQuizzes();
    watch.stop();

    expect(watch.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 20)));
  });

  test('repository maps datasource errors to UnknownFailure', () async {
    final repo = QuizRepositoryImpl(
      _ThrowingQuizDataSource(StateError('boom')),
    );

    final result = await repo.getAllQuizzes();

    expect(result.isFailure, isTrue);
    expect(result.failureOrNull, isA<UnknownFailure>());
  });

  test('repository maps format errors to ValidationFailure', () async {
    final repo = QuizRepositoryImpl(
      _ThrowingQuizDataSource(const FormatException('bad payload')),
    );

    final result = await repo.getQuizById('x');

    expect(result.failureOrNull, isA<ValidationFailure>());
  });
}
