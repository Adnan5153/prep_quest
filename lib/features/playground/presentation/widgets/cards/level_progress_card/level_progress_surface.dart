import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';
import 'level_progress_bar.dart';
import 'level_progress_header.dart';
import 'level_progress_reward_pill.dart';
import 'level_progress_stages.dart';
import 'level_progress_stars.dart';
import 'level_progress_visual.dart';

class LevelProgressSurface extends StatelessWidget {
  const LevelProgressSurface({
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
    final fillColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightBackground;
    final borderColor = visual.isPremium
        ? PlaygroundColors.premiumChrome.withValues(alpha: 0.55)
        : isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);
    final opacity = _opacityFor();

    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(
            PlaygroundSizes.cardCornerRadius * scale,
          ),
          border: Border.all(
            color: borderColor,
            width: PlaygroundSizes.cardBorderWidth,
          ),
          boxShadow: _shadows(),
          gradient: visual.isPremium ? _premiumGradient() : null,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: PlaygroundSizes.cardPaddingHorizontal * scale,
          vertical: PlaygroundSizes.cardPaddingVertical * scale,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LevelProgressHeader(visual: visual, isDark: isDark, scale: scale),
            SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
            LevelProgressBar(visual: visual, isDark: isDark, scale: scale),
            SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
            LevelProgressStages(visual: visual, isDark: isDark, scale: scale),
            SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
            LevelProgressStars(visual: visual, isDark: isDark, scale: scale),
            if (visual.reward != null) ...<Widget>[
              SizedBox(height: PlaygroundSizes.cardInnerGap * scale),
              _RewardRow(visual: visual, isDark: isDark, scale: scale),
            ],
          ],
        ),
      ),
    );
  }

  double _opacityFor() {
    if (visual.isLocked) return PlaygroundOpacity.locked;
    if (visual.isCompleted) return PlaygroundOpacity.dimmed;
    return 1.0;
  }

  List<BoxShadow> _shadows() {
    if (visual.isPremium) {
      return <BoxShadow>[
        BoxShadow(
          color: PlaygroundColors.cardGlowAccent.withValues(alpha: 0.30),
          blurRadius: PlaygroundSizes.cardPremiumShadowBlur,
          spreadRadius: PlaygroundSizes.cardPremiumShadowSpread,
          offset: PlaygroundSizes.cardShadowOffset,
        ),
        const BoxShadow(
          color: AppColors.nodeDropShadow,
          blurRadius: PlaygroundSizes.cardShadowBlur,
          offset: PlaygroundSizes.cardShadowOffset,
        ),
      ];
    }
    return const <BoxShadow>[
      BoxShadow(
        color: AppColors.nodeDropShadow,
        blurRadius: PlaygroundSizes.cardShadowBlur,
        offset: PlaygroundSizes.cardShadowOffset,
      ),
    ];
  }

  LinearGradient _premiumGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        PlaygroundColors.cardPremiumStart,
        PlaygroundColors.cardPremiumEnd,
      ],
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({
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
    return Row(
      children: <Widget>[
        Text(
          PlaygroundStrings.levelProgressRewardLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: PlaygroundSizes.cardInnerGap * scale),
        LevelProgressRewardPill(
          reward: visual.reward!,
          isDark: isDark,
          scale: scale,
        ),
      ],
    );
  }
}
