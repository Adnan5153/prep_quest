import 'package:flutter/foundation.dart';

import '../enums/streak_enums.dart';

/// A single row in the user's streak-bonus ledger.
///
/// Represents **one** bonus entry — for example the day-7 weekly bonus
/// or the day-30 milestone bonus. The ledger is sorted by [day] ascending
/// and consumed at most once per user; once [claimed] is true the bonus
/// is permanently retired.
@immutable
class StreakEntity {
  const StreakEntity({
    required this.id,
    required this.type,
    required this.day,
    required this.xp,
    required this.coins,
    this.badgeId,
    this.claimed = false,
  });

  /// Stable identifier — e.g. `streak_bonus_daily_1` or `streak_bonus_weekly_7`.
  final String id;

  final StreakBonusType type;

  /// Day threshold that must be met to claim.
  final int day;

  /// XP granted on claim.
  final int xp;

  /// Coins granted on claim.
  final int coins;

  /// Optional badge dropped on claim.
  final String? badgeId;

  /// Whether the user has already claimed this bonus.
  final bool claimed;

  StreakEntity copyWith({
    String? id,
    StreakBonusType? type,
    int? day,
    int? xp,
    int? coins,
    String? badgeId,
    bool? claimed,
  }) {
    return StreakEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      day: day ?? this.day,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      badgeId: badgeId ?? this.badgeId,
      claimed: claimed ?? this.claimed,
    );
  }
}