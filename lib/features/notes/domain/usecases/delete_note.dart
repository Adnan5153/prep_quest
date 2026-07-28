import '../../../../shared/typedefs/result.dart';
import '../repositories/notes_repository.dart';

/// Removes a note by id.
class DeleteNote {
  const DeleteNote(this._repository);
  final NotesRepository _repository;

  Future<Result<void>> call(String id) => _repository.deleteNote(id);
}
