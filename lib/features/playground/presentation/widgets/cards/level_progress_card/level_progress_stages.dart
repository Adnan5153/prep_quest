import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'level_progress_stage_dot.dart';
import 'level_progress_visual.dart';

class LevelProgressStages extends StatelessWidget {
  const LevelProgressStages({
    super.key,
    required this.visual,
    required this.isDark,
    required this.scale,
  });

  final LevelProgressVisual visual;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = visual.totalStages;
    final completed = visual.completedStages.clamp(0, total);
    final dotSize = PlaygroundSizes.cardStageDotSize * scale;
    final connectorHeight = PlaygroundSizes.cardStageConnectorHeight * scale;
    final dotSpacing = PlaygroundSizes.cardStageDotSpacing * scale;

    final children = <Widget>[];
    for (int i = 0; i < total; i++) {
      children.add(
        LevelProgressStageDot(
          size: dotSize,
          status: _statusFor(i, completed),
          isPremium: visual.isPremium,
          isDark: isDark,
        ),
      );
      if (i < total - 1) {
        children.add(SizedBox(width: dotSpacing));
        children.add(
          SizedBox(
            width: dotSpacing,
            height: connectorHeight,
            child: Container(
              decoration: BoxDecoration(
                color: _connectorColor(i, completed),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        );
        children.add(SizedBox(width: dotSpacing));
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          PlaygroundStrings.levelProgressStagesLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            fontWeight: FontWeight.w700,
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
        Expanded(
          child: Wrap(
            spacing: dotSpacing,
            runSpacing: dotSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ),
      ],
    );
  }

  LevelProgressStageStatus _statusFor(int index, int completed) {
    if (index < completed) return LevelProgressStageStatus.done;
    if (index == completed && !visual.isCompleted && !visual.isLocked) {
      return LevelProgressStageStatus.current;
    }
    return LevelProgressStageStatus.upcoming;
  }

  Color _connectorColor(int index, int completed) {
    final isDone = index < completed;
    if (isDone) {
      return visual.isCompleted
          ? PlaygroundColors.completed
          : PlaygroundColors.xp;
    }
    return isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.08);
  }
}
