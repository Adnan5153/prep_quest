import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';

class NoteEmptyState extends StatelessWidget {
  const NoteEmptyState({
    super.key,
    this.onCreateNote,
    this.variant = NoteEmptyVariant.neverCreated,
  });

  final VoidCallback? onCreateNote;
  final NoteEmptyVariant variant;

  String get _title {
    switch (variant) {
      case NoteEmptyVariant.neverCreated:
        return AppStrings.notesEmpty;
      case NoteEmptyVariant.noMatches:
        return AppStrings.notesEmptyFiltered;
      case NoteEmptyVariant.noSearch:
        return AppStrings.notesEmptySearch;
    }
  }

  String get _subtitle {
    switch (variant) {
      case NoteEmptyVariant.neverCreated:
        return AppStrings.notesEmptySubtitle;
      case NoteEmptyVariant.noMatches:
        return AppStrings.notesEmptyFiltered;
      case NoteEmptyVariant.noSearch:
        return AppStrings.notesEmptySearch;
    }
  }

  IconData get _icon {
    switch (variant) {
      case NoteEmptyVariant.neverCreated:
        return AppIcons.noteEmpty;
      case NoteEmptyVariant.noMatches:
        return AppIcons.noteList;
      case NoteEmptyVariant.noSearch:
        return AppIcons.searchEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(_icon, size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text(
              _title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onCreateNote != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onCreateNote,
                icon: const Icon(AppIcons.noteAdd),
                label: const Text(AppStrings.notesCreateCta),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum NoteEmptyVariant { neverCreated, noMatches, noSearch }
