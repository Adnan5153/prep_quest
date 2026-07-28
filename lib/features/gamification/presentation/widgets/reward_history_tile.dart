import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/reward_history_entry.dart';
import '../constants/rewards_strings.dart';
import 'rewards_hud_chip.dart';

/// Single row in the reward history list.
class RewardHistoryTile extends StatelessWidget {
  const RewardHistoryTile({
    super.key,
    required this.entry,
    required this.isDark,
  });

  final RewardHistoryEntry entry;
  final bool isDark;

  Color get _foreground =>
      isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

  Color get _muted => isDark ? AppColors.darkMuted : AppColors.lightMuted;

  @override
  Widget build(BuildContext context) {
    final int xpTotal = entry.xpTotal;
    final int coinTotal = entry.coinsTotal;
    final DateTime? grantedAt = DateTime.tryParse(entry.grantedAtIso);
    final String dateLabel = grantedAt == null
        ? ''
        : '${grantedAt.year.toString().padLeft(4, '0')}-'
            '${grantedAt.month.toString().padLeft(2, '0')}-'
            '${grantedAt.day.toString().padLeft(2, '0')}';
    return Semantics(
      label:
          '${entry.sourceLabel}, $dateLabel, ${xpTotal > 0 ? '+$xpTotal XP' : ''} ${coinTotal > 0 ? '+$coinTotal coins' : ''}',
      container: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _muted.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconForSource(entry.sourceLabel),
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    entry.sourceLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _foreground,
                          fontWeight: FontWeight.w800,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (dateLabel.isNotEmpty)
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _muted,
                          ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            if (xpTotal > 0)
              RewardsHudChip(
                label: RewardsStrings.xpLabel,
                value: '+$xpTotal',
                icon: AppIcons.xp,
                color: AppColors.accent,
                isDark: isDark,
              ),
            if (xpTotal > 0 && coinTotal > 0)
              const SizedBox(width: AppSpacing.xs),
            if (coinTotal > 0)
              RewardsHudChip(
                label: RewardsStrings.coinsLabel,
                value: '+$coinTotal',
                icon: AppIcons.coinIcon,
                color: AppColors.warning,
                isDark: isDark,
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconForSource(String source) {
    final String lower = source.toLowerCase();
    if (lower.contains('quiz')) return AppIcons.target;
    if (lower.contains('lesson')) return AppIcons.book;
    if (lower.contains('mission')) return AppIcons.mission;
    if (lower.contains('daily')) return AppIcons.calendar;
    if (lower.contains('chest')) return AppIcons.gem;
    if (lower.contains('badge')) return AppIcons.badgeStar;
    if (lower.contains('level')) return AppIcons.trophy;
    return AppIcons.sparkle;
  }
}