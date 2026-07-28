import '../../../../shared/typedefs/result.dart';
import '../entities/highlight_entity.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

/// Persists a highlighted passage as a [NoteEntity] of type
/// [NoteType.highlight].
class SaveHighlight {
  const SaveHighlight(this._repository);
  final NotesRepository _repository;

  Future<Result<NoteEntity>> call(HighlightEntity highlight) =>
      _repository.saveHighlight(highlight);
}
