import '../../../../shared/typedefs/result.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

/// Flips the [NoteEntity.isPinned] flag.
class TogglePin {
  const TogglePin(this._repository);
  final NotesRepository _repository;

  Future<Result<NoteEntity>> call(String id) => _repository.togglePin(id);
}
