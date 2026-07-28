import '../../../../shared/typedefs/result.dart';
import '../entities/ai_note_entity.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

/// Persists an AI Tutor explanation as a [NoteEntity].
class SaveAiNote {
  const SaveAiNote(this._repository);
  final NotesRepository _repository;

  Future<Result<NoteEntity>> call(AiNoteEntity aiNote) =>
      _repository.saveAiNote(aiNote);
}
