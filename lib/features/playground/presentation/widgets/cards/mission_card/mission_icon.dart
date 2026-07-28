import 'package:flutter/material.dart';

import '../../../constants/playground_sizes.dart';
import 'mission_card_visual.dart';
import 'mission_utils.dart';

class MissionIcon extends StatelessWidget {
  const MissionIcon({super.key, required this.visual, required this.scale});

  final MissionVisual visual;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final size = PlaygroundSizes.cardIconSize * scale;
    final fill = MissionIconPalette.fillFor(
      tag: visual.tag,
      state: visual.state,
      isDark: true,
    );
    final fg = MissionIconPalette.fgFor(tag: visual.tag, state: visual.state);
    final icon = MissionIconPalette.iconFor(visual);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: fg.withValues(alpha: 0.30),
          width: PlaygroundSizes.cardBorderWidth,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.55, color: fg),
    );
  }
}
