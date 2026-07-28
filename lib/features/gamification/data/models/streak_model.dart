import '../../domain/entities/streak_entity.dart';
import '../../domain/enums/streak_enums.dart';

/// JSON-ready persistence shape for [StreakEntity].
///
/// Stored by [StreakLocalDataSource]; the entity is the only object
/// exposed to the rest of the app so domain and presentation stay free
/// of data-layer concerns.
class StreakModel {
  const StreakModel({
    required this.id,
    required this.typeId,
    required this.day,
    required this.xp,
    required this.coins,
    this.badgeId,
    this.claimed = false,
  });

  final String id;
  final String typeId;
  final int day;
  final int xp;
  final int coins;
  final String? badgeId;
  final bool claimed;

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      id: (json['id'] as String?) ?? '',
      typeId: (json['typeId'] as String?) ?? 'daily',
      day: (json['day'] as num?)?.toInt() ?? 0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      badgeId: json['badgeId'] as String?,
      claimed: (json['claimed'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'typeId': typeId,
      'day': day,
      'xp': xp,
      'coins': coins,
      'badgeId': badgeId,
      'claimed': claimed,
    };
  }

  StreakEntity toEntity() {
    return StreakEntity(
      id: id,
      type: _typeFromId(typeId),
      day: day,
      xp: xp,
      coins: coins,
      badgeId: badgeId,
      claimed: claimed,
    );
  }

  static StreakModel fromEntity(StreakEntity entity) {
    return StreakModel(
      id: entity.id,
      typeId: entity.type.name,
      day: entity.day,
      xp: entity.xp,
      coins: entity.coins,
      badgeId: entity.badgeId,
      claimed: entity.claimed,
    );
  }

  static StreakBonusType _typeFromId(String id) {
    for (final StreakBonusType t in StreakBonusType.values) {
      if (t.name == id) return t;
    }
    return StreakBonusType.daily;
  }
}