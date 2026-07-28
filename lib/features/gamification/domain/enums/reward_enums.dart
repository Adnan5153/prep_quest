/// Catalog of reward primitives the engine can issue.
///
/// New reward types are added here and to the sealed [Reward]
/// hierarchy; existing business logic does not need to change.
enum RewardType {
  xp,
  coins,
  badge,
  chest,
  unlock,
  daily,
}

/// Visual / gameplay rarity tier.
enum RewardRarity { common, rare, epic, legendary }

/// Lifecycle of a reward chest.
enum ChestStatus { locked, opening, opened, claimed }

/// State of a single day in the daily-reward calendar.
enum DailyRewardStatus { future, claimable, claimed, missed }

/// Origin event that triggered a reward grant.
///
/// Drives the rule lookup inside the reward engine — the engine does
/// not switch on raw event payloads, only on this enum + its
/// [RewardTriggerData] payload (kept type-safe per event).
enum RewardTrigger {
  quizCompleted,
  lessonCompleted,
  missionCompleted,
  levelCompleted,
  dailyLogin,
  badgeEarned,
  chestOpened,
}