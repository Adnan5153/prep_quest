import '../../../../shared/typedefs/result.dart';
import '../entities/quiz_category_entity.dart';
import '../entities/quiz_query.dart';
import '../entities/quiz_question_entity.dart';

/// Pagination metadata surfaced on every paginated result.
class PaginationInfo {
  const PaginationInfo({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}

/// Paginated page of quiz categories.
typedef QuizCategoryEntityPage = ({
  List<QuizCategoryEntity> items,
  PaginationInfo pagination,
});

/// Paginated page of quiz questions.
typedef QuizQuestionEntityPage = ({
  List<QuizQuestionEntity> items,
  PaginationInfo pagination,
});

/// Contract every Quiz Hub repository must satisfy.
abstract class QuizApiRepository {
  Future<Result<QuizCategoryEntityPage>> listCategories({
    QuizCategoryQuery query,
  });

  Future<Result<QuizCategoryEntity>> getCategory(String id);

  Future<Result<QuizCategoryEntity>> createCategory({
    required String name,
    String? description,
  });

  Future<Result<QuizCategoryEntity>> updateCategory({
    required String id,
    required String name,
    String? description,
  });

  Future<Result<void>> deleteCategory(String id);

  Future<Result<QuizQuestionEntityPage>> listQuestionsForCategory(
    String categoryId, {
    QuizQuestionQuery query,
  });

  Future<Result<QuizQuestionEntity>> createQuestion({
    required String categoryId,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    int mark,
  });

  Future<Result<List<QuizQuestionEntity>>> getRandomQuestions({
    required String categoryId,
    int count,
  });

  Future<Result<QuizQuestionEntity>> getQuestion(String id);

  Future<Result<QuizQuestionEntity>> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    int mark,
  });

  Future<Result<void>> deleteQuestion(String id);

  Future<Result<int>> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  });

  Future<Result<int>> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  });

  Future<Result<List<int>>> exportQuestions({
    required String categoryId,
    String format,
  });
}