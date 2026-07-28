import 'package:flutter/foundation.dart';

import '../enums/leaderboard_enums.dart';
import 'leaderboard_entry_entity.dart';

/// A full leaderboard result — a category's entries plus summary stats.
@immutable
class LeaderboardCategoryEntity {
  const LeaderboardCategoryEntity({
    required this.scope,
    required this.title,
    required this.subtitle,
    required this.entries,
    required this.totalParticipants,
    required this.lastUpdatedIso,
  });

  /// Which leaderboard this result is for.
  final LeaderboardScope scope;

  final String title;
  final String subtitle;
  final List<LeaderboardEntryEntity> entries;
  final int totalParticipants;
  final String lastUpdatedIso;

  LeaderboardCategoryEntity copyWith({
    LeaderboardScope? scope,
    String? title,
    String? subtitle,
    List<LeaderboardEntryEntity>? entries,
    int? totalParticipants,
    String? lastUpdatedIso,
  }) {
    return LeaderboardCategoryEntity(
      scope: scope ?? this.scope,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      entries: entries ?? this.entries,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      lastUpdatedIso: lastUpdatedIso ?? this.lastUpdatedIso,
    );
  }

  /// The current user's entry within this category, if present.
  LeaderboardEntryEntity? get currentUserEntry {
    for (final LeaderboardEntryEntity e in entries) {
      if (e.isCurrentUser) return e;
    }
    return null;
  }

  /// Top-3 podium entries (rank 1..3).
  List<LeaderboardEntryEntity> get podium {
    return List<LeaderboardEntryEntity>.unmodifiable(
      entries.where((LeaderboardEntryEntity e) => e.rank >= 1 && e.rank <= 3),
    );
  }
}