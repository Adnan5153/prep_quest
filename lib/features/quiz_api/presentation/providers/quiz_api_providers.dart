import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../quiz_engine/data/datasources/mock_quiz_remote_datasource.dart';
import '../../../quiz_engine/data/datasources/quiz_remote_datasource.dart';
import '../../../quiz_engine/data/models/quiz_model.dart' as engine;
import '../../data/cache/quiz_api_cache.dart';
import '../../data/datasources/http_quiz_api_remote_datasource.dart';
import '../../data/datasources/mock_quiz_api_remote_datasource.dart';
import '../../data/datasources/quiz_api_quiz_engine_adapter.dart';
import '../../data/datasources/quiz_api_remote_datasource.dart';
import '../../data/repositories/cached_quiz_api_repository.dart';
import '../../data/repositories/fallback_quiz_api_repository.dart';
import '../../data/repositories/quiz_api_repository_impl.dart';
import '../../domain/entities/quiz_category_entity.dart';
import '../../domain/repositories/quiz_api_repository.dart';

/// Dio client bound to the Quiz Hub base URL.
///
/// Re-instantiating with a different [baseUrl] lets tests / flavors
/// point at a staging backend without touching feature code.
final quizApiDioClientProvider = Provider<DioClient>((ref) {
  return DioClient.build(baseUrl: ApiEndpoints.quizApiBaseUrl);
});

/// Production Quiz Hub remote datasource (HTTPS).
final httpQuizApiRemoteDataSourceProvider =
    Provider<QuizApiRemoteDataSource>((ref) {
  final DioClient client = ref.watch(quizApiDioClientProvider);
  return HttpQuizApiRemoteDataSource(client: client);
});

/// In-memory mock used as the offline fallback datasource.
final mockQuizApiRemoteDataSourceProvider =
    Provider<QuizApiRemoteDataSource>((ref) {
  return MockQuizApiRemoteDataSource();
});

/// Primary repository wrapping the HTTP datasource through Result +
/// ErrorHandler.
final quizApiRepositoryProvider = Provider<QuizApiRepository>((ref) {
  final QuizApiRemoteDataSource remote =
      ref.watch(httpQuizApiRemoteDataSourceProvider);
  final QuizApiRepository primary = QuizApiRepositoryImpl(remote: remote);

  final QuizApiCache cache = ref.watch(quizApiCacheProvider);
  final QuizApiRepository cached =
      CachedQuizApiRepository(inner: primary, cache: cache);

  final QuizApiRemoteDataSource fallback =
      ref.watch(mockQuizApiRemoteDataSourceProvider);
  final QuizApiRepository fallbackRepo = QuizApiRepositoryImpl(remote: fallback);

  return FallbackQuizApiRepository(primary: cached, fallback: fallbackRepo);
});

/// Optional cache layer the user is free to share across the app.
final quizApiCacheProvider = Provider<QuizApiCache>((ref) {
  return QuizApiCache();
});

/// Live list of categories (page 1, limit 20, no filter).
final quizCategoriesListProvider =
    FutureProvider<QuizCategoryEntityPage>((ref) async {
  final QuizApiRepository repo = ref.watch(quizApiRepositoryProvider);
  const QuizCategoryQuery query = QuizCategoryQuery(page: 1, limit: 20);
  final result = await repo.listCategories(query: query);
  return result.fold(
    onFailure: (Failure f) => throw _QuizApiFailureException(f),
    onSuccess: (QuizCategoryEntityPage page) => page,
  );
});

/// Flat list of every category available on the Quiz Hub API.
///
/// Used by the playground to bootstrap once and by any code path that
/// only needs a `List` of categories. Pagination is honoured
/// automatically; the API caps results at 25 pages of 100 categories.
final quizApiCategoriesProvider =
    FutureProvider<List<QuizCategoryEntity>>((ref) async {
  final QuizApiRepository repo = ref.watch(quizApiRepositoryProvider);
  return _fetchAllQuizCategories(repo);
});

