import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notes_provider.dart';
import 'notes_state.dart';

/// Synchronously-derived set of note ids — used by widgets that need
/// to know whether a note is pinned/favorited without spawning a Future.
final noteIdsProvider = Provider<Set<String>>((Ref ref) {
  final NotesViewState state = ref.watch(notesControllerProvider);
  return state.items.map((n) => n.id).toSet();
});

/// Set of pinned note ids.
final pinnedNoteIdsProvider = Provider<Set<String>>((Ref ref) {
  final NotesViewState state = ref.watch(notesControllerProvider);
  return state.items.where((n) => n.isPinned).map((n) => n.id).toSet();
});

/// Set of favorited note ids.
final favoriteNoteIdsProvider = Provider<Set<String>>((Ref ref) {
  final NotesViewState state = ref.watch(notesControllerProvider);
  return state.items.where((n) => n.isFavorite).map((n) => n.id).toSet();
});
