import 'package:flutter/material.dart';

import '../constants/playground_constants.dart';
import '../utils/world_layout.dart';

/// Display-time helpers shared between Playground screens.
class PlaygroundHelpers {
  const PlaygroundHelpers._();

  /// Determines whether a given world node is interactive based on the
  /// current progression state.
  static bool isNodeInteractive({
    required WorldNodePlacement node,
    required bool isUnlocked,
    required bool isCompleted,
  }) {
    if (!isUnlocked) return false;
    if (isCompleted) return false;
    return true;
  }

  /// Returns the requirement dialog title for a locked node.
  static String lockedTitle(String nodeTitle) =>
      'Complete previous levels to unlock $nodeTitle';

  /// Returns the requirement body text for a locked boss gate.
  static String bossGateLockedBody({required int requiredLevel}) {
    return 'You must reach Level $requiredLevel before this boss opens.';
  }

  /// Convenience for resolving a node by string id from a list of placements.
  static WorldNodePlacement? findNode(
    Iterable<WorldNodePlacement> nodes,
    String? id,
  ) {
    if (id == null) return null;
    for (final node in nodes) {
      if (node.id == id) return node;
    }
    return null;
  }

  /// Determines the camera focus target for a given node placement. Falls
  /// back to the world center when no node is supplied.
  static Offset focusTargetFor(
    WorldNodePlacement? node, {
    required Size worldSize,
  }) {
    if (node == null) return worldSize.center(Offset.zero);
    return node.position + const Offset(32.0, 32.0);
  }

  /// Maps a node completion to a reward popup color tone.
  static PlaygroundRarity rewardRarityFor(WorldStepKind kind) {
    switch (kind) {
      case WorldStepKind.boss:
        return PlaygroundRarity.legendary;
      case WorldStepKind.milestone:
        return PlaygroundRarity.epic;
      case WorldStepKind.reward:
        return PlaygroundRarity.rare;
      case WorldStepKind.regular:
        return PlaygroundRarity.common;
    }
  }
}