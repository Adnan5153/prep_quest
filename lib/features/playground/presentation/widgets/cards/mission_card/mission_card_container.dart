import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'mission_card_body.dart';
import 'mission_card_footer.dart';
import 'mission_card_header.dart';
import 'mission_card_visual.dart';
import 'mission_progress.dart';
import 'mission_utils.dart';

class MissionCardContainer extends StatelessWidget {
  const MissionCardContainer({
    super.key,
    required this.visual,
    required this.isDark,
    required this.scale,
    this.onClaim,
  });

  final MissionVisual visual;
  final bool isDark;
  final double scale;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightBackground;
    final opacity = MissionOpacityResolver.forState(visual.state);

    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(
            PlaygroundSizes.cardCornerRadius * scale,
          ),
          border: Border.all(
            color: MissionBorderResolver.forCard(
              tag: visual.tag,
              isDark: isDark,
            ),
            width: PlaygroundSizes.cardBorderWidth,
          ),
          boxShadow: MissionShadowResolver.forCard(tag: visual.tag),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: PlaygroundSizes.cardPaddingHorizontal * scale,
          vertical: PlaygroundSizes.cardPaddingVertical * scale,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MissionCardHeader(visual: visual, isDark: isDark, scale: scale),
            SizedBox(height: PlaygroundSizes.cardStackGap * scale),
            MissionCardBody(visual: visual, isDark: isDark, scale: scale),
            SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
            MissionProgress(visual: visual, isDark: isDark, scale: scale),
            if (visual.hasTimer) ...<Widget>[
              SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
              _MissionTimer(visual: visual, isDark: isDark, scale: scale),
            ],
            SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
            MissionCardFooter(
              visual: visual,
              isDark: isDark,
              scale: scale,
              onClaim: onClaim,
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionTimer extends StatelessWidget {
  const _MissionTimer({
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
    final seconds = visual.timerSecondsRemaining ?? 0;
    final label = MissionProgressFormatter.format(seconds);

    return Semantics(
      label: PlaygroundStrings.missionCardTimerSemantic,
      container: true,
      child: Container(
        padding: PlaygroundSizes.cardTimerPadding,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(
            PlaygroundSizes.cardRewardPillRadius,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              AppIcons.clock,
              size: PlaygroundSizes.cardTimerIconSize * scale,
              color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            ),
            SizedBox(width: PlaygroundSizes.cardTimerGap * scale),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
                fontWeight: FontWeight.w800,
                fontSize: PlaygroundSizes.cardTimerFontSize,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
