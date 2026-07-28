import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../constants/statistics_strings.dart';
import '../../utils/statistics_visual_mapper.dart';
import '../charts/line_chart_widget.dart';
import '../charts/pie_chart_widget.dart';
import '../shared/section_card.dart';
import '../shared/stat_tile.dart';

class AccuracyStatisticsSection extends StatelessWidget {
  const AccuracyStatisticsSection({super.key, required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: StatisticsStrings.accuracySectionTitle,
      subtitle: 'How well you are answering questions',
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  label: StatisticsStrings.accuracyOverall,
                  value: '${visual.accuracy.overallPercent}%',
                  icon: Icons.percent_rounded,
                  color: AppColors.primary,
                  subtitle:
                      '${visual.accuracy.correctCount}/${visual.accuracy.correctCount + visual.accuracy.incorrectCount + visual.accuracy.skippedCount} answered correctly',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PieChartWidget(
            slices: <PieSlice>[
              PieSlice(
                label: StatisticsStrings.correctLabel,
                value: visual.accuracy.correctRatio,
                color: AppColors.success,
              ),
              PieSlice(
                label: StatisticsStrings.wrongLabel,
                value: visual.accuracy.incorrectRatio,
                color: AppColors.error,
              ),
              PieSlice(
                label: StatisticsStrings.skippedLabel,
                value: visual.accuracy.skippedRatio,
                color: AppColors.warning,
              ),
            ],
            title: 'Correct vs Wrong Distribution',
            subtitle: 'Across all answered questions',
          ),
          const SizedBox(height: AppSpacing.md),
          LineChartWidget(
            points: visual.dailyAccuracy,
            color: AppColors.info,
            title: StatisticsStrings.accuracyDailyTrend,
            subtitle: 'Last 7 days',
            valueSuffix: '%',
          ),
          const SizedBox(height: AppSpacing.md),
          LineChartWidget(
            points: visual.weeklyAccuracy,
            color: AppColors.secondary,
            title: StatisticsStrings.accuracyWeeklyTrend,
            subtitle: 'Last 8 weeks',
            valueSuffix: '%',
          ),
          const SizedBox(height: AppSpacing.md),
          _SubjectAccuracyList(visual: visual),
        ],
      ),
    );
  }
}

class _SubjectAccuracyList extends StatelessWidget {
  const _SubjectAccuracyList({required this.visual});

  final StatisticsVisual visual;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          StatisticsStrings.accuracySubject,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final SubjectBreakdownVisual subject in visual.subjects)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: Text(
                    subject.subjectName,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: subject.accuracyPercent / 100,
                      minHeight: 8,
                      backgroundColor:
                          theme.dividerColor.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _accuracyColor(subject.accuracyPercent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 42,
                  child: Text(
                    '${subject.accuracyPercent}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _accuracyColor(int percent) {
    if (percent >= 80) return AppColors.success;
    if (percent >= 60) return AppColors.warning;
    return AppColors.error;
  }
}