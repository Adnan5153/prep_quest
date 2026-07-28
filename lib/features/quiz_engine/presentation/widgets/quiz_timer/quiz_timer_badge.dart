import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../providers/quiz_timer_provider.dart';
import 'quiz_timer_utils.dart';

/// Circular badge variant of [QuizTimer]. Used on the AppBar of the
/// active quiz screen.
class QuizTimerBadge extends StatelessWidget {
  const QuizTimerBadge({super.key, required this.snapshot});

  final QuizTimerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QuizTimerPalette palette = QuizTimerUtils.paletteFor(theme, snapshot);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: palette.background,
        shape: BoxShape.circle,
        border: Border.all(color: palette.border, width: 2),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(palette.icon, color: palette.foreground, size: 12),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            snapshot.formatted,
            style: theme.textTheme.labelSmall?.copyWith(
              color: palette.foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}