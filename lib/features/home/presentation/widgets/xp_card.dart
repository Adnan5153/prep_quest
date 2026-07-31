import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// XP / level tile on the home dashboard.
class XpCard extends StatelessWidget {
  const XpCard({
    super.key,
    required this.totalXp,
    required this.level,
    required this.xpInLevel,
    required this.xpForNextLevel,
  });

  final int totalXp;
  final int level;
  final int xpInLevel;
  final int xpForNextLevel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final double progress = xpForNextLevel == 0
        ? 0
        : (xpInLevel / xpForNextLevel).clamp(0.0, 1.0);

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
                AppStrings.homeXpCardTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Lv $level',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$totalXp XP',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$xpInLevel / $xpForNextLevel XP to next level',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            ),
          ),
        ],
      ),
    );
  }
}