/// Pure domain description of a single node on the Playground world map.
///
/// Mirrors the presentation-only `WorldStepKind` enum used by the
/// procedural layout so the existing layout pipeline can consume the
/// data source without modification.
library;

/// Logical kind of a node — what the player experiences when it opens.
enum NodeKind {
  /// A regular lesson/level node.
  regular,

  /// A bonus reward (chest) node.
  reward,

  /// A milestone that doubles as a building anchor (Library / Academy).
  milestone,

  /// A boss-gated challenge.
  boss,
}

/// Status of a node from the perspective of the active user.
enum NodeStatus {
  /// Player cannot reach it yet.
  locked,

  /// Available to start.
  unlocked,

  /// Started; partial progress.
  inProgress,

  /// Player has finished it (and its reward, if any, was claimed).
  completed,
}

class NodeEntity {
  const NodeEntity({
    required this.id,
    required this.worldId,
    required this.index,
    required this.title,
    this.subtitle = '',
    required this.kind,
    required this.status,
    this.levelId,
    this.buildingId,
    this.prerequisiteNodeIds = const <String>[],
    this.xpReward = 0,
    this.coinReward = 0,
    this.challengeGoalCount = 0,
    this.challengeCompletedCount = 0,
    this.isRewardClaimed = false,
  });

  final String id;
  final String worldId;
  final int index;
  final String title;
  final String subtitle;
  final NodeKind kind;
  final NodeStatus status;

  /// Optional pointer to a populated [LevelEntity] when this node has
  /// challenges to play.
  final String? levelId;

  /// Optional pointer to the building overlay rendered on this node
  /// (Academy / Library / Mission).
  final String? buildingId;

  /// Other node ids the player must complete before this node unlocks.
  final List<String> prerequisiteNodeIds;

  /// XP granted on completion.
  final int xpReward;

  /// Coins granted on completion.
  final int coinReward;

  /// Total number of challenges inside the level. `0` means there are
  /// no challenges (e.g. reward / milestone nodes).
  final int challengeGoalCount;

  /// Number of challenges the player already finished.
  final int challengeCompletedCount;

  /// True once the post-completion reward has been claimed.
  final bool isRewardClaimed;

  bool get isLocked => status == NodeStatus.locked;
  bool get isUnlocked => status == NodeStatus.unlocked;
  bool get isInProgress => status == NodeStatus.inProgress;
  bool get isCompleted => status == NodeStatus.completed;
  bool get isBoss => kind == NodeKind.boss;
  bool get isReward => kind == NodeKind.reward;
  bool get isMilestone => kind == NodeKind.milestone;

  /// True when the node has any challenges remaining. Reward/milestone
  /// nodes always report `false`.
  bool get hasChallenges =>
      challengeGoalCount > 0 && challengeCompletedCount < challengeGoalCount;

  double get challengeProgress {
    if (challengeGoalCount <= 0) return 0;
    return (challengeCompletedCount / challengeGoalCount).clamp(0.0, 1.0);
  }

  NodeEntity copyWith({
    String? id,
    String? worldId,
    int? index,
    String? title,
    String? subtitle,
    NodeKind? kind,
    NodeStatus? status,
    String? levelId,
    String? buildingId,
    List<String>? prerequisiteNodeIds,
    int? xpReward,
    int? coinReward,
    int? challengeGoalCount,
    int? challengeCompletedCount,
    bool? isRewardClaimed,
  }) {
    return NodeEntity(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      index: index ?? this.index,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      levelId: levelId ?? this.levelId,
      buildingId: buildingId ?? this.buildingId,
      prerequisiteNodeIds:
          prerequisiteNodeIds ?? this.prerequisiteNodeIds,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
      challengeGoalCount: challengeGoalCount ?? this.challengeGoalCount,
      challengeCompletedCount:
          challengeCompletedCount ?? this.challengeCompletedCount,
      isRewardClaimed: isRewardClaimed ?? this.isRewardClaimed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NodeEntity &&
        other.id == id &&
        other.worldId == worldId &&
        other.index == index &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.kind == kind &&
        other.status == status &&
        other.levelId == levelId &&
        other.buildingId == buildingId &&
        other.prerequisiteNodeIds == prerequisiteNodeIds &&
        other.xpReward == xpReward &&
        other.coinReward == coinReward &&
        other.challengeGoalCount == challengeGoalCount &&
        other.challengeCompletedCount == challengeCompletedCount &&
        other.isRewardClaimed == isRewardClaimed;
  }

  @override
  int get hashCode => Object.hash(
        id,
        worldId,
        index,
        title,
        subtitle,
        kind,
        status,
        levelId,
        buildingId,
        prerequisiteNodeIds,
        xpReward,
        coinReward,
        challengeGoalCount,
        challengeCompletedCount,
        isRewardClaimed,
      );
}