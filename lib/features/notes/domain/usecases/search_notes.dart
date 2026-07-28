import '../../../../shared/typedefs/result.dart';
import '../entities/note_entity.dart';
import '../enums/note_filter.dart';
import '../enums/note_sort.dart';
import '../repositories/notes_repository.dart';

/// Search notes by free-text query.
class SearchNotes {
  const SearchNotes(this._repository);
  final NotesRepository _repository;

  Future<Result<List<NoteEntity>>> call(
    String query, {
    NoteFilter filter = NoteFilter.all,
    NoteSort sort = NoteSort.newest,
    int limit = 30,
  }) {
    final String normalized = query.trim();
    return _repository.getNotes(
      filter: filter,
      sort: sort,
      query: normalized.isEmpty ? null : normalized,
      offset: 0,
      limit: limit,
    );
  }
}
