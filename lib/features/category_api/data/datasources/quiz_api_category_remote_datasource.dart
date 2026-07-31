import '../../../quiz_api/domain/entities/quiz_category_entity.dart';
import '../../../quiz_api/domain/entities/quiz_query.dart';
import '../../../quiz_api/domain/repositories/quiz_api_repository.dart';
import '../models/category_model.dart';
import 'category_remote_datasource.dart';

/// Category remote data source backed by the Quiz Hub REST API.
///
/// Each Quiz Hub category (`{ id, name, description }`) becomes a
/// single playground node. The mapping is intentionally lossy because
/// the Quiz Hub schema is a strict subset of [CategoryModel]:
///   * `id` (Quiz Hub) → `id` (model)
///   * `name` (Quiz Hub) → `title` (model)
///   * `description` (Quiz Hub) → `subtitle` (model)
///   * `kind` defaults to `lesson` (every API category is a regular node
///     until the API grows a `kind` discriminator).
///   * `order` falls back to `int.tryParse(id) ?? 0` so numeric ids
///     sort naturally; slug ids fall back to insertion order.
///
/// The [watchCategories] stream polls every 30 seconds — the same
/// cadence `quizApiCategoriesStreamProvider` already uses — and
/// preserves the previous snapshot on transient failures so the
/// playground never flashes empty during a network blip.
class QuizApiCategoryRemoteDataSource implements CategoryRemoteDataSource {
  QuizApiCategoryRemoteDataSource({
    required QuizApiRepository repository,
    this._pollInterval = const Duration(seconds: 30),
  }) : _repository = repository;

  final QuizApiRepository _repository;
  final Duration _pollInterval;

  @override
  Future<List<CategoryModel>> listCategories() async {
    final List<QuizCategoryEntity> entities = await _fetchAll();
    return entities.map(_toModel).toList(growable: false);
  }

  @override
  Future<CategoryModel?> getCategory(String id) async {
    final dynamic result = await _repository.getCategory(id);
    if (result.isFailure) return null;
    final QuizCategoryEntity? entity = result.valueOrNull;
    return entity == null ? null : _toModel(entity);
  }

  @override
  Stream<List<CategoryModel>> watchCategories() async* {
    List<CategoryModel> last = const <CategoryModel>[];
    while (true) {
      final List<QuizCategoryEntity> entities = await _fetchAll();
      if (entities.isNotEmpty) {
        last = List<CategoryModel>.unmodifiable(
          entities.map(_toModel),
        );
      }
      yield last;
      await Future<void>.delayed(_pollInterval);
    }
  }

  Future<List<QuizCategoryEntity>> _fetchAll() async {
    final List<QuizCategoryEntity> aggregated = <QuizCategoryEntity>[];
    int page = 1;
    while (true) {
      final dynamic result = await _repository.listCategories(
        query: QuizCategoryQuery(page: page, limit: 100),
      );
      if (result.isFailure) break;
      final dynamic pageData = result.valueOrNull;
      if (pageData == null) break;
      final List<QuizCategoryEntity> items =
          pageData.items as List<QuizCategoryEntity>;
      if (items.isEmpty) break;
      aggregated.addAll(items);
      final dynamic pagination = pageData.pagination;
      final bool hasNext = pagination?.hasNext == true;
      if (!hasNext) break;
      page += 1;
      // Cap at 25 pages of 100 to mirror the upstream poll guard.
      if (page > 25) break;
    }
    return List<QuizCategoryEntity>.unmodifiable(aggregated);
  }

  CategoryModel _toModel(QuizCategoryEntity q) {
    return CategoryModel(
      id: q.id,
      title: q.name,
      subtitle: q.description ?? '',
      kind: 'lesson',
      order: int.tryParse(q.id) ?? 0,
    );
  }
}
