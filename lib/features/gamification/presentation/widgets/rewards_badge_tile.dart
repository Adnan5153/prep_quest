import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/badge_entry.dart';
import '../constants/rewards_strings.dart';
import 'rewards_hud_chip.dart';

/// Tile for a single badge in the collection grid.
class RewardsBadgeTile extends StatelessWidget {
  const RewardsBadgeTile({
    super.key,
    required this.badge,
    required this.isDark,
    this.onFavoriteToggle,
  });

  final BadgeEntry badge;
  final bool isDark;
  final VoidCallback? onFavoriteToggle;

  Color get _foreground =>
      isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

  Color get _muted => isDark ? AppColors.darkMuted : AppColors.lightMuted;

  @override
  Widget build(BuildContext context) {
    final Color rarityColor = rewardsRarityColor(badge.rarity);
    return Semantics(
      label: '${badge.title}, ${badge.isFavorite ? 'favorite' : ''}',
      container: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: rarityColor.withValues(alpha: 0.4),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: rarityColor.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    rewardsRarityIcon(badge.rarity),
                    color: rarityColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    badge.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _foreground,
                          fontWeight: FontWeight.w800,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onFavoriteToggle != null)
                  IconButton(
                    iconSize: AppSizes.iconSm,
                    visualDensity: VisualDensity.compact,
                    tooltip: badge.isFavorite
                        ? RewardsStrings.badgesFavoriteRemove
                        : RewardsStrings.badgesFavoriteAdd,
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      badge.isFavorite
                          ? AppIcons.bookmarkFilled
                          : AppIcons.bookmark,
                      color: badge.isFavorite
                          ? AppColors.accent
                          : _muted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              badge.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _muted,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            RewardsHudChip(
              label: badge.isFavorite
                  ? RewardsStrings.badgesFilterFavorites
                  : RewardsStrings.badgesUnlocked,
              value: rarityColor.toARGB32().toString().padLeft(3, '0'),
              icon: AppIcons.badgeStar,
              color: rarityColor,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}