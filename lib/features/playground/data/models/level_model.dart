import '../../domain/entities/level_entity.dart';
import 'challenge_model.dart';

/// JSON-ready representation of [LevelRewardEntity].
class LevelRewardModel {
  const LevelRewardModel({
    this.xp = 0,
    this.coins = 0,
    this.badgeId,
  });

  final int xp;
  final int coins;
  final String? badgeId;

  LevelRewardEntity toEntity() {
    return LevelRewardEntity(
      xp: xp,
      coins: coins,
      badgeId: badgeId,
    );
  }

  factory LevelRewardModel.fromEntity(LevelRewardEntity entity) {
    return LevelRewardModel(
      xp: entity.xp,
      coins: entity.coins,
      badgeId: entity.badgeId,
    );
  }

  factory LevelRewardModel.fromMap(Map<String, dynamic> map) {
    return LevelRewardModel(
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      badgeId: map['badgeId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'xp': xp,
      'coins': coins,
      'badgeId': badgeId,
    };
  }
}

/// JSON-ready representation of [LevelEntity].
class LevelModel {
  const LevelModel({
    required this.id,
    required this.nodeId,
    required this.title,
    required this.description,
    this.challenges = const <ChallengeModel>[],
    this.reward = const LevelRewardModel(),
    this.requiresLevel = 1,
    this.unlocksNodeId,
    this.startedAt,
    this.completedAt,
  });

  final String id;
  final String nodeId;
  final String title;
  final String description;
  final List<ChallengeModel> challenges;
  final LevelRewardModel reward;
  final int requiresLevel;
  final String? unlocksNodeId;
  final DateTime? startedAt;
  final DateTime? completedAt;

  LevelEntity toEntity() {
    return LevelEntity(
      id: id,
      nodeId: nodeId,
      title: title,
      description: description,
      challenges: challenges.map((ChallengeModel c) => c.toEntity()).toList(
            growable: false,
          ),
      reward: reward.toEntity(),
      requiresLevel: requiresLevel,
      unlocksNodeId: unlocksNodeId,
      startedAt: startedAt,
      completedAt: completedAt,
    );
  }

  factory LevelModel.fromEntity(LevelEntity entity) {
    return LevelModel(
      id: entity.id,
      nodeId: entity.nodeId,
      title: entity.title,
      description: entity.description,
      challenges: entity.challenges
          .map(ChallengeModel.fromEntity)
          .toList(growable: false),
      reward: LevelRewardModel.fromEntity(entity.reward),
      requiresLevel: entity.requiresLevel,
      unlocksNodeId: entity.unlocksNodeId,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
    );
  }

  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'] as String? ?? '',
      nodeId: map['nodeId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      challenges: ((map['challenges'] as List<dynamic>?) ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(ChallengeModel.fromMap)
          .toList(growable: false),
      reward: LevelRewardModel.fromMap(
        (map['reward'] as Map<String, dynamic>?) ?? const <String, dynamic>{},
      ),
      requiresLevel: (map['requiresLevel'] as num?)?.toInt() ?? 1,
      unlocksNodeId: map['unlocksNodeId'] as String?,
      startedAt: map['startedAt'] != null
          ? DateTime.tryParse(map['startedAt'] as String)?.toLocal()
          : null,
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String)?.toLocal()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nodeId': nodeId,
      'title': title,
      'description': description,
      'challenges': challenges.map((ChallengeModel c) => c.toMap()).toList(),
      'reward': reward.toMap(),
      'requiresLevel': requiresLevel,
      'unlocksNodeId': unlocksNodeId,
      'startedAt': startedAt?.toUtc().toIso8601String(),
      'completedAt': completedAt?.toUtc().toIso8601String(),
    };
  }

  LevelModel copyWith({
    String? id,
    String? nodeId,
    String? title,
    String? description,
    List<ChallengeModel>? challenges,
    LevelRewardModel? reward,
    int? requiresLevel,
    String? unlocksNodeId,
    DateTime? startedAt,
    DateTime? completedAt,
    bool clearStartedAt = false,
    bool clearCompletedAt = false,
  }) {
    return LevelModel(
      id: id ?? this.id,
      nodeId: nodeId ?? this.nodeId,
      title: title ?? this.title,
      description: description ?? this.description,
      challenges: challenges ?? this.challenges,
      reward: reward ?? this.reward,
      requiresLevel: requiresLevel ?? this.requiresLevel,
      unlocksNodeId: unlocksNodeId ?? this.unlocksNodeId,
      startedAt: clearStartedAt ? null : (startedAt ?? this.startedAt),
      completedAt:
          clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }
}