import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/enums/note_category.dart';
import '../../domain/enums/note_type.dart';
import '../extensions/note_color_extension.dart';

/// List-row variant of a note card with a left accent strip.
class NoteListItem extends StatelessWidget {
  const NoteListItem({
    super.key,
    required this.note,
    required this.onTap,
    required this.onTogglePin,
    required this.onToggleFavorite,
    required this.onShare,
  });

  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShare;

  String _typeLabel() {
    switch (note.type) {
      case NoteType.personal:
        return AppStrings.notesTypePersonal;
      case NoteType.highlight:
        return AppStrings.notesTypeHighlight;
      case NoteType.ai:
        return AppStrings.notesTypeAi;
    }
  }

  IconData _typeIcon() {
    switch (note.type) {
      case NoteType.personal:
        return AppIcons.noteContent;
      case NoteType.highlight:
        return AppIcons.noteHighlight;
      case NoteType.ai:
        return AppIcons.noteAiFilled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: note.color.resolve(context),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: note.color.resolveAccent(context),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.lg),
                    bottomLeft: Radius.circular(AppRadius.lg),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            _typeIcon(),
                            size: 16,
                            color: note.color.resolveAccent(context),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            _typeLabel(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: note.color.resolveAccent(context),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          if (note.isPinned)
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: AppSpacing.xs),
                              child: Icon(
                                AppIcons.notePinFilled,
                                size: 16,
                                color: note.color.resolveAccent(context),
                              ),
                            ),
                          if (note.isFavorite)
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: AppSpacing.xs),
                              child: Icon(
                                AppIcons.noteFavoriteFilled,
                                size: 16,
                                color: note.color.resolveAccent(context),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        note.resolvedPreview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: <Widget>[
                          CategoryChip(
                            label: note.category.displayLabel,
                            selected: false,
                            enabled: false,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              note.isPinned
                                  ? AppIcons.notePinFilled
                                  : AppIcons.notePin,
                              size: 18,
                            ),
                            tooltip: note.isPinned
                                ? AppStrings.notesUnpinCta
                                : AppStrings.notesPinCta,
                            onPressed: onTogglePin,
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            icon: Icon(
                              note.isFavorite
                                  ? AppIcons.noteFavoriteFilled
                                  : AppIcons.noteFavorite,
                              size: 18,
                            ),
                            tooltip: note.isFavorite
                                ? AppStrings.notesUnfavoriteCta
                                : AppStrings.notesFavoriteCta,
                            onPressed: onToggleFavorite,
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            icon: const Icon(AppIcons.noteShare, size: 18),
                            tooltip: AppStrings.notesShareCta,
                            onPressed: onShare,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
