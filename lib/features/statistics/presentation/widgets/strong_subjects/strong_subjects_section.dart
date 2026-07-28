import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../domain/entities/subject_statistics_entity.dart';
import '../../constants/statistics_strings.dart';
import '../../utils/statistics_visual_mapper.dart';
import '../shared/section_card.dart';

class StrongSubjectsSection extends StatelessWidget {
  const StrongSubjectsSection({super.key, required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: StatisticsStrings.strongSectionTitle,
      subtitle: 'Subjects where you are performing at your best',
      icon: Icons.emoji_events_rounded,
      iconColor: AppColors.success,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final SubjectTileVisual subject in visual.strongSubjects)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _StrongSubjectTile(visual: subject),
            ),
        ],
      ),
    );
  }
}

class _StrongSubjectTile extends StatelessWidget {
  const _StrongSubjectTile({required this.visual});

  final SubjectTileVisual visual;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: AppColors.success.withValues(alpha: 0.4),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              _masteryIcon(visual.mastery),
              color: AppColors.success,
              size: 24,
            ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        _masteryLabel(visual.mastery),
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
                  '${visual.totalQuestions} questions · ${visual.accuracyPercent}% accuracy · ${visual.xpEarned} XP',
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
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (visual.achievementBadgeId != null) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.accent,
              size: AppSizes.iconMd,
              semanticLabel: StatisticsStrings.strongAchievement,
            ),
          ],
        ],
      ),
    );
  }

  IconData _masteryIcon(SubjectMastery mastery) {
    switch (mastery) {
      case SubjectMastery.mastered:
        return Icons.workspace_premium_rounded;
      case SubjectMastery.confident:
        return Icons.star_rounded;
      case SubjectMastery.learning:
        return Icons.school_rounded;
      case SubjectMastery.novice:
        return Icons.menu_book_rounded;
    }
  }

  String _masteryLabel(SubjectMastery mastery) {
    switch (mastery) {
      case SubjectMastery.mastered:
        return 'Mastered';
      case SubjectMastery.confident:
        return 'Confident';
      case SubjectMastery.learning:
        return 'Learning';
      case SubjectMastery.novice:
        return 'Novice';
    }
  }
}