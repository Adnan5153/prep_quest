import '../models/quiz_category_model.dart';
import '../models/quiz_pagination_model.dart';
import '../models/quiz_question_model.dart';
import 'quiz_api_remote_datasource.dart';

/// Offline-friendly mock implementation of [QuizApiRemoteDataSource].
///
/// Used by tests and by the Quiz Hub repository when the network
/// datasource is unreachable (see [FallbackQuizApiRemoteDataSource]).
/// State is held in-memory so a single mock instance can be reused
/// across calls inside one test session.
class MockQuizApiRemoteDataSource implements QuizApiRemoteDataSource {
  MockQuizApiRemoteDataSource({
    List<QuizCategoryModel>? seedCategories,
    Map<String, List<QuizQuestionModel>>? seedQuestions,
  })  : _categories = <String, QuizCategoryModel>{
          if (seedCategories != null)
            for (final QuizCategoryModel c in seedCategories) c.id: c,
        },
        _questions = <String, List<QuizQuestionModel>>{
          if (seedQuestions != null)
            for (final MapEntry<String, List<QuizQuestionModel>> e
                in seedQuestions.entries)
              e.key: List<QuizQuestionModel>.from(e.value),
        };

  final Map<String, QuizCategoryModel> _categories;
  final Map<String, List<QuizQuestionModel>> _questions;

  int _categoryAutoId = 1000;
  int _questionAutoId = 1000;

  void seedCategory(QuizCategoryModel category) {
    _categories[category.id] = category;
  }

  void seedQuestion(String categoryId, QuizQuestionModel question) {
    _questions.putIfAbsent(categoryId, () => <QuizQuestionModel>[]).add(question);
  }

  @override
  Future<QuizCategoryPage> listCategories(QuizCategoryQuery query) async {
    final List<QuizCategoryModel> filtered = _categories.values
        .where((QuizCategoryModel c) {
          if (query.search == null || query.search!.isEmpty) return true;
          return c.name.toLowerCase().contains(query.search!.toLowerCase());
        })
        .toList()
      ..sort((QuizCategoryModel a, QuizCategoryModel b) => a.id.compareTo(b.id));

    final int total = filtered.length;
    final int from = ((query.page - 1) * query.limit).clamp(0, total);
    final int to = (from + query.limit).clamp(0, total);
    final List<QuizCategoryModel> items = filtered.sublist(from, to);

    return (
      items: List<QuizCategoryModel>.unmodifiable(items),
      pagination: QuizPaginationModel(
        page: query.page,
        limit: query.limit,
        totalItems: total,
        totalPages: (total / query.limit).ceil(),
        hasNext: to < total,
        hasPrevious: query.page > 1,
      ),
    );
  }

  @override
  Future<QuizCategoryModel> getCategory(String id) async {
    final QuizCategoryModel? c = _categories[id];
    if (c == null) {
      throw StateError('Category $id not found.');
    }
    return c;
  }

  @override
  Future<QuizCategoryModel> createCategory({
    required String name,
    String? description,
  }) async {
    final String id = '${++_categoryAutoId}';
    final QuizCategoryModel created = QuizCategoryModel(
      id: id,
      name: name,
      description: description,
    );
    _categories[id] = created;
    return created;
  }

  @override
  Future<QuizCategoryModel> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async {
    if (!_categories.containsKey(id)) {
      throw StateError('Category $id not found.');
    }
    final QuizCategoryModel updated = QuizCategoryModel(
      id: id,
      name: name,
      description: description,
    );
    _categories[id] = updated;
    return updated;
  }

  @override
  Future<void> deleteCategory(String id) async {
    _categories.remove(id);
    _questions.remove(id);
  }

  @override
  Future<QuizQuestionPage> listQuestionsForCategory(
    String categoryId,
    QuizQuestionQuery query,
  ) async {
    final List<QuizQuestionModel> all = _questions[categoryId] ?? <QuizQuestionModel>[];
    final List<QuizQuestionModel> filtered = all
        .where((QuizQuestionModel q) {
          if (query.search == null || query.search!.isEmpty) return true;
          return q.prompt.toLowerCase().contains(query.search!.toLowerCase());
        })
        .toList();
    final int total = filtered.length;
    final int from = ((query.page - 1) * query.limit).clamp(0, total);
    final int to = (from + query.limit).clamp(0, total);
    return (
      items: List<QuizQuestionModel>.unmodifiable(filtered.sublist(from, to)),
      pagination: QuizPaginationModel(
        page: query.page,
        limit: query.limit,
        totalItems: total,
        totalPages: (total / query.limit).ceil(),
        hasNext: to < total,
        hasPrevious: query.page > 1,
      ),
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
    final String id = '${++_questionAutoId}';
    final QuizQuestionModel created = QuizQuestionModel(
      id: id,
      categoryId: categoryId,
      prompt: prompt,
      options: options,
      answerIndex: answerIndex,
      mark: mark,
    );
    _questions.putIfAbsent(categoryId, () => <QuizQuestionModel>[]).add(created);
    return created;
  }

  @override
  Future<List<QuizQuestionModel>> getRandomQuestions({
    required String categoryId,
    int count = 10,
  }) async {
    final List<QuizQuestionModel> all = _questions[categoryId] ?? <QuizQuestionModel>[];
    final List<QuizQuestionModel> copy = List<QuizQuestionModel>.from(all)..shuffle();
    return List<QuizQuestionModel>.unmodifiable(copy.take(count));
  }

  @override
  Future<QuizQuestionModel> getQuestion(String id) async {
    for (final List<QuizQuestionModel> bucket in _questions.values) {
      for (final QuizQuestionModel q in bucket) {
        if (q.id == id) return q;
      }
    }
    throw StateError('Question $id not found.');
  }

  @override
  Future<QuizQuestionModel> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  }) async {
    for (final String categoryId in _questions.keys) {
      final List<QuizQuestionModel> bucket = _questions[categoryId]!;
      final int index = bucket.indexWhere((QuizQuestionModel q) => q.id == id);
      if (index >= 0) {
        final QuizQuestionModel updated = QuizQuestionModel(
          id: id,
          categoryId: categoryId,
          prompt: prompt,
          options: options,
          answerIndex: answerIndex,
          mark: mark,
        );
        bucket[index] = updated;
        return updated;
      }
    }
    throw StateError('Question $id not found.');
  }

  @override
  Future<void> deleteQuestion(String id) async {
    for (final String categoryId in List<String>.from(_questions.keys)) {
      _questions[categoryId]?.removeWhere((QuizQuestionModel q) => q.id == id);
    }
  }

  @override
  Future<int> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  }) async {
    final List<QuizQuestionModel> bucket = _questions[categoryId] ?? <QuizQuestionModel>[];
    final int before = bucket.length;
    bucket.removeWhere((QuizQuestionModel q) => ids.contains(q.id));
    return before - bucket.length;
  }

  @override
  Future<int> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  }) async {
    int inserted = 0;
    for (final Map<String, dynamic> json in questions) {
      _questions.putIfAbsent(categoryId, () => <QuizQuestionModel>[]).add(
            QuizQuestionModel.fromJson(<String, dynamic>{
              'categoryId': categoryId,
              ...json,
            }),
          );
      inserted++;
    }
    return inserted;
  }

  @override
  Future<List<int>> exportQuestions({
    required String categoryId,
    String format = 'json',
  }) async {
    final List<QuizQuestionModel> bucket = _questions[categoryId] ?? <QuizQuestionModel>[];
    final String encoded = bucket.map((QuizQuestionModel q) => q.toJson()).toString();
    return List<int>.unmodifiable(encoded.codeUnits);
  }
}