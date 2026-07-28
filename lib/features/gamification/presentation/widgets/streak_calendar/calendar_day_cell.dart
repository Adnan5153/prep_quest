import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../domain/entities/streak_day.dart';
import '../../../domain/enums/streak_enums.dart';

/// Single cell in the streak calendar grid.
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
    required this.isDark,
  });

  final StreakDay day;
  final bool isDark;

  Color _backgroundFor(BuildContext context) {
    switch (day.status) {
      case StreakDayStatus.completed:
        return AppColors.success;
      case StreakDayStatus.missed:
        return AppColors.error;
      case StreakDayStatus.today:
        return AppColors.accent;
      case StreakDayStatus.future:
        return (isDark ? AppColors.darkMuted : AppColors.lightMuted)
            .withValues(alpha: 0.18);
      case StreakDayStatus.locked:
        return (isDark ? AppColors.darkMuted : AppColors.lightMuted)
            .withValues(alpha: 0.18);
    }
  }

  Color _foregroundFor(BuildContext context) {
    switch (day.status) {
      case StreakDayStatus.completed:
      case StreakDayStatus.missed:
      case StreakDayStatus.today:
        return Colors.white;
      case StreakDayStatus.future:
      case StreakDayStatus.locked:
        return isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: _backgroundFor(context),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.dayOfMonth}',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _foregroundFor(context),
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

/// Weekday header row used above the grid.
class CalendarWeekdayHeader extends StatelessWidget {
  const CalendarWeekdayHeader({super.key, required this.isDark});

  final bool isDark;

  static const List<String> _labels = <String>[
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];

  @override
  Widget build(BuildContext context) {
    final Color foreground =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    return Row(
      children: <Widget>[
        for (final String label in _labels)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: foreground.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

// Sized box helper used by the calendar grid layout.
class CalendarGridPlaceholder extends StatelessWidget {
  const CalendarGridPlaceholder({super.key, this.size = AppSizes.iconMd});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}