import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../data/datasources/notes_local_datasource.dart';
import '../../data/datasources/notes_remote_datasource.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../domain/entities/ai_note_entity.dart';
import '../../domain/entities/highlight_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_filter.dart';
import '../../domain/enums/note_sort.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_all_notes.dart';
import '../../domain/usecases/get_pinned_notes.dart';
import '../../domain/usecases/save_ai_note.dart';
import '../../domain/usecases/save_highlight.dart';
import '../../domain/usecases/search_notes.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/toggle_pin.dart';
import '../../domain/usecases/update_note.dart';
import 'notes_filter_provider.dart';
import 'notes_state.dart';

final notesLocalDataSourceProvider = Provider<NotesLocalDataSource>(
  (Ref ref) => NotesLocalDataSource(),
);

final notesRemoteDatasourceProvider = Provider<NotesRemoteDatasource>(
  (Ref ref) => const NotesRemoteDatasource(),
);

final notesRepositoryProvider = Provider<NotesRepository>(
  (Ref ref) => NotesRepositoryImpl(
    local: ref.watch(notesLocalDataSourceProvider),
    remote: ref.watch(notesRemoteDatasourceProvider),
  ),
);

final getAllNotesUseCaseProvider = Provider<GetAllNotes>(
  (Ref ref) => GetAllNotes(ref.watch(notesRepositoryProvider)),
);

final getPinnedNotesUseCaseProvider = Provider<GetPinnedNotes>(
  (Ref ref) => GetPinnedNotes(ref.watch(notesRepositoryProvider)),
);

final searchNotesUseCaseProvider = Provider<SearchNotes>(
  (Ref ref) => SearchNotes(ref.watch(notesRepositoryProvider)),
);

final createNoteUseCaseProvider = Provider<CreateNote>(
  (Ref ref) => CreateNote(ref.watch(notesRepositoryProvider)),
);

final updateNoteUseCaseProvider = Provider<UpdateNote>(
  (Ref ref) => UpdateNote(ref.watch(notesRepositoryProvider)),
);

final deleteNoteUseCaseProvider = Provider<DeleteNote>(
  (Ref ref) => DeleteNote(ref.watch(notesRepositoryProvider)),
);

final togglePinUseCaseProvider = Provider<TogglePin>(
  (Ref ref) => TogglePin(ref.watch(notesRepositoryProvider)),
);

final toggleFavoriteUseCaseProvider = Provider<ToggleFavorite>(
  (Ref ref) => ToggleFavorite(ref.watch(notesRepositoryProvider)),
);

final saveHighlightUseCaseProvider = Provider<SaveHighlight>(
  (Ref ref) => SaveHighlight(ref.watch(notesRepositoryProvider)),
);

final saveAiNoteUseCaseProvider = Provider<SaveAiNote>(
  (Ref ref) => SaveAiNote(ref.watch(notesRepositoryProvider)),
);

/// Owns the Notes screen lifecycle, search/filter/sort, CRUD actions,
/// and the feedback stream consumed by widgets that surface snackbars.
class NotesController extends StateNotifier<NotesViewState> {
  NotesController({
    required GetAllNotes getAllNotes,
    required GetPinnedNotes getPinnedNotes,
    required SearchNotes searchNotes,
    required CreateNote createNote,
    required UpdateNote updateNote,
    required DeleteNote deleteNote,
    required TogglePin togglePin,
    required ToggleFavorite toggleFavorite,
    required SaveHighlight saveHighlight,
    required SaveAiNote saveAiNote,
    required Ref ref,
  })  : _getAllNotes = getAllNotes,
        _getPinnedNotes = getPinnedNotes,
        _searchNotes = searchNotes,
        _createNote = createNote,
        _updateNote = updateNote,
        _deleteNote = deleteNote,
        _togglePin = togglePin,
        _toggleFavorite = toggleFavorite,
        _saveHighlight = saveHighlight,
        _saveAiNote = saveAiNote,
        _ref = ref,
        super(NotesViewState.initial);

  final GetAllNotes _getAllNotes;
  final GetPinnedNotes _getPinnedNotes;
  final SearchNotes _searchNotes;
  final CreateNote _createNote;
  final UpdateNote _updateNote;
  final DeleteNote _deleteNote;
  final TogglePin _togglePin;
  final ToggleFavorite _toggleFavorite;
  final SaveHighlight _saveHighlight;
  final SaveAiNote _saveAiNote;
  final Ref _ref;

  final StreamController<NoteFeedback> _feedback =
      StreamController<NoteFeedback>.broadcast();

  Stream<NoteFeedback> get feedback => _feedback.stream;

