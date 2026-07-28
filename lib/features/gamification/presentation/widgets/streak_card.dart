import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/streak_state.dart';
import '../constants/streak_strings.dart';
import 'streak_flame.dart';

/// Compact summary card that surfaces the user's streak on dashboards
/// and the profile screen.
class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.state,
    required this.isDark,
    this.onTap,
  });

  final StreakState state;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color foreground =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final bool alive = state.currentDays > 0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: alive
                  ? AppColors.accent.withValues(alpha: 0.4)
                  : foreground.withValues(alpha: 0.1),
              width: 1.0,
            ),
          ),
          child: Row(
            children: <Widget>[
              StreakFlame(isAlive: alive),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${state.currentDays} day streak',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: foreground,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    Text(
                      'Best ${state.bestDays} · ${state.shieldCharges} '
                      '${StreakStrings.shieldsLabel}',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: foreground.withValues(alpha: 0.7),
                              ),
                    ),
                  ],
                ),
              ),
              const Icon(
                AppIcons.chevronRight,
                size: AppSizes.iconMd,
                color: AppColors.lightMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}