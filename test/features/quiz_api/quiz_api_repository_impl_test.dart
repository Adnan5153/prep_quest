import 'package:flutter_test/flutter_test.dart';
import 'package:prep_quest/core/errors/failures.dart';
import 'package:prep_quest/features/quiz_api/data/datasources/quiz_api_remote_datasource.dart';
import 'package:prep_quest/features/quiz_api/data/models/quiz_category_model.dart';
import 'package:prep_quest/features/quiz_api/data/models/quiz_pagination_model.dart';
import 'package:prep_quest/features/quiz_api/data/models/quiz_question_model.dart';
import 'package:prep_quest/features/quiz_api/data/repositories/quiz_api_repository_impl.dart';

class _ThrowingRemote implements QuizApiRemoteDataSource {
  const _ThrowingRemote(this.error);
  final Object error;
  Never _throw() => throw error;

  @override
  Future<({List<QuizCategoryModel> items, QuizPaginationModel pagination})>
      listCategories(QuizCategoryQuery query) async =>
          _throw();
  @override
  Future<QuizCategoryModel> getCategory(String id) async => _throw();
  @override
  Future<QuizCategoryModel> createCategory({
    required String name,
    String? description,
  }) async =>
      _throw();
  @override
  Future<QuizCategoryModel> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async =>
      _throw();
  @override
  Future<void> deleteCategory(String id) async => _throw();
  @override
  Future<({List<QuizQuestionModel> items, QuizPaginationModel pagination})>
      listQuestionsForCategory(
    String categoryId,
    QuizQuestionQuery query,
  ) async =>
      _throw();
  @override
  Future<QuizQuestionModel> createQuestion({
    required String categoryId,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  }) async =>
      _throw();
  @override
  Future<List<QuizQuestionModel>> getRandomQuestions({
    required String categoryId,
    int count = 10,
  }) async =>
      _throw();
  @override
  Future<QuizQuestionModel> getQuestion(String id) async => _throw();
  @override
  Future<QuizQuestionModel> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  }) async =>
      _throw();
  @override
  Future<void> deleteQuestion(String id) async => _throw();
  @override
  Future<int> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  }) async =>
      _throw();
  @override
  Future<int> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  }) async =>
      _throw();
  @override
  Future<List<int>> exportQuestions({
    required String categoryId,
    String format = 'json',
  }) async =>
      _throw();
}

class _FixtureRemote implements QuizApiRemoteDataSource {
  @override
  Future<({List<QuizCategoryModel> items, QuizPaginationModel pagination})>
      listCategories(QuizCategoryQuery query) async {
    return (
      items: <QuizCategoryModel>[
        QuizCategoryModel(id: '1', name: 'Math'),
      ],
      pagination: QuizPaginationModel.fromJson(<String, dynamic>{
        'page': 1,
        'limit': 20,
        'totalItems': 1,
        'totalPages': 1,
        'hasNext': false,
        'hasPrevious': false,
      }),
    );
  }

  @override
  Future<QuizCategoryModel> getCategory(String id) async {
    return QuizCategoryModel(id: id, name: 'Math');
  }

  @override
  Future<QuizCategoryModel> createCategory({
    required String name,
    String? description,
  }) async {
    return QuizCategoryModel(id: '99', name: name, description: description);
  }

  @override
  Future<QuizCategoryModel> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async {
    return QuizCategoryModel(id: id, name: name, description: description);
  }

  @override
  Future<void> deleteCategory(String id) async {}

  @override
  Future<({List<QuizQuestionModel> items, QuizPaginationModel pagination})>
      listQuestionsForCategory(
    String categoryId,
    QuizQuestionQuery query,
  ) async {
    return (
      items: <QuizQuestionModel>[],
      pagination: QuizPaginationModel.fromJson(<String, dynamic>{
        'page': 1,
        'limit': 20,
        'totalItems': 0,
        'totalPages': 0,
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
    return QuizQuestionModel(
      id: '5',
      categoryId: categoryId,
      prompt: prompt,
      options: options,
      answerIndex: answerIndex,
      mark: mark,
    );
  }

  @override
  Future<List<QuizQuestionModel>> getRandomQuestions({
    required String categoryId,
    int count = 10,
  }) async {
    return <QuizQuestionModel>[
      QuizQuestionModel(
        id: '1',
        categoryId: categoryId,
        prompt: 'Q',
        options: <String>['A', 'B'],
        answerIndex: 0,
        mark: 1,
      ),
    ];
  }

  @override
  Future<QuizQuestionModel> getQuestion(String id) async {
    return QuizQuestionModel(
      id: id,
      categoryId: '1',
      prompt: 'Q',
      options: <String>['A', 'B'],
      answerIndex: 0,
      mark: 1,
    );
  }

  @override
  Future<QuizQuestionModel> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  }) async {
    return QuizQuestionModel(
      id: id,
      categoryId: '1',
      prompt: prompt,
      options: options,
      answerIndex: answerIndex,
      mark: mark,
    );
  }

  @override
  Future<void> deleteQuestion(String id) async {}

  @override
  Future<int> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  }) async {
    return ids.length;
  }

  @override
  Future<int> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  }) async {
    return questions.length;
  }

  @override
  Future<List<int>> exportQuestions({
    required String categoryId,
    String format = 'json',
  }) async {
    return <int>[1, 2, 3];
  }
}

void main() {
  group('QuizApiRepositoryImpl', () {
    test('wraps success results for listCategories', () async {
      final repo = QuizApiRepositoryImpl(remote: _FixtureRemote());
      final result = await repo.listCategories();
      expect(result.isSuccess, isTrue);
      final page = result.value as dynamic;
      expect(page.items, hasLength(1));
      expect((page.items as dynamic).first.id, '1');
      expect(page.pagination.totalItems, 1);
    });

    test('maps thrown errors to ServerFailure', () async {
      final repo =
          const QuizApiRepositoryImpl(remote: _ThrowingRemote('boom'));
      final result = await repo.listCategories();
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<UnknownFailure>());
      expect(result.failureOrNull!.message, contains('boom'));
    });

    test('createQuestion round-trips a model through to an entity', () async {
      final repo = QuizApiRepositoryImpl(remote: _FixtureRemote());
      final result = await repo.createQuestion(
        categoryId: '7',
        prompt: 'Capital?',
        options: <String>['Paris', 'London'],
        answerIndex: 0,
      );
      expect(result.isSuccess, isTrue);
      final entity = result.value as dynamic;
      expect(entity.id, '5');
      expect(entity.options.first, 'Paris');
      expect(entity.answerIndex, 0);
    });

    test('bulkDeleteQuestions returns the count from the data source',
        () async {
      final repo = QuizApiRepositoryImpl(remote: _FixtureRemote());
      final result =
          await repo.bulkDeleteQuestions(categoryId: '1', ids: <String>['a', 'b']);
      expect(result.isSuccess, isTrue);
      expect(result.value, 2);
    });

    test('exportQuestions returns raw bytes', () async {
      final repo = QuizApiRepositoryImpl(remote: _FixtureRemote());
      final result = await repo.exportQuestions(categoryId: '1');
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, <int>[1, 2, 3]);
    });
  });
}
