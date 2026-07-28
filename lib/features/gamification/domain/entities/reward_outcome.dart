import 'package:flutter/foundation.dart';

import 'reward.dart';
import 'user_rewards_state.dart';

/// What the reward engine returned for a single [RewardTrigger].
///
/// [grants] is the ordered list of every reward issued (one entry per
/// reward primitive — a single trigger may produce XP + coins + a
/// badge + a chest unlock). [stateAfter] is the resulting snapshot
/// of the user's progression state, already applied. [celebration]
/// flags grants that should play the full unlock animation in the
/// presentation layer (badge reveals, level-ups, legendary chests).
@immutable
class RewardOutcome {
  const RewardOutcome({
    required this.grants,
    required this.stateBefore,
    required this.stateAfter,
    required this.celebration,
  });

  final List<Reward> grants;
  final UserRewardsState stateBefore;
  final UserRewardsState stateAfter;
  final CelebrationSpec celebration;

  /// True when the trigger caused the user to level up.
  bool get leveledUp => stateAfter.level.currentLevel >
      stateBefore.level.currentLevel;

  /// True when the trigger caused the streak to tick up.
  bool get streakAdvanced =>
      stateAfter.streak.currentDays > stateBefore.streak.currentDays;

  /// True when at least one new badge was earned.
  bool get earnedNewBadge =>
      grants.any((Reward r) => r is BadgeReward) ||
      stateAfter.badges.length > stateBefore.badges.length;
}

/// What the presentation layer should celebrate.
@immutable
class CelebrationSpec {
  const CelebrationSpec({
    this.confetti = false,
    this.showLevelUpDialog = false,
    this.showBadgeUnlock = false,
    this.showChestOpen = false,
  });

  final bool confetti;
  final bool showLevelUpDialog;
  final bool showBadgeUnlock;
  final bool showChestOpen;

  static const CelebrationSpec none = CelebrationSpec();
}