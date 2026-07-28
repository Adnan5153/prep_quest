import '../../../../shared/typedefs/result.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

/// Flips the [NoteEntity.isFavorite] flag.
class ToggleFavorite {
  const ToggleFavorite(this._repository);
  final NotesRepository _repository;

  Future<Result<NoteEntity>> call(String id) => _repository.toggleFavorite(id);
}
