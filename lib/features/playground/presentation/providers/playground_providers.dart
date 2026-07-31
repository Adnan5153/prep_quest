import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/presentation/providers/profile_providers.dart';
import 'playground_provider.dart';

/// Riverpod owner for the legacy [PlaygroundProvider].
///
/// Surfaced as a [StateNotifierProvider] so listeners can rebuild
/// when a quiz completes and the playground progress mutates. The
/// underlying `PlaygroundProvider` is a `ChangeNotifier` for
/// backward-compatibility with the existing widget tree.
final playgroundProgressProvider =
    StateNotifierProvider<PlaygroundNotifier, PlaygroundProgress>((ref) {
      final initial = ref.watch(_bootstrapProgressProvider);
      return PlaygroundNotifier(initial);
    });

/// Reads the current profile (when ready) and seeds the playground
/// progress with the user's XP / coins / streak / completed nodes.
final _bootstrapProgressProvider = Provider<PlaygroundProgress>((ref) {
  final profileState = ref.watch(profileControllerProvider);
  final profile = profileState.profile;
  if (profile == null) return PlaygroundProgress.seed;
  return PlaygroundProgress(
    totalXp: profile.progression.totalXp,
    userLevel: profile.progression.level,
    xpInLevel: profile.progression.xpInLevel,
    xpForNextLevel: profile.progression.xpForNextLevel,
    coins: profile.progression.coins,
    energy: profile.progression.energy,
    maxEnergy: profile.progression.maxEnergy,
    streakDays: profile.progression.streakDays,
    completedLevelIds: const <String>[],
    unlockedLevelIds: const <String>[],
    activeLevelId: null,
    lastReward: PlaygroundRewardEvent.empty,
  );
});

/// StateNotifier wrapper that exposes the playground's progress
/// mutations to the rest of the app.
class PlaygroundNotifier extends StateNotifier<PlaygroundProgress> {
  PlaygroundNotifier(super.initial);

  final PlaygroundProvider _provider = PlaygroundProvider(
    initial: PlaygroundProgress.seed,
  );

  PlaygroundProgress get progress => state;

  void markCompleted(String nodeId) {
    _provider.replace(progress);
    _provider.markCompleted(nodeId);
    state = _provider.progress;
  }

  void grantRewardChest(String nodeId) {
    _provider.replace(progress);
    _provider.grantRewardChest(nodeId);
    state = _provider.progress;
  }

  void grantBossReward(String nodeId) {
    _provider.replace(progress);
    _provider.grantBossReward(nodeId);
    state = _provider.progress;
  }

  void focusNode(String nodeId) {
    _provider.replace(progress);
    _provider.focusNode(nodeId);
    state = _provider.progress;
  }

  void consumeReward() {
    _provider.replace(progress);
    _provider.consumeReward();
    state = _provider.progress;
  }

  void reset() {
    _provider.reset();
    state = _provider.progress;
  }

  /// Replaces the entire progress snapshot. Used by the
  /// [UserProgressService] when applying a quiz completion.
  void replace(PlaygroundProgress next) {
    _provider.replace(next);
    state = _provider.progress;
  }

  /// Phase 57 — feeds the canonical Quiz Hub category ordering into
  /// the legacy [PlaygroundProvider] so [markCompleted] and
  /// [grantBossReward] can resolve "next node" against real category
  /// ids instead of the previous synthetic `node-N` scheme.
  void setOrderedNodeIds(List<String> ids) {
    _provider.setOrderedNodeIds(ids);
  }
}
