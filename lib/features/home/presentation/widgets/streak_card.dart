import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Streak tile — shows current streak days + at-risk warning when
/// the user has not yet claimed today's reward.
class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.days,
    required this.atRisk,
  });

  final int days;
  final bool atRisk;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: atRisk
            ? AppColors.warning.withValues(alpha: 0.12)
            : (isDark ? AppColors.darkSurface : AppColors.lightBackground),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: atRisk
              ? AppColors.warning
              : (isDark
                  ? AppColors.darkMuted.withValues(alpha: 0.4)
                  : AppColors.lightMuted.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.local_fire_department,
            color: atRisk ? AppColors.warning : AppColors.accent,
            size: 36,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.homeStreakCardTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$days day${days == 1 ? '' : 's'}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: atRisk ? AppColors.warning : AppColors.accent,
                  ),
                ),
                if (atRisk)
                  Text(
                    'Claim today to keep the chain alive',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}