import 'package:flutter/material.dart';

import '../utils/world_layout.dart';

/// Result of [WorldMapBuilder.build]: a fully configured world ready to
/// hand to `PlaygroundMap`.
@immutable
class WorldMapBlueprint {
  const WorldMapBlueprint({
    required this.layout,
    required this.activeNodeId,
    required this.unlockedNodeIds,
    required this.completedNodeIds,
  });

  final WorldLayoutSpec layout;
  final String? activeNodeId;
  final Set<String> unlockedNodeIds;
  final Set<String> completedNodeIds;
}

/// Translates progression data into a [WorldLayoutSpec] that reflects the
/// current state of the world.
class WorldMapBuilder {
  const WorldMapBuilder._();

  static WorldMapBlueprint build({
    required List<WorldStep> steps,
    required String? activeNodeId,
    required Iterable<String> unlockedNodeIds,
    required Iterable<String> completedNodeIds,
    int seed = 23,
    double? worldWidth,
  }) {
    final unlockedSet = unlockedNodeIds.toSet();
    final completedSet = completedNodeIds.toSet();

    final completedByIndex = <int>{
      for (var i = 0; i < steps.length; i++)
        if (completedSet.contains('node-$i')) i,
    };

    final activeIndex = _resolveActiveIndex(steps, activeNodeId);

    final adjustedSteps = <WorldStep>[
      for (var i = 0; i < steps.length; i++)
        WorldStep(
          kind: steps[i].kind,
          subtitle: steps[i].subtitle,
          isCompleted: completedByIndex.contains(i),
        ),
    ];

    final layout = WorldLayout.build(
      steps: adjustedSteps,
      activeIndex: activeIndex,
      seed: seed,
      worldWidth: worldWidth,
    );

    return WorldMapBlueprint(
      layout: layout,
      activeNodeId: activeNodeId,
      unlockedNodeIds: unlockedSet,
      completedNodeIds: completedSet,
    );
  }

  static int _resolveActiveIndex(List<WorldStep> steps, String? activeNodeId) {
    if (activeNodeId == null) return 0;
    const prefix = 'node-';
    if (!activeNodeId.startsWith(prefix)) return 0;
    final raw = activeNodeId.substring(prefix.length);
    final parsed = int.tryParse(raw);
    if (parsed == null) return 0;
    return parsed.clamp(0, steps.length - 1);
  }
}