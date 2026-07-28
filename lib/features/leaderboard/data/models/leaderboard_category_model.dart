import '../../domain/entities/leaderboard_category_entity.dart';
import '../../domain/enums/leaderboard_enums.dart';
import 'leaderboard_entry_model.dart';

/// JSON-ready persistence shape for [LeaderboardCategoryEntity].
class LeaderboardCategoryModel {
  const LeaderboardCategoryModel({
    required this.scopeId,
    required this.title,
    required this.subtitle,
    required this.entries,
    required this.totalParticipants,
    required this.lastUpdatedIso,
  });

  factory LeaderboardCategoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawEntries =
        (json['entries'] as List<dynamic>?) ?? <dynamic>[];
    return LeaderboardCategoryModel(
      scopeId: (json['scopeId'] as String?) ?? 'friends',
      title: (json['title'] as String?) ?? 'Leaderboard',
      subtitle: (json['subtitle'] as String?) ?? '',
      entries: rawEntries
          .whereType<Map<String, dynamic>>()
          .map(LeaderboardEntryModel.fromJson)
          .toList(growable: false),
      totalParticipants:
          (json['totalParticipants'] as num?)?.toInt() ?? 0,
      lastUpdatedIso: (json['lastUpdatedIso'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'scopeId': scopeId,
      'title': title,
      'subtitle': subtitle,
      'entries': entries
          .map((LeaderboardEntryModel e) => e.toJson())
          .toList(growable: false),
      'totalParticipants': totalParticipants,
      'lastUpdatedIso': lastUpdatedIso,
    };
  }

  final String scopeId;
  final String title;
  final String subtitle;
  final List<LeaderboardEntryModel> entries;
  final int totalParticipants;
  final String lastUpdatedIso;

  LeaderboardCategoryEntity toEntity() {
    return LeaderboardCategoryEntity(
      scope: _scopeFromId(scopeId),
      title: title,
      subtitle: subtitle,
      entries: entries
          .map((LeaderboardEntryModel m) => m.toEntity())
          .toList(growable: false),
      totalParticipants: totalParticipants,
      lastUpdatedIso: lastUpdatedIso,
    );
  }

  static LeaderboardScope _scopeFromId(String id) {
    for (final LeaderboardScope s in LeaderboardScope.values) {
      if (s.name == id) return s;
    }
    return LeaderboardScope.friends;
  }
}