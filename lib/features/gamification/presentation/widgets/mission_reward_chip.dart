import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';
import '../../domain/entities/mission_reward_entity.dart';

/// Compact pill summarising the rewards promised by a mission.
class MissionRewardChip extends StatelessWidget {
  const MissionRewardChip({
    super.key,
    required this.reward,
    this.isDark = false,
  });

  final MissionRewardEntity reward;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color foreground =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final List<Widget> children = <Widget>[];

    if (reward.xp > 0) {
      children.add(_pill(
        context,
        icon: AppIcons.xp,
        color: AppColors.accent,
        text: MissionStrings.rewardXpTemplate.replaceAll('%d', '${reward.xp}'),
        foreground: foreground,
      ));
    }
    if (reward.coins > 0) {
      children.add(_pill(
        context,
        icon: AppIcons.coinIcon,
        color: AppColors.warning,
        text: MissionStrings.rewardCoinTemplate
            .replaceAll('%d', '${reward.coins}'),
        foreground: foreground,
      ));
    }
    if (reward.energy > 0) {
      children.add(_pill(
        context,
        icon: AppIcons.xp,
        color: AppColors.info,
        text: MissionStrings.rewardEnergyTemplate
            .replaceAll('%d', '${reward.energy}'),
        foreground: foreground,
      ));
    }
    if (reward.hasBadge) {
      children.add(_pill(
        context,
        icon: AppIcons.badgeStar,
        color: AppColors.secondary,
        text: MissionStrings.rewardBadgeLabel,
        foreground: foreground,
      ));
    }
    if (reward.hasChest) {
      children.add(_pill(
        context,
        icon: AppIcons.gem,
        color: AppColors.warning,
        text: MissionStrings.rewardChestLabel,
        foreground: foreground,
      ));
    }

    if (children.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: children);
  }

  Widget _pill(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String text,
    required Color foreground,
  }) {
    return Semantics(
      label: text,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.18 : 0.14),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: color.withValues(alpha: 0.45),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}