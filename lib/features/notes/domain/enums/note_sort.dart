/// Sort options for the Notes hub list / grid.
enum NoteSort {
  newest,
  oldest,
  alphabetical,
  favoritesFirst,
  pinnedFirst,
}

extension NoteSortX on NoteSort {
  String get displayLabel {
    switch (this) {
      case NoteSort.newest:
        return 'Newest first';
      case NoteSort.oldest:
        return 'Oldest first';
      case NoteSort.alphabetical:
        return 'Alphabetical';
      case NoteSort.favoritesFirst:
        return 'Favorites first';
      case NoteSort.pinnedFirst:
        return 'Pinned first';
    }
  }
}
