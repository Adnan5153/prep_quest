import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../constants/mission_strings.dart';
import '../../domain/entities/mission_entity.dart';

/// Slim progress bar tuned for the missions screen.
///
/// Independent of the playground's `LevelProgressBar` so we can
/// keep the mission card's progress label and color semantics
/// localized to the gamification feature.
class MissionProgressBar extends StatelessWidget {
  const MissionProgressBar({
    super.key,
    required this.mission,
    this.height = 8.0,
    this.animateFromZero = true,
  });

  final MissionEntity mission;
  final double height;
  final bool animateFromZero;

  Color _fillColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (mission.isCompleted || mission.isClaimed) {
      return AppColors.success;
    }
    if (mission.isExpired) return AppColors.error;
    if (mission.isLocked) {
      return isDark ? AppColors.darkMuted : AppColors.lightMuted;
    }
    return AppColors.accent;
  }

  Color _trackColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.darkSurface : AppColors.lightMuted.withValues(alpha: 0.25);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double ratio = mission.ratio;
    final Color fill = _fillColor(context);
    final Color track = _trackColor(context);
    final TextStyle? labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: AppColors.lightMuted,
      fontWeight: FontWeight.w700,
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              MissionStrings.progressTemplate
                  .replaceAll('%d', '${mission.progress}')
                  .replaceFirst('%d', '${mission.goal}'),
              style: labelStyle,
            ),
            Text(
              MissionStrings.progressPercentTemplate
                  .replaceAll('%d', '${(ratio * 100).round()}'),
              style: labelStyle?.copyWith(color: fill),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Stack(
          children: <Widget>[
            Container(
              height: height,
              decoration: BoxDecoration(
                color: track,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            RepaintBoundary(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(
                  begin: animateFromZero ? 0 : ratio,
                  end: ratio,
                ),
                builder: (context, value, _) {
                  return FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            fill.withValues(alpha: 0.8),
                            fill,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
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