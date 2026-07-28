import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/quiz_strings.dart';
import '../../utils/quiz_visual_mapper.dart';

class QuizRewardCard extends StatelessWidget {
  const QuizRewardCard({super.key, required this.visual});

  final QuizResultVisual visual;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.bolt, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${QuizStrings.xpRewardLabel}: +${visual.rewardXp}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Icon(Icons.savings_outlined, color: theme.colorScheme.tertiary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${QuizStrings.coinRewardLabel}: +${visual.rewardCoins}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}