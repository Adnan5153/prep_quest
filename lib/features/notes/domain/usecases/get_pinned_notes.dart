import '../../../../shared/typedefs/result.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

/// Returns pinned notes for the dashboard / sidebar preview.
class GetPinnedNotes {
  const GetPinnedNotes(this._repository);
  final NotesRepository _repository;

  Future<Result<List<NoteEntity>>> call({int limit = 8}) =>
      _repository.getPinnedNotes(limit: limit);
}
