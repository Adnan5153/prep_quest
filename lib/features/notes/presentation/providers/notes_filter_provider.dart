import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/note_filter.dart';
import '../../domain/enums/note_sort.dart';

/// Screen-level filter and sort UI state.
final noteFilterProvider = StateProvider<NoteFilter>(
  (Ref ref) => NoteFilter.all,
);

final noteSortProvider = StateProvider<NoteSort>(
  (Ref ref) => NoteSort.newest,
);
