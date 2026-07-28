import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/enums/note_filter.dart';
import 'note_category_chip.dart';

/// Horizontal scroll of [NoteCategoryChip]s.
class NoteCategoryTabs extends StatelessWidget {
  const NoteCategoryTabs({
    super.key,
    required this.selected,
    required this.onSelect,
    this.counts = const <NoteFilter, int>{},
  });

  final NoteFilter selected;
  final ValueChanged<NoteFilter> onSelect;
  final Map<NoteFilter, int> counts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: <Widget>[
          for (final NoteFilter f in NoteFilter.values)
            NoteCategoryChip(
              filter: f,
              selected: f == selected,
              count: counts[f],
              onSelect: onSelect,
            ),
        ],
      ),
    );
  }
}
