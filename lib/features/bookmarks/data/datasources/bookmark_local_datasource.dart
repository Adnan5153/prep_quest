import 'dart:async';

import '../../domain/enums/bookmark_item_type.dart';
import '../../domain/enums/bookmark_filter.dart';
import '../../domain/enums/bookmark_sort.dart';
import '../models/bookmark_model.dart';

/// Deterministic in-memory datasource used until bookmark sync is wired.
class BookmarkLocalDataSource {
  BookmarkLocalDataSource({
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  List<BookmarkModel>? _cache;
  final StreamController<List<BookmarkModel>> _changes =
      StreamController<List<BookmarkModel>>.broadcast();

  /// Stream of changes — emitted after every write so widgets can react.
  Stream<List<BookmarkModel>> watch() => _changes.stream;

  List<BookmarkModel> readAll({int limit = 1000}) {
    _ensureSeeded();
    return List<BookmarkModel>.unmodifiable(
      _cache!.take(limit),
    );
  }

  /// Filtered, sorted, searched, paginated view of the cache.
  List<BookmarkModel> query({
    required BookmarkFilter filter,
    required BookmarkSort sort,
    String? search,
    required int offset,
    required int limit,
  }) {
    _ensureSeeded();
    Iterable<BookmarkModel> rows = _cache!;
    rows = _applyFilter(rows, filter);
    rows = _applySearch(rows, search);
    rows = _applySort(rows, sort);
    final List<BookmarkModel> filtered = rows.toList(growable: false);
    if (offset >= filtered.length) return const <BookmarkModel>[];
    final int end = (offset + limit).clamp(0, filtered.length);
    return List<BookmarkModel>.unmodifiable(filtered.sublist(offset, end));
  }

  bool isBookmarked({
    required BookmarkItemType type,
    required String itemId,
  }) {
    _ensureSeeded();
    return _cache!.any((BookmarkModel row) =>
        row.itemType == type && row.itemId == itemId);
  }

  /// Returns the existing row id for a `(type, itemId)` pair, or null.
  String? findId({required BookmarkItemType type, required String itemId}) {
    _ensureSeeded();
    for (final BookmarkModel row in _cache!) {
      if (row.itemType == type && row.itemId == itemId) return row.id;
    }
    return null;
  }

  void writeAll(List<BookmarkModel> rows) {
    _cache = List<BookmarkModel>.from(rows);
    _changes.add(List<BookmarkModel>.unmodifiable(_cache!));
  }

  BookmarkModel? writeOne(BookmarkModel model) {
    _ensureSeeded();
    final int idx =
        _cache!.indexWhere((BookmarkModel row) => row.id == model.id);
    if (idx >= 0) {
      _cache![idx] = model;
    } else {
      _cache!.insert(0, model);
    }
    _changes.add(List<BookmarkModel>.unmodifiable(_cache!));
    return model;
  }

  bool removeOne(String id) {
    _ensureSeeded();
    final int before = _cache!.length;
    _cache!.removeWhere((BookmarkModel row) => row.id == id);
    final bool removed = _cache!.length != before;
    if (removed) {
      _changes.add(List<BookmarkModel>.unmodifiable(_cache!));
    }
    return removed;
  }

  void clear() {
    _cache = <BookmarkModel>[];
    _changes.add(const <BookmarkModel>[]);
  }

  void dispose() {
    _changes.close();
  }

  Iterable<BookmarkModel> _applyFilter(
    Iterable<BookmarkModel> rows,
    BookmarkFilter filter,
  ) {
    switch (filter) {
      case BookmarkFilter.all:
        return rows;
      case BookmarkFilter.questions:
        return rows.where((BookmarkModel r) => r.itemType == BookmarkItemType.question);
      case BookmarkFilter.lessons:
        return rows.where((BookmarkModel r) => r.itemType == BookmarkItemType.lesson);
      case BookmarkFilter.ai:
        return rows.where((BookmarkModel r) => r.itemType == BookmarkItemType.aiResponse);
      case BookmarkFilter.notes:
        return rows.where((BookmarkModel r) => r.itemType == BookmarkItemType.note);
    }
  }

  Iterable<BookmarkModel> _applySearch(
    Iterable<BookmarkModel> rows,
    String? search,
  ) {
    if (search == null || search.trim().isEmpty) return rows;
    final String needle = search.trim().toLowerCase();
    return rows.where((BookmarkModel row) {
      if (row.title.toLowerCase().contains(needle)) return true;
      if ((row.subtitle ?? '').toLowerCase().contains(needle)) return true;
      return row.tags.any((String t) => t.toLowerCase().contains(needle));
    });
  }

  Iterable<BookmarkModel> _applySort(
    Iterable<BookmarkModel> rows,
    BookmarkSort sort,
  ) {
    final List<BookmarkModel> list = rows.toList(growable: false);
    switch (sort) {
      case BookmarkSort.newest:
        list.sort((BookmarkModel a, BookmarkModel b) =>
            b.createdAtIso.compareTo(a.createdAtIso));
      case BookmarkSort.oldest:
        list.sort((BookmarkModel a, BookmarkModel b) =>
            a.createdAtIso.compareTo(b.createdAtIso));
      case BookmarkSort.alphabetical:
        list.sort((BookmarkModel a, BookmarkModel b) =>
            a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
    return list;
  }

  void _ensureSeeded() {
    if (_cache != null) return;
    final DateTime now = _clock();
    _cache = <BookmarkModel>[
      BookmarkModel(
        id: 'bookmark_q1',
        itemType: BookmarkItemType.question,
        itemId: 'q-bcs-2024-014',
        title: 'BCS 2024 — Question 14',
        subtitle: 'Geography · Climate of Bangladesh',
        thumbnailIconKey: 'bookmarkQuestion',
        createdAtIso: now.subtract(const Duration(hours: 3)).toIso8601String(),
        updatedAtIso: now.subtract(const Duration(hours: 3)).toIso8601String(),
        sourceFeature: 'quiz',
        tags: const <String>['BCS', 'Geography', 'Climate'],
        routeName: '/quiz/review',
        routeParams: const <String, String>{'questionId': 'q-bcs-2024-014'},
      ),
      BookmarkModel(
        id: 'bookmark_l1',
        itemType: BookmarkItemType.lesson,
        itemId: 'lesson-en-tenses',
        title: 'English Tenses — Present Perfect',
        subtitle: 'Lesson · Grammar · 12 min',
        thumbnailIconKey: 'bookmarkLesson',
        createdAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
        updatedAtIso: now.subtract(const Duration(days: 1)).toIso8601String(),
        sourceFeature: 'guidebook',
        tags: const <String>['English', 'Grammar', 'Tenses'],
        routeName: '/lessons/reader',
        routeParams: const <String, String>{'lessonId': 'lesson-en-tenses'},
      ),
      BookmarkModel(
        id: 'bookmark_ai1',
        itemType: BookmarkItemType.aiResponse,
        itemId: 'resp-hint-001',
        title: 'AI hint on Mughal Empire',
        subtitle: 'AI Tutor · Hint · 2 min read',
        thumbnailIconKey: 'bookmarkAiResponse',
        createdAtIso: now.subtract(const Duration(days: 2)).toIso8601String(),
        updatedAtIso: now.subtract(const Duration(days: 2)).toIso8601String(),
        sourceFeature: 'ai_tutor',
        tags: const <String>['History', 'Mughal', 'AI Hint'],
        routeName: '/ai-tutor/hint',
        routeParams: const <String, String>{'responseId': 'resp-hint-001'},
      ),
      BookmarkModel(
        id: 'bookmark_n1',
        itemType: BookmarkItemType.note,
        itemId: 'note-math-algebra',
        title: 'Algebra shortcuts to memorise',
        subtitle: 'Personal Note · Mathematics',
        thumbnailIconKey: 'bookmarkNote',
        createdAtIso: now.subtract(const Duration(days: 4)).toIso8601String(),
        updatedAtIso: now.subtract(const Duration(days: 4)).toIso8601String(),
        sourceFeature: 'notes',
        tags: const <String>['Math', 'Algebra'],
        routeName: '/lessons/detail',
        routeParams: const <String, String>{'noteId': 'note-math-algebra'},
      ),
      BookmarkModel(
        id: 'bookmark_q2',
        itemType: BookmarkItemType.question,
        itemId: 'q-bcs-2024-021',
        title: 'BCS 2024 — Question 21',
        subtitle: 'Bangla · সন্ধি বিচ্ছেদ',
        thumbnailIconKey: 'bookmarkQuestion',
        createdAtIso: now.subtract(const Duration(days: 5)).toIso8601String(),
        updatedAtIso: now.subtract(const Duration(days: 5)).toIso8601String(),
        sourceFeature: 'quiz',
        tags: const <String>['Bangla', 'সন্ধি'],
        routeName: '/quiz/review',
        routeParams: const <String, String>{'questionId': 'q-bcs-2024-021'},
      ),
      BookmarkModel(
        id: 'bookmark_l2',
        itemType: BookmarkItemType.lesson,
        itemId: 'lesson-math-percentage',
        title: 'Percentage tricks for BCS',
        subtitle: 'Lesson · Math · 8 min',
        thumbnailIconKey: 'bookmarkLesson',
        createdAtIso: now.subtract(const Duration(days: 7)).toIso8601String(),
        updatedAtIso: now.subtract(const Duration(days: 7)).toIso8601String(),
        sourceFeature: 'guidebook',
        tags: const <String>['Math', 'Percentage'],
        routeName: '/lessons/reader',
        routeParams: const <String, String>{'lessonId': 'lesson-math-percentage'},
      ),
    ];
  }
}