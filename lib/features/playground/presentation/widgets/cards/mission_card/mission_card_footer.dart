import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'mission_action_button.dart';
import 'mission_card_visual.dart';
import 'mission_reward.dart';

class MissionCardFooter extends StatelessWidget {
  const MissionCardFooter({
    super.key,
    required this.visual,
    required this.isDark,
    required this.scale,
    this.onClaim,
  });

  final MissionVisual visual;
  final bool isDark;
  final double scale;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          PlaygroundStrings.missionCardRewardLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: MissionRewardPill(
              reward: visual.reward,
              isDark: isDark,
              scale: scale,
            ),
          ),
        ),
        if (visual.isCompleted && onClaim != null)
          MissionActionButton(onClaim: onClaim, isDark: isDark, scale: scale),
      ],
    );
  }
}
