import 'package:flutter/foundation.dart';

import '../enums/reward_enums.dart';

/// A single badge the user owns (or has favourited).
@immutable
class BadgeEntry {
  const BadgeEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.rarity,
    required this.earnedAtIso,
    this.category,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final RewardRarity rarity;
  final String earnedAtIso;
  final String? category;
  final bool isFavorite;

  BadgeEntry copyWith({bool? isFavorite}) {
    return BadgeEntry(
      id: id,
      title: title,
      description: description,
      iconKey: iconKey,
      rarity: rarity,
      earnedAtIso: earnedAtIso,
      category: category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}