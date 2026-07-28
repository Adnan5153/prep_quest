import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/flashcard.dart';
import '../extensions/ai_tutor_extensions.dart';

/// A flip-card style tile that renders the front of a [Flashcard] and
/// reveals the back on tap. Pure presentation; no provider access.
class FlashcardTile extends StatefulWidget {
  const FlashcardTile({
    super.key,
    required this.card,
    required this.onShowAnswer,
    required this.onHideAnswer,
  });

  final Flashcard card;
  final VoidCallback onShowAnswer;
  final VoidCallback onHideAnswer;

  @override
  State<FlashcardTile> createState() => _FlashcardTileState();
}

class _FlashcardTileState extends State<FlashcardTile> {
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Flashcard card = widget.card;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.style_rounded,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  card.difficulty.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  card.topic,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _showBack ? card.back : card.front,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
                ),
                if (card.hint != null && !_showBack) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.lightbulb_outline_rounded,
                            size: 16, color: theme.colorScheme.tertiary),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            card.hint!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showBack = !_showBack;
                    });
                    if (_showBack) {
                      widget.onShowAnswer();
                    } else {
                      widget.onHideAnswer();
                    }
                  },
                  icon: Icon(
                    _showBack
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 16,
                  ),
                  label: Text(_showBack ? 'Hide answer' : 'Show answer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}