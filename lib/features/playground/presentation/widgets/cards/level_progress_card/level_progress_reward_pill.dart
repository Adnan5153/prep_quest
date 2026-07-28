import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_sizes.dart';
import 'level_progress_reward.dart';
import 'level_progress_utils.dart';

class LevelProgressRewardPill extends StatelessWidget {
  const LevelProgressRewardPill({
    super.key,
    required this.reward,
    required this.isDark,
    required this.scale,
  });

  final LevelProgressReward reward;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = LevelProgressRewards.colorFor(reward.kind);
    final icon = reward.icon ?? LevelProgressRewards.iconFor(reward.kind);
    final label = reward.label ?? LevelProgressRewards.labelFor(reward.kind);

    final pill = Container(
      padding: PlaygroundSizes.cardRewardPillPadding,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.18 : 0.14),
        borderRadius: BorderRadius.circular(
          PlaygroundSizes.cardRewardPillRadius,
        ),
        border: Border.all(
          color: accent.withValues(alpha: 0.45),
          width: PlaygroundSizes.cardBorderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: PlaygroundSizes.cardRewardPillIconSize * scale,
            color: accent,
          ),
          SizedBox(width: AppSpacing.xxs * scale),
          Text(
            '$label +${reward.amount}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );

    if (reward.heroTag != null) return Hero(tag: reward.heroTag!, child: pill);
    return pill;
  }
}
