import '../../../../core/services/cache_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/quiz_category_entity.dart';
import '../../domain/entities/quiz_query.dart';
import '../../domain/entities/quiz_question_entity.dart';
import '../../domain/repositories/quiz_api_repository.dart';
import '../cache/quiz_api_cache.dart';
import '../models/quiz_category_model.dart';
import '../models/quiz_question_model.dart';

/// Caches read-through / write-through the canonical
/// [QuizApiRepository] using [QuizApiCache].
///
/// Reads check the cache first; on miss the request is forwarded to the
/// underlying repository and the response is cached for [listTtl] /
/// [itemTtl]. Writes invalidate the relevant cache entries so a stale
/// list doesn't outlive a write.
class CachedQuizApiRepository implements QuizApiRepository {
  CachedQuizApiRepository({
    required QuizApiRepository inner,
    required QuizApiCache cache,
  })  : _inner = inner,
        _cache = cache;

  final QuizApiRepository _inner;
  final QuizApiCache _cache;

  @override
  Future<Result<QuizCategoryEntityPage>> listCategories({
    QuizCategoryQuery query = const QuizCategoryQuery(),
  }) async {
    final String key =
        _cache.categoryListKey(query.page, query.limit, query.search);
    final Map<String, dynamic>? cached = await _cache.getCategoryList(key: key);
    if (cached != null) {
      return _decodeCategoryPage(cached);
    }
    final Result<QuizCategoryEntityPage> result = await _inner.listCategories(
      query: query,
    );
    if (result.isSuccess && result.valueOrNull != null) {
      await _cache.putCategoryList(
        key: key,
        value: <String, dynamic>{
          'items': result.valueOrNull!.items
              .map((QuizCategoryEntity c) => <String, dynamic>{
                    'id': c.id,
                    'name': c.name,
                    'description': c.description,
                  })
              .toList(),
          'pagination': <String, dynamic>{
            'page': result.valueOrNull!.pagination.page,
            'limit': result.valueOrNull!.pagination.limit,
            'totalItems': result.valueOrNull!.pagination.totalItems,
            'totalPages': result.valueOrNull!.pagination.totalPages,
            'hasNext': result.valueOrNull!.pagination.hasNext,
            'hasPrevious': result.valueOrNull!.pagination.hasPrevious,
          },
        },
      );
    }
    return result;
  }

  @override
  Future<Result<QuizCategoryEntity>> getCategory(String id) async {
    final String key = _cache.categoryItemKey(id);
    final Map<String, dynamic>? cached = await _cache.getCategoryItem(key: key);
    if (cached != null) {
      return Result.success(QuizCategoryModel.fromJson(cached).toEntity());
    }
    final Result<QuizCategoryEntity> result = await _inner.getCategory(id);
    if (result.isSuccess && result.valueOrNull != null) {
      final QuizCategoryEntity c = result.valueOrNull!;
      await _cache.putCategoryItem(
        key: key,
        value: <String, dynamic>{
          'id': c.id,
          'name': c.name,
          'description': c.description,
        },
      );
    }
    return result;
  }

  @override
  Future<Result<QuizCategoryEntity>> createCategory({
    required String name,
    String? description,
  }) async {
    final Result<QuizCategoryEntity> result =
        await _inner.createCategory(name: name, description: description);
    if (result.isSuccess) {
      await _cache.clear();
    }
    return result;
  }

  @override
  Future<Result<QuizCategoryEntity>> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async {
    final Result<QuizCategoryEntity> result = await _inner.updateCategory(
      id: id,
      name: name,
      description: description,
    );
    if (result.isSuccess) {
      await _cache.invalidate(_cache.categoryItemKey(id));
    }
    return result;
  }

  @override
  Future<Result<void>> deleteCategory(String id) async {
    final Result<void> result = await _inner.deleteCategory(id);
    if (result.isSuccess) {
      await _cache.invalidate(_cache.categoryItemKey(id));
    }
    return result;
  }

  @override
  Future<Result<QuizQuestionEntityPage>> listQuestionsForCategory(
    String categoryId, {
    QuizQuestionQuery query = const QuizQuestionQuery(),
  }) async {
    final String key = _cache.questionListKey(
      categoryId,
      query.page,
      query.limit,
      query.search,
    );
    final Map<String, dynamic>? cached = await _cache.getQuestionList(key: key);
    if (cached != null) {
      return _decodeQuestionPage(cached);
    }
    final Result<QuizQuestionEntityPage> result =
        await _inner.listQuestionsForCategory(
      categoryId,
      query: query,
    );
    if (result.isSuccess && result.valueOrNull != null) {
      final QuizQuestionEntityPage page = result.valueOrNull!;
      await _cache.putQuestionList(
        key: key,
        value: <String, dynamic>{
          'items': page.items
              .map((QuizQuestionEntity q) => <String, dynamic>{
                    'id': q.id,
                    'categoryId': q.categoryId,
                    'prompt': q.prompt,
                    'options': q.options,
                    'answerIndex': q.answerIndex,
                    'mark': q.mark,
                  })
              .toList(),
          'pagination': <String, dynamic>{
            'page': page.pagination.page,
            'limit': page.pagination.limit,
            'totalItems': page.pagination.totalItems,
            'totalPages': page.pagination.totalPages,
            'hasNext': page.pagination.hasNext,
            'hasPrevious': page.pagination.hasPrevious,
          },
        },
      );
    }
    return result;
  }

