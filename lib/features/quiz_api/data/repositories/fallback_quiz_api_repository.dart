import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/quiz_category_entity.dart';
import '../../domain/entities/quiz_query.dart';
import '../../domain/entities/quiz_question_entity.dart';
import '../../domain/repositories/quiz_api_repository.dart';

/// Routes every call to the primary repository but transparently falls
/// back to a secondary repository when the primary returns a
/// [NetworkFailure] / [UnknownFailure] / [CacheFailure] (i.e. the
/// device is offline or the remote is unreachable).
///
/// `ServerFailure` and `ValidationFailure` are *not* intercepted so
/// the UI keeps surfacing real backend errors (e.g. "category name is
/// required") instead of silently substituting mock data.
class FallbackQuizApiRepository implements QuizApiRepository {
  FallbackQuizApiRepository({
    required QuizApiRepository primary,
    required QuizApiRepository fallback,
  })  : _primary = primary,
        _fallback = fallback;

  final QuizApiRepository _primary;
  final QuizApiRepository _fallback;

  Future<Result<T>> _run<T>(
    Future<Result<T>> Function(QuizApiRepository repo) op,
  ) async {
    final Result<T> result = await op(_primary);
    if (result.isSuccess) return result;
    final Failure? failure = result.failureOrNull;
    if (failure is NetworkFailure || failure is UnknownFailure || failure is CacheFailure) {
      return op(_fallback);
    }
    return result;
  }

  @override
  Future<Result<QuizCategoryEntityPage>> listCategories({
    QuizCategoryQuery query = const QuizCategoryQuery(),
  }) =>
      _run<QuizCategoryEntityPage>(
        (QuizApiRepository r) => r.listCategories(query: query),
      );

  @override
  Future<Result<QuizCategoryEntity>> getCategory(String id) =>
      _run<QuizCategoryEntity>((QuizApiRepository r) => r.getCategory(id));

  @override
  Future<Result<QuizCategoryEntity>> createCategory({
    required String name,
    String? description,
  }) =>
      _run<QuizCategoryEntity>((QuizApiRepository r) => r.createCategory(
            name: name,
            description: description,
          ));

  @override
  Future<Result<QuizCategoryEntity>> updateCategory({
    required String id,
    required String name,
    String? description,
  }) =>
      _run<QuizCategoryEntity>((QuizApiRepository r) => r.updateCategory(
            id: id,
            name: name,
            description: description,
          ));

  @override
  Future<Result<void>> deleteCategory(String id) =>
      _run<void>((QuizApiRepository r) => r.deleteCategory(id));

  @override
  Future<Result<QuizQuestionEntityPage>> listQuestionsForCategory(
    String categoryId, {
    QuizQuestionQuery query = const QuizQuestionQuery(),
  }) =>
      _run<QuizQuestionEntityPage>(
        (QuizApiRepository r) => r.listQuestionsForCategory(
          categoryId,
          query: query,
        ),
      );

  @override
  Future<Result<QuizQuestionEntity>> createQuestion({
    required String categoryId,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    int mark = 1,
  }) =>
      _run<QuizQuestionEntity>((QuizApiRepository r) => r.createQuestion(
            categoryId: categoryId,
            prompt: prompt,
            options: options,
            answerIndex: answerIndex,
            mark: mark,
          ));

  @override
  Future<Result<List<QuizQuestionEntity>>> getRandomQuestions({
    required String categoryId,
    int count = 10,
  }) =>
      _run<List<QuizQuestionEntity>>(
        (QuizApiRepository r) => r.getRandomQuestions(
          categoryId: categoryId,
          count: count,
        ),
      );

  @override
  Future<Result<QuizQuestionEntity>> getQuestion(String id) =>
      _run<QuizQuestionEntity>((QuizApiRepository r) => r.getQuestion(id));

  @override
  Future<Result<QuizQuestionEntity>> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    int mark = 1,
  }) =>
      _run<QuizQuestionEntity>((QuizApiRepository r) => r.updateQuestion(
            id: id,
            prompt: prompt,
            options: options,
            answerIndex: answerIndex,
            mark: mark,
          ));

  @override
  Future<Result<void>> deleteQuestion(String id) =>
      _run<void>((QuizApiRepository r) => r.deleteQuestion(id));

  @override
  Future<Result<int>> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  }) =>
      _run<int>((QuizApiRepository r) => r.bulkDeleteQuestions(
            categoryId: categoryId,
            ids: ids,
          ));

  @override
  Future<Result<int>> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  }) =>
      _run<int>((QuizApiRepository r) => r.importQuestions(
            categoryId: categoryId,
            questions: questions,
          ));

  @override
  Future<Result<List<int>>> exportQuestions({
    required String categoryId,
    String format = 'json',
  }) =>
      _run<List<int>>((QuizApiRepository r) => r.exportQuestions(
            categoryId: categoryId,
            format: format,
          ));
}

/// Convenience guard — true when the failure is one the fallback can
/// reasonably substitute for (i.e. a transport-level issue, not a
/// semantic one).
bool isFallbackableFailure(Failure failure) {
  return failure is NetworkFailure ||
      failure is UnknownFailure ||
      failure is CacheFailure;
}

/// Bridges a failure through [ErrorHandler.map] to ensure consistent
/// vocabulary even when callers hand in raw exceptions.
Failure normalizeFailure(Object error, [StackTrace? stackTrace]) =>
    ErrorHandler.map(error, stackTrace);