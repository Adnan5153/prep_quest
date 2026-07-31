import 'package:flutter/foundation.dart';

import '../../../../core/services/level_curve.dart';

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

  static final PlaygroundProgress seed = PlaygroundProgress(
    totalXp: 0,
    userLevel: 1,
    xpInLevel: 0,
    xpForNextLevel: LevelCurve.defaultCurve.xpRequiredForLevel(1),
    coins: 0,
    energy: 5,
    maxEnergy: 5,
    streakDays: 0,
    // Phase 57 — the seed starts empty. The first category id from
    // Quiz Hub is unlocked on first launch; the player must complete
    // it to unlock the next. Callers that want a non-empty seed can
    // pass [PlaygroundProgress] with explicit values via
    // [PlaygroundProvider] constructor.
    completedLevelIds: <String>[],
    unlockedLevelIds: <String>[],
    activeLevelId: null,
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

  /// Marks [nodeId] as completed and unlocks the next sequential node
  /// (if any). XP / coins are **not** mutated here — those come from
  /// the canonical funnel `UserProgressService.applyQuizCompletion`,
  /// which pushes the updated profile's XP/coins/level into
  /// `playgroundProgressProvider` via [replace].
  ///
  /// Keeping this method free of XP/coin deltas is what guarantees the
  /// Playground UI totalXp/coins always match `UserProfile.progression`
  /// rather than a duplicated, hardcoded source.
  void markCompleted(String nodeId) {
    final completed = <String>[..._progress.completedLevelIds];
    if (!completed.contains(nodeId)) completed.add(nodeId);

    // Phase 57 — the previous `node-N` synthesis was replaced by the
    // canonical Quiz Hub category ordering. We pick the next category
    // id by appending the just-completed node to the locked/unlocked
    // ordering, deduping, and returning whatever follows it. If the
    // caller has supplied an [orderedNodeIds] hint (set via
    // [setOrderedNodeIds]) we prefer that ordering; otherwise we fall
    // back to the completed-ordering heuristic so the playground still
    // makes forward progress when the canonical category list is not
    // yet hydrated.
    final List<String> orderedIds = _orderedNodeIds.isNotEmpty
        ? _orderedNodeIds
        : <String>[...completed];
    final nextNode = _findNextNode(orderedIds, fromId: nodeId);

    final unlocked = <String>[..._progress.unlockedLevelIds];
    if (nextNode != null && !unlocked.contains(nextNode)) {
      unlocked.add(nextNode);
    }

    replace(
      _progress.copyWith(
        completedLevelIds: completed,
        unlockedLevelIds: unlocked,
        activeLevelId: nextNode ?? _progress.activeLevelId,
        lastReward: PlaygroundRewardEvent(
          xp: 0,
          coins: 0,
          sourceId: nodeId,
          kind: PlaygroundRewardKind.level,
        ),
      ),
    );
  }

  /// Records a boss completion and unlocks the next node. XP / coins
  /// remain sourced exclusively from `UserProgressService` — see the
  /// note on [markCompleted].
  void grantBossReward(String nodeId) {
    final completed = <String>[..._progress.completedLevelIds];
    if (!completed.contains(nodeId)) completed.add(nodeId);

    final List<String> orderedIds = _orderedNodeIds.isNotEmpty
        ? _orderedNodeIds
        : <String>[...completed];
    final nextNode = _findNextNode(orderedIds, fromId: nodeId);

    final unlocked = <String>[..._progress.unlockedLevelIds];
    if (nextNode != null && !unlocked.contains(nextNode)) {
      unlocked.add(nextNode);
    }

    replace(
      _progress.copyWith(
        completedLevelIds: completed,
        unlockedLevelIds: unlocked,
        activeLevelId: nextNode ?? _progress.activeLevelId,
        lastReward: PlaygroundRewardEvent(
          xp: 0,
          coins: 0,
          sourceId: nodeId,
          kind: PlaygroundRewardKind.boss,
        ),
      ),
    );
  }

  /// Records a chest opened on [nodeId]. XP / coins are sourced
  /// exclusively from `UserProgressService` — see the note on
  /// [markCompleted].
  void grantRewardChest(String nodeId) {
    replace(
      _progress.copyWith(
        lastReward: PlaygroundRewardEvent(
          xp: 0,
          coins: 0,
          sourceId: nodeId,
          kind: PlaygroundRewardKind.rewardChest,
        ),
      ),
    );
  }

  void consumeReward() {
    if (_progress.lastReward == PlaygroundRewardEvent.empty) return;
    replace(_progress.copyWith(lastReward: PlaygroundRewardEvent.empty));
  }

  /// Marks [nodeId] as the current in-progress node so the camera can focus.
  void focusNode(String nodeId) {
    if (_progress.activeLevelId == nodeId) return;
    replace(_progress.copyWith(activeLevelId: nodeId));
  }

  static String? _findNextNode(
    List<String> orderedIds, {
    required String fromId,
  }) {
    final int idx = orderedIds.indexOf(fromId);
    if (idx < 0 || idx + 1 >= orderedIds.length) return null;
    return orderedIds[idx + 1];
  }

  /// Phase 57 — caller-provided canonical ordering of every node id
  /// on the world map. Populated by [worldStepsProvider] so the legacy
  /// "next node after this one" logic can resolve against real
  /// Quiz Hub category ids instead of a synthetic `node-N` scheme.
  List<String> _orderedNodeIds = const <String>[];

  /// Sets the canonical category ordering used by [markCompleted]
  /// and [grantBossReward] to compute the next-unlocked node.
  void setOrderedNodeIds(List<String> ids) {
    _orderedNodeIds = List<String>.unmodifiable(ids);
  }
}
