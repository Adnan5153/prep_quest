import '../../domain/entities/quiz_query.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_pagination_model.dart';
import '../models/quiz_question_model.dart';

// Re-export so callers (and tests) only need a single import.
export '../../domain/entities/quiz_query.dart' show QuizCategoryQuery, QuizQuestionQuery;

/// Result envelope returned by paginated Quiz Hub endpoints.
typedef QuizCategoryPage = ({
  List<QuizCategoryModel> items,
  QuizPaginationModel pagination,
});

typedef QuizQuestionPage = ({
  List<QuizQuestionModel> items,
  QuizPaginationModel pagination,
});

/// Contract every Quiz Hub remote data source must satisfy.
///
/// Two implementations live in the same folder:
/// * `HttpQuizApiRemoteDataSource` — talks to the Quiz Hub REST API.
/// * `MockQuizApiRemoteDataSource` — used in development + tests.
abstract class QuizApiRemoteDataSource {
  Future<QuizCategoryPage> listCategories(QuizCategoryQuery query);

  Future<QuizCategoryModel> getCategory(String id);

  Future<QuizCategoryModel> createCategory({
    required String name,
    String? description,
  });

  Future<QuizCategoryModel> updateCategory({
    required String id,
    required String name,
    String? description,
  });

  Future<void> deleteCategory(String id);

  Future<QuizQuestionPage> listQuestionsForCategory(
    String categoryId,
    QuizQuestionQuery query,
  );

  Future<QuizQuestionModel> createQuestion({
    required String categoryId,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  });

  Future<List<QuizQuestionModel>> getRandomQuestions({
    required String categoryId,
    int count,
  });

  Future<QuizQuestionModel> getQuestion(String id);

  Future<QuizQuestionModel> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    required int mark,
  });

  Future<void> deleteQuestion(String id);

  Future<int> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  });

  Future<int> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  });

  Future<List<int>> exportQuestions({
    required String categoryId,
    String format,
  });
}