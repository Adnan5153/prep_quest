import '../../../../features/gamification/domain/enums/reward_enums.dart';
import '../../domain/entities/user_profile.dart';
import '../../../gamification/domain/entities/badge_entry.dart';

class AchievementMapper {
  const AchievementMapper._();

  static BadgeEntry toBadgeEntry(BadgeEntity entity) {
    return BadgeEntry(
      id: entity.id,
      title: entity.name,
      description: entity.description,
      iconKey: entity.iconName,
      rarity: _rarityFor(entity.progress),
      earnedAtIso: entity.isEarned
          ? DateTime.now().toIso8601String()
          : '',
      isFavorite: false,
    );
  }

  static RewardRarity _rarityFor(double progress) {
    if (progress >= 1.0) return RewardRarity.legendary;
    if (progress >= 0.66) return RewardRarity.epic;
    if (progress >= 0.33) return RewardRarity.rare;
    return RewardRarity.common;
  }
}