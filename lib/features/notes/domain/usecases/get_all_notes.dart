import '../../../../shared/typedefs/result.dart';
import '../entities/note_entity.dart';
import '../enums/note_filter.dart';
import '../enums/note_sort.dart';
import '../repositories/notes_repository.dart';

/// Returns a paginated, filtered, sorted list of notes.
class GetAllNotes {
  const GetAllNotes(this._repository);
  final NotesRepository _repository;

  Future<Result<List<NoteEntity>>> call({
    NoteFilter filter = NoteFilter.all,
    NoteSort sort = NoteSort.newest,
    String? query,
    int offset = 0,
    int limit = 20,
  }) =>
      _repository.getNotes(
        filter: filter,
        sort: sort,
        query: query,
        offset: offset,
        limit: limit,
      );
}
