/// Distinguishes the origin of a [NoteEntity].
///
/// - [NoteType.personal] — a note written entirely by the user.
/// - [NoteType.highlight] — a highlighted passage from a lesson or AI
///   response, captured with attribution.
/// - [NoteType.ai] — a note generated from an AI Tutor explanation.
enum NoteType { personal, highlight, ai }

extension NoteTypeX on NoteType {
  String get displayLabel {
    switch (this) {
      case NoteType.personal:
        return 'Personal';
      case NoteType.highlight:
        return 'Highlight';
      case NoteType.ai:
        return 'AI Note';
    }
  }
}
