import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/enums/note_color.dart';
import '../extensions/note_color_extension.dart';

/// Inline color swatch picker used by the editor.
class NotePalettePicker extends StatelessWidget {
  const NotePalettePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final NoteColor selected;
  final ValueChanged<NoteColor> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        for (final NoteColor c in NoteColor.values)
          _Swatch(
            color: c,
            selected: c == selected,
            label: _labelFor(c),
            onTap: () => onChanged(c),
          ),
      ],
    );
  }

  String _labelFor(NoteColor c) {
    switch (c) {
      case NoteColor.defaultColor:
        return AppStrings.notesColorDefault;
      case NoteColor.yellow:
        return AppStrings.notesColorYellow;
      case NoteColor.green:
        return AppStrings.notesColorGreen;
      case NoteColor.blue:
        return AppStrings.notesColorBlue;
      case NoteColor.pink:
        return AppStrings.notesColorPink;
      case NoteColor.purple:
        return AppStrings.notesColorPurple;
    }
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final NoteColor color;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.resolve(context),
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                width: selected ? 3 : 1,
              ),
            ),
            child: selected
                ? Icon(Icons.check,
                    size: 18, color: color.resolveAccent(context))
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            )),
      ],
    );
  }
}
