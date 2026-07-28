import 'package:flutter/foundation.dart';

/// World-step runtime status tracked by [PlaygroundProvider].
@immutable
class PlaygroundNodeStatus {
  const PlaygroundNodeStatus({
    required this.id,
    required this.isCompleted,
    required this.isLocked,
    required this.isActive,
  });

  final String id;
  final bool isCompleted;
  final bool isLocked;

  /// Only one node can be the active (currently in progress) node at a time.
  final bool isActive;

  PlaygroundNodeStatus copyWith({
    bool? isCompleted,
    bool? isLocked,
    bool? isActive,
  }) {
    return PlaygroundNodeStatus(
      id: id,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Snapshot of reward events emitted by level/ challenge completion.
@immutable
class PlaygroundRewardEvent {
  const PlaygroundRewardEvent({
    required this.xp,
    required this.coins,
    this.sourceId,
    this.kind = PlaygroundRewardKind.generic,
    this.consume = true,
  });

  final int xp;
  final int coins;
  final String? sourceId;
  final PlaygroundRewardKind kind;
  final bool consume;

  static const PlaygroundRewardEvent empty = PlaygroundRewardEvent(
    xp: 0,
    coins: 0,
  );
}

enum PlaygroundRewardKind {
  level,
  challenge,
  boss,
  mission,
  rewardChest,
  generic,
}

/// Aggregate progression data used by every layer of the Playground UI.
@immutable
class PlaygroundProgress {
  const PlaygroundProgress({
    required this.totalXp,
    required this.userLevel,
    required this.xpInLevel,
    required this.xpForNextLevel,
    required this.coins,
    required this.energy,
    required this.maxEnergy,
    required this.streakDays,
    required this.completedLevelIds,
    required this.unlockedLevelIds,
    required this.activeLevelId,
    required this.lastReward,
  });

  final int totalXp;
  final int userLevel;
  final int xpInLevel;
  final int xpForNextLevel;
  final int coins;
  final int energy;
  final int maxEnergy;
  final int streakDays;

  /// Ordered list mirroring the world map nodes.
  final List<String> completedLevelIds;
  final List<String> unlockedLevelIds;
  final String? activeLevelId;

  /// Most recent reward granted to the player; consumed by listeners.
  final PlaygroundRewardEvent lastReward;

  bool isCompleted(String nodeId) => completedLevelIds.contains(nodeId);
  bool isUnlocked(String nodeId) => unlockedLevelIds.contains(nodeId);

  static const PlaygroundProgress seed = PlaygroundProgress(
    totalXp: 0,
    userLevel: 1,
    xpInLevel: 0,
    xpForNextLevel: 100,
    coins: 0,
    energy: 5,
    maxEnergy: 5,
    streakDays: 0,
    completedLevelIds: <String>[],
    unlockedLevelIds: <String>['node-0', 'node-2'],
    activeLevelId: 'node-2',
    lastReward: PlaygroundRewardEvent.empty,
  );

  PlaygroundProgress copyWith({
    int? totalXp,
    int? userLevel,
    int? xpInLevel,
    int? xpForNextLevel,
    int? coins,
    int? energy,
    int? maxEnergy,
    int? streakDays,
    List<String>? completedLevelIds,
    List<String>? unlockedLevelIds,
    Object? activeLevelId = _sentinel,
    PlaygroundRewardEvent? lastReward,
  }) {
    return PlaygroundProgress(
      totalXp: totalXp ?? this.totalXp,
      userLevel: userLevel ?? this.userLevel,
      xpInLevel: xpInLevel ?? this.xpInLevel,
      xpForNextLevel: xpForNextLevel ?? this.xpForNextLevel,
      coins: coins ?? this.coins,
      energy: energy ?? this.energy,
      maxEnergy: maxEnergy ?? this.maxEnergy,
      streakDays: streakDays ?? this.streakDays,
      completedLevelIds: completedLevelIds ?? this.completedLevelIds,
      unlockedLevelIds: unlockedLevelIds ?? this.unlockedLevelIds,
      activeLevelId: identical(activeLevelId, _sentinel)
          ? this.activeLevelId
          : activeLevelId as String?,
      lastReward: lastReward ?? this.lastReward,
    );
  }
}

const Object _sentinel = Object();

/// Legacy throw-away controller preserved for backwards compatibility with
/// imports that still expect a `ChangeNotifier`-style provider in the
/// Playground feature.
class PlaygroundProvider extends ChangeNotifier {
  PlaygroundProvider({PlaygroundProgress? initial})
      : _progress = initial ?? PlaygroundProgress.seed;

  PlaygroundProgress _progress;

  PlaygroundProgress get progress => _progress;

  void replace(PlaygroundProgress next) {
    if (_progress == next) return;
    _progress = next;
    notifyListeners();
  }

  void reset() {
    replace(PlaygroundProgress.seed);
  }

  void markCompleted(String nodeId) {
    final completed = <String>[..._progress.completedLevelIds];
    if (!completed.contains(nodeId)) completed.add(nodeId);

    final ids = _progress.completedLevelIds.isEmpty
        ? _allNodeIds()
        : _progress.completedLevelIds;
    final nextNode = _findNextNode(ids, fromId: nodeId);

    final unlocked = <String>[..._progress.unlockedLevelIds];
    if (nextNode != null && !unlocked.contains(nextNode)) {
      unlocked.add(nextNode);
    }

    final reward = PlaygroundRewardEvent(
      xp: 25,
      coins: 10,
      sourceId: nodeId,
      kind: PlaygroundRewardKind.level,
    );

    replace(
      _progress.copyWith(
        completedLevelIds: completed,
        unlockedLevelIds: unlocked,
        activeLevelId: nextNode ?? _progress.activeLevelId,
        totalXp: _progress.totalXp + reward.xp,
        coins: _progress.coins + reward.coins,
        lastReward: reward,
      ),
    );
  }

  void grantBossReward(String nodeId) {
    final completed = <String>[..._progress.completedLevelIds];
    if (!completed.contains(nodeId)) completed.add(nodeId);

    final unlocked = <String>[..._progress.unlockedLevelIds];
    final nextNode = _findNextNode(completed, fromId: nodeId);
    if (nextNode != null && !unlocked.contains(nextNode)) {
      unlocked.add(nextNode);
    }

    final reward = PlaygroundRewardEvent(
      xp: 100,
      coins: 50,
      sourceId: nodeId,
      kind: PlaygroundRewardKind.boss,
    );

    replace(
      _progress.copyWith(
        completedLevelIds: completed,
        unlockedLevelIds: unlocked,
        activeLevelId: nextNode ?? _progress.activeLevelId,
        totalXp: _progress.totalXp + reward.xp,
        coins: _progress.coins + reward.coins,
        lastReward: reward,
      ),
    );
  }

  void grantRewardChest(String nodeId) {
    final reward = PlaygroundRewardEvent(
      xp: 15,
      coins: 5,
      sourceId: nodeId,
      kind: PlaygroundRewardKind.rewardChest,
    );
    replace(
      _progress.copyWith(
        totalXp: _progress.totalXp + reward.xp,
        coins: _progress.coins + reward.coins,
        lastReward: reward,
      ),
    );
  }

  void consumeReward() {
    if (_progress.lastReward == PlaygroundRewardEvent.empty) return;
    replace(
      _progress.copyWith(lastReward: PlaygroundRewardEvent.empty),
    );
  }

  /// Marks [nodeId] as the current in-progress node so the camera can focus.
  void focusNode(String nodeId) {
    if (_progress.activeLevelId == nodeId) return;
    replace(_progress.copyWith(activeLevelId: nodeId));
  }

  static List<String> _allNodeIds() {
    return List<String>.generate(7, (i) => 'node-$i');
  }

  static String? _findNextNode(
    List<String> completedIds, {
    required String fromId,
  }) {
    final prefix = 'node-';
    if (!fromId.startsWith(prefix)) return null;
    final current = int.tryParse(fromId.substring(prefix.length));
    if (current == null) return null;
    final nextId = '$prefix${current + 1}';
    if (completedIds.contains(nextId)) return null;
    return nextId;
  }
}
