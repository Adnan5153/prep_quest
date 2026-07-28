import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/enums/note_category.dart';
import '../../domain/enums/note_color.dart';
import 'note_palette_picker.dart';

/// Inline editor used by both the Create and Edit note screens.
class NoteEditor extends StatelessWidget {
  const NoteEditor({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.tagsController,
    required this.category,
    required this.color,
    required this.onCategoryChanged,
    required this.onColorChanged,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController tagsController;
  final NoteCategory category;
  final NoteColor color;
  final ValueChanged<NoteCategory> onCategoryChanged;
  final ValueChanged<NoteColor> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Text(AppStrings.notesTitleHint,
            style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: titleController,
          maxLength: 120,
          decoration: const InputDecoration(
            hintText: AppStrings.notesTitleHint,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.notesContentHint,
            style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: contentController,
          maxLines: 8,
          minLines: 5,
          maxLength: 10000,
          decoration: const InputDecoration(
            hintText: AppStrings.notesContentHint,
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.notesCategoryHint,
            style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: <Widget>[
            for (final NoteCategory c in NoteCategory.values)
              _EditorCategoryChip(
                category: c,
                selected: c == category,
                onTap: () => onCategoryChanged(c),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.notesTagsHint,
            style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: tagsController,
          decoration: const InputDecoration(
            hintText: AppStrings.notesTagsHint,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(AppStrings.notesPaletteTitle,
            style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        NotePalettePicker(
          selected: color,
          onChanged: onColorChanged,
        ),
      ],
    );
  }
}

class _EditorCategoryChip extends StatelessWidget {
  const _EditorCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final NoteCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: selected
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            category.displayLabel,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected ? Colors.white : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
