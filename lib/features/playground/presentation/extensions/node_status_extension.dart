import '../widgets/nodes/node_ring.dart';
import '../widgets/nodes/node_icon.dart';

/// Bridges the runtime [NodeStatus] enum to its visual representations.
enum NodeStatus { locked, unlocked, inProgress, completed, boss, premium }

extension NodeStatusVisual on NodeStatus {
  NodeRingState get ringState {
    switch (this) {
      case NodeStatus.locked:
        return NodeRingState.locked;
      case NodeStatus.unlocked:
        return NodeRingState.unlocked;
      case NodeStatus.inProgress:
        return NodeRingState.inProgress;
      case NodeStatus.completed:
        return NodeRingState.completed;
      case NodeStatus.boss:
        return NodeRingState.boss;
      case NodeStatus.premium:
        return NodeRingState.premium;
    }
  }

  NodeIconKind get iconKind {
    switch (this) {
      case NodeStatus.locked:
        return NodeIconKind.locked;
      case NodeStatus.boss:
        return NodeIconKind.boss;
      case NodeStatus.premium:
        return NodeIconKind.premium;
      case NodeStatus.unlocked:
      case NodeStatus.inProgress:
      case NodeStatus.completed:
        return NodeIconKind.completed;
    }
  }
}