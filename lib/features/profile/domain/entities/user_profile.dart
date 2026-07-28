import 'package:flutter/foundation.dart';

import '../../../../shared/enums/exam_track.dart';

/// Languages the learner can pick from for content + UI hints.
enum ProfileLanguage {
  english,
  bangla;

  String get id {
    switch (this) {
      case ProfileLanguage.english:
        return 'en';
      case ProfileLanguage.bangla:
        return 'bn';
    }
  }

  String get displayName {
    switch (this) {
      case ProfileLanguage.english:
        return 'English';
      case ProfileLanguage.bangla:
        return 'বাংলা';
    }
  }

  static ProfileLanguage fromId(String? value) {
    if (value == null) return ProfileLanguage.english;
    for (final ProfileLanguage lang in ProfileLanguage.values) {
      if (lang.id == value) return lang;
    }
    return ProfileLanguage.english;
  }
}

/// Rank tiers surfaced on the profile (Bronze → Diamond).
enum ProfileRank {
  bronze,
  silver,
  gold,
  platinum,
  diamond;

  String get id {
    switch (this) {
      case ProfileRank.bronze:
        return 'bronze';
      case ProfileRank.silver:
        return 'silver';
      case ProfileRank.gold:
        return 'gold';
      case ProfileRank.platinum:
        return 'platinum';
      case ProfileRank.diamond:
        return 'diamond';
    }
  }

  String get displayName {
    switch (this) {
      case ProfileRank.bronze:
        return 'Bronze';
      case ProfileRank.silver:
        return 'Silver';
      case ProfileRank.gold:
        return 'Gold';
      case ProfileRank.platinum:
        return 'Platinum';
      case ProfileRank.diamond:
        return 'Diamond';
    }
  }

  static ProfileRank fromId(String? value) {
    if (value == null) return ProfileRank.bronze;
    for (final ProfileRank rank in ProfileRank.values) {
      if (rank.id == value) return rank;
    }
    return ProfileRank.bronze;
  }
}

/// Lightweight achievement the user has unlocked.
@immutable
class AchievementEntity {
  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.unlockedAt,
    this.xpReward = 0,
    this.coinReward = 0,
  });

  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime unlockedAt;
  final int xpReward;
  final int coinReward;

  AchievementEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? iconName,
    DateTime? unlockedAt,
    int? xpReward,
    int? coinReward,
  }) {
    return AchievementEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AchievementEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.iconName == iconName &&
        other.unlockedAt == unlockedAt &&
        other.xpReward == xpReward &&
        other.coinReward == coinReward;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        iconName,
        unlockedAt,
        xpReward,
        coinReward,
      );
}

/// Static badge definition (catalog) + earned status tracked per-user.
@immutable
class BadgeEntity {
  const BadgeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.isEarned,
    this.progress = 0,
  });

  final String id;
  final String name;
  final String description;
  final String iconName;
  final bool isEarned;

  /// 0.0 — 1.0 progress towards unlocking the badge.
  final double progress;

  BadgeEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    bool? isEarned,
    double? progress,
  }) {
    return BadgeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isEarned: isEarned ?? this.isEarned,
      progress: progress ?? this.progress,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BadgeEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.iconName == iconName &&
        other.isEarned == isEarned &&
        other.progress == progress;
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, iconName, isEarned, progress);
}

/// Aggregate study statistics. Surfaced on the profile screen and
/// consumed by the Statistics screen (Phase 18).
@immutable
class StudyStatsEntity {
  const StudyStatsEntity({
    required this.totalQuizzesTaken,
    required this.totalQuestionsAnswered,
    required this.totalCorrectAnswers,
    required this.totalStudyMinutes,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.averageAccuracy,
    required this.lastActiveAt,
  });

  final int totalQuizzesTaken;
  final int totalQuestionsAnswered;
  final int totalCorrectAnswers;
  final int totalStudyMinutes;
  final int currentStreakDays;
  final int longestStreakDays;

  /// 0.0 — 1.0
  final double averageAccuracy;
  final DateTime lastActiveAt;

  double get accuracy =>
      totalQuestionsAnswered == 0
          ? 0
          : totalCorrectAnswers / totalQuestionsAnswered;

  StudyStatsEntity copyWith({
    int? totalQuizzesTaken,
    int? totalQuestionsAnswered,
    int? totalCorrectAnswers,
    int? totalStudyMinutes,
    int? currentStreakDays,
    int? longestStreakDays,
    double? averageAccuracy,
    DateTime? lastActiveAt,
  }) {
    return StudyStatsEntity(
      totalQuizzesTaken: totalQuizzesTaken ?? this.totalQuizzesTaken,
      totalQuestionsAnswered:
          totalQuestionsAnswered ?? this.totalQuestionsAnswered,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      longestStreakDays: longestStreakDays ?? this.longestStreakDays,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudyStatsEntity &&
        other.totalQuizzesTaken == totalQuizzesTaken &&
        other.totalQuestionsAnswered == totalQuestionsAnswered &&
        other.totalCorrectAnswers == totalCorrectAnswers &&
        other.totalStudyMinutes == totalStudyMinutes &&
        other.currentStreakDays == currentStreakDays &&
        other.longestStreakDays == longestStreakDays &&
        other.averageAccuracy == averageAccuracy &&
        other.lastActiveAt == lastActiveAt;
  }

  @override
  int get hashCode => Object.hash(
        totalQuizzesTaken,
        totalQuestionsAnswered,
        totalCorrectAnswers,
        totalStudyMinutes,
        currentStreakDays,
        longestStreakDays,
        averageAccuracy,
        lastActiveAt,
      );
}

/// Aggregate gamification counters — XP, coins, energy, level, rank.
@immutable
class ProgressionEntity {
  const ProgressionEntity({
    required this.totalXp,
    required this.level,
    required this.xpInLevel,
    required this.xpForNextLevel,
    required this.coins,
    required this.energy,
    required this.maxEnergy,
    required this.energyRechargeSecondsRemaining,
    required this.rank,
    required this.streakDays,
    required this.isStreakAtRisk,
  });

