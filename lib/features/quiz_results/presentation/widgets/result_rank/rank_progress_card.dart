import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../utils/quiz_results_visual_mapper.dart';

/// Card displaying rank progress.
class RankProgressCard extends StatelessWidget {
  const RankProgressCard({super.key, required this.visual});

  final RankProgressVisual visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.workspace_premium, color: AppColors.accent),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Rank Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            visual.rank.rankAfter,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: visual.rank.progressToNextRank,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            visual.rank.isLevelUp
                ? 'Rank up! You are now ${visual.rank.rankAfter}.'
                : 'Progress to next rank',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
