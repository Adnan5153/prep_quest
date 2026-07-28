import '../../../../shared/enums/exam_track.dart';
import '../../domain/entities/user_profile.dart';

/// JSON-ready representation of [UserProfile].
///
/// Models are immutable DTOs. They know how to talk to Firestore / REST
/// but never reach into the UI — the conversion to a domain entity
/// happens at the repository boundary.
class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.emailVerified,
    required this.phoneNumber,
    required this.university,
    required this.examTrackId,
    required this.languageId,
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
  final String examTrackId;
  final String languageId;
  final String role;
  final String district;
  final String bio;
  final String photoUrl;
  final ProgressionModel progression;
  final StudyStatsModel studyStats;
  final List<AchievementModel> achievements;
  final List<BadgeModel> badges;
  final List<String> quickActions;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName,
      emailVerified: emailVerified,
      phoneNumber: phoneNumber,
      university: university,
      examTrack: ExamTrack.fromId(examTrackId),
      language: ProfileLanguage.fromId(languageId),
      role: role,
      district: district,
      bio: bio,
      photoUrl: photoUrl,
      progression: progression.toEntity(),
      studyStats: studyStats.toEntity(),
      achievements: achievements.map((m) => m.toEntity()).toList(),
      badges: badges.map((m) => m.toEntity()).toList(),
      quickActions: List<String>.unmodifiable(quickActions),
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      emailVerified: entity.emailVerified,
      phoneNumber: entity.phoneNumber,
      university: entity.university,
      examTrackId: entity.examTrack.id,
      languageId: entity.language.id,
      role: entity.role,
      district: entity.district,
      bio: entity.bio,
      photoUrl: entity.photoUrl,
      progression: ProgressionModel.fromEntity(entity.progression),
      studyStats: StudyStatsModel.fromEntity(entity.studyStats),
      achievements: entity.achievements
          .map(AchievementModel.fromEntity)
          .toList(growable: false),
      badges:
          entity.badges.map(BadgeModel.fromEntity).toList(growable: false),
      quickActions: List<String>.unmodifiable(entity.quickActions),
      createdAt: entity.createdAt,
      lastUpdatedAt: entity.lastUpdatedAt,
    );
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      emailVerified: map['emailVerified'] as bool? ?? false,
      phoneNumber: map['phoneNumber'] as String? ?? '',
      university: map['university'] as String? ?? '',
      examTrackId: map['examTrackId'] as String? ?? ExamTrack.other.id,
      languageId:
          map['languageId'] as String? ?? ProfileLanguage.english.id,
      role: map['role'] as String? ?? 'free',
      district: map['district'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      photoUrl: map['photoUrl'] as String? ?? '',
      progression: ProgressionModel.fromMap(
        (map['progression'] as Map<String, dynamic>?) ??
            const <String, dynamic>{},
      ),
      studyStats: StudyStatsModel.fromMap(
        (map['studyStats'] as Map<String, dynamic>?) ??
            const <String, dynamic>{},
      ),
      achievements: ((map['achievements'] as List<dynamic>?) ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(AchievementModel.fromMap)
          .toList(growable: false),
      badges: ((map['badges'] as List<dynamic>?) ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(BadgeModel.fromMap)
          .toList(growable: false),
      quickActions: ((map['quickActions'] as List<dynamic>?) ?? <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '')?.toLocal() ??
              DateTime.now(),
      lastUpdatedAt:
          DateTime.tryParse(map['lastUpdatedAt'] as String? ?? '')?.toLocal() ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'displayName': displayName,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'university': university,
      'examTrackId': examTrackId,
      'languageId': languageId,
      'role': role,
      'district': district,
      'bio': bio,
      'photoUrl': photoUrl,
      'progression': progression.toMap(),
      'studyStats': studyStats.toMap(),
      'achievements': achievements.map((a) => a.toMap()).toList(),
      'badges': badges.map((b) => b.toMap()).toList(),
      'quickActions': quickActions,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toUtc().toIso8601String(),
    };
  }
}

