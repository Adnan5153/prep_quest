import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/streak_state.dart';
import '../constants/streak_strings.dart';
import 'streak_flame.dart';

/// Compact horizontal banner — embeds in the Playground / Quiz
/// Results / Profile screens so users can claim without leaving
/// their current task.
class DailyLoginBanner extends StatelessWidget {
  const DailyLoginBanner({
    super.key,
    required this.state,
    required this.onClaim,
    this.onRecover,
  });

  final StreakState state;
  final Future<void> Function() onClaim;
  final VoidCallback? onRecover;

  bool _isClaimedToday() {
    if (state.lastClaimedAtIso.isEmpty) return false;
    final DateTime? parsed = DateTime.tryParse(state.lastClaimedAtIso);
    if (parsed == null) return false;
    final DateTime now = DateTime.now();
    return parsed.year == now.year &&
        parsed.month == now.month &&
        parsed.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final bool claimed = _isClaimedToday();
    final bool broken = state.currentDays == 0 &&
        state.lastClaimedAtIso.isNotEmpty;
    final Color background = broken
        ? AppColors.error.withValues(alpha: 0.12)
        : AppColors.accent.withValues(alpha: 0.12);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: broken ? AppColors.error : AppColors.accent,
          width: 1.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          StreakFlame(
            isAlive: state.currentDays > 0,
            color: broken ? AppColors.error : AppColors.accent,
            size: AppSizes.iconLg,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  StreakStrings.bannerTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: broken ? AppColors.error : AppColors.accent,
                      ),
                ),
                Text(
                  broken
                      ? 'Streak broken — recover now'
                      : StreakStrings.bannerSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (broken && onRecover != null)
            FilledButton.icon(
              onPressed: onRecover,
              icon: const Icon(AppIcons.shield, size: AppSizes.iconSm),
              label: const Text(StreakStrings.bannerRecoverCta),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
              ),
            )
          else
            FilledButton(
              onPressed: claimed ? null : () => onClaim(),
              style: FilledButton.styleFrom(
                backgroundColor:
                    claimed ? AppColors.success : AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
              ),
              child: Text(
                claimed
                    ? StreakStrings.bannerActionClaimed
                    : StreakStrings.bannerAction,
              ),
            ),
        ],
      ),
    );
  }
}