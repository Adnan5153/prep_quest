import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_sizes.dart';
import 'mission_card_enums.dart';
import 'mission_utils.dart';

class MissionCardReward {
  const MissionCardReward({
    required this.kind,
    required this.amount,
    this.icon,
    this.label,
    this.heroTag,
  });

  final MissionCardRewardKind kind;
  final int amount;
  final IconData? icon;
  final String? label;
  final String? heroTag;

  factory MissionCardReward.xp(
    int amount, {
    IconData? icon,
    String? label,
    String? heroTag,
  }) => MissionCardReward(
    kind: MissionCardRewardKind.xp,
    amount: amount,
    icon: icon,
    label: label,
    heroTag: heroTag,
  );

  factory MissionCardReward.coin(
    int amount, {
    IconData? icon,
    String? label,
    String? heroTag,
  }) => MissionCardReward(
    kind: MissionCardRewardKind.coin,
    amount: amount,
    icon: icon,
    label: label,
    heroTag: heroTag,
  );

  factory MissionCardReward.gem(
    int amount, {
    IconData? icon,
    String? label,
    String? heroTag,
  }) => MissionCardReward(
    kind: MissionCardRewardKind.gem,
    amount: amount,
    icon: icon,
    label: label,
    heroTag: heroTag,
  );

  factory MissionCardReward.badge(
    int amount, {
    IconData? icon,
    String? label,
    String? heroTag,
  }) => MissionCardReward(
    kind: MissionCardRewardKind.badge,
    amount: amount,
    icon: icon,
    label: label,
    heroTag: heroTag,
  );
}

class MissionRewardPill extends StatelessWidget {
  const MissionRewardPill({
    super.key,
    required this.reward,
    required this.isDark,
    required this.scale,
  });

  final MissionCardReward reward;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = MissionRewardPalette.colorFor(reward.kind);
    final icon = reward.icon ?? MissionRewardPalette.iconFor(reward.kind);
    final label = reward.label ?? MissionRewardPalette.labelFor(reward.kind);
    final semantic = MissionRewardPalette.semanticFor(reward.kind);

    final pill = Semantics(
      label: semantic,
      child: Container(
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
      ),
    );

    if (reward.heroTag != null) {
      return Hero(tag: reward.heroTag!, child: pill);
    }
    return pill;
  }
}