class ProgressionModel {
  const ProgressionModel({
    required this.totalXp,
    required this.level,
    required this.xpInLevel,
    required this.xpForNextLevel,
    required this.coins,
    required this.energy,
    required this.maxEnergy,
    required this.energyRechargeSecondsRemaining,
    required this.rankId,
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
  final String rankId;
  final int streakDays;
  final bool isStreakAtRisk;

  ProgressionEntity toEntity() {
    return ProgressionEntity(
      totalXp: totalXp,
      level: level,
      xpInLevel: xpInLevel,
      xpForNextLevel: xpForNextLevel,
      coins: coins,
      energy: energy,
      maxEnergy: maxEnergy,
      energyRechargeSecondsRemaining: energyRechargeSecondsRemaining,
      rank: ProfileRank.fromId(rankId),
      streakDays: streakDays,
      isStreakAtRisk: isStreakAtRisk,
    );
  }

  factory ProgressionModel.fromEntity(ProgressionEntity entity) {
    return ProgressionModel(
      totalXp: entity.totalXp,
      level: entity.level,
      xpInLevel: entity.xpInLevel,
      xpForNextLevel: entity.xpForNextLevel,
      coins: entity.coins,
      energy: entity.energy,
      maxEnergy: entity.maxEnergy,
      energyRechargeSecondsRemaining: entity.energyRechargeSecondsRemaining,
      rankId: entity.rank.id,
      streakDays: entity.streakDays,
      isStreakAtRisk: entity.isStreakAtRisk,
    );
  }

  factory ProgressionModel.fromMap(Map<String, dynamic> map) {
    return ProgressionModel(
      totalXp: (map['totalXp'] as num?)?.toInt() ?? 0,
      level: (map['level'] as num?)?.toInt() ?? 1,
      xpInLevel: (map['xpInLevel'] as num?)?.toInt() ?? 0,
      xpForNextLevel: (map['xpForNextLevel'] as num?)?.toInt() ?? 100,
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      energy: (map['energy'] as num?)?.toInt() ?? 5,
      maxEnergy: (map['maxEnergy'] as num?)?.toInt() ?? 5,
      energyRechargeSecondsRemaining:
          (map['energyRechargeSecondsRemaining'] as num?)?.toInt() ?? 0,
      rankId: map['rankId'] as String? ?? ProfileRank.bronze.id,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 0,
      isStreakAtRisk: map['isStreakAtRisk'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalXp': totalXp,
      'level': level,
      'xpInLevel': xpInLevel,
      'xpForNextLevel': xpForNextLevel,
      'coins': coins,
      'energy': energy,
      'maxEnergy': maxEnergy,
      'energyRechargeSecondsRemaining': energyRechargeSecondsRemaining,
      'rankId': rankId,
      'streakDays': streakDays,
      'isStreakAtRisk': isStreakAtRisk,
    };
  }
}

class StudyStatsModel {
  const StudyStatsModel({
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
  final double averageAccuracy;
  final DateTime lastActiveAt;

  StudyStatsEntity toEntity() {
    return StudyStatsEntity(
      totalQuizzesTaken: totalQuizzesTaken,
      totalQuestionsAnswered: totalQuestionsAnswered,
      totalCorrectAnswers: totalCorrectAnswers,
      totalStudyMinutes: totalStudyMinutes,
      currentStreakDays: currentStreakDays,
      longestStreakDays: longestStreakDays,
      averageAccuracy: averageAccuracy,
      lastActiveAt: lastActiveAt,
    );
  }

  factory StudyStatsModel.fromEntity(StudyStatsEntity entity) {
    return StudyStatsModel(
      totalQuizzesTaken: entity.totalQuizzesTaken,
      totalQuestionsAnswered: entity.totalQuestionsAnswered,
      totalCorrectAnswers: entity.totalCorrectAnswers,
      totalStudyMinutes: entity.totalStudyMinutes,
      currentStreakDays: entity.currentStreakDays,
      longestStreakDays: entity.longestStreakDays,
      averageAccuracy: entity.averageAccuracy,
      lastActiveAt: entity.lastActiveAt,
    );
  }

  factory StudyStatsModel.fromMap(Map<String, dynamic> map) {
    return StudyStatsModel(
      totalQuizzesTaken: (map['totalQuizzesTaken'] as num?)?.toInt() ?? 0,
      totalQuestionsAnswered:
          (map['totalQuestionsAnswered'] as num?)?.toInt() ?? 0,
      totalCorrectAnswers:
          (map['totalCorrectAnswers'] as num?)?.toInt() ?? 0,
      totalStudyMinutes: (map['totalStudyMinutes'] as num?)?.toInt() ?? 0,
      currentStreakDays: (map['currentStreakDays'] as num?)?.toInt() ?? 0,
      longestStreakDays: (map['longestStreakDays'] as num?)?.toInt() ?? 0,
      averageAccuracy: (map['averageAccuracy'] as num?)?.toDouble() ?? 0,
      lastActiveAt:
          DateTime.tryParse(map['lastActiveAt'] as String? ?? '')?.toLocal() ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalQuizzesTaken': totalQuizzesTaken,
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'totalCorrectAnswers': totalCorrectAnswers,
      'totalStudyMinutes': totalStudyMinutes,
      'currentStreakDays': currentStreakDays,
      'longestStreakDays': longestStreakDays,
      'averageAccuracy': averageAccuracy,
      'lastActiveAt': lastActiveAt.toUtc().toIso8601String(),
    };
  }
}

class AchievementModel {
  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.unlockedAt,
    required this.xpReward,
    required this.coinReward,
  });

  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime unlockedAt;
  final int xpReward;
  final int coinReward;

  AchievementEntity toEntity() {
    return AchievementEntity(
      id: id,
      title: title,
      description: description,
      iconName: iconName,
      unlockedAt: unlockedAt,
      xpReward: xpReward,
      coinReward: coinReward,
    );
  }

  factory AchievementModel.fromEntity(AchievementEntity entity) {
    return AchievementModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      iconName: entity.iconName,
      unlockedAt: entity.unlockedAt,
      xpReward: entity.xpReward,
      coinReward: entity.coinReward,
    );
  }

  factory AchievementModel.fromMap(Map<String, dynamic> map) {
    return AchievementModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      iconName: map['iconName'] as String? ?? 'emoji_events',
      unlockedAt:
          DateTime.tryParse(map['unlockedAt'] as String? ?? '')?.toLocal() ??
              DateTime.now(),
      xpReward: (map['xpReward'] as num?)?.toInt() ?? 0,
      coinReward: (map['coinReward'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'unlockedAt': unlockedAt.toUtc().toIso8601String(),
      'xpReward': xpReward,
      'coinReward': coinReward,
    };
  }
}

class BadgeModel {
  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.isEarned,
    required this.progress,
  });

  final String id;
  final String name;
  final String description;
  final String iconName;
  final bool isEarned;
  final double progress;

  BadgeEntity toEntity() {
    return BadgeEntity(
      id: id,
      name: name,
      description: description,
      iconName: iconName,
      isEarned: isEarned,
      progress: progress,
    );
  }

  factory BadgeModel.fromEntity(BadgeEntity entity) {
    return BadgeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      iconName: entity.iconName,
      isEarned: entity.isEarned,
      progress: entity.progress,
    );
  }

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      iconName: map['iconName'] as String? ?? 'workspace_premium',
      isEarned: map['isEarned'] as bool? ?? false,
      progress: (map['progress'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'isEarned': isEarned,
      'progress': progress,
    };
  }
}
