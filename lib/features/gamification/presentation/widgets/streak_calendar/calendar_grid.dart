import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/streak_day.dart';
import '../../../domain/enums/streak_enums.dart';
import '../../constants/streak_strings.dart';
import 'calendar_day_cell.dart';

/// 30-day streak calendar grid — six rows of seven cells, including a
/// leading offset for the first weekday of the window.
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.days,
    required this.isDark,
  });

  final List<StreakDay> days;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final DateTime firstDate = days.isEmpty
        ? DateTime.now()
        : days.first.date;
    final int leadingOffset = (firstDate.weekday - 1) % 7;
    final List<Widget> cells = <Widget>[];
    for (int i = 0; i < leadingOffset; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (final StreakDay d in days) {
      cells.add(CalendarDayCell(day: d, isDark: isDark));
    }
    final Color surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CalendarWeekdayHeader(isDark: isDark),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: cells,
          ),
          const SizedBox(height: AppSpacing.md),
          _Legend(isDark: isDark),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color foreground =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        _LegendDot(label: StreakStrings.calendarLegendCompleted,
            color: AppColors.success, foreground: foreground),
        _LegendDot(label: StreakStrings.calendarLegendMissed,
            color: AppColors.error, foreground: foreground),
        _LegendDot(label: StreakStrings.calendarLegendToday,
            color: AppColors.accent, foreground: foreground),
        _LegendDot(label: StreakStrings.calendarLegendFuture,
            color: AppColors.lightMuted, foreground: foreground),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.label,
    required this.color,
    required this.foreground,
  });

  final String label;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground.withValues(alpha: 0.8),
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

// Re-export so screens don't need their own copies.
typedef CalendarDayStatus = StreakDayStatus;