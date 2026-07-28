import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../providers/quiz_timer_provider.dart';
import 'quiz_timer_utils.dart';

/// Compact countdown timer for the active quiz screen.
class QuizTimer extends StatelessWidget {
  const QuizTimer({super.key, required this.snapshot, this.compact = false});

  final QuizTimerSnapshot snapshot;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QuizTimerPalette palette = QuizTimerUtils.paletteFor(theme, snapshot);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.md : AppSpacing.lg,
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(palette.icon, color: palette.foreground, size: 18),
          const SizedBox(width: AppSpacing.xs),
          Text(
            snapshot.formatted,
            style: theme.textTheme.titleMedium?.copyWith(
              color: palette.foreground,
              fontWeight: FontWeight.w800,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}