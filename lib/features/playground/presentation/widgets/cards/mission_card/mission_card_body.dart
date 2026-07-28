import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import 'mission_card_visual.dart';

class MissionCardBody extends StatelessWidget {
  const MissionCardBody({
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
    return Text(
      visual.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodySmall?.copyWith(
        color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );
  }
}
