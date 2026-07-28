import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/quiz_strings.dart';
import '../../utils/quiz_visual_mapper.dart';

class QuizStatsRow extends StatelessWidget {
  const QuizStatsRow({super.key, required this.visual});

  final QuizResultVisual visual;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _Stat(
          icon: Icons.check_circle,
          label: QuizStrings.correctLabel,
          value: '${visual.correctCount}/${visual.totalQuestions}',
          color: const Color(0xFF34A853),
        ),
        const SizedBox(width: AppSpacing.sm),
        _Stat(
          icon: Icons.cancel,
          label: QuizStrings.incorrectLabel,
          value: '${visual.incorrectCount}',
          color: const Color(0xFFE53935),
        ),
        const SizedBox(width: AppSpacing.sm),
        _Stat(
          icon: Icons.skip_next_outlined,
          label: QuizStrings.skippedLabel,
          value: '${visual.skippedCount}',
          color: const Color(0xFF8D6E63),
        ),
        const SizedBox(width: AppSpacing.sm),
        _Stat(
          icon: Icons.timer_outlined,
          label: QuizStrings.timeSpentLabel,
          value: '${visual.timeSpentSeconds}s',
          color: const Color(0xFF3F51B5),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: color, size: 18),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}