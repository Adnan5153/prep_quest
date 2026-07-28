import 'package:flutter/foundation.dart';

import '../../../quiz_engine/domain/entities/quiz_result_entity.dart';

/// Pure value object representing the rewards unlocked by a quiz.
@immutable
class QuizRewardSummary {
  const QuizRewardSummary({
    required this.rewardXp,
    required this.rewardCoins,
    required this.passed,
    required this.scorePercent,
  });

  final int rewardXp;
  final int rewardCoins;
  final bool passed;
  final int scorePercent;
}

/// Pure reward calculator. Derives a [QuizRewardSummary] from the
/// canonical [QuizResultEntity]. Reward multipliers are intentionally
/// minimal — the canonical reward fields on the result are trusted.
class CalculateRewards {
  const CalculateRewards();

  QuizRewardSummary call(QuizResultEntity result) {
    return QuizRewardSummary(
      rewardXp: result.rewardXp,
      rewardCoins: result.rewardCoins,
      passed: result.passed,
      scorePercent: result.scorePercent,
    );
  }
}