/// Live stream of every Quiz Hub category.
///
/// Emits the current list once on subscription, then re-emits every
/// 30 seconds so newly-published categories become visible without
/// forcing the user to reload the playground. The Quiz Hub REST API
/// does not expose a long-lived push channel, so a periodic refresh is
/// the closest equivalent available without a websocket upgrade.
final quizApiCategoriesStreamProvider =
    StreamProvider<List<QuizCategoryEntity>>((ref) async* {
  final QuizApiRepository repo = ref.watch(quizApiRepositoryProvider);
  yield await _fetchAllQuizCategories(repo);

  // Re-poll on a 30-second cadence. The async generator tears down
  // automatically when the provider is disposed (Riverpod cancels the
  // stream subscription), so we don't need an explicit timer / hook.
  while (true) {
    await Future<void>.delayed(const Duration(seconds: 30));
    try {
      yield await _fetchAllQuizCategories(repo);
    } catch (_) {
      // Swallow transient failures — the previous snapshot stays live
      // until the next tick succeeds.
    }
  }
});

/// Walks every page of `/categories` and flattens the result into a
/// single immutable list. Centralised here so the future + stream
/// providers stay byte-identical and the orchestration rule (cap at
/// 25 pages of 100) lives in one place.
Future<List<QuizCategoryEntity>> _fetchAllQuizCategories(
  QuizApiRepository repo,
) async {
  final List<QuizCategoryEntity> aggregated = <QuizCategoryEntity>[];
  int page = 1;
  while (true) {
    final result = await repo.listCategories(
      query: QuizCategoryQuery(page: page, limit: 100),
    );
    final QuizCategoryEntityPage? pageData = result.fold(
      onFailure: (Failure f) => null,
      onSuccess: (QuizCategoryEntityPage p) => p,
    );
    if (pageData == null || pageData.items.isEmpty) break;
    aggregated.addAll(pageData.items);
    if (!pageData.pagination.hasNext) break;
    page += 1;
    if (page > 25) break;
  }
  return List<QuizCategoryEntity>.unmodifiable(aggregated);
}

/// Single category lookup.
final quizCategoryByIdProvider =
    FutureProvider.family<QuizCategoryEntity, String>((ref, String id) async {
  final QuizApiRepository repo = ref.watch(quizApiRepositoryProvider);
  final result = await repo.getCategory(id);
  return result.fold(
    onFailure: (Failure f) => throw _QuizApiFailureException(f),
    onSuccess: (QuizCategoryEntity c) => c,
  );
});

/// Questions for a single category (page 1).
final quizQuestionsForCategoryProvider = FutureProvider.family<
    QuizQuestionEntityPage, String>((ref, String categoryId) async {
  final QuizApiRepository repo = ref.watch(quizApiRepositoryProvider);
  const QuizQuestionQuery query = QuizQuestionQuery(page: 1, limit: 20);
  final result = await repo.listQuestionsForCategory(
    categoryId,
    query: query,
  );
  return result.fold(
    onFailure: (Failure f) => throw _QuizApiFailureException(f),
    onSuccess: (QuizQuestionEntityPage page) => page,
  );
});

/// Thrown from the future providers so consumers can `try { } on
/// _QuizApiFailureException` if they need the underlying failure.
class _QuizApiFailureException implements Exception {
  _QuizApiFailureException(this.failure);

  final Failure failure;

  Failure get cause => failure;

  @override
  String toString() => 'QuizApiFailureException: ${failure.message}';
}

/// Exposes the Quiz Hub `QuizApiQuizEngineAdapter` so the Quiz Engine
/// can route [QuizRemoteDataSource] calls into the REST-backed
/// repository. Falls back to `null` (mock-only) when no adapter could
/// be built — e.g. when the HTTP datasource refuses to construct in
/// tests.
final quizApiAdapterProvider = Provider<QuizApiQuizEngineAdapter?>((ref) {
  final QuizApiRemoteDataSource remote = ref.watch(
    httpQuizApiRemoteDataSourceProvider,
  );
  final MockQuizRemoteDataSource fallback = MockQuizRemoteDataSource();
  return QuizApiQuizEngineAdapter(remote: remote, fallback: fallback);
});

/// Resolves a category id into a synthesised Quiz Engine `QuizModel`
/// by joining the Quiz Hub category metadata with its question bank.
///
/// Surfaced as a Riverpod provider so the playground can hop from a
/// tapped node straight into a ready-to-play quiz without having to
/// compose a synthetic quiz id and re-enter the existing
/// `quizDetailControllerProvider` family.
final quizApiQuizForCategoryProvider = FutureProvider.family<
    engine.QuizModel, String>((ref, String categoryId) async {
  final QuizApiQuizEngineAdapter? adapter = ref.watch(quizApiAdapterProvider);
  if (adapter == null) {
    throw StateError('Quiz Hub adapter is not available in this build.');
  }
  return adapter.fetchQuizByCategoryId(categoryId);
});
