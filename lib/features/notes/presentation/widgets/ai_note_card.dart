import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/ai_note_entity.dart';

/// Read-only card rendering an [AiNoteEntity] with a "Save as note" CTA.
class AiNoteCard extends StatelessWidget {
  const AiNoteCard({
    super.key,
    required this.aiNote,
    this.onSaveAsNote,
  });

  final AiNoteEntity aiNote;
  final VoidCallback? onSaveAsNote;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = aiNote.color.resolveAccent(context);
    final Color surface = aiNote.color.resolve(context);
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(AppIcons.noteAiFilled, color: accent, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(
                aiNote.title ?? aiNote.prompt,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(aiNote.response, style: theme.textTheme.bodyMedium),
          if (onSaveAsNote != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            FilledButton.tonalIcon(
              onPressed: onSaveAsNote,
              icon: const Icon(AppIcons.noteAdd),
              label: const Text(AppStrings.notesAiSaved),
            ),
          ],
        ],
      ),
    );
  }
}
