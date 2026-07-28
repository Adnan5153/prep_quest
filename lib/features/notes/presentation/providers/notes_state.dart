import 'package:flutter/foundation.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_filter.dart';
import '../../domain/enums/note_sort.dart';

enum NotesStatus { initial, loading, ready, loadingMore, error }

/// Transient feedback event for note actions.
@immutable
class NoteFeedback {
  const NoteFeedback({required this.message, required this.variant});

  final String message;
  final NoteFeedbackVariant variant;
}

enum NoteFeedbackVariant { created, updated, deleted, pinned, unpinned, favorited, unfavorited, savedHighlight, savedAi, error }

@immutable
class NotesViewState {
  const NotesViewState({
    required this.status,
    required this.items,
    required this.filter,
    required this.sort,
    required this.hasMore,
    required this.query,
    required this.errorMessage,
    this.pinnedPreview = const <NoteEntity>[],
    this.recentPreview = const <NoteEntity>[],
    this.isRefreshing = false,
  });

  final NotesStatus status;
  final List<NoteEntity> items;
  final NoteFilter filter;
  final NoteSort sort;
  final bool hasMore;
  final String query;
  final String? errorMessage;
  final List<NoteEntity> pinnedPreview;
  final List<NoteEntity> recentPreview;
  final bool isRefreshing;

  bool get hasQuery => query.trim().isNotEmpty;
  bool get hasResults => items.isNotEmpty;
  bool get isEmpty => items.isEmpty && !hasQuery;

  NotesViewState copyWith({
    NotesStatus? status,
    List<NoteEntity>? items,
    NoteFilter? filter,
    NoteSort? sort,
    bool? hasMore,
    String? query,
    bool clearQuery = false,
    String? errorMessage,
    bool clearError = false,
    List<NoteEntity>? pinnedPreview,
    List<NoteEntity>? recentPreview,
    bool? isRefreshing,
  }) {
    return NotesViewState(
      status: status ?? this.status,
      items: items ?? this.items,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      hasMore: hasMore ?? this.hasMore,
      query: clearQuery ? '' : (query ?? this.query),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pinnedPreview: pinnedPreview ?? this.pinnedPreview,
      recentPreview: recentPreview ?? this.recentPreview,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  static const NotesViewState initial = NotesViewState(
    status: NotesStatus.initial,
    items: <NoteEntity>[],
    filter: NoteFilter.all,
    sort: NoteSort.newest,
    hasMore: true,
    query: '',
    errorMessage: null,
  );
}
