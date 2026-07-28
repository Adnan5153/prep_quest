import 'package:flutter/foundation.dart';

import '../entities/streak_state.dart';
import '../enums/streak_enums.dart';

/// Output of a successful streak recovery.
///
/// The controller reads this and dispatches the implied XP / coins /
/// badge into the rewards engine — the repository itself stays free of
/// reward-engine coupling.
@immutable
class StreakRecoveryResult {
  const StreakRecoveryResult({
    required this.state,
    required this.method,
    required this.coinCost,
    this.badgeId,
  });

  final StreakState state;
  final RecoveryMethod method;
  final int coinCost;
  final String? badgeId;
}