  final int totalXp;
  final int level;
  final int xpInLevel;
  final int xpForNextLevel;
  final int coins;
  final int energy;
  final int maxEnergy;
  final int energyRechargeSecondsRemaining;
  final ProfileRank rank;
  final int streakDays;
  final bool isStreakAtRisk;

  double get xpProgress {
    if (xpForNextLevel <= 0) return 0;
    return (xpInLevel / xpForNextLevel).clamp(0.0, 1.0);
  }

  double get energyProgress {
    if (maxEnergy <= 0) return 0;
    return (energy / maxEnergy).clamp(0.0, 1.0);
  }

  ProgressionEntity copyWith({
    int? totalXp,
    int? level,
    int? xpInLevel,
    int? xpForNextLevel,
    int? coins,
    int? energy,
    int? maxEnergy,
    int? energyRechargeSecondsRemaining,
    ProfileRank? rank,
    int? streakDays,
    bool? isStreakAtRisk,
  }) {
    return ProgressionEntity(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      xpInLevel: xpInLevel ?? this.xpInLevel,
      xpForNextLevel: xpForNextLevel ?? this.xpForNextLevel,
      coins: coins ?? this.coins,
      energy: energy ?? this.energy,
      maxEnergy: maxEnergy ?? this.maxEnergy,
      energyRechargeSecondsRemaining: energyRechargeSecondsRemaining ??
          this.energyRechargeSecondsRemaining,
      rank: rank ?? this.rank,
      streakDays: streakDays ?? this.streakDays,
      isStreakAtRisk: isStreakAtRisk ?? this.isStreakAtRisk,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProgressionEntity &&
        other.totalXp == totalXp &&
        other.level == level &&
        other.xpInLevel == xpInLevel &&
        other.xpForNextLevel == xpForNextLevel &&
        other.coins == coins &&
        other.energy == energy &&
        other.maxEnergy == maxEnergy &&
        other.energyRechargeSecondsRemaining == energyRechargeSecondsRemaining &&
        other.rank == rank &&
        other.streakDays == streakDays &&
        other.isStreakAtRisk == isStreakAtRisk;
  }

  @override
  int get hashCode => Object.hash(
        totalXp,
        level,
        xpInLevel,
        xpForNextLevel,
        coins,
        energy,
        maxEnergy,
        energyRechargeSecondsRemaining,
        rank,
        streakDays,
        isStreakAtRisk,
      );
}

/// Editable user profile (passed to [ProfileRepository.updateProfile]).
@immutable
class ProfileUpdateEntity {
  const ProfileUpdateEntity({
    required this.displayName,
    required this.university,
    required this.examTrack,
    required this.language,
    this.district = '',
    this.bio = '',
  });

  final String displayName;
  final String university;
  final ExamTrack examTrack;
  final ProfileLanguage language;
  final String district;
  final String bio;
}

/// Root profile entity — the single source of truth for everything
/// the Profile screen and Playground HUD render.
@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.emailVerified,
    required this.phoneNumber,
    required this.university,
    required this.examTrack,
    required this.language,
    required this.role,
    required this.district,
    required this.bio,
    required this.photoUrl,
    required this.progression,
    required this.studyStats,
    required this.achievements,
    required this.badges,
    required this.quickActions,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  final String id;
  final String email;
  final String displayName;
  final bool emailVerified;
  final String phoneNumber;
  final String university;
  final ExamTrack examTrack;
  final ProfileLanguage language;
  final String role;
  final String district;
  final String bio;
  final String photoUrl;
  final ProgressionEntity progression;
  final StudyStatsEntity studyStats;
  final List<AchievementEntity> achievements;
  final List<BadgeEntity> badges;
  final List<String> quickActions;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  /// Initials derived from the display name (used as a fallback when
  /// no avatar photo is set).
  String get initials {
    final List<String> parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    bool? emailVerified,
    String? phoneNumber,
    String? university,
    ExamTrack? examTrack,
    ProfileLanguage? language,
    String? role,
    String? district,
    String? bio,
    String? photoUrl,
    ProgressionEntity? progression,
    StudyStatsEntity? studyStats,
    List<AchievementEntity>? achievements,
    List<BadgeEntity>? badges,
    List<String>? quickActions,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      university: university ?? this.university,
      examTrack: examTrack ?? this.examTrack,
      language: language ?? this.language,
      role: role ?? this.role,
      district: district ?? this.district,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      progression: progression ?? this.progression,
      studyStats: studyStats ?? this.studyStats,
      achievements: achievements ?? this.achievements,
      badges: badges ?? this.badges,
      quickActions: quickActions ?? this.quickActions,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName &&
        other.emailVerified == emailVerified &&
        other.phoneNumber == phoneNumber &&
        other.university == university &&
        other.examTrack == examTrack &&
        other.language == language &&
        other.role == role &&
        other.district == district &&
        other.bio == bio &&
        other.photoUrl == photoUrl &&
        other.progression == progression &&
        other.studyStats == studyStats &&
        other.createdAt == createdAt &&
        other.lastUpdatedAt == lastUpdatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        email,
        displayName,
        emailVerified,
        phoneNumber,
        university,
        examTrack,
        language,
        role,
        district,
        bio,
        photoUrl,
        progression,
        studyStats,
        createdAt,
        lastUpdatedAt,
      );
}