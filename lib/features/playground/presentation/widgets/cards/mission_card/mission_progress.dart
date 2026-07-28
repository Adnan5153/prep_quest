import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'mission_card_visual.dart';
import 'mission_utils.dart';

class MissionProgress extends StatelessWidget {
  const MissionProgress({
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
    final trackColor = MissionProgressPalette.trackFor(isDark: isDark);
    final fillColor = MissionProgressPalette.fillFor(
      isCompleted: visual.isCompleted,
      tag: visual.tag,
    );
    final value = visual.isCompleted ? 1.0 : visual.completion;
    final height = PlaygroundSizes.cardProgressHeight * scale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${PlaygroundStrings.missionCardProgressLabel} ${visual.progress.clamp(0, visual.required)} / ${visual.required}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                fontWeight: FontWeight.w700,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: fillColor,
                fontWeight: FontWeight.w800,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Stack(
          children: <Widget>[
            Container(
              height: height,
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            RepaintBoundary(
              child: TweenAnimationBuilder<double>(
                duration: PlaygroundDurations.cardProgress,
                curve: PlaygroundCurves.stateEase,
                tween: Tween<double>(begin: 0, end: value),
                builder: (context, animatedValue, _) {
                  return FractionallySizedBox(
                    widthFactor: animatedValue,
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            fillColor.withValues(alpha: 0.85),
                            fillColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: fillColor.withValues(alpha: 0.45),
                            blurRadius: PlaygroundSizes.cardProgressGlowBlur,
                            spreadRadius:
                                PlaygroundSizes.cardProgressGlowSpread,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
