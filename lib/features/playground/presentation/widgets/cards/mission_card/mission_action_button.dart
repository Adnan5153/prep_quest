import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/widget_constants.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import 'mission_constants.dart';

class MissionActionButton extends StatelessWidget {
  const MissionActionButton({
    super.key,
    required this.onClaim,
    required this.isDark,
    required this.scale,
  });

  final VoidCallback? onClaim;
  final bool isDark;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = PlaygroundColors.completed;
    return Semantics(
      button: true,
      enabled: onClaim != null,
      label: MissionCardDefaults.claimButtonSemantic,
      child: GestureDetector(
        onTap: onClaim,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: 1.0,
          duration: WidgetConstants.pressAnimationDuration,
          curve: PlaygroundCurves.stateEase,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md * scale,
              vertical: AppSpacing.xs * scale,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[accent.withValues(alpha: 0.85), accent],
              ),
              borderRadius: BorderRadius.circular(
                PlaygroundSizes.cardRewardPillRadius,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: accent.withValues(alpha: 0.40),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  AppIcons.sparkle,
                  size: PlaygroundSizes.cardRewardPillIconSize * scale,
                  color: AppColors.darkOnSurface,
                ),
                SizedBox(width: AppSpacing.xxs * scale),
                Text(
                  MissionCardDefaults.claimLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.darkOnSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
