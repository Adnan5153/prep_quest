import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';
import '../../domain/enums/mission_enums.dart';
import '../providers/mission_provider.dart';

/// Top-of-screen summary card showing the user's progress across
/// every cadence.
class MissionStatisticsCard extends StatelessWidget {
  const MissionStatisticsCard({
    super.key,
    required this.state,
    this.isDark = false,
  });

  final MissionsViewState state;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            MissionStrings.statsTotalTemplate
                .replaceAll('%d', '${state.completedCount}')
                .replaceFirst('%d', '${state.totalCount}'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _CadenceProgress(
            cadence: MissionCadence.daily,
            completed: state.dailyCompleted,
            total: state.daily.length,
          ),
          const SizedBox(height: AppSpacing.xs),
          _CadenceProgress(
            cadence: MissionCadence.weekly,
            completed: state.weeklyCompleted,
            total: state.weekly.length,
          ),
          const SizedBox(height: AppSpacing.xs),
          _CadenceProgress(
            cadence: MissionCadence.monthly,
            completed: state.monthlyCompleted,
            total: state.monthly.length,
          ),
        ],
      ),
    );
  }
}

class _CadenceProgress extends StatelessWidget {
  const _CadenceProgress({
    required this.cadence,
    required this.completed,
    required this.total,
  });

  final MissionCadence cadence;
  final int completed;
  final int total;

  String _label() {
    switch (cadence) {
      case MissionCadence.daily:
        return MissionStrings.statsDailyTemplate;
      case MissionCadence.weekly:
        return MissionStrings.statsWeeklyTemplate;
      case MissionCadence.monthly:
        return MissionStrings.statsMonthlyTemplate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double ratio = total <= 0 ? 0 : (completed / total).clamp(0.0, 1.0);
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _label().replaceAll('%d', '$completed').replaceFirst(
                      '%d',
                      '$total',
                    ),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 4,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '${(ratio * 100).round()}%',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}