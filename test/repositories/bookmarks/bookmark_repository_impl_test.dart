import 'package:prep_quest/features/bookmarks/data/datasources/bookmark_local_datasource.dart';
import 'package:prep_quest/features/bookmarks/data/repositories/bookmark_repository_impl.dart';
import 'package:prep_quest/features/bookmarks/domain/entities/bookmark_entity.dart';
import 'package:prep_quest/features/bookmarks/domain/enums/bookmark_filter.dart';
import 'package:prep_quest/features/bookmarks/domain/enums/bookmark_item_type.dart';
import 'package:prep_quest/features/bookmarks/domain/enums/bookmark_sort.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BookmarkLocalDataSource local;
  late BookmarkRepositoryImpl repository;

  setUp(() {
    local = BookmarkLocalDataSource();
    repository = BookmarkRepositoryImpl(local: local);
  });

  tearDown(() {
    local.dispose();
  });

  test('getBookmarks returns all seeded bookmarks', () async {
    final result = await repository.getBookmarks();
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, hasLength(6));
  });

  test('getBookmarks filters by question item type', () async {
    final result = await repository.getBookmarks(
      filter: BookmarkFilter.questions,
    );
    expect(
      result.valueOrNull!.every(
        (b) => b.itemType == BookmarkItemType.question,
      ),
      isTrue,
    );
  });

  test('getBookmarks sorts alphabetically', () async {
    final result = await repository.getBookmarks(
      sort: BookmarkSort.alphabetical,
    );
    final titles = result.valueOrNull!.map((b) => b.title).toList();
    final sorted = List<String>.from(titles)..sort();
    expect(titles, equals(sorted));
  });

  test('getBookmarks filters by search query', () async {
    final result = await repository.getBookmarks(query: 'BCS');
    expect(result.valueOrNull!.every((b) => b.title.contains('BCS')), isTrue);
  });

  test('getBookmarks paginates with offset and limit', () async {
    final page = await repository.getBookmarks(limit: 2);
    expect(page.valueOrNull, hasLength(2));
  });

  test('addBookmark finds existing id and merges', () async {
    final localBefore = local.readAll().length;

    final added = await repository.addBookmark(BookmarkEntity(
      id: 'override-id',
      itemType: BookmarkItemType.question,
      itemId: 'q-bcs-2024-014',
      title: 'BCS 2024 — Question 14 edited',
      createdAt: DateTime.utc(2025, 1, 1),
      updatedAt: DateTime.utc(2025, 1, 2),
      sourceFeature: 'quiz',
      tags: const <String>['BCS'],
      routeName: '/quiz/review',
      routeParams: const <String, String>{'questionId': 'q-bcs-2024-014'},
    ));

    expect(added.isSuccess, isTrue);
    expect(
      added.valueOrNull?.title,
      'BCS 2024 — Question 14 edited',
    );
    expect(local.readAll().length, localBefore);
  });

  test('addBookmark creates a new row when not present', () async {
    final before = local.readAll().length;
    final result = await repository.addBookmark(BookmarkEntity(
      id: '',
      itemType: BookmarkItemType.lesson,
      itemId: 'lesson-new',
      title: 'New lesson bookmark',
      createdAt: DateTime.utc(2025, 1, 1),
      updatedAt: DateTime.utc(2025, 1, 1),
      sourceFeature: 'guidebook',
      tags: const <String>['english'],
      routeName: '/lessons/reader',
      routeParams: const <String, String>{'lessonId': 'lesson-new'},
    ));

    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull?.id, 'lesson_lesson-new');
    expect(local.readAll().length, before + 1);
  });

  test('isBookmarked and findBookmarkId reflect the cache', () async {
    final isBookmarked = await repository.isBookmarked(
      type: BookmarkItemType.question,
      itemId: 'q-bcs-2024-014',
    );
    final missing = await repository.isBookmarked(
      type: BookmarkItemType.lesson,
      itemId: 'lesson-missing',
    );
    final id = await repository.findBookmarkId(
      type: BookmarkItemType.question,
      itemId: 'q-bcs-2024-014',
    );

    expect(isBookmarked.valueOrNull, isTrue);
    expect(missing.valueOrNull, isFalse);
    expect(id.valueOrNull, isNotNull);
  });

  test('removeBookmark deletes the matching row', () async {
    final result = await repository.removeBookmark('bookmark_q1');
    expect(result.isSuccess, isTrue);
    expect(
      (await repository.isBookmarked(
        type: BookmarkItemType.question,
        itemId: 'q-bcs-2024-014',
      )).valueOrNull,
      isFalse,
    );
  });

  test('removeBookmark on missing id is a no-op success', () async {
    final result = await repository.removeBookmark('missing-id');
    expect(result.isSuccess, isTrue);
  });

  test('clearAll empties the cache', () async {
    final cleared = await repository.clearAll();
    expect(cleared.isSuccess, isTrue);
    expect((await repository.getBookmarks()).valueOrNull, isEmpty);
  });

  test('sync keeps preferences local when no remote is wired', () async {
    final result = await repository.sync();
    expect(result.isSuccess, isTrue);
  });
}
