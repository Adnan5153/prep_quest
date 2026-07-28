import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/enums/streak_enums.dart';
import '../constants/streak_strings.dart';

/// A single bonus tile from the streak-bonus ledger.
class StreakBonus extends StatelessWidget {
  const StreakBonus({
    super.key,
    required this.bonus,
    required this.unlocked,
    required this.isDark,
    this.onClaim,
  });

  final StreakEntity bonus;
  final bool unlocked;
  final bool isDark;
  final VoidCallback? onClaim;

  Color get _accent {
    switch (bonus.type) {
      case StreakBonusType.daily:
        return AppColors.info;
      case StreakBonusType.weekly:
        return AppColors.accent;
      case StreakBonusType.milestone:
        return AppColors.warning;
    }
  }

  String get _typeLabel {
    switch (bonus.type) {
      case StreakBonusType.daily:
        return StreakStrings.bonusDailyTag;
      case StreakBonusType.weekly:
        return StreakStrings.bonusWeeklyTag;
      case StreakBonusType.milestone:
        return StreakStrings.bonusMilestoneTag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color foreground =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: unlocked
              ? _accent.withValues(alpha: 0.5)
              : foreground.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  _typeLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _accent,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              const Spacer(),
              Icon(
                bonus.claimed
                    ? AppIcons.checkCircle
                    : (unlocked ? AppIcons.star : AppIcons.locked),
                size: AppSizes.iconSm,
                color: bonus.claimed
                    ? AppColors.success
                    : (unlocked ? _accent : AppColors.lightMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            StreakStrings.bonusDayTemplate.replaceAll('%d', '${bonus.day}'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            StreakStrings.bonusRewardTemplate
                .replaceAll('%d', '${bonus.xp}')
                .replaceAll('%d', '${bonus.coins}'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: foreground.withValues(alpha: 0.75),
                ),
          ),
          if (bonus.badgeId != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: <Widget>[
                const Icon(
                  AppIcons.badgeStar,
                  size: AppSizes.iconSm,
                  color: AppColors.accent,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  bonus.badgeId!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _accent,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ],
          if (onClaim != null && unlocked && !bonus.claimed) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            _ClaimButton(onPressed: onClaim!, accent: _accent),
          ],
          if (bonus.claimed) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(
              StreakStrings.bonusClaimedLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
          if (!unlocked && !bonus.claimed) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(
              StreakStrings.bonusLockedLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.lightMuted,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({required this.onPressed, required this.accent});

  final VoidCallback onPressed;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: const Text('Claim'),
      ),
    );
  }
}