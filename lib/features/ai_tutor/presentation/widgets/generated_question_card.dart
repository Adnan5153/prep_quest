import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/generated_question.dart';
import '../extensions/ai_tutor_extensions.dart';

/// A single practice question card used by the Generated Questions
/// screen. Shows the prompt, options, and reveals the explanation on
/// tap. Tracks user selections in local state.
class GeneratedQuestionCard extends StatefulWidget {
  const GeneratedQuestionCard({
    super.key,
    required this.question,
  });

  final GeneratedQuestion question;

  @override
  State<GeneratedQuestionCard> createState() => _GeneratedQuestionCardState();
}

class _GeneratedQuestionCardState extends State<GeneratedQuestionCard> {
  final Set<String> _selected = <String>{};
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final GeneratedQuestion q = widget.question;
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
                Icon(Icons.quiz_outlined,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  q.difficulty.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  q.topic,
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
                  q.prompt,
                  style: theme.textTheme.titleSmall?.copyWith(height: 1.35),
                ),
                const SizedBox(height: AppSpacing.md),
                for (final GeneratedQuestionOption opt in q.options)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: _OptionTile(
                      option: opt,
                      selected: _selected.contains(opt.id),
                      revealed: _revealed,
                      isCorrect: q.correctAnswerIds.contains(opt.id),
                      onTap: () => setState(() {
                        if (q.isMultiSelect) {
                          if (_selected.contains(opt.id)) {
                            _selected.remove(opt.id);
                          } else {
                            _selected.add(opt.id);
                          }
                        } else {
                          _selected
                            ..clear()
                            ..add(opt.id);
                        }
                      }),
                    ),
                  ),
                if (_revealed) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.lightbulb_outline_rounded,
                            color: theme.colorScheme.tertiary),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            q.explanation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FilledButton.tonalIcon(
                  onPressed: () => setState(() => _revealed = !_revealed),
                  icon: Icon(
                    _revealed ? Icons.visibility_off : Icons.visibility,
                    size: 16,
                  ),
                  label: Text(_revealed ? 'Hide explanation' : 'Show answer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.selected,
    required this.revealed,
    required this.isCorrect,
    required this.onTap,
  });

  final GeneratedQuestionOption option;
  final bool selected;
  final bool revealed;
  final bool isCorrect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Color borderColor = theme.colorScheme.outlineVariant;
    Color? fill;
    if (revealed) {
      if (isCorrect) {
        borderColor = Colors.green.shade400;
        fill = Colors.green.withValues(alpha: 0.08);
      } else if (selected) {
        borderColor = theme.colorScheme.error;
        fill = theme.colorScheme.errorContainer.withValues(alpha: 0.3);
      }
    } else if (selected) {
      borderColor = theme.colorScheme.primary;
      fill = theme.colorScheme.primary.withValues(alpha: 0.08);
    }
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 18,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(option.text)),
            if (revealed && isCorrect)
              Icon(Icons.check_circle, color: Colors.green.shade600, size: 18),
          ],
        ),
      ),
    );
  }
}