import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../constants/playground_sizes.dart';
import 'mission_card_visual.dart';
import 'mission_icon.dart';
import 'mission_metadata.dart';

class MissionCardHeader extends StatelessWidget {
  const MissionCardHeader({
    super.key,
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final MissionVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        MissionIcon(visual: visual, scale: scale),
        SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                visual.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              MissionMetadata(visual: visual, isDark: isDark),
            ],
          ),
        ),
      ],
    );
  }
}
