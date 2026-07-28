import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../constants/statistics_strings.dart';
import '../../utils/statistics_visual_mapper.dart';
import '../shared/section_card.dart';

class WeakSubjectsSection extends StatelessWidget {
  const WeakSubjectsSection({super.key, required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: StatisticsStrings.weakSectionTitle,
      subtitle: 'Focus on these to boost your overall accuracy',
      icon: Icons.priority_high_rounded,
      iconColor: AppColors.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final SubjectTileVisual subject in visual.weakSubjects)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _SubjectTile(visual: subject, accent: AppColors.error),
            ),
          if (visual.recommendations.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              StatisticsStrings.weakRecommendedRevision,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final SubjectTileVisual subject in visual.recommendations)
              _RecommendationRow(visual: subject),
          ],
        ],
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({required this.visual, required this.accent});

  final SubjectTileVisual visual;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: accent.withValues(alpha: 0.4),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.book_rounded, color: accent, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        visual.subjectName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (visual.isPriority)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          StatisticsStrings.weakPriorityIndicator,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${visual.totalQuestions} questions · ${visual.accuracyPercent}% accuracy',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: visual.accuracyPercent / 100,
                    minHeight: 6,
                    backgroundColor:
                        theme.dividerColor.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
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

class _RecommendationRow extends StatelessWidget {
  const _RecommendationRow({required this.visual});

  final SubjectTileVisual visual;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (visual.weakestTopicName == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.replay_circle_filled_rounded,
            color: AppColors.warning,
            size: AppSizes.iconSm,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Revise ${visual.subjectName} · ${visual.weakestTopicName}',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (visual.weakestTopicAccuracy != null)
            Text(
              '${visual.weakestTopicAccuracy}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}