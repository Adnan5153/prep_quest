import 'package:flutter/material.dart';

import '../../../constants/playground_sizes.dart';
import 'mission_card_visual.dart';
import 'mission_utils.dart';

class MissionStatusChip extends StatelessWidget {
  const MissionStatusChip({
    super.key,
    required this.visual,
    required this.isDark,
  });

  final MissionVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = MissionStatePalette.colorFor(visual.state, isDark: isDark);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          MissionStateIcons.iconFor(visual.state),
          size: PlaygroundSizes.cardTagIconSize,
          color: fg,
        ),
        const SizedBox(width: 4),
        Text(
          MissionStateCopy.labelFor(visual.state),
          style: theme.textTheme.labelSmall?.copyWith(
            color: fg,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
