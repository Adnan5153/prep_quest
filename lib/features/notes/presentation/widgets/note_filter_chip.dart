import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/enums/note_filter.dart';

/// Filter chip used inside the filter sheet.
class NoteFilterChip extends StatelessWidget {
  const NoteFilterChip({
    super.key,
    required this.filter,
    required this.selected,
    required this.onChanged,
  });

  final NoteFilter filter;
  final bool selected;
  final ValueChanged<NoteFilter> onChanged;

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
    final ThemeData theme = Theme.of(context);
    return FilterChip(
      selected: selected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(_icon(), size: 16),
          const SizedBox(width: AppSpacing.xs),
          Text(filter.displayLabel),
        ],
      ),
      onSelected: (_) => onChanged(filter),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: theme.colorScheme.primary,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: selected ? Colors.white : theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      checkmarkColor: Colors.white,
      showCheckmark: false,
    );
  }
}
