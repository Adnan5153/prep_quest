import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/mission_entity.dart';
import '../../domain/enums/mission_enums.dart';
import 'daily_mission_card.dart';
import 'mission_category_header.dart';
import 'monthly_mission_card.dart';
import 'weekly_mission_card.dart';

/// Section renderer (header + list of cards) used inside the screen.
class MissionList extends StatelessWidget {
  const MissionList({
    super.key,
    required this.cadence,
    required this.missions,
    required this.nextReset,
    required this.isDark,
    this.onClaim,
  });

  final MissionCadence cadence;
  final List<MissionEntity> missions;
  final DateTime? nextReset;
  final bool isDark;
  final void Function(String missionId)? onClaim;

  Widget _cardFor(MissionEntity mission) {
    switch (cadence) {
      case MissionCadence.daily:
        return DailyMissionCard(
          mission: mission,
          isDark: isDark,
          onClaim: () => onClaim?.call(mission.id),
        );
      case MissionCadence.weekly:
        return WeeklyMissionCard(
          mission: mission,
          isDark: isDark,
          onClaim: () => onClaim?.call(mission.id),
        );
      case MissionCadence.monthly:
        return MonthlyMissionCard(
          mission: mission,
          isDark: isDark,
          onClaim: () => onClaim?.call(mission.id),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int completed = missions
        .where((MissionEntity m) => m.isCompleted || m.isClaimed)
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MissionCategoryHeader(
          cadence: cadence,
          count: missions.length,
          completedCount: completed,
          nextReset: nextReset,
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final MissionEntity m in missions) ...<Widget>[
          _cardFor(m),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}