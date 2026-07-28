import '../../domain/entities/world_entity.dart';
import 'node_model.dart';

/// JSON-ready representation of [WorldEntity].
class WorldModel {
  const WorldModel({
    required this.id,
    required this.title,
    this.nodes = const <NodeModel>[],
    this.activeNodeId,
    this.lastFocusedNodeId,
  });

  final String id;
  final String title;
  final List<NodeModel> nodes;
  final String? activeNodeId;
  final String? lastFocusedNodeId;

  WorldEntity toEntity() {
    return WorldEntity(
      id: id,
      title: title,
      nodes: nodes.map((NodeModel n) => n.toEntity()).toList(growable: false),
      activeNodeId: activeNodeId,
      lastFocusedNodeId: lastFocusedNodeId,
    );
  }

  factory WorldModel.fromEntity(WorldEntity entity) {
    return WorldModel(
      id: entity.id,
      title: entity.title,
      nodes: entity.nodes.map(NodeModel.fromEntity).toList(growable: false),
      activeNodeId: entity.activeNodeId,
      lastFocusedNodeId: entity.lastFocusedNodeId,
    );
  }

  factory WorldModel.fromMap(Map<String, dynamic> map) {
    return WorldModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      nodes: ((map['nodes'] as List<dynamic>?) ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(NodeModel.fromMap)
          .toList(growable: false),
      activeNodeId: map['activeNodeId'] as String?,
      lastFocusedNodeId: map['lastFocusedNodeId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'nodes': nodes.map((NodeModel n) => n.toMap()).toList(),
      'activeNodeId': activeNodeId,
      'lastFocusedNodeId': lastFocusedNodeId,
    };
  }

  WorldModel copyWith({
    String? id,
    String? title,
    List<NodeModel>? nodes,
    String? activeNodeId,
    String? lastFocusedNodeId,
    bool clearActiveNodeId = false,
    bool clearLastFocusedNodeId = false,
  }) {
    return WorldModel(
      id: id ?? this.id,
      title: title ?? this.title,
      nodes: nodes ?? this.nodes,
      activeNodeId:
          clearActiveNodeId ? null : (activeNodeId ?? this.activeNodeId),
      lastFocusedNodeId: clearLastFocusedNodeId
          ? null
          : (lastFocusedNodeId ?? this.lastFocusedNodeId),
    );
  }
}