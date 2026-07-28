import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/quiz_strings.dart';
import '../../utils/quiz_visual_mapper.dart';
import 'quiz_reward_card.dart';
import 'quiz_stats_row.dart';

class QuizScoreCard extends StatelessWidget {
  const QuizScoreCard({super.key, required this.visual});

  final QuizResultVisual visual;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: visual.passed
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                visual.passed ? Icons.celebration : Icons.refresh,
                color: visual.passed
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                visual.passed
                    ? QuizStrings.passedLabel
                    : QuizStrings.failedLabel,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: visual.passed
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${visual.scorePercent}%',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: visual.passed
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          QuizStatsRow(visual: visual),
          const SizedBox(height: AppSpacing.md),
          QuizRewardCard(visual: visual),
        ],
      ),
    );
  }
}