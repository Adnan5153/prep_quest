/// Filter pills rendered in the Notes hub.
enum NoteFilter {
  all,
  pinned,
  favorites,
  highlights,
  ai,
  personal,
}

extension NoteFilterX on NoteFilter {
  String get displayLabel {
    switch (this) {
      case NoteFilter.all:
        return 'All';
      case NoteFilter.pinned:
        return 'Pinned';
      case NoteFilter.favorites:
        return 'Favorites';
      case NoteFilter.highlights:
        return 'Highlights';
      case NoteFilter.ai:
        return 'AI Notes';
      case NoteFilter.personal:
        return 'Personal';
    }
  }
}
