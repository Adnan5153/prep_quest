import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/highlight_entity.dart';

/// Read-only card rendering a captured [HighlightEntity] with a
/// "Save as note" CTA.
class HighlightCard extends StatelessWidget {
  const HighlightCard({
    super.key,
    required this.highlight,
    this.onSaveAsNote,
  });

  final HighlightEntity highlight;
  final VoidCallback? onSaveAsNote;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dynamic color = highlight.color;
    final Color surface = color?.resolve(context) ??
        theme.colorScheme.surfaceContainerHighest;
    final Color accent = color?.resolveAccent(context) ??
        theme.colorScheme.primary;
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
              Icon(AppIcons.noteHighlight, color: accent, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Highlight — ${highlight.sourceTitle}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '“${highlight.text}”',
            style: theme.textTheme.bodyMedium,
          ),
          if (onSaveAsNote != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            FilledButton.tonalIcon(
              onPressed: onSaveAsNote,
              icon: const Icon(AppIcons.noteAdd),
              label: const Text(AppStrings.notesHighlightSaved),
            ),
          ],
        ],
      ),
    );
  }
}