  @override
  Future<Result<QuizQuestionEntity>> createQuestion({
    required String categoryId,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    int mark = 1,
  }) async {
    final Result<QuizQuestionEntity> result = await _inner.createQuestion(
      categoryId: categoryId,
      prompt: prompt,
      options: options,
      answerIndex: answerIndex,
      mark: mark,
    );
    if (result.isSuccess) {
      await _cache.clear();
    }
    return result;
  }

  @override
  Future<Result<List<QuizQuestionEntity>>> getRandomQuestions({
    required String categoryId,
    int count = 10,
  }) async {
    return _inner.getRandomQuestions(categoryId: categoryId, count: count);
  }

  @override
  Future<Result<QuizQuestionEntity>> getQuestion(String id) async {
    final String key = _cache.questionItemKey(id);
    final Map<String, dynamic>? cached = await _cache.getQuestionItem(key: key);
    if (cached != null) {
      return Result.success(QuizQuestionModel.fromJson(cached).toEntity());
    }
    final Result<QuizQuestionEntity> result = await _inner.getQuestion(id);
    if (result.isSuccess && result.valueOrNull != null) {
      final QuizQuestionEntity q = result.valueOrNull!;
      await _cache.putQuestionItem(
        key: key,
        value: <String, dynamic>{
          'id': q.id,
          'categoryId': q.categoryId,
          'prompt': q.prompt,
          'options': q.options,
          'answerIndex': q.answerIndex,
          'mark': q.mark,
        },
      );
    }
    return result;
  }

  @override
  Future<Result<QuizQuestionEntity>> updateQuestion({
    required String id,
    required String prompt,
    required List<String> options,
    required int answerIndex,
    int mark = 1,
  }) async {
    final Result<QuizQuestionEntity> result = await _inner.updateQuestion(
      id: id,
      prompt: prompt,
      options: options,
      answerIndex: answerIndex,
      mark: mark,
    );
    if (result.isSuccess) {
      await _cache.invalidate(_cache.questionItemKey(id));
    }
    return result;
  }

  @override
  Future<Result<void>> deleteQuestion(String id) async {
    final Result<void> result = await _inner.deleteQuestion(id);
    if (result.isSuccess) {
      await _cache.invalidate(_cache.questionItemKey(id));
    }
    return result;
  }

  @override
  Future<Result<int>> bulkDeleteQuestions({
    required String categoryId,
    required List<String> ids,
  }) async {
    final Result<int> result = await _inner.bulkDeleteQuestions(
      categoryId: categoryId,
      ids: ids,
    );
    if (result.isSuccess) {
      for (final String id in ids) {
        await _cache.invalidate(_cache.questionItemKey(id));
      }
    }
    return result;
  }

  @override
  Future<Result<int>> importQuestions({
    required String categoryId,
    required List<Map<String, dynamic>> questions,
  }) async {
    final Result<int> result = await _inner.importQuestions(
      categoryId: categoryId,
      questions: questions,
    );
    if (result.isSuccess) {
      await _cache.clear();
    }
    return result;
  }

  @override
  Future<Result<List<int>>> exportQuestions({
    required String categoryId,
    String format = 'json',
  }) async {
    return _inner.exportQuestions(categoryId: categoryId, format: format);
  }

  Result<QuizCategoryEntityPage> _decodeCategoryPage(Map<String, dynamic> raw) {
    final Object? itemsField = raw['items'];
    final List<dynamic> items = itemsField is List<dynamic>
        ? itemsField
        : <dynamic>[];
    final Object? paginationField = raw['pagination'];
    final Map<String, dynamic> pagination = paginationField is Map<String, dynamic>
        ? paginationField
        : <String, dynamic>{};
    return Result.success((
      items: items
          .whereType<Map<String, dynamic>>()
          .map(QuizCategoryModel.fromJson)
          .map((QuizCategoryModel m) => m.toEntity())
          .toList(growable: false),
      pagination: PaginationInfo(
        page: (pagination['page'] as num?)?.toInt() ?? 1,
        limit: (pagination['limit'] as num?)?.toInt() ?? 20,
        totalItems: (pagination['totalItems'] as num?)?.toInt() ?? 0,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 0,
        hasNext: pagination['hasNext'] as bool? ?? false,
        hasPrevious: pagination['hasPrevious'] as bool? ?? false,
      ),
    ));
  }

  Result<QuizQuestionEntityPage> _decodeQuestionPage(Map<String, dynamic> raw) {
    final Object? itemsField = raw['items'];
    final List<dynamic> items = itemsField is List<dynamic>
        ? itemsField
        : <dynamic>[];
    final Object? paginationField = raw['pagination'];
    final Map<String, dynamic> pagination = paginationField is Map<String, dynamic>
        ? paginationField
        : <String, dynamic>{};
    return Result.success((
      items: items
          .whereType<Map<String, dynamic>>()
          .map(QuizQuestionModel.fromJson)
          .map((QuizQuestionModel m) => m.toEntity())
          .toList(growable: false),
      pagination: PaginationInfo(
        page: (pagination['page'] as num?)?.toInt() ?? 1,
        limit: (pagination['limit'] as num?)?.toInt() ?? 20,
        totalItems: (pagination['totalItems'] as num?)?.toInt() ?? 0,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 0,
        hasNext: pagination['hasNext'] as bool? ?? false,
        hasPrevious: pagination['hasPrevious'] as bool? ?? false,
      ),
    ));
  }
}

/// Re-export to keep the cache_service import flowable for callers
/// that want a default [CacheService].
typedef QuizApiCacheService = CacheService;
