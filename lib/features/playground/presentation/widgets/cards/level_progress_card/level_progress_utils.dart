import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_icons.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_strings.dart';
import 'level_progress_enums.dart';

class LevelProgressShadows {
  const LevelProgressShadows._();

  static List<BoxShadow> forCard({
    required bool premium,
    required Offset offset,
    required double blur,
  }) {
    if (premium) {
      return <BoxShadow>[
        BoxShadow(
          color: PlaygroundColors.cardGlowAccent.withValues(alpha: 0.30),
          blurRadius: 22,
          spreadRadius: 1,
          offset: offset,
        ),
        BoxShadow(
          color: const Color(0x14000000),
          blurRadius: blur,
          offset: offset,
        ),
      ];
    }
    return <BoxShadow>[
      BoxShadow(
        color: const Color(0x14000000),
        blurRadius: blur,
        offset: offset,
      ),
    ];
  }
}

class LevelProgressRewards {
  const LevelProgressRewards._();

  static IconData iconFor(LevelProgressRewardKind kind) {
    switch (kind) {
      case LevelProgressRewardKind.xp:
        return AppIcons.xp;
      case LevelProgressRewardKind.coin:
        return AppIcons.coinIcon;
      case LevelProgressRewardKind.gem:
        return AppIcons.gem;
      case LevelProgressRewardKind.badge:
        return AppIcons.badgeStar;
    }
  }

  static String labelFor(LevelProgressRewardKind kind) {
    switch (kind) {
      case LevelProgressRewardKind.xp:
        return PlaygroundStrings.xpLabel;
      case LevelProgressRewardKind.coin:
        return PlaygroundStrings.coinLabel;
      case LevelProgressRewardKind.gem:
        return 'Gems';
      case LevelProgressRewardKind.badge:
        return 'Badge';
    }
  }

  static Color colorFor(LevelProgressRewardKind kind) {
    switch (kind) {
      case LevelProgressRewardKind.xp:
        return PlaygroundColors.xp;
      case LevelProgressRewardKind.coin:
        return PlaygroundColors.coin;
      case LevelProgressRewardKind.gem:
        return PlaygroundColors.gems;
      case LevelProgressRewardKind.badge:
        return PlaygroundColors.premiumChrome;
    }
  }
}

class LevelProgressSemanticResolver {
  const LevelProgressSemanticResolver._();

  static String labelFor(LevelCardState state) {
    switch (state) {
      case LevelCardState.completed:
        return PlaygroundStrings.levelProgressCompletedSemantic;
      case LevelCardState.locked:
        return PlaygroundStrings.levelProgressLockedSemantic;
      case LevelCardState.premium:
        return PlaygroundStrings.levelProgressPremiumSemantic;
      case LevelCardState.current:
        return PlaygroundStrings.levelProgressCurrentSemantic;
    }
  }
}

class LevelProgressOpacity {
  const LevelProgressOpacity._();

  static double forState({required bool locked, required bool completed}) {
    if (locked) return PlaygroundOpacity.locked;
    if (completed) return PlaygroundOpacity.dimmed;
    return 1.0;
  }
}
