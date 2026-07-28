import 'challenge_entity.dart';

/// Immutable XP/coin payload granted when a level is completed.
class LevelRewardEntity {
  const LevelRewardEntity({
    this.xp = 0,
    this.coins = 0,
    this.badgeId,
  });

  final int xp;
  final int coins;
  final String? badgeId;

  bool get isEmpty => xp <= 0 && coins <= 0 && badgeId == null;

  LevelRewardEntity copyWith({int? xp, int? coins, String? badgeId}) {
    return LevelRewardEntity(
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      badgeId: badgeId ?? this.badgeId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelRewardEntity &&
        other.xp == xp &&
        other.coins == coins &&
        other.badgeId == badgeId;
  }

  @override
  int get hashCode => Object.hash(xp, coins, badgeId);
}

class LevelEntity {
  const LevelEntity({
    required this.id,
    required this.nodeId,
    required this.title,
    required this.description,
    this.challenges = const <ChallengeEntity>[],
    this.reward = const LevelRewardEntity(),
    this.requiresLevel = 1,
    this.unlocksNodeId,
    this.startedAt,
    this.completedAt,
  });

  final String id;
  final String nodeId;
  final String title;
  final String description;
  final List<ChallengeEntity> challenges;
  final LevelRewardEntity reward;
  final int requiresLevel;
  final String? unlocksNodeId;
  final DateTime? startedAt;
  final DateTime? completedAt;

  bool get isStarted => startedAt != null;
  bool get isCompleted => completedAt != null;
  int get completedChallenges =>
      challenges.where((ChallengeEntity c) => c.isCompleted).length;

  double get progress {
    if (challenges.isEmpty) return isCompleted ? 1 : 0;
    return (completedChallenges / challenges.length).clamp(0.0, 1.0);
  }

  LevelEntity copyWith({
    String? id,
    String? nodeId,
    String? title,
    String? description,
    List<ChallengeEntity>? challenges,
    LevelRewardEntity? reward,
    int? requiresLevel,
    String? unlocksNodeId,
    DateTime? startedAt,
    DateTime? completedAt,
    bool clearStartedAt = false,
    bool clearCompletedAt = false,
  }) {
    return LevelEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelEntity &&
        other.id == id &&
        other.nodeId == nodeId &&
        other.title == title &&
        other.description == description &&
        other.challenges == challenges &&
        other.reward == reward &&
        other.requiresLevel == requiresLevel &&
        other.unlocksNodeId == unlocksNodeId &&
        other.startedAt == startedAt &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        nodeId,
        title,
        description,
        challenges,
        reward,
        requiresLevel,
        unlocksNodeId,
        startedAt,
        completedAt,
      );
}
