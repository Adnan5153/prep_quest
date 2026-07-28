import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/enums/reward_enums.dart';

/// Compact pill summarising a reward value (XP, coins, …).
///
/// Surfaces on the hub, daily-reward calendar and history tile.
class RewardsHudChip extends StatelessWidget {
  const RewardsHudChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.isDark = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final bool isDark;

  Color _resolveColor(BuildContext context) {
    if (color != null) return color!;
    return isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
  }

  Color _resolveSurface(BuildContext context) {
    return isDark ? AppColors.darkSurface : AppColors.lightSurface;
  }

  @override
  Widget build(BuildContext context) {
    final Color foreground = _resolveColor(context);
    final Color surface = _resolveSurface(context);
    return Semantics(
      label: '$label: $value',
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: foreground.withValues(alpha: 0.16),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: AppSizes.iconSm, color: foreground),
            const SizedBox(width: AppSpacing.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foreground.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience factory that resolves rarity → color.
Color rewardsRarityColor(RewardRarity rarity) {
  switch (rarity) {
    case RewardRarity.common:
      return AppColors.lightMuted;
    case RewardRarity.rare:
      return AppColors.info;
    case RewardRarity.epic:
      return AppColors.accent;
    case RewardRarity.legendary:
      return AppColors.warning;
  }
}

IconData rewardsRarityIcon(RewardRarity rarity) {
  switch (rarity) {
    case RewardRarity.common:
      return AppIcons.starOutline;
    case RewardRarity.rare:
      return AppIcons.starHalf;
    case RewardRarity.epic:
      return AppIcons.star;
    case RewardRarity.legendary:
      return AppIcons.crown;
  }
}