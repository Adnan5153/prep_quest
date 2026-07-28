import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/enums/bookmark_sort.dart';

/// Three-dot menu letting the user pick the active sort order.
class BookmarkSortDropdown extends StatelessWidget {
  const BookmarkSortDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final BookmarkSort selected;
  final ValueChanged<BookmarkSort> onChanged;

  String _label(BookmarkSort s) {
    switch (s) {
      case BookmarkSort.newest:
        return AppStrings.bookmarksSortNewest;
      case BookmarkSort.oldest:
        return AppStrings.bookmarksSortOldest;
      case BookmarkSort.alphabetical:
        return AppStrings.bookmarksSortAlpha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BookmarkSort>(
      tooltip: AppStrings.bookmarksSortNewest,
      onSelected: onChanged,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<BookmarkSort>>[
        for (final BookmarkSort s in BookmarkSort.values)
          PopupMenuItem<BookmarkSort>(
            value: s,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (s == selected) const Icon(Icons.check_rounded, size: 18),
                if (s == selected) const SizedBox(width: 6),
                Text(_label(s)),
              ],
            ),
          ),
      ],
      icon: const Icon(Icons.sort_rounded),
    );
  }
}
