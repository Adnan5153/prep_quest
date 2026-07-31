import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../gamification/presentation/providers/mission_provider.dart';

/// Daily-mission summary tile on the home dashboard. Shows the count
/// of missions completed today and surfaces the top mission so the
/// user can pick up where they left off.
class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({super.key, required this.missions});

  final MissionsViewState missions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final int total = missions.daily.length;
    final int done = missions.daily.where((m) => m.isCompleted).length;
    final double progress = total == 0 ? 0 : (done / total).clamp(0.0, 1.0);

    final String? topTitle = missions.daily.isEmpty
        ? null
        : missions.daily.first.title;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkMuted.withValues(alpha: 0.4)
              : AppColors.lightMuted.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppStrings.homeDailyGoalTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$done / $total',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.info.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
            ),
          ),
          if (topTitle != null) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              topTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}