import 'node_entity.dart';

/// A whole Playground world map and its nodes.
class WorldEntity {
  const WorldEntity({
    required this.id,
    required this.title,
    required this.nodes,
    this.activeNodeId,
    this.lastFocusedNodeId,
  });

  final String id;
  final String title;
  final List<NodeEntity> nodes;
  final String? activeNodeId;
  final String? lastFocusedNodeId;

  NodeEntity? nodeById(String id) {
    for (final NodeEntity n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  /// Returns the nodes that the player can currently reach. A node is
  /// considered "next" if it is still locked but every prerequisite has
  /// been completed.
  List<NodeEntity> get nextUnlockedCandidates {
    final List<NodeEntity> completed =
        nodes.where((NodeEntity n) => n.isCompleted).toList();
    final List<String> completedIds =
        completed.map((NodeEntity n) => n.id).toList(growable: false);

    final List<NodeEntity> out = <NodeEntity>[];
    for (final NodeEntity n in nodes) {
      if (!n.isLocked) continue;
      final List<String> prereqs = n.prerequisiteNodeIds;
      if (prereqs.isEmpty) {
        out.add(n);
        continue;
      }
      final bool allDone =
          prereqs.every(completedIds.contains);
      if (allDone) out.add(n);
    }
    return out;
  }

  /// First node that is in-progress; falls back to first unlocked node;
  /// falls back to first node.
  NodeEntity? get currentNode {
    for (final NodeEntity n in nodes) {
      if (n.isInProgress) return n;
    }
    for (final NodeEntity n in nodes) {
      if (n.isUnlocked) return n;
    }
    return nodes.isEmpty ? null : nodes.first;
  }

  /// Percentage of nodes completed (0..1).
  double get completionRatio {
    if (nodes.isEmpty) return 0;
    final int done =
        nodes.where((NodeEntity n) => n.isCompleted).length;
    return done / nodes.length;
  }

  WorldEntity copyWith({
    String? id,
    String? title,
    List<NodeEntity>? nodes,
    String? activeNodeId,
    String? lastFocusedNodeId,
  }) {
    return WorldEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      nodes: nodes ?? this.nodes,
      activeNodeId: activeNodeId ?? this.activeNodeId,
      lastFocusedNodeId: lastFocusedNodeId ?? this.lastFocusedNodeId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorldEntity &&
        other.id == id &&
        other.title == title &&
        other.nodes == nodes &&
        other.activeNodeId == activeNodeId &&
        other.lastFocusedNodeId == lastFocusedNodeId;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, nodes, activeNodeId, lastFocusedNodeId);
}