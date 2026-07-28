import '../../domain/entities/leaderboard_entry_entity.dart';

/// JSON-ready persistence shape for [LeaderboardEntryEntity].
class LeaderboardEntryModel {
  const LeaderboardEntryModel({
    required this.userId,
    required this.rank,
    required this.previousRank,
    required this.username,
    required this.university,
    required this.avatarUrl,
    required this.level,
    required this.xp,
    required this.coins,
    required this.streakDays,
    required this.badges,
    required this.isCurrentUser,
    required this.isPremium,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawBadges =
        (json['badges'] as List<dynamic>?) ?? <dynamic>[];
    return LeaderboardEntryModel(
      userId: (json['userId'] as String?) ?? '',
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      previousRank: (json['previousRank'] as num?)?.toInt() ?? 0,
      username: (json['username'] as String?) ?? '',
      university: (json['university'] as String?) ?? '',
      avatarUrl: (json['avatarUrl'] as String?) ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      badges:
          rawBadges.map((dynamic e) => e.toString()).toList(growable: false),
      isCurrentUser: (json['isCurrentUser'] as bool?) ?? false,
      isPremium: (json['isPremium'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'rank': rank,
      'previousRank': previousRank,
      'username': username,
      'university': university,
      'avatarUrl': avatarUrl,
      'level': level,
      'xp': xp,
      'coins': coins,
      'streakDays': streakDays,
      'badges': badges,
      'isCurrentUser': isCurrentUser,
      'isPremium': isPremium,
    };
  }

  final String userId;
  final int rank;
  final int previousRank;
  final String username;
  final String university;
  final String avatarUrl;
  final int level;
  final int xp;
  final int coins;
  final int streakDays;
  final List<String> badges;
  final bool isCurrentUser;
  final bool isPremium;

  LeaderboardEntryEntity toEntity() {
    return LeaderboardEntryEntity(
      userId: userId,
      rank: rank,
      previousRank: previousRank,
      username: username,
      university: university,
      avatarUrl: avatarUrl,
      level: level,
      xp: xp,
      coins: coins,
      streakDays: streakDays,
      badges: badges,
      isCurrentUser: isCurrentUser,
      isPremium: isPremium,
    );
  }

  static LeaderboardEntryModel fromEntity(LeaderboardEntryEntity entity) {
    return LeaderboardEntryModel(
      userId: entity.userId,
      rank: entity.rank,
      previousRank: entity.previousRank,
      username: entity.username,
      university: entity.university,
      avatarUrl: entity.avatarUrl,
      level: entity.level,
      xp: entity.xp,
      coins: entity.coins,
      streakDays: entity.streakDays,
      badges: entity.badges,
      isCurrentUser: entity.isCurrentUser,
      isPremium: entity.isPremium,
    );
  }
}