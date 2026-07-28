import 'package:flutter/foundation.dart';

import '../enums/reward_enums.dart';

/// Static badge definition; the engine looks these up by id when a
/// [RewardDrop] fires.
@immutable
class BadgeDefinition {
  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.rarity,
    this.category,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final RewardRarity rarity;
  final String? category;
}

class BadgeCatalog {
  const BadgeCatalog();

  static const List<BadgeDefinition> _all = <BadgeDefinition>[
    BadgeDefinition(
      id: 'quiz_first_blood',
      title: 'First Blood',
      description: 'Win your first quiz.',
      iconKey: 'sword',
      rarity: RewardRarity.common,
      category: 'quiz',
    ),
    BadgeDefinition(
      id: 'quiz_streak_3',
      title: 'Hat-trick',
      description: 'Complete 3 quizzes in a single day.',
      iconKey: 'streak',
      rarity: RewardRarity.rare,
      category: 'quiz',
    ),
    BadgeDefinition(
      id: 'lesson_finisher',
      title: 'Lesson Finisher',
      description: 'Read a lesson end to end.',
      iconKey: 'book',
      rarity: RewardRarity.common,
      category: 'lesson',
    ),
    BadgeDefinition(
      id: 'mission_master',
      title: 'Mission Master',
      description: 'Complete a daily mission.',
      iconKey: 'flag',
      rarity: RewardRarity.rare,
      category: 'mission',
    ),
    BadgeDefinition(
      id: 'level_clearer',
      title: 'Pathfinder',
      description: 'Clear a Playground level.',
      iconKey: 'compass',
      rarity: RewardRarity.rare,
      category: 'playground',
    ),
    BadgeDefinition(
      id: 'chest_first_clear',
      title: 'Treasure Hunter',
      description: 'Open your first reward chest.',
      iconKey: 'chest',
      rarity: RewardRarity.epic,
      category: 'playground',
    ),
    BadgeDefinition(
      id: 'streak_week',
      title: 'Week Warrior',
      description: 'Hold a 7-day login streak.',
      iconKey: 'flame',
      rarity: RewardRarity.legendary,
      category: 'streak',
    ),
    BadgeDefinition(
      id: 'perfect_score',
      title: 'Perfectionist',
      description: 'Score 100% on a hard quiz.',
      iconKey: 'crown',
      rarity: RewardRarity.legendary,
      category: 'quiz',
    ),
  ];

  List<BadgeDefinition> all() => List<BadgeDefinition>.unmodifiable(_all);

  BadgeDefinition? byId(String id) {
    for (final BadgeDefinition def in _all) {
      if (def.id == id) return def;
    }
    return null;
  }
}