import '../../../../shared/typedefs/result.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

/// Persists a brand-new [NoteEntity].
class CreateNote {
  const CreateNote(this._repository);
  final NotesRepository _repository;

  Future<Result<NoteEntity>> call(NoteEntity note) =>
      _repository.createNote(note);
}