  Future<void> hydrate({int offset = 0, int limit = 20}) async {
    final NoteFilter filter = _ref.read(noteFilterProvider);
    final NoteSort sort = _ref.read(noteSortProvider);
    final String query = state.query;

    if (offset == 0) {
      state = state.copyWith(
        status: NotesStatus.loading,
        clearError: true,
      );
    } else {
      state = state.copyWith(status: NotesStatus.loadingMore);
    }

    final Result<List<NoteEntity>> result = await _getAllNotes(
      filter: filter,
      sort: sort,
      query: query.trim().isEmpty ? null : query.trim(),
      offset: offset,
      limit: limit,
    );

    if (!mounted) return;

    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          status: NotesStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (List<NoteEntity> rows) {
        final List<NoteEntity> combined = offset == 0
            ? List<NoteEntity>.unmodifiable(rows)
            : List<NoteEntity>.unmodifiable(<NoteEntity>[...state.items, ...rows]);
        state = state.copyWith(
          status: NotesStatus.ready,
          items: combined,
          hasMore: rows.length >= limit,
          clearError: true,
        );
      },
    );

    if (offset == 0) {
      _refreshPinnedPreview();
      _refreshRecentPreview();
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await hydrate(offset: 0);
    if (!mounted) return;
    state = state.copyWith(isRefreshing: false);
  }

  Future<void> loadMore({int limit = 20}) async {
    if (!state.hasMore) return;
    if (state.status == NotesStatus.loadingMore) return;
    await hydrate(offset: state.items.length, limit: limit);
  }

  Future<void> onFilterChanged(NoteFilter filter) async {
    _ref.read(noteFilterProvider.notifier).state = filter;
    state = state.copyWith(filter: filter);
    await hydrate(offset: 0);
  }

  Future<void> onSortChanged(NoteSort sort) async {
    _ref.read(noteSortProvider.notifier).state = sort;
    state = state.copyWith(sort: sort);
    await hydrate(offset: 0);
  }

  void onQueryChanged(String query) {
    state = state.copyWith(query: query);
  }

