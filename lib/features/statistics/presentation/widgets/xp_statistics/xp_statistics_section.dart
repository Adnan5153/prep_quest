import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../gamification/domain/entities/level_progress.dart';
import '../../extensions/statistics_extensions.dart';
import '../../constants/statistics_strings.dart';
import '../../utils/statistics_visual_mapper.dart';
import '../charts/line_chart_widget.dart';
import '../shared/section_card.dart';
import '../shared/stat_tile.dart';

class XpStatisticsSection extends StatelessWidget {
  const XpStatisticsSection({super.key, required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: StatisticsStrings.xpSectionTitle,
      subtitle: 'Track how experience points grow over time',
      icon: Icons.bolt_rounded,
      iconColor: AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _XpSummaryTiles(visual: visual),
          const SizedBox(height: AppSpacing.md),
          LineChartWidget(
            points: visual.xpGrowth,
            color: AppColors.accent,
            title: StatisticsStrings.xpGrowthChart,
            subtitle: 'Last 12 months',
          ),
          const SizedBox(height: AppSpacing.md),
          _LevelProgressBar(visual: visual),
        ],
      ),
    );
  }
}

class _XpSummaryTiles extends StatelessWidget {
  const _XpSummaryTiles({required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: StatTile(
                label: StatisticsStrings.xpTotal,
                value: StatisticsFormatters.xp(visual.totalXp),
                icon: Icons.workspace_premium_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: StatTile(
                label: StatisticsStrings.xpToday,
                value: StatisticsFormatters.xp(visual.todayXp),
                icon: Icons.today_rounded,
                color: AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            Expanded(
              child: StatTile(
                label: StatisticsStrings.xpWeekly,
                value: StatisticsFormatters.xp(visual.weeklyXp),
                icon: Icons.date_range_rounded,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: StatTile(
                label: StatisticsStrings.xpMonthly,
                value: StatisticsFormatters.xp(visual.monthlyXp),
                icon: Icons.calendar_month_rounded,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LevelProgressBar extends StatelessWidget {
  const _LevelProgressBar({required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LevelProgress progress = LevelProgress(
      currentLevel: visual.levelProgress.level,
      currentXP: visual.levelProgress.currentXp,
      nextLevelXP: visual.levelProgress.requiredXp,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${StatisticsStrings.xpLevel} ${visual.levelProgress.level}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${visual.levelProgress.currentXp} / ${visual.levelProgress.requiredXp} XP',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: visual.levelProgress.ratio,
            minHeight: 12,
            backgroundColor: theme.dividerColor.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${progress.xpToNext} ${StatisticsStrings.xpToNext}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}