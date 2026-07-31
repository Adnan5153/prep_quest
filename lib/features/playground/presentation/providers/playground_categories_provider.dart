import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../category_api/domain/entities/category_entity.dart';
import '../../../category_api/presentation/providers/category_providers.dart';

/// Playground-handle for the live category stream.
///
/// Phase 57. The playground world map is now driven by Quiz Hub
/// categories (see [quizApiCategoryRemoteDataSourceProvider]). This
/// provider exposes the same stream under a stable, playground-owned
/// name so:
///
///   * the auth lifecycle can target the playground's data source
///     without coupling to the `quiz_api` layer,
///   * future playground feature work can watch/read the same stream
///     without deduplicating the wiring,
///   * tests can override this single provider to inject a deterministic
///     category list without poking through the category_api facade.
final playgroundCategoriesProvider =
    StreamProvider<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories();
});