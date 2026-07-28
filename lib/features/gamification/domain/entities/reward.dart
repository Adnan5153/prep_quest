import 'package:flutter/foundation.dart';

import '../enums/reward_enums.dart';

/// Sealed payload describing a single reward a user can receive.
///
/// The reward engine never hardcodes per-type branches outside of the
/// `when` clauses that consume this hierarchy. New reward types are
/// introduced by adding a new subtype here plus matching handling in
/// the UI / repository.
@immutable
sealed class Reward {
  const Reward({required this.id, required this.title, required this.rarity});

  final String id;
  final String title;
  final RewardRarity rarity;
}

@immutable
class XpReward extends Reward {
  const XpReward({
    required super.id,
    required super.title,
    required super.rarity,
    required this.amount,
    this.bonusLabel,
  });

  final int amount;
  final String? bonusLabel;
}

@immutable
class CoinReward extends Reward {
  const CoinReward({
    required super.id,
    required super.title,
    required super.rarity,
    required this.amount,
    this.bonusLabel,
  });

  final int amount;
  final String? bonusLabel;
}

@immutable
class BadgeReward extends Reward {
  const BadgeReward({
    required super.id,
    required super.title,
    required super.rarity,
    required this.iconKey,
    required this.description,
    this.category,
  });

  final String iconKey;
  final String description;
  final String? category;
}

@immutable
class UnlockReward extends Reward {
  const UnlockReward({
    required super.id,
    required super.title,
    required super.rarity,
    required this.unlockKey,
    required this.subtitle,
  });

  final String unlockKey;
  final String subtitle;
}

@immutable
class ChestReward extends Reward {
  const ChestReward({
    required super.id,
    required super.title,
    required super.rarity,
    required this.contents,
  });

  /// Rewards rolled out of the chest. Always non-empty for a valid
  /// opened chest — the engine guarantees at least one entry.
  final List<Reward> contents;
}

@immutable
class DailyRewardEntry extends Reward {
  const DailyRewardEntry({
    required super.id,
    required super.title,
    required super.rarity,
    required this.day,
    required this.xp,
    required this.coins,
    this.badgeIconKey,
  });

  final int day;
  final int xp;
  final int coins;
  final String? badgeIconKey;
}