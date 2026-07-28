import '../../domain/entities/node_entity.dart';

/// JSON-ready representation of [NodeEntity].
class NodeModel {
  const NodeModel({
    required this.id,
    required this.worldId,
    required this.index,
    required this.title,
    required this.subtitle,
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
  final String? levelId;
  final String? buildingId;
  final List<String> prerequisiteNodeIds;
  final int xpReward;
  final int coinReward;
  final int challengeGoalCount;
  final int challengeCompletedCount;
  final bool isRewardClaimed;

  NodeEntity toEntity() {
    return NodeEntity(
      id: id,
      worldId: worldId,
      index: index,
      title: title,
      subtitle: subtitle,
      kind: kind,
      status: status,
      levelId: levelId,
      buildingId: buildingId,
      prerequisiteNodeIds: List<String>.unmodifiable(prerequisiteNodeIds),
      xpReward: xpReward,
      coinReward: coinReward,
      challengeGoalCount: challengeGoalCount,
      challengeCompletedCount: challengeCompletedCount,
      isRewardClaimed: isRewardClaimed,
    );
  }

  factory NodeModel.fromEntity(NodeEntity entity) {
    return NodeModel(
      id: entity.id,
      worldId: entity.worldId,
      index: entity.index,
      title: entity.title,
      subtitle: entity.subtitle,
      kind: entity.kind,
      status: entity.status,
      levelId: entity.levelId,
      buildingId: entity.buildingId,
      prerequisiteNodeIds:
          List<String>.unmodifiable(entity.prerequisiteNodeIds),
      xpReward: entity.xpReward,
      coinReward: entity.coinReward,
      challengeGoalCount: entity.challengeGoalCount,
      challengeCompletedCount: entity.challengeCompletedCount,
      isRewardClaimed: entity.isRewardClaimed,
    );
  }

  factory NodeModel.fromMap(Map<String, dynamic> map) {
    return NodeModel(
      id: map['id'] as String? ?? '',
      worldId: map['worldId'] as String? ?? '',
      index: (map['index'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      kind: _kindFromString(map['kind'] as String?),
      status: _statusFromString(map['status'] as String?),
      levelId: map['levelId'] as String?,
      buildingId: map['buildingId'] as String?,
      prerequisiteNodeIds: ((map['prerequisiteNodeIds'] as List<dynamic>?) ??
              <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      xpReward: (map['xpReward'] as num?)?.toInt() ?? 0,
      coinReward: (map['coinReward'] as num?)?.toInt() ?? 0,
      challengeGoalCount: (map['challengeGoalCount'] as num?)?.toInt() ?? 0,
      challengeCompletedCount:
          (map['challengeCompletedCount'] as num?)?.toInt() ?? 0,
      isRewardClaimed: map['isRewardClaimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'worldId': worldId,
      'index': index,
      'title': title,
      'subtitle': subtitle,
      'kind': kind.id,
      'status': status.id,
      'levelId': levelId,
      'buildingId': buildingId,
      'prerequisiteNodeIds': prerequisiteNodeIds,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'challengeGoalCount': challengeGoalCount,
      'challengeCompletedCount': challengeCompletedCount,
      'isRewardClaimed': isRewardClaimed,
    };
  }

  NodeModel copyWith({
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
    return NodeModel(
      id: id ?? this.id,
      worldId: worldId ?? this.worldId,
      index: index ?? this.index,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      levelId: levelId ?? this.levelId,
      buildingId: buildingId ?? this.buildingId,
      prerequisiteNodeIds: prerequisiteNodeIds ?? this.prerequisiteNodeIds,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
      challengeGoalCount: challengeGoalCount ?? this.challengeGoalCount,
      challengeCompletedCount:
          challengeCompletedCount ?? this.challengeCompletedCount,
      isRewardClaimed: isRewardClaimed ?? this.isRewardClaimed,
    );
  }

  static NodeKind _kindFromString(String? value) {
    switch (value) {
      case 'reward':
        return NodeKind.reward;
      case 'milestone':
        return NodeKind.milestone;
      case 'boss':
        return NodeKind.boss;
      case 'regular':
      default:
        return NodeKind.regular;
    }
  }

  static NodeStatus _statusFromString(String? value) {
    switch (value) {
      case 'unlocked':
        return NodeStatus.unlocked;
      case 'inProgress':
        return NodeStatus.inProgress;
      case 'completed':
        return NodeStatus.completed;
      case 'locked':
      default:
        return NodeStatus.locked;
    }
  }
}

extension on NodeKind {
  String get id {
    switch (this) {
      case NodeKind.regular:
        return 'regular';
      case NodeKind.reward:
        return 'reward';
      case NodeKind.milestone:
        return 'milestone';
      case NodeKind.boss:
        return 'boss';
    }
  }
}

extension on NodeStatus {
  String get id {
    switch (this) {
      case NodeStatus.locked:
        return 'locked';
      case NodeStatus.unlocked:
        return 'unlocked';
      case NodeStatus.inProgress:
        return 'inProgress';
      case NodeStatus.completed:
        return 'completed';
    }
  }
}