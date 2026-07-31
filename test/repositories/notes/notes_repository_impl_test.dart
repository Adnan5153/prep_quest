import 'package:prep_quest/core/errors/failures.dart';
import 'package:prep_quest/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:prep_quest/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:prep_quest/features/notes/domain/entities/note_entity.dart';
import 'package:prep_quest/features/notes/domain/enums/note_category.dart';
import 'package:prep_quest/features/notes/domain/enums/note_color.dart';
import 'package:prep_quest/features/notes/domain/enums/note_filter.dart';
import 'package:prep_quest/features/notes/domain/enums/note_sort.dart';
import 'package:prep_quest/features/notes/domain/enums/note_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late NotesLocalDataSource local;
  late NotesRepositoryImpl repository;

  setUp(() {
    local = NotesLocalDataSource();
    repository = NotesRepositoryImpl(local: local);
  });

  tearDown(() {
    local.dispose();
  });

  test('getNotes returns all seeded notes by default', () async {
    final result = await repository.getNotes();
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, hasLength(8));
  });

  test('getNotes filters by pinned, favourite and ai', () async {
    final pinned = await repository.getNotes(filter: NoteFilter.pinned);
    final favourite = await repository.getNotes(filter: NoteFilter.favorites);
    final ai = await repository.getNotes(filter: NoteFilter.ai);

    expect(pinned.valueOrNull, isNotEmpty);
    expect(pinned.valueOrNull!.every((n) => n.isPinned), isTrue);
    expect(favourite.valueOrNull!.every((n) => n.isFavorite), isTrue);
    expect(ai.valueOrNull!.every((n) => n.type == NoteType.ai), isTrue);
  });

  test('getNotes sorts alphabetically', () async {
    final result = await repository.getNotes(sort: NoteSort.alphabetical);
    final titles = result.valueOrNull!.map((n) => n.title).toList();

    final sorted = List<String>.from(titles)..sort();
    expect(titles, equals(sorted));
  });

  test('getNotes paginates and applies search query', () async {
    final page = await repository.getNotes(limit: 3);
    expect(page.valueOrNull, hasLength(3));

    final match = await repository.getNotes(query: 'percentage');
    expect(match.valueOrNull!.length, greaterThanOrEqualTo(1));
  });

  test('getPinnedNotes and getRecentNotes respect limits', () async {
    final pinned = await repository.getPinnedNotes();
    final recent = await repository.getRecentNotes(limit: 4);

    expect(pinned.valueOrNull!.every((n) => n.isPinned), isTrue);
    expect(recent.valueOrNull, hasLength(4));
  });

  test('createNote and updateNote mutate local cache', () async {
    final before = (await repository.getNotes()).valueOrNull!.length;
    final created = await repository.createNote(NoteEntity(
      id: 'note-test',
      title: 'A test note',
      content: 'Body',
      type: NoteType.personal,
      category: NoteCategory.personal,
      color: NoteColor.defaultColor,
      isPinned: false,
      isFavorite: false,
      tags: const <String>['test'],
      attachments: const <NoteAttachmentEntity>[],
      createdAtIso: '2025-01-01T00:00:00.000Z',
      updatedAtIso: '2025-01-01T00:00:00.000Z',
    ));
    final updated = await repository.updateNote(
      created.valueOrNull!.copyWith(title: 'A test note — revised'),
    );

    expect(created.isSuccess, isTrue);
    expect(updated.valueOrNull?.title, 'A test note — revised');
    final after = (await repository.getNotes()).valueOrNull!.length;
    expect(after, before + 1);
  });

  test('togglePin and toggleFavorite flip booleans', () async {
    final before = (await repository.getNotes()).valueOrNull!.firstWhere(
          (n) => n.id == 'note-constitution-articles',
        );

    final pinned = await repository.togglePin(before.id);
    expect(pinned.valueOrNull?.isPinned, !before.isPinned);

    final fav = await repository.toggleFavorite(before.id);
    expect(fav.valueOrNull?.isFavorite, !before.isFavorite);
  });

  test('togglePin fails for missing notes', () async {
    final result = await repository.togglePin('missing-id');
    expect(result.isFailure, isTrue);
    expect(result.failureOrNull, isA<UnknownFailure>());
  });

  test('findNoteById returns null for unknown id', () async {
    final result = await repository.findNoteById('missing');
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, isNull);
  });

  test('deleteNote and clearAll purge the cache', () async {
    final first = (await repository.getNotes()).valueOrNull!.first;
    final deleted = await repository.deleteNote(first.id);

    expect(deleted.isSuccess, isTrue);
    expect(
      (await repository.findNoteById(first.id)).valueOrNull,
      isNull,
    );

    final cleared = await repository.clearAll();
    expect(cleared.isSuccess, isTrue);
    expect((await repository.getNotes()).valueOrNull, isEmpty);
  });
}
