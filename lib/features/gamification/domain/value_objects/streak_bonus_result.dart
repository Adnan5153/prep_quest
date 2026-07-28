import 'package:flutter/foundation.dart';

import '../entities/streak_entity.dart';
import '../enums/streak_enums.dart';

/// Output of a successful streak-bonus claim.
@immutable
class StreakBonusResult {
  const StreakBonusResult({
    required this.bonus,
    required this.day,
    required this.type,
    required this.xp,
    required this.coins,
    this.badgeId,
  });

  final StreakEntity bonus;
  final int day;
  final StreakBonusType type;
  final int xp;
  final int coins;
  final String? badgeId;
}