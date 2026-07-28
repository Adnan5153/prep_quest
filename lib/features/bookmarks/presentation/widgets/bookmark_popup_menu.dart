import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

/// Per-tile three-dot menu with "Open" and "Remove bookmark".
class BookmarkPopupMenu extends StatelessWidget {
  const BookmarkPopupMenu({
    super.key,
    required this.onOpen,
    required this.onRemove,
  });

  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'More actions',
      onSelected: (String value) {
        if (value == 'open') {
          onOpen();
        } else if (value == 'remove') {
          onRemove();
        }
      },
      itemBuilder: (BuildContext context) => const <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'open',
          child: Text('Open'),
        ),
        PopupMenuItem<String>(
          value: 'remove',
          child: Text(AppStrings.bookmarkRemoveTooltip),
        ),
      ],
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
