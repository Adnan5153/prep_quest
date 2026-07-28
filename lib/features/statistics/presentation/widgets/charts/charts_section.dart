import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/statistics_strings.dart';
import '../../utils/statistics_visual_mapper.dart';
import '../charts/bar_chart_widget.dart';
import '../charts/line_chart_widget.dart';
import '../charts/progress_ring_widget.dart';
import '../shared/section_card.dart';

class ChartsSection extends StatelessWidget {
  const ChartsSection({super.key, required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: StatisticsStrings.chartsSectionTitle,
      subtitle: 'Visual summary of your learning journey',
      icon: Icons.show_chart_rounded,
      iconColor: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LineChartWidget(
            points: visual.xpGrowth,
            color: AppColors.accent,
            title: StatisticsStrings.chartLine,
            subtitle: 'XP earned by month',
          ),
          const SizedBox(height: AppSpacing.md),
          BarChartWidget(
            points: visual.weeklyActivity,
            color: AppColors.primary,
            title: StatisticsStrings.chartBar,
            subtitle: 'Weekly study minutes',
          ),
          const SizedBox(height: AppSpacing.md),
          ProgressRingWidget(
            title: StatisticsStrings.chartRing,
            subtitle: 'Streak, accuracy, weekly goal',
            centerLabel: 'Streak',
            centerValue: '${visual.study.streakDays}d',
            rings: <ProgressRingData>[
              ProgressRingData(
                label: 'Streak',
                value: (visual.study.streakDays / 30).clamp(0.0, 1.0),
                color: AppColors.error,
              ),
              ProgressRingData(
                label: 'Accuracy',
                value: visual.accuracy.overallPercent / 100,
                color: AppColors.success,
              ),
              ProgressRingData(
                label: 'Weekly Goal',
                value: (visual.study.weeklyMinutes / 600).clamp(0.0, 1.0),
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          BarChartWidget(
            points: visual.monthlyActivity,
            color: AppColors.secondary,
            title: StatisticsStrings.chartMonthly,
            subtitle: 'Total study time per month',
          ),
        ],
      ),
    );
  }
}