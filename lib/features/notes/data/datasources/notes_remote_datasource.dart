import '../models/note_model.dart';

/// Firestore-ready remote seam for notes.
///
/// Until cloud sync is wired, `pull` and `push` throw `UnimplementedError`.
class NotesRemoteDatasource {
  const NotesRemoteDatasource();

  Future<List<NoteModel>> pull() async {
    throw UnimplementedError(
      'NotesRemoteDatasource is not yet wired to Firestore.',
    );
  }

  Future<void> push(List<NoteModel> items) async {
    throw UnimplementedError(
      'NotesRemoteDatasource is not yet wired to Firestore.',
    );
  }
}
