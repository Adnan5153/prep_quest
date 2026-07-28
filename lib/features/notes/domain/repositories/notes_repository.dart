import '../../../../shared/typedefs/result.dart';
import '../entities/ai_note_entity.dart';
import '../entities/highlight_entity.dart';
import '../entities/note_entity.dart';
import '../enums/note_filter.dart';
import '../enums/note_sort.dart';

/// Storage contract for the Notes feature.
abstract class NotesRepository {
  Future<Result<List<NoteEntity>>> getNotes({
    NoteFilter filter = NoteFilter.all,
    NoteSort sort = NoteSort.newest,
    String? query,
    int offset = 0,
    int limit = 20,
  });

  Future<Result<List<NoteEntity>>> getPinnedNotes({int limit = 8});

  Future<Result<List<NoteEntity>>> getRecentNotes({int limit = 6});

  Future<Result<NoteEntity?>> findNoteById(String id);

  Future<Result<NoteEntity>> createNote(NoteEntity note);

  Future<Result<NoteEntity>> updateNote(NoteEntity note);

  Future<Result<void>> deleteNote(String id);

  Future<Result<NoteEntity>> togglePin(String id);

  Future<Result<NoteEntity>> toggleFavorite(String id);

  Future<Result<NoteEntity>> saveHighlight(HighlightEntity highlight);

  Future<Result<NoteEntity>> saveAiNote(AiNoteEntity aiNote);

  Future<Result<void>> clearAll();
}
