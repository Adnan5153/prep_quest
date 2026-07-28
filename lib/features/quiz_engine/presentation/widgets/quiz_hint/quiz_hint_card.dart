import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/hint_entity.dart';
import 'quiz_hint_utils.dart';

class QuizHintCard extends StatelessWidget {
  const QuizHintCard({
    super.key,
    required this.hint,
    required this.index,
  });

  final HintEntity hint;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QuizHintCardPalette palette = QuizHintUtils.cardPalette(theme, hint);
    return Container(
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.accent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '${index + 1}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: palette.foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Hint ${index + 1}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: palette.foreground,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    if (hint.isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: palette.accent,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Premium',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: palette.foreground,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  hint.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.foreground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}