import 'package:flutter/material.dart';

import '../../../../core/widgets/category_chip.dart';
import '../../domain/enums/bookmark_filter.dart';

/// Horizontal scroll of category chips used on the Bookmarks screen.
class BookmarkCategoryTabs extends StatelessWidget {
  const BookmarkCategoryTabs({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.counts,
  });

  final BookmarkFilter selected;
  final ValueChanged<BookmarkFilter> onSelect;

  /// Map of filter → count for the badges.
  final Map<BookmarkFilter, int> counts;

  String _label(BookmarkFilter filter) {
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: <Widget>[
          for (final BookmarkFilter filter in BookmarkFilter.values) ...<Widget>[
            CategoryChip(
              label: _label(filter),
              selected: filter == selected,
              count: counts[filter] ?? 0,
              onTap: () => onSelect(filter),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}