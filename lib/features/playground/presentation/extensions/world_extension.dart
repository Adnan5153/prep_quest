import '../utils/world_layout.dart';

/// Convenience accessors for world-level placements used across screens.
extension WorldPlacementList on List<WorldNodePlacement> {
  /// Finds a node by its identifier. Returns `null` if absent.
  WorldNodePlacement? findById(String id) {
    for (final node in this) {
      if (node.id == id) return node;
    }
    return null;
  }

  /// Returns the index of [id] within the list, or `-1` if missing.
  int indexOfId(String id) {
    for (var i = 0; i < length; i++) {
      if (this[i].id == id) return i;
    }
    return -1;
  }
}

extension WorldDecorationList on List<WorldDecorationPlacement> {
  /// Filter decorations matching a particular kind.
  List<WorldDecorationPlacement> ofKind(WorldDecorationKind kind) {
    return where((d) => d.kind == kind).toList(growable: false);
  }
}