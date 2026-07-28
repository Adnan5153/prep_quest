import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import 'mission_badge.dart';
import 'mission_card_enums.dart';
import 'mission_card_visual.dart';
import 'mission_status_chip.dart';

class MissionMetadata extends StatelessWidget {
  const MissionMetadata({
    super.key,
    required this.visual,
    required this.isDark,
  });

  final MissionVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MissionBadge(tag: visual.tag),
        if (visual.tag != MissionCardTag.none) SizedBox(width: AppSpacing.xs),
        MissionStatusChip(visual: visual, isDark: isDark),
      ],
    );
  }
}
