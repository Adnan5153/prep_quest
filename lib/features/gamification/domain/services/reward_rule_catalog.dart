import 'package:flutter/foundation.dart';

import '../../../../core/services/level_curve.dart' as core;
import '../../../../core/services/level_curve.dart' show LevelSnapshot;
import '../entities/level_progress.dart';
import '../enums/reward_enums.dart';

typedef CoreLevelCurve = core.LevelCurve;
typedef CoreLevelSnapshot = LevelSnapshot;

/// Data-driven rule for the reward engine.
///
/// The engine does not hardcode per-trigger math — it reads these
/// specs and produces [XpReward] / [CoinReward] / etc. Adding a new
/// event type means adding a new entry here, not changing engine code.
@immutable
class RewardRule {
  const RewardRule({
    required this.id,
    required this.trigger,
    required this.baseXP,
    required this.baseCoins,
    this.perfectBonusXP = 0,
    this.streakBonusPerDay = 0,
    this.streakBonusCap = 10,
    this.difficultyMultiplier = const <String, double>{
      'easy': 1.0,
      'medium': 1.25,
      'hard': 1.6,
    },
    this.subjectXPBonus = 0,
    this.drops = const <RewardDrop>[],
  });

  final String id;
  final RewardTrigger trigger;
  final int baseXP;
  final int baseCoins;
  final int perfectBonusXP;
  final int streakBonusPerDay;
  final int streakBonusCap;
  final Map<String, double> difficultyMultiplier;
  final int subjectXPBonus;
  final List<RewardDrop> drops;
}

@immutable
class RewardDrop {
  const RewardDrop({
    required this.badgeId,
    required this.probability,
  });

  final String badgeId;
  final double probability;
}

/// Re-exported as [LevelCurve] for backward compatibility with
/// existing call sites in the gamification feature. The canonical
/// implementation lives in `lib/core/services/level_curve.dart` and
/// is the single source of truth consumed by both the gamification
/// engine and the canonical quiz-completion funnel. Tests may still
/// pass an alternative curve via the [levelFor] parameter.
typedef LevelCurve = CoreLevelCurve;

class RewardRuleCatalog {
  const RewardRuleCatalog();

  static const List<RewardRule> _rules = <RewardRule>[
    RewardRule(
      id: 'quiz_completed_v1',
      trigger: RewardTrigger.quizCompleted,
      baseXP: 40,
      baseCoins: 15,
      perfectBonusXP: 60,
      streakBonusPerDay: 4,
      streakBonusCap: 60,
      difficultyMultiplier: <String, double>{
        'easy': 1.0,
        'medium': 1.25,
        'hard': 1.6,
        'mixed': 1.1,
      },
      drops: <RewardDrop>[
        RewardDrop(badgeId: 'quiz_first_blood', probability: 0.05),
        RewardDrop(badgeId: 'quiz_streak_3', probability: 0.15),
      ],
    ),
    RewardRule(
      id: 'lesson_completed_v1',
      trigger: RewardTrigger.lessonCompleted,
      baseXP: 25,
      baseCoins: 8,
      drops: <RewardDrop>[
        RewardDrop(badgeId: 'lesson_finisher', probability: 0.10),
      ],
    ),
    RewardRule(
      id: 'mission_completed_v1',
      trigger: RewardTrigger.missionCompleted,
      baseXP: 30,
      baseCoins: 12,
      drops: <RewardDrop>[
        RewardDrop(badgeId: 'mission_master', probability: 0.20),
      ],
    ),
    RewardRule(
      id: 'level_completed_v1',
      trigger: RewardTrigger.levelCompleted,
      baseXP: 60,
      baseCoins: 25,
      perfectBonusXP: 80,
      drops: <RewardDrop>[
        RewardDrop(badgeId: 'level_clearer', probability: 0.25),
        RewardDrop(badgeId: 'chest_first_clear', probability: 0.50),
      ],
    ),
    RewardRule(
      id: 'daily_login_v1',
      trigger: RewardTrigger.dailyLogin,
      baseXP: 10,
      baseCoins: 5,
    ),
  ];

  List<RewardRule> all() => List<RewardRule>.unmodifiable(_rules);

  RewardRule? findByTrigger(RewardTrigger trigger) {
    for (final RewardRule rule in _rules) {
      if (rule.trigger == trigger) return rule;
    }
    return null;
  }

  /// Pure function: applies a level curve to a current XP value and
  /// returns the new [LevelProgress]. Idempotent and side-effect free.
  ///
  /// Uses the canonical [LevelCurve.defaultCurve] when [curve] is
  /// not supplied. The growth multiplier is unified across the
  /// gamification engine and the canonical funnel (1.25× — see
  /// `lib/core/services/level_curve.dart`).
  LevelProgress levelFor(
    int totalXP, {
    CoreLevelCurve curve = CoreLevelCurve.defaultCurve,
  }) {
    final CoreLevelSnapshot snapshot = curve.compute(totalXP);
    return LevelProgress(
      currentLevel: snapshot.level,
      currentXP: snapshot.xpInLevel,
      nextLevelXP: snapshot.xpForNext,
    );
  }
}

/// Rarity table used by chest rolls.
class RarityTable {
  const RarityTable();

  static const Map<RewardRarity, double> _weights = <RewardRarity, double>{
    RewardRarity.common: 60,
    RewardRarity.rare: 25,
    RewardRarity.epic: 12,
    RewardRarity.legendary: 3,
  };

  RewardRarity roll(int pick) {
    final int total = _weights.values.fold<int>(0, (int s, double w) => s + w.round());
    final int normalised = pick % total;
    int cursor = 0;
    for (final MapEntry<RewardRarity, double> entry in _weights.entries) {
      cursor += entry.value.round();
      if (normalised < cursor) return entry.key;
    }
    return RewardRarity.common;
  }
}