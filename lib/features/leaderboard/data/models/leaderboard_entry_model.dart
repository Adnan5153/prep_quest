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
    this.accuracyPercent = 0,
    this.completedCategories = 0,
    this.completedMissions = 0,
    this.score = 0,
    this.seasonId = 'lifetime',
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
      accuracyPercent: (json['accuracyPercent'] as num?)?.toInt() ?? 0,
      completedCategories:
          (json['completedCategories'] as num?)?.toInt() ?? 0,
      completedMissions:
          (json['completedMissions'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      seasonId: (json['seasonId'] as String?) ?? 'lifetime',
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
      'accuracyPercent': accuracyPercent,
      'completedCategories': completedCategories,
      'completedMissions': completedMissions,
      'score': score,
      'seasonId': seasonId,
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
  final int accuracyPercent;
  final int completedCategories;
  final int completedMissions;
  final int score;
  final String seasonId;

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
      accuracyPercent: accuracyPercent,
      completedCategories: completedCategories,
      completedMissions: completedMissions,
      score: score,
      seasonId: seasonId,
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
      accuracyPercent: entity.accuracyPercent,
      completedCategories: entity.completedCategories,
      completedMissions: entity.completedMissions,
      score: entity.score,
      seasonId: entity.seasonId,
    );
  }
}