import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/note_entity.dart';

/// Detail-screen toolbar: pin, favorite, share, edit, delete.
class NoteToolbar extends StatelessWidget {
  const NoteToolbar({
    super.key,
    required this.note,
    required this.onTogglePin,
    required this.onToggleFavorite,
    required this.onShare,
    required this.onEdit,
    required this.onDelete,
  });

  final NoteEntity note;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShare;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          tooltip: note.isPinned
              ? AppStrings.notesUnpinCta
              : AppStrings.notesPinCta,
          icon: Icon(
            note.isPinned ? AppIcons.notePinFilled : AppIcons.notePin,
          ),
          onPressed: onTogglePin,
        ),
        IconButton(
          tooltip: note.isFavorite
              ? AppStrings.notesUnfavoriteCta
              : AppStrings.notesFavoriteCta,
          icon: Icon(
            note.isFavorite ? AppIcons.noteFavoriteFilled : AppIcons.noteFavorite,
          ),
          onPressed: onToggleFavorite,
        ),
        IconButton(
          tooltip: AppStrings.notesShareCta,
          icon: const Icon(AppIcons.noteShare),
          onPressed: onShare,
        ),
        IconButton(
          tooltip: AppStrings.notesEditCta,
          icon: const Icon(AppIcons.noteEdit),
          onPressed: onEdit,
        ),
        IconButton(
          tooltip: AppStrings.notesDeleteCta,
          icon: const Icon(AppIcons.noteDelete),
          onPressed: onDelete,
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
