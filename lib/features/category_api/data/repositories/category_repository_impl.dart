import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

/// Default [CategoryRepository] backed by a [CategoryRemoteDataSource].
///
/// All remote failures are wrapped in [UnknownFailure] so callers can
/// treat the repo as a black box that returns a [Result] envelope
/// without having to know about the underlying transport.
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._remote);

  final CategoryRemoteDataSource _remote;

  Future<Result<List<CategoryEntity>>> listCategoriesSafe() async {
    try {
      final List<CategoryEntity> value = await _entities(_remote.listCategories);
      return Result<List<CategoryEntity>>.success(value);
    } catch (error) {
      return Result<List<CategoryEntity>>.failure(
        UnknownFailure('Failed to load categories', cause: error),
      );
    }
  }

  Future<Result<CategoryEntity?>> getCategorySafe(String id) async {
    try {
      final CategoryEntity? value = await _entity(() => _remote.getCategory(id));
      return Result<CategoryEntity?>.success(value);
    } catch (error) {
      return Result<CategoryEntity?>.failure(
        UnknownFailure('Failed to load category $id', cause: error),
      );
    }
  }

  @override
  Future<List<CategoryEntity>> listCategories() async {
    final Result<List<CategoryEntity>> result = await listCategoriesSafe();
    if (result.isFailure) {
      throw StateError(result.failureOrNull?.message ?? 'Unknown failure');
    }
    return result.valueOrNull ?? const <CategoryEntity>[];
  }

  @override
  Future<CategoryEntity?> getCategory(String id) async {
    final Result<CategoryEntity?> result = await getCategorySafe(id);
    if (result.isFailure) {
      throw StateError(result.failureOrNull?.message ?? 'Unknown failure');
    }
    return result.valueOrNull;
  }

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    return _remote.watchCategories().map(
          (List<CategoryModel> models) => List<CategoryEntity>.unmodifiable(
            models.map((CategoryModel m) => m.toEntity()),
          ),
        );
  }

  Future<List<CategoryEntity>> _entities(
    Future<List<CategoryModel>> Function() source,
  ) async {
    final List<CategoryModel> models = await source();
    return List<CategoryEntity>.unmodifiable(
      models.map((CategoryModel m) => m.toEntity()),
    );
  }

  Future<CategoryEntity?> _entity(
    Future<CategoryModel?> Function() source,
  ) async {
    final CategoryModel? model = await source();
    return model?.toEntity();
  }
}