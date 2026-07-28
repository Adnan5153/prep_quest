import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/streak_state.dart';
import '../constants/streak_strings.dart';
import 'streak_flame.dart';

/// Big animated "current streak" counter with the flame icon.
class StreakCounter extends StatelessWidget {
  const StreakCounter({
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
    final Color foreground =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final Color surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final bool claimedToday = state.lastClaimedAtIso.isNotEmpty &&
        _isToday(state.lastClaimedAtIso);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.4),
              width: 1.0,
            ),
          ),
          child: Row(
            children: <Widget>[
              StreakFlame(
                isAlive: state.currentDays > 0,
                color: state.currentDays > 0
                    ? AppColors.error
                    : AppColors.lightMuted,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StreakStrings.currentStreakLabel,
                      style:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: foreground.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _AnimatedDays(
                      days: state.currentDays,
                      style:
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: foreground,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${StreakStrings.bestStreakLabel}: ${state.bestDays}',
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: foreground.withValues(alpha: 0.7),
                              ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                isClaimed: claimedToday,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isToday(String iso) {
    final DateTime? parsed = DateTime.tryParse(iso);
    if (parsed == null) return false;
    final DateTime now = DateTime.now();
    return parsed.year == now.year &&
        parsed.month == now.month &&
        parsed.day == now.day;
  }
}

class _AnimatedDays extends StatelessWidget {
  const _AnimatedDays({required this.days, required this.style});

  final int days;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: days.toDouble()),
      duration: const Duration(milliseconds: 600),
      builder: (BuildContext context, double value, Widget? child) {
        return Text(
          value.toInt().toString(),
          style: style,
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isClaimed, required this.isDark});

  final bool isClaimed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color background =
        isClaimed ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        isClaimed
            ? StreakStrings.todayStatusClaimed
            : StreakStrings.todayStatusPending,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: background,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}