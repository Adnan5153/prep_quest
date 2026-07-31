import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../quiz_api/presentation/providers/quiz_api_providers.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/datasources/quiz_api_category_remote_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

/// Provider for the Quiz Hub-backed category remote data source.
///
/// Phase 57. The Quiz Hub REST API (`/categories`) is the canonical
/// source for playground nodes. This provider resolves the
/// implementation that maps Quiz Hub responses into the existing
/// [CategoryModel] shape so the world map, search, and category
/// browser can all keep their canonical type.
final quizApiCategoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  return QuizApiCategoryRemoteDataSource(
    repository: ref.watch(quizApiRepositoryProvider),
  );
});

/// Provider for the Firestore-backed category remote data source.
///
/// Kept for any non-playground consumer (search, category browser,
/// admin tooling) that still reads the canonical `categories`
/// Firestore collection. Phase 57 does not delete this provider — the
/// follow-up will migrate search + browser consumers and remove it.
final firestoreCategoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  if (FirebaseConfig.isPlatformConfigured) {
    try {
      return const FirestoreCategoryRemoteDataSource();
    } catch (_) {
      // Fall through to mock if Firestore init failed at runtime.
    }
  }
  return MockCategoryRemoteDataSource();
});

/// Default category remote data source.
///
/// Phase 57. The playground now uses Quiz Hub exclusively. Other
/// consumers (search, category browser) that still watch
/// [categoriesStreamProvider] continue to read from this default
/// provider — which is the Quiz Hub adapter. A follow-up phase can
/// point specific non-playground consumers back at
/// [firestoreCategoryRemoteDataSourceProvider] if the migration to
/// Quiz Hub needs to be staged.
final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>(
  (ref) => ref.watch(quizApiCategoryRemoteDataSourceProvider),
);

/// Provider for the category repository.
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    ref.watch(categoryRemoteDataSourceProvider),
  );
});

/// Async list of every published category, sorted by `order`.
///
/// Use this when the playground needs to bootstrap once (e.g. on cold
/// start). For live updates prefer [categoriesStreamProvider].
final categoriesListProvider = FutureProvider<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).listCategories();
});

/// Realtime stream of every category.
///
/// Phase 57: backed by the Quiz Hub REST API via the
/// [QuizApiCategoryRemoteDataSource] polling adapter. Emits the
/// current list on subscription, then re-emits every 30 seconds so
/// newly-published categories become visible without forcing the user
/// to reload the playground.
final categoriesStreamProvider = StreamProvider<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories();
});

/// Convenience provider that returns a single category by id, or
/// `null` when not found / still loading.
final categoryByIdProvider =
    FutureProvider.family<CategoryEntity?, String>((ref, id) {
  return ref.watch(categoryRepositoryProvider).getCategory(id);
});