import '../../domain/entities/badge_entry.dart';
import '../../domain/enums/reward_enums.dart';

class BadgeEntryModel {
  const BadgeEntryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.rarityId,
    required this.earnedAtIso,
    this.category,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String rarityId;
  final String earnedAtIso;
  final String? category;
  final bool isFavorite;

  BadgeEntry toEntity() {
    return BadgeEntry(
      id: id,
      title: title,
      description: description,
      iconKey: iconKey,
      rarity: _rarityFromId(rarityId),
      earnedAtIso: earnedAtIso,
      category: category,
      isFavorite: isFavorite,
    );
  }

  static RewardRarity _rarityFromId(String id) {
    for (final RewardRarity r in RewardRarity.values) {
      if (r.name == id) return r;
    }
    return RewardRarity.common;
  }
}