import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../extensions/statistics_extensions.dart';
import '../../constants/statistics_strings.dart';
import '../../utils/statistics_visual_mapper.dart';
import '../charts/bar_chart_widget.dart';
import '../charts/heatmap_widget.dart';
import '../shared/section_card.dart';
import '../shared/stat_tile.dart';

class StudyTimeSection extends StatelessWidget {
  const StudyTimeSection({super.key, required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: StatisticsStrings.studySectionTitle,
      subtitle: 'How long you are learning every day',
      icon: Icons.timer_rounded,
      iconColor: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  label: StatisticsStrings.studyToday,
                  value: StatisticsFormatters
                      .studyMinutes(visual.study.todayMinutes),
                  icon: Icons.today_rounded,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: StatTile(
                  label: StatisticsStrings.studyStreak,
                  value: '${visual.study.streakDays} days',
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.error,
                  subtitle: 'Best: ${visual.study.longestStreak} days',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  label: StatisticsStrings.studyWeek,
                  value: StatisticsFormatters
                      .studyMinutes(visual.study.weeklyMinutes),
                  icon: Icons.date_range_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: StatTile(
                  label: StatisticsStrings.studyMonth,
                  value: StatisticsFormatters
                      .studyMinutes(visual.study.monthlyMinutes),
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  label: StatisticsStrings.studyDailyAverage,
                  value: StatisticsFormatters.studyMinutes(
                    visual.study.averageDailyMinutes,
                  ),
                  icon: Icons.trending_up_rounded,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          BarChartWidget(
            points: visual.weeklyActivity,
            color: AppColors.primary,
            title: StatisticsStrings.studyWeeklyActivity,
            subtitle: 'Minutes per day (last 7 days)',
          ),
          const SizedBox(height: AppSpacing.md),
          BarChartWidget(
            points: visual.monthlyActivity,
            color: AppColors.secondary,
            title: StatisticsStrings.studyMonthlyActivity,
            subtitle: 'Minutes per month (last 12 months)',
          ),
          const SizedBox(height: AppSpacing.md),
          StudyHeatmapWidget(
            cells: visual.heatmap,
            title: StatisticsStrings.studyHeatmap,
            subtitle: 'Last 90 days',
          ),
        ],
      ),
    );
  }
}