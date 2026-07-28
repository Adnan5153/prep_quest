import 'package:flutter/material.dart';

import '../../../playground/presentation/widgets/cards/mission_card/mission_card.dart';
import '../../../playground/presentation/widgets/cards/mission_card/mission_card_enums.dart';
import '../../../playground/presentation/widgets/cards/mission_card/mission_card_visual.dart';
import '../../../playground/presentation/widgets/cards/mission_card/mission_reward.dart';
import '../../domain/entities/mission_entity.dart';
import '../../domain/entities/mission_reward_entity.dart';
import '../../domain/enums/mission_enums.dart';
import 'mission_progress_bar.dart';
import 'mission_reward_chip.dart';
import 'mission_status_badge.dart';

/// Mission card tuned for the daily cadence.
class DailyMissionCard extends StatelessWidget {
  const DailyMissionCard({
    super.key,
    required this.mission,
    required this.isDark,
    this.onClaim,
  });

  final MissionEntity mission;
  final bool isDark;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    return MissionCardForCadence(
      mission: mission,
      isDark: isDark,
      onClaim: onClaim,
    );
  }

  /// Resolves the appropriate Material icon for a [MissionCategory].
  static IconData iconFor(MissionCategory category) {
    switch (category) {
      case MissionCategory.quiz:
        return Icons.quiz_outlined;
      case MissionCategory.lesson:
        return Icons.menu_book_rounded;
      case MissionCategory.streak:
        return Icons.local_fire_department_outlined;
      case MissionCategory.exploration:
        return Icons.travel_explore_outlined;
      case MissionCategory.social:
        return Icons.groups_outlined;
      case MissionCategory.energy:
        return Icons.bolt_outlined;
      case MissionCategory.mixed:
        return Icons.flag_rounded;
    }
  }
}

/// Shared implementation for daily / weekly / monthly cards.
///
/// Each public mission-card widget is a 5-line wrapper that simply
/// delegates here with the right [MissionCardTag]. Keeping a single
/// implementation prevents the three cadence-specific widgets from
/// drifting apart over time.
class MissionCardForCadence extends StatelessWidget {
  const MissionCardForCadence({
    super.key,
    required this.mission,
    required this.isDark,
    this.onClaim,
    this.tagOverride,
  });

  final MissionEntity mission;
  final bool isDark;
  final VoidCallback? onClaim;

  /// Allows callers to override the auto-resolved tag (e.g. for
  /// bottom-sheet variants). When `null` the tag is derived from
  /// `mission.cadence`.
  final MissionCardTag? tagOverride;

  MissionCardTag _tagForCadence(MissionCadence cadence) {
    switch (cadence) {
      case MissionCadence.daily:
        return MissionCardTag.daily;
      case MissionCadence.weekly:
        return MissionCardTag.weekly;
      case MissionCadence.monthly:
        return MissionCardTag.monthly;
    }
  }

  MissionCardState _stateForMission() {
    if (mission.isClaimed) return MissionCardState.completed;
    if (mission.isLocked) return MissionCardState.locked;
    if (mission.isCompleted) return MissionCardState.completed;
    return MissionCardState.active;
  }

  MissionCardReward _primaryReward() {
    if (mission.rewardXp > 0) {
      return MissionCardReward.xp(mission.rewardXp);
    }
    if (mission.rewardCoins > 0) {
      return MissionCardReward.coin(mission.rewardCoins);
    }
    if (mission.rewardChestId != null && mission.rewardChestId!.isNotEmpty) {
      return MissionCardReward.gem(1);
    }
    return MissionCardReward.xp(0);
  }

  @override
  Widget build(BuildContext context) {
    final visual = MissionVisual(
      id: mission.id,
      title: mission.title,
      description: mission.description,
      required: mission.goal,
      progress: mission.progress,
      reward: _primaryReward(),
      state: _stateForMission(),
      tag: tagOverride ?? _tagForCadence(mission.cadence),
      icon: DailyMissionCard.iconFor(mission.category),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MissionCard(visual: visual, onClaim: onClaim),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: MissionProgressBar(mission: mission)),
                  const SizedBox(width: 8),
                  MissionStatusBadge(status: mission.status, compact: true),
                ],
              ),
              const SizedBox(height: 8),
              MissionRewardChip(
                reward: MissionRewardEntity(
                  xp: mission.rewardXp,
                  coins: mission.rewardCoins,
                  energy: mission.rewardEnergy,
                  badgeId: mission.rewardBadgeId,
                  chestId: mission.rewardChestId,
                  specialKey: mission.specialKey,
                ),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}