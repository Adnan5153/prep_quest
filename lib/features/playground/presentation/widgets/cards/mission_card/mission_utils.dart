import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_strings.dart';
import 'mission_card_enums.dart';
import 'mission_card_visual.dart';
import 'mission_constants.dart';

class MissionProgressFormatter {
  const MissionProgressFormatter._();

  static String format(int totalSeconds) {
    if (totalSeconds <= 0) return MissionCardDefaults.timerFallback;
    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (days > 0) {
      return '${days}d ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class MissionSemanticResolver {
  const MissionSemanticResolver._();

  static String labelFor(MissionCardState state) {
    switch (state) {
      case MissionCardState.completed:
        return PlaygroundStrings.missionCardCompletedSemantic;
      case MissionCardState.locked:
        return PlaygroundStrings.missionCardLockedSemantic;
      case MissionCardState.active:
        return PlaygroundStrings.missionCardActiveSemantic;
    }
  }
}

class MissionStateCopy {
  const MissionStateCopy._();

  static String labelFor(MissionCardState state) {
    switch (state) {
      case MissionCardState.completed:
        return PlaygroundStrings.missionCardCompleted;
      case MissionCardState.locked:
        return PlaygroundStrings.missionCardLocked;
      case MissionCardState.active:
        return PlaygroundStrings.missionCardActive;
    }
  }
}

class MissionStatePalette {
  const MissionStatePalette._();

  static Color colorFor(MissionCardState state, {required bool isDark}) {
    switch (state) {
      case MissionCardState.completed:
        return PlaygroundColors.completed;
      case MissionCardState.locked:
        return PlaygroundColors.cardLockedSurface;
      case MissionCardState.active:
        return isDark ? AppColors.darkMuted : AppColors.lightMuted;
    }
  }
}

class MissionTagCopy {
  const MissionTagCopy._();

  static String labelFor(MissionCardTag tag) {
    switch (tag) {
      case MissionCardTag.daily:
        return PlaygroundStrings.missionTagDaily.toUpperCase();
      case MissionCardTag.weekly:
        return PlaygroundStrings.missionTagWeekly.toUpperCase();
      case MissionCardTag.monthly:
        return PlaygroundStrings.missionTagMonthly.toUpperCase();
      case MissionCardTag.premium:
        return PlaygroundStrings.missionTagPremium.toUpperCase();
      case MissionCardTag.special:
        return PlaygroundStrings.missionTagSpecial.toUpperCase();
      case MissionCardTag.none:
        return '';
    }
  }
}

class MissionTagPalette {
  const MissionTagPalette._();

  static Color fillFor(MissionCardTag tag) {
    switch (tag) {
      case MissionCardTag.daily:
        return PlaygroundColors.xp.withValues(alpha: 0.18);
      case MissionCardTag.weekly:
        return PlaygroundColors.streak.withValues(alpha: 0.18);
      case MissionCardTag.monthly:
        return PlaygroundColors.progressionSeasonal.withValues(alpha: 0.18);
      case MissionCardTag.premium:
        return PlaygroundColors.premiumChrome.withValues(alpha: 0.22);
      case MissionCardTag.special:
        return PlaygroundColors.gems.withValues(alpha: 0.18);
      case MissionCardTag.none:
        return Colors.transparent;
    }
  }

  static Color fgFor(MissionCardTag tag) {
    switch (tag) {
      case MissionCardTag.daily:
        return PlaygroundColors.xp;
      case MissionCardTag.weekly:
        return PlaygroundColors.streak;
      case MissionCardTag.monthly:
        return PlaygroundColors.progressionSeasonal;
      case MissionCardTag.premium:
        return PlaygroundColors.premiumChrome;
      case MissionCardTag.special:
        return PlaygroundColors.gems;
      case MissionCardTag.none:
        return Colors.transparent;
    }
  }
}

class MissionStateIcons {
  const MissionStateIcons._();

  static IconData iconFor(MissionCardState state) {
    switch (state) {
      case MissionCardState.completed:
        return AppIcons.checkCircle;
      case MissionCardState.locked:
        return AppIcons.lockFilled;
      case MissionCardState.active:
        return AppIcons.mission;
    }
  }
}

class MissionRewardPalette {
  const MissionRewardPalette._();

  static IconData iconFor(MissionCardRewardKind kind) {
    switch (kind) {
      case MissionCardRewardKind.xp:
        return AppIcons.xp;
      case MissionCardRewardKind.coin:
        return AppIcons.coinIcon;
      case MissionCardRewardKind.gem:
        return AppIcons.gem;
      case MissionCardRewardKind.badge:
        return AppIcons.badgeStar;
    }
  }

  static String labelFor(MissionCardRewardKind kind) {
    switch (kind) {
      case MissionCardRewardKind.xp:
        return PlaygroundStrings.xpLabel;
      case MissionCardRewardKind.coin:
        return PlaygroundStrings.coinLabel;
      case MissionCardRewardKind.gem:
        return MissionCardDefaults.defaultGemLabel;
      case MissionCardRewardKind.badge:
        return MissionCardDefaults.defaultBadgeLabel;
    }
  }

  static Color colorFor(MissionCardRewardKind kind) {
    switch (kind) {
      case MissionCardRewardKind.xp:
        return PlaygroundColors.xp;
      case MissionCardRewardKind.coin:
        return PlaygroundColors.coin;
      case MissionCardRewardKind.gem:
        return PlaygroundColors.gems;
      case MissionCardRewardKind.badge:
        return PlaygroundColors.premiumChrome;
    }
  }

  static String semanticFor(MissionCardRewardKind kind) {
    switch (kind) {
      case MissionCardRewardKind.xp:
        return PlaygroundStrings.missionCardRewardXpSemantic;
      case MissionCardRewardKind.coin:
        return PlaygroundStrings.missionCardRewardCoinSemantic;
      case MissionCardRewardKind.gem:
        return PlaygroundStrings.missionCardRewardGemSemantic;
      case MissionCardRewardKind.badge:
        return PlaygroundStrings.missionCardRewardBadgeSemantic;
    }
  }
}

class MissionProgressPalette {
  const MissionProgressPalette._();

  static Color trackFor({required bool isDark}) {
    return isDark
        ? PlaygroundColors.progressTrack
        : PlaygroundColors.progressTrackLight;
  }

  static Color fillFor({
    required bool isCompleted,
    required MissionCardTag tag,
  }) {
    if (isCompleted) return PlaygroundColors.completed;
    if (tag == MissionCardTag.premium) return PlaygroundColors.premiumChrome;
    return PlaygroundColors.xp;
  }
}

class MissionIconPalette {
  const MissionIconPalette._();

  static Color fillFor({
    required MissionCardTag tag,
    required MissionCardState state,
    required bool isDark,
  }) {
    if (tag == MissionCardTag.premium) {
      return PlaygroundColors.premiumChrome.withValues(alpha: 0.18);
    }
    switch (state) {
      case MissionCardState.completed:
        return PlaygroundColors.completed.withValues(alpha: 0.18);
      case MissionCardState.locked:
        return PlaygroundColors.cardLockedSurface.withValues(alpha: 0.18);
      case MissionCardState.active:
        return PlaygroundColors.xp.withValues(alpha: 0.18);
    }
  }

  static Color fgFor({
    required MissionCardTag tag,
    required MissionCardState state,
  }) {
    if (tag == MissionCardTag.premium) return PlaygroundColors.premiumChrome;
    switch (state) {
      case MissionCardState.completed:
        return PlaygroundColors.completed;
      case MissionCardState.locked:
        return PlaygroundColors.cardLockedSurface;
      case MissionCardState.active:
        return PlaygroundColors.xp;
    }
  }

  static IconData iconFor(MissionVisual visual) {
    if (visual.icon != null) return visual.icon!;
    switch (visual.state) {
      case MissionCardState.completed:
        return AppIcons.checkCircle;
      case MissionCardState.locked:
        return AppIcons.lockFilled;
      case MissionCardState.active:
        return AppIcons.mission;
    }
  }
}

class MissionShadowResolver {
  const MissionShadowResolver._();

  static List<BoxShadow> forCard({required MissionCardTag tag}) {
    if (tag == MissionCardTag.premium) {
      return <BoxShadow>[
        BoxShadow(
          color: PlaygroundColors.cardGlowAccent.withValues(alpha: 0.20),
          blurRadius: 22,
          spreadRadius: 0.0,
          offset: const Offset(0, 6),
        ),
        const BoxShadow(
          color: AppColors.nodeDropShadow,
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
      ];
    }
    return const <BoxShadow>[
      BoxShadow(
        color: AppColors.nodeDropShadow,
        blurRadius: 16,
        offset: Offset(0, 6),
      ),
    ];
  }
}

class MissionOpacityResolver {
  const MissionOpacityResolver._();

  static double forState(MissionCardState state) {
    if (state == MissionCardState.locked) return PlaygroundOpacity.locked;
    return 1.0;
  }
}

class MissionBorderResolver {
  const MissionBorderResolver._();

  static Color forCard({required MissionCardTag tag, required bool isDark}) {
    if (tag == MissionCardTag.premium) {
      return PlaygroundColors.premiumChrome.withValues(alpha: 0.45);
    }
    return isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);
  }
}
