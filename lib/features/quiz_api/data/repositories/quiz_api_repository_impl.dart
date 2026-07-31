import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/quiz_category_entity.dart';
import '../../domain/entities/quiz_query.dart';
import '../../domain/entities/quiz_question_entity.dart';
import '../../domain/repositories/quiz_api_repository.dart';
import '../datasources/quiz_api_remote_datasource.dart';

/// Concrete [QuizApiRepository] backed by a [QuizApiRemoteDataSource].
///
/// Every public method delegates to the data source and wraps any
/// exception via [ErrorHandler.map] so the application/presentation
/// layer can branch on the [Result] without try/catch noise.
class QuizApiRepositoryImpl implements QuizApiRepository {
  const QuizApiRepositoryImpl({required QuizApiRemoteDataSource remote})
      : _remote = remote;

  final QuizApiRemoteDataSource _remote;

  @override
  Future<Result<QuizCategoryEntityPage>> listCategories({
    QuizCategoryQuery query = const QuizCategoryQuery(),
  }) async {
    try {
      final page = await _remote.listCategories(query);
      return Result.success(
        (
          items: page.items.map((m) => m.toEntity()).toList(growable: false),
          pagination: _toInfo(page.pagination),
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizCategoryEntity>> getCategory(String id) async {
    try {
      final model = await _remote.getCategory(id);
      return Result.success(model.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizCategoryEntity>> createCategory({
    required String name,
    String? description,
  }) async {
    try {
      final model = await _remote.createCategory(
        name: name,
        description: description,
      );
      return Result.success(model.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizCategoryEntity>> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async {
    try {
      final model = await _remote.updateCategory(
        id: id,
        name: name,
        description: description,
      );
      return Result.success(model.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> deleteCategory(String id) async {
    try {
      await _remote.deleteCategory(id);
      return Result.success(null);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizQuestionEntityPage>> listQuestionsForCategory(
    String categoryId, {
    QuizQuestionQuery query = const QuizQuestionQuery(),
  }) async {
    try {
      final page =
          await _remote.listQuestionsForCategory(categoryId, query);
      return Result.success(
        (
          items: page.items.map((m) => m.toEntity()).toList(growable: false),
          pagination: _toInfo(page.pagination),
        ),
      );
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  PaginationInfo _toInfo(dynamic pagination) {
    return PaginationInfo(
      page: pagination.page as int,
      limit: pagination.limit as int,
      totalItems: pagination.totalItems as int,
      totalPages: pagination.totalPages as int,
      hasNext: pagination.hasNext as bool,
      hasPrevious: pagination.hasPrevious as bool,
    );
  }

  @override
  Future<Result<QuizQuestionEntity>> createQuestion({
    required String categoryId,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    int mark = 1,
  }) async {
    try {
      final model = await _remote.createQuestion(
        categoryId: categoryId,
        prompt: prompt,
        options: options,
        answerIndex: answerIndex,
        mark: mark,
      );
      return Result.success(model.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<List<QuizQuestionEntity>>> getRandomQuestions({
    required String categoryId,
    int count = 10,
  }) async {
    try {
      final models =
          await _remote.getRandomQuestions(categoryId: categoryId, count: count);
      return Result.success(
        models.map((m) => m.toEntity()).toList(growable: false),
      );
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizQuestionEntity>> getQuestion(String id) async {
    try {
      final model = await _remote.getQuestion(id);
      return Result.success(model.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<QuizQuestionEntity>> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    int mark = 1,
  }) async {
    try {
      final model = await _remote.updateQuestion(
        id: id,
        prompt: prompt,
        options: options,
        answerIndex: answerIndex,
        mark: mark,
      );
      return Result.success(model.toEntity());
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> deleteQuestion(String id) async {
    try {
      await _remote.deleteQuestion(id);
      return Result.success(null);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<int>> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  }) async {
    try {
      final count = await _remote.bulkDeleteQuestions(
        categoryId: categoryId,
        ids: ids,
      );
      return Result.success(count);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<int>> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final count = await _remote.importQuestions(
        categoryId: categoryId,
        questions: questions,
      );
      return Result.success(count);
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }

  @override
  Future<Result<List<int>>> exportQuestions({
    required String categoryId,
    String format = 'json',
  }) async {
    try {
      final bytes = await _remote.exportQuestions(
        categoryId: categoryId,
        format: format,
      );
      return Result.success(List<int>.unmodifiable(bytes));
    } catch (error, stackTrace) {
      return Result.failure(ErrorHandler.map(error, stackTrace));
    }
  }
}