import 'package:flutter/material.dart';

import '../../../constants/playground_sizes.dart';
import 'mission_card_enums.dart';
import 'mission_utils.dart';

class MissionBadge extends StatelessWidget {
  const MissionBadge({super.key, required this.tag});

  final MissionCardTag tag;

  @override
  Widget build(BuildContext context) {
    if (tag == MissionCardTag.none) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final fill = MissionTagPalette.fillFor(tag);
    final fg = MissionTagPalette.fgFor(tag);

    return Container(
      padding: PlaygroundSizes.cardTagPadding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(
          PlaygroundSizes.cardTagCornerRadius,
        ),
      ),
      child: Text(
        MissionTagCopy.labelFor(tag),
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: PlaygroundSizes.cardTagFontSize,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
