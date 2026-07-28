import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/reward.dart';
import '../../domain/entities/user_rewards_state.dart';
import '../../domain/enums/reward_enums.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../../domain/services/system_streak_resolver.dart';
import '../constants/rewards_strings.dart';

/// 7-day calendar tile grid.
class DailyRewardCalendar extends StatelessWidget {
  const DailyRewardCalendar({
    super.key,
    required this.templates,
    required this.state,
    required this.onClaim,
    required this.isDark,
  });

  final List<DailyRewardTemplate> templates;
  final UserRewardsState state;
  final ValueChanged<int> onClaim;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double tileSize = (constraints.maxWidth - AppSpacing.md * 6) / 7;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: <Widget>[
            for (final DailyRewardTemplate template in templates)
              _DayTile(
                template: template,
                tileSize: tileSize,
                state: state,
                onClaim: onClaim,
                isDark: isDark,
              ),
          ],
        );
      },
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    required this.template,
    required this.tileSize,
    required this.state,
    required this.onClaim,
    required this.isDark,
  });

  final DailyRewardTemplate template;
  final double tileSize;
  final UserRewardsState state;
  final ValueChanged<int> onClaim;
  final bool isDark;

  static const SystemStreakResolver _resolver = SystemStreakResolver();

  @override
  Widget build(BuildContext context) {
    final DailyRewardStatus status = _resolveStatus();
    final Color color = _statusColor(status);
    return Semantics(
      label: 'Day ${template.day}, ${_statusLabel(status)}, ${template.xp} XP, ${template.coins} coins',
      button: status == DailyRewardStatus.claimable,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: status == DailyRewardStatus.claimable
            ? () => onClaim(template.day)
            : null,
        child: Container(
          width: tileSize,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: color.withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconFor(status),
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Day ${template.day}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    AppIcons.xp,
                    size: 12,
                    color: color,
                  ),
                  Text(
                    '+${template.xp}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    AppIcons.coinIcon,
                    size: 12,
                    color: color,
                  ),
                  Text(
                    '+${template.coins}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              if (template.badgeIconKey != null) ...<Widget>[
                const SizedBox(height: AppSpacing.xxs),
                Icon(
                  AppIcons.badgeStar,
                  size: 14,
                  color: color,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  DailyRewardStatus _resolveStatus() {
    final DateTime now = DateTime.now();
    if (_resolver.isToday(state.streak.lastClaimedAtIso, now: now)) {
      if (state.streak.currentDays >= template.day) {
        return DailyRewardStatus.claimed;
      }
      return DailyRewardStatus.claimed;
    }
    if (state.streak.currentDays >= template.day) {
      return DailyRewardStatus.claimed;
    }
    if (template.day == state.streak.currentDays + 1) {
      return DailyRewardStatus.claimable;
    }
    if (template.day <= state.streak.currentDays) {
      return DailyRewardStatus.claimed;
    }
    if (_resolver.isMissed(
      lastClaimedIso: state.streak.lastClaimedAtIso,
      now: now,
    )) {
      return DailyRewardStatus.missed;
    }
    return DailyRewardStatus.future;
  }

  String _statusLabel(DailyRewardStatus status) {
    switch (status) {
      case DailyRewardStatus.claimed:
        return RewardsStrings.dailyClaimedToday;
      case DailyRewardStatus.claimable:
        return RewardsStrings.dailyClaimable;
      case DailyRewardStatus.future:
        return RewardsStrings.dailyFuture;
      case DailyRewardStatus.missed:
        return RewardsStrings.dailyMissed;
    }
  }

  IconData _iconFor(DailyRewardStatus status) {
    switch (status) {
      case DailyRewardStatus.claimed:
        return AppIcons.checkCircle;
      case DailyRewardStatus.claimable:
        return AppIcons.calendar;
      case DailyRewardStatus.future:
        return AppIcons.lockFilled;
      case DailyRewardStatus.missed:
        return AppIcons.close;
    }
  }

  Color _statusColor(DailyRewardStatus status) {
    switch (status) {
      case DailyRewardStatus.claimed:
        return AppColors.success;
      case DailyRewardStatus.claimable:
        return AppColors.accent;
      case DailyRewardStatus.future:
        return _muted;
      case DailyRewardStatus.missed:
        return AppColors.error;
    }
  }

  Color get _muted =>
      isDark ? AppColors.darkMuted : AppColors.lightMuted;
}

/// Surfaces a daily-reward day's reward as a [Reward]-like data
/// carrier for downstream components (popup, history).
Reward dailyRewardAsReward(DailyRewardTemplate template) {
  return DailyRewardEntry(
    id: 'daily-${template.day}',
    title: template.title ?? 'Day ${template.day}',
    rarity: template.day >= 6 ? RewardRarity.epic : RewardRarity.common,
    day: template.day,
    xp: template.xp,
    coins: template.coins,
    badgeIconKey: template.badgeIconKey,
  );
}