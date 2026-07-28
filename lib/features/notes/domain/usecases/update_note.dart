import '../../../../shared/typedefs/result.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

/// Persists edits to an existing [NoteEntity].
class UpdateNote {
  const UpdateNote(this._repository);
  final NotesRepository _repository;

  Future<Result<NoteEntity>> call(NoteEntity note) =>
      _repository.updateNote(note);
}
