import 'package:prep_quest/core/errors/failures.dart';
import 'package:prep_quest/features/lessons/data/datasources/lesson_remote_datasource.dart';
import 'package:prep_quest/features/lessons/data/datasources/mock_lesson_remote_datasource.dart';
import 'package:prep_quest/features/lessons/data/models/lesson_model.dart';
import 'package:prep_quest/features/lessons/data/repositories/lesson_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _ThrowingLessonDataSource implements LessonRemoteDataSource {
  const _ThrowingLessonDataSource(this.error);
  final Object error;
  Never _throw() => throw error;

  @override
  Future<List<LessonModel>> fetchAllLessons() async => _throw();
  @override
  Future<List<LessonModel>> fetchLessonsForNode(String nodeId) async => _throw();
  @override
  Future<LessonModel?> fetchLessonById(String id) async => _throw();
  @override
  Future<LessonModel?> fetchLessonBySlug(String slug) async => _throw();
}

void main() {
  late MockLessonRemoteDataSource dataSource;
  late LessonRepositoryImpl repository;

  setUp(() {
    dataSource = MockLessonRemoteDataSource(latency: Duration.zero);
    repository = LessonRepositoryImpl(dataSource);
  });

  test('getAllLessons returns entities with sections', () async {
    final result = await repository.getAllLessons();

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, hasLength(5));
    expect(result.valueOrNull!.first.sections, isNotEmpty);
  });

  test('getLessonsForNode filters by node id', () async {
    final result = await repository.getLessonsForNode('cat-mock-test');

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, isNotEmpty);
    // The LessonEntity exposes tags + requiresLevel but the model uses
    // nodeIds. Verify at least one lesson survived the filter.
    expect(result.valueOrNull!.first.tags, isNotEmpty);
  });

  test('getLessonById returns entity or null', () async {
    final found = await repository.getLessonById('lesson-foundations');
    final missing = await repository.getLessonById('missing');

    expect(found.valueOrNull?.title, 'Foundations of Bangladesh');
    expect(missing.isSuccess, isTrue);
    expect(missing.valueOrNull, isNull);
  });

  test('getLessonBySlug returns entity by slug', () async {
    final result = await repository.getLessonBySlug('bcs-foundations');

    expect(result.valueOrNull?.id, 'lesson-foundations');
  });

  test('repository maps datasource errors to UnknownFailure', () async {
    final repo = LessonRepositoryImpl(
      _ThrowingLessonDataSource(StateError('boom')),
    );

    final result = await repo.getAllLessons();

    expect(result.failureOrNull, isA<UnknownFailure>());
  });

  test('latency adds a measurable delay', () async {
    final delayed = MockLessonRemoteDataSource(
      latency: const Duration(milliseconds: 30),
    );
    final Stopwatch watch = Stopwatch()..start();
    await delayed.fetchAllLessons();
    watch.stop();

    expect(watch.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 20)));
  });
}