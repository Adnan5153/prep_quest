import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/streak_state.dart';

/// Slim progress bar showing how close the user is to the next
/// streak milestone.
class StreakProgress extends StatelessWidget {
  const StreakProgress({
    super.key,
    required this.state,
    required this.isDark,
  });

  final StreakState state;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final int milestone = state.nextMilestoneDays > 0
        ? state.nextMilestoneDays
        : 7;
    final int current =
        state.currentDays > milestone ? milestone : state.currentDays;
    final double ratio = milestone == 0 ? 0 : current / milestone;
    final Color surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color foreground =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Next milestone',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foreground.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                '$current / $milestone',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (BuildContext context, double value, Widget? child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: foreground.withValues(alpha: 0.1),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}