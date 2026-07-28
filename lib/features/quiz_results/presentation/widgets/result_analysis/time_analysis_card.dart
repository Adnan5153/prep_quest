import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../extensions/quiz_result_extensions.dart';
import '../../utils/quiz_results_visual_mapper.dart';

/// Card describing the time the player spent on the quiz.
class TimeAnalysisCard extends StatelessWidget {
  const TimeAnalysisCard({super.key, required this.visual});

  final TimeAnalysisVisual visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Time Analysis',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _row('Total', QuizResultFormatters.duration(visual.totalSeconds)),
          _row(
            'Average per question',
            QuizResultFormatters.duration(visual.averageSeconds),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
}
