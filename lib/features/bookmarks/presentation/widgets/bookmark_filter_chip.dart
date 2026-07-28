import 'package:flutter/material.dart';

import '../../domain/enums/bookmark_filter.dart';

/// Presentational chip rendered inside [BookmarkFilterSheet].
class BookmarkFilterChip extends StatelessWidget {
  const BookmarkFilterChip({
    super.key,
    required this.filter,
    required this.selected,
    required this.onChanged,
  });

  final BookmarkFilter filter;
  final bool selected;
  final ValueChanged<bool> onChanged;

  String get label {
    switch (filter) {
      case BookmarkFilter.all:
        return 'All';
      case BookmarkFilter.questions:
        return 'Questions';
      case BookmarkFilter.lessons:
        return 'Lessons';
      case BookmarkFilter.ai:
        return 'AI';
      case BookmarkFilter.notes:
        return 'Notes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onChanged,
    );
  }
}
