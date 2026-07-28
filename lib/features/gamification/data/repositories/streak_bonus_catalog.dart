import '../../domain/entities/streak_entity.dart';
import '../../domain/enums/streak_enums.dart';
import '../models/streak_model.dart';

/// Static catalog of every bonus a user can earn from their streak.
///
/// The catalog is intentionally pure and deterministic — the same
/// input always returns the same list, so tests don't need a network
/// fixture. New milestones are added here in one place.
class StreakBonusCatalog {
  const StreakBonusCatalog();

  static const List<Map<String, Object>> _entries =
      <Map<String, Object>>[
    <String, Object>{
      'id': 'streak_bonus_daily_1',
      'typeId': 'daily',
      'day': 1,
      'xp': 10,
      'coins': 5,
    },
    <String, Object>{
      'id': 'streak_bonus_daily_2',
      'typeId': 'daily',
      'day': 2,
      'xp': 15,
      'coins': 6,
    },
    <String, Object>{
      'id': 'streak_bonus_daily_3',
      'typeId': 'daily',
      'day': 3,
      'xp': 20,
      'coins': 8,
    },
    <String, Object>{
      'id': 'streak_bonus_weekly_7',
      'typeId': 'weekly',
      'day': 7,
      'xp': 50,
      'coins': 25,
      'badgeId': 'streak_week',
    },
    <String, Object>{
      'id': 'streak_bonus_weekly_14',
      'typeId': 'weekly',
      'day': 14,
      'xp': 80,
      'coins': 40,
    },
    <String, Object>{
      'id': 'streak_bonus_weekly_30',
      'typeId': 'weekly',
      'day': 30,
      'xp': 150,
      'coins': 75,
      'badgeId': 'streak_month',
    },
    <String, Object>{
      'id': 'streak_bonus_milestone_50',
      'typeId': 'milestone',
      'day': 50,
      'xp': 300,
      'coins': 150,
    },
    <String, Object>{
      'id': 'streak_bonus_milestone_100',
      'typeId': 'milestone',
      'day': 100,
      'xp': 600,
      'coins': 300,
      'badgeId': 'streak_centurion',
    },
  ];

  /// Returns the full seed list as [StreakModel]s.
  List<StreakModel> seed() {
    return List<StreakModel>.unmodifiable(_entries.map(_toModel));
  }

  /// Returns a [StreakEntity] for the given [day] / [type] combo, or
  /// null if no such bonus exists in the catalog.
  StreakEntity? findByDayAndType(int day, StreakBonusType type) {
    for (final Map<String, Object> row in _entries) {
      if ((row['day'] as int) == day && (row['typeId'] as String) == type.name) {
        return _toModel(row).toEntity();
      }
    }
    return null;
  }

  /// The smallest unclaimed milestone day that the user has reached.
  int nextMilestone(int currentDays) {
    const List<int> milestones = <int>[7, 14, 30, 50, 100];
    for (final int m in milestones) {
      if (currentDays < m) return m;
    }
    return 100;
  }

  StreakModel _toModel(Map<String, Object> row) {
    return StreakModel(
      id: row['id'] as String,
      typeId: row['typeId'] as String,
      day: row['day'] as int,
      xp: row['xp'] as int,
      coins: row['coins'] as int,
      badgeId: row['badgeId'] as String?,
    );
  }
}