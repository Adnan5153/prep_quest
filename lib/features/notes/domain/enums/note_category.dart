/// Top-level grouping a user picks for a [NoteEntity].
///
/// Categories are user-facing labels that survive any data-layer
/// round-trip via [NoteCategory.name].
enum NoteCategory {
  personal,
  study,
  review,
  insight,
  question,
  ai,
}

extension NoteCategoryX on NoteCategory {
  String get displayLabel {
    switch (this) {
      case NoteCategory.personal:
        return 'Personal';
      case NoteCategory.study:
        return 'Study';
      case NoteCategory.review:
        return 'Review';
      case NoteCategory.insight:
        return 'Insight';
      case NoteCategory.question:
        return 'Question';
      case NoteCategory.ai:
        return 'AI';
    }
  }
}