  Future<void> runSearch({String? query}) async {
    final String next = (query ?? state.query).trim();
    state = state.copyWith(
      query: next,
      status: NotesStatus.loading,
      clearError: true,
    );
    if (next.isEmpty) {
      await hydrate(offset: 0);
      return;
    }
    final Result<List<NoteEntity>> result =
        await _searchNotes(next, limit: 30);
    if (!mounted) return;
    result.fold(
      onFailure: (Failure failure) {
        state = state.copyWith(
          status: NotesStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (List<NoteEntity> rows) {
        state = state.copyWith(
          status: NotesStatus.ready,
          items: List<NoteEntity>.unmodifiable(rows),
          hasMore: false,
          clearError: true,
        );
      },
    );
  }

  Future<NoteEntity?> create(NoteEntity note) async {
    final Result<NoteEntity> result = await _createNote(note);
    if (!mounted) return null;
    return result.fold(
      onFailure: (Failure failure) {
        _feedback.add(NoteFeedback(
          message: failure.message,
          variant: NoteFeedbackVariant.error,
        ));
        return null;
      },
      onSuccess: (NoteEntity saved) {
        _feedback.add(NoteFeedback(
          message: 'Note saved',
          variant: NoteFeedbackVariant.created,
        ));
        hydrate(offset: 0);
        return saved;
      },
    );
  }

  Future<NoteEntity?> update(NoteEntity note) async {
    final Result<NoteEntity> result = await _updateNote(note);
    if (!mounted) return null;
    return result.fold(
      onFailure: (Failure failure) {
        _feedback.add(NoteFeedback(
          message: failure.message,
          variant: NoteFeedbackVariant.error,
        ));
        return null;
      },
      onSuccess: (NoteEntity saved) {
        _feedback.add(NoteFeedback(
          message: 'Note updated',
          variant: NoteFeedbackVariant.updated,
        ));
        hydrate(offset: 0);
        return saved;
      },
    );
  }

  Future<void> remove(String id) async {
    final Result<void> result = await _deleteNote(id);
    if (!mounted) return;
    result.fold(
      onFailure: (Failure failure) {
        _feedback.add(NoteFeedback(
          message: failure.message,
          variant: NoteFeedbackVariant.error,
        ));
      },
      onSuccess: (_) {
        _feedback.add(NoteFeedback(
          message: 'Note deleted',
          variant: NoteFeedbackVariant.deleted,
        ));
        hydrate(offset: 0);
      },
    );
  }

  Future<void> togglePinFor(String id) async {
    final Result<NoteEntity> result = await _togglePin(id);
    if (!mounted) return;
    result.fold(
      onFailure: (Failure failure) {
        _feedback.add(NoteFeedback(
          message: failure.message,
          variant: NoteFeedbackVariant.error,
        ));
      },
      onSuccess: (NoteEntity saved) {
        _feedback.add(NoteFeedback(
          message: saved.isPinned ? 'Pinned to top' : 'Removed from pinned',
          variant:
              saved.isPinned ? NoteFeedbackVariant.pinned : NoteFeedbackVariant.unpinned,
        ));
        hydrate(offset: 0);
      },
    );
  }

  Future<void> toggleFavoriteFor(String id) async {
    final Result<NoteEntity> result = await _toggleFavorite(id);
    if (!mounted) return;
    result.fold(
      onFailure: (Failure failure) {
        _feedback.add(NoteFeedback(
          message: failure.message,
          variant: NoteFeedbackVariant.error,
        ));
      },
      onSuccess: (NoteEntity saved) {
        _feedback.add(NoteFeedback(
          message: saved.isFavorite ? 'Added to favorites' : 'Removed from favorites',
          variant: saved.isFavorite
              ? NoteFeedbackVariant.favorited
              : NoteFeedbackVariant.unfavorited,
        ));
        hydrate(offset: 0);
      },
    );
  }

  Future<NoteEntity?> saveHighlight(HighlightEntity highlight) async {
    final Result<NoteEntity> result = await _saveHighlight(highlight);
    if (!mounted) return null;
    return result.fold(
      onFailure: (Failure failure) {
        _feedback.add(NoteFeedback(
          message: failure.message,
          variant: NoteFeedbackVariant.error,
        ));
        return null;
      },
      onSuccess: (NoteEntity saved) {
        _feedback.add(NoteFeedback(
          message: 'Highlight saved',
          variant: NoteFeedbackVariant.savedHighlight,
        ));
        hydrate(offset: 0);
        return saved;
      },
    );
  }

  Future<NoteEntity?> saveAiNote(AiNoteEntity aiNote) async {
    final Result<NoteEntity> result = await _saveAiNote(aiNote);
    if (!mounted) return null;
    return result.fold(
      onFailure: (Failure failure) {
        _feedback.add(NoteFeedback(
          message: failure.message,
          variant: NoteFeedbackVariant.error,
        ));
        return null;
      },
      onSuccess: (NoteEntity saved) {
        _feedback.add(NoteFeedback(
          message: 'AI note saved',
          variant: NoteFeedbackVariant.savedAi,
        ));
        hydrate(offset: 0);
        return saved;
      },
    );
  }

  Future<NoteEntity?> findById(String id) async {
    final Result<NoteEntity?> result =
        await _ref.read(notesRepositoryProvider).findNoteById(id);
    return result.fold(
      onFailure: (_) => null,
      onSuccess: (NoteEntity? n) => n,
    );
  }

  Future<void> clearAll() async {
    final Result<void> result =
        await _ref.read(notesRepositoryProvider).clearAll();
    if (!mounted) return;
    result.fold(
      onFailure: (Failure failure) {
        _feedback.add(NoteFeedback(
          message: failure.message,
          variant: NoteFeedbackVariant.error,
        ));
      },
      onSuccess: (_) {
        state = state.copyWith(
          items: const <NoteEntity>[],
          pinnedPreview: const <NoteEntity>[],
          recentPreview: const <NoteEntity>[],
        );
        _feedback.add(NoteFeedback(
          message: 'All notes cleared',
          variant: NoteFeedbackVariant.deleted,
        ));
      },
    );
  }

  void _refreshPinnedPreview() {
    _getPinnedNotes().then((Result<List<NoteEntity>> result) {
      if (!mounted) return;
      result.fold(
        onFailure: (_) {},
        onSuccess: (List<NoteEntity> rows) {
          state = state.copyWith(pinnedPreview: rows);
        },
      );
    });
  }

  void _refreshRecentPreview() {
    _ref.read(notesRepositoryProvider).getRecentNotes(limit: 6).then(
      (Result<List<NoteEntity>> result) {
        if (!mounted) return;
        result.fold(
          onFailure: (_) {},
          onSuccess: (List<NoteEntity> rows) {
            state = state.copyWith(recentPreview: rows);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _feedback.close();
    super.dispose();
  }
}

final notesControllerProvider =
    StateNotifierProvider<NotesController, NotesViewState>(
  (Ref ref) => NotesController(
    getAllNotes: ref.watch(getAllNotesUseCaseProvider),
    getPinnedNotes: ref.watch(getPinnedNotesUseCaseProvider),
    searchNotes: ref.watch(searchNotesUseCaseProvider),
    createNote: ref.watch(createNoteUseCaseProvider),
    updateNote: ref.watch(updateNoteUseCaseProvider),
    deleteNote: ref.watch(deleteNoteUseCaseProvider),
    togglePin: ref.watch(togglePinUseCaseProvider),
    toggleFavorite: ref.watch(toggleFavoriteUseCaseProvider),
    saveHighlight: ref.watch(saveHighlightUseCaseProvider),
    saveAiNote: ref.watch(saveAiNoteUseCaseProvider),
    ref: ref,
  ),
);
