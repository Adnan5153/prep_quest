import 'package:flutter/material.dart';

import '../../domain/entities/mission_entity.dart';
import 'daily_mission_card.dart';

/// Mission card tuned for the weekly cadence.
class WeeklyMissionCard extends StatelessWidget {
  const WeeklyMissionCard({
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
}