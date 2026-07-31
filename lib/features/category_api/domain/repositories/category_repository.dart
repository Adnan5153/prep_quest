import '../entities/category_entity.dart';

/// Contract every category repository must satisfy.
///
/// Returns a [Stream] of entities (mirroring the realtime Firestore
/// collection when available, or the in-memory mock when offline) so
/// the presentation layer can subscribe once and stay in sync.
abstract class CategoryRepository {
  /// One-shot list, sorted by [CategoryEntity.order] ascending.
  Future<List<CategoryEntity>> listCategories();

  /// Returns null when no category with [id] is published.
  Future<CategoryEntity?> getCategory(String id);

  /// Realtime stream of the categories. Emits at least once with the
  /// current state, and again whenever the underlying collection
  /// changes.
  Stream<List<CategoryEntity>> watchCategories();
}