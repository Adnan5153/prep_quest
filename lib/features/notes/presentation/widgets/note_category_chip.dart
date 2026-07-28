import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../domain/enums/note_filter.dart';

/// Pill chip used to switch the active [NoteFilter] on the Notes hub.
class NoteCategoryChip extends StatelessWidget {
  const NoteCategoryChip({
    super.key,
    required this.filter,
    required this.selected,
    required this.onSelect,
    this.count,
  });

  final NoteFilter filter;
  final bool selected;
  final ValueChanged<NoteFilter> onSelect;
  final int? count;

  IconData _icon() {
    switch (filter) {
      case NoteFilter.all:
        return AppIcons.noteList;
      case NoteFilter.pinned:
        return AppIcons.notePinFilled;
      case NoteFilter.favorites:
        return AppIcons.noteFavoriteFilled;
      case NoteFilter.highlights:
        return AppIcons.noteHighlight;
      case NoteFilter.ai:
        return AppIcons.noteAiFilled;
      case NoteFilter.personal:
        return AppIcons.noteContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: CategoryChip(
        label: filter.displayLabel,
        selected: selected,
        leading: Icon(_icon(), size: 16),
        count: count,
        onTap: () => onSelect(filter),
      ),
    );
  }
}
