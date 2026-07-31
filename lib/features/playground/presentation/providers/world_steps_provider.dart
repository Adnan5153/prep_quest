import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../category_api/domain/entities/category_entity.dart';
import '../../../category_api/presentation/providers/category_providers.dart';
import '../utils/world_layout.dart';
import 'playground_provider.dart';
import 'playground_providers.dart';

/// Reactive view of every category that should appear on the
/// playground world map.
///
/// Phase 57. Watches [categoriesStreamProvider] (Quiz Hub-backed when
/// the network is reachable, mock-backed otherwise) and merges in
/// [playgroundProgressProvider] so each [WorldStep] knows whether the
/// user has completed it.
///
/// The provider returns a [WorldStepsSnapshot] rather than a raw list
/// so callers always get a deterministic active-node index even when
/// the categories stream is still resolving.
class WorldStepsSnapshot {
  const WorldStepsSnapshot({
    required this.steps,
    required this.activeIndex,
    required this.source,
  });

  final List<WorldStep> steps;

  /// Index of the user's active node within [steps]. When the user has
  /// not completed anything this resolves to `0` (the first node), so
  /// the world map always shows a focused anchor.
  final int activeIndex;

  /// Where the snapshot came from — surfaced for diagnostics.
  final WorldStepsSource source;

  bool get isEmpty => steps.isEmpty;
  bool get isLoading => source == WorldStepsSource.loading;

  static const WorldStepsSnapshot loading = WorldStepsSnapshot(
    steps: <WorldStep>[],
    activeIndex: 0,
    source: WorldStepsSource.loading,
  );
}

enum WorldStepsSource {
  /// Initial state — the categories stream has not emitted yet.
  loading,

  /// Stream emitted at least once but no categories were returned.
  empty,

  /// Mapped from a non-empty categories response.
  categories,

  /// Categories stream errored — fall back to the playground seed so
  /// the UI never goes blank.
  fallbackSeed,
}

/// Single source of truth for the playground world map. The screen
/// watches this provider instead of constructing the layout from a
/// hardcoded `_steps` literal.
final worldStepsProvider = Provider<WorldStepsSnapshot>((ref) {
  final AsyncValue<List<CategoryEntity>> asyncCategories = ref.watch(
    categoriesStreamProvider,
  );

  final List<CategoryEntity> categories = asyncCategories.maybeWhen(
    data: (List<CategoryEntity> data) {
      final List<CategoryEntity> sorted = <CategoryEntity>[...data]
        ..sort(
          (CategoryEntity a, CategoryEntity b) => a.order.compareTo(b.order),
        );
      return sorted;
    },
    orElse: () => const <CategoryEntity>[],
  );

  if (asyncCategories.isLoading && categories.isEmpty) {
    return WorldStepsSnapshot.loading;
  }

  if (categories.isEmpty) {
    if (asyncCategories.hasError) {
      return _seedSnapshot(WorldStepsSource.fallbackSeed);
    }
    return WorldStepsSnapshot(
      steps: const <WorldStep>[],
      activeIndex: 0,
      source: WorldStepsSource.empty,
    );
  }

  // Phase 57 — feed the canonical Quiz Hub category ordering into
  // the legacy [PlaygroundNotifier] so `markCompleted` /
  // `grantBossReward` can resolve the next-unlocked node using
  // real category ids instead of synthesising `node-N`. This is a
  // fire-and-forget side-effect; it does not affect the snapshot
  // returned below and runs on every recomputation of the provider.
  final List<String> orderedIds = <String>[
    for (final CategoryEntity c in categories) c.id,
  ];
  ref.read(playgroundProgressProvider.notifier).setOrderedNodeIds(orderedIds);
  final PlaygroundProgress progress = ref.watch(playgroundProgressProvider);
  final List<String> completedIds = progress.completedLevelIds;
  final List<String> unlockedIds = progress.unlockedLevelIds;
  final String? activeId = progress.activeLevelId;

  final List<WorldStep> steps = <WorldStep>[];
  for (int i = 0; i < categories.length; i++) {
    final CategoryEntity c = categories[i];
    final bool isCompleted = completedIds.contains(c.id);
    final bool isUnlockedAndPassed =
        unlockedIds.contains(c.id) &&
        _isPassedActive(c.id, activeId, categories);
    steps.add(
      WorldStep(
        // Phase 57 — propagate the real Quiz Hub category id so the
        // world map and the routing layer share the same identifier.
        id: c.id,
        kind: _mapKind(c.kind),
        subtitle: c.title,
        isCompleted: isCompleted || isUnlockedAndPassed,
      ),
    );
  }

  int activeIndex = _resolveActiveIndex(activeId, categories);

  return WorldStepsSnapshot(
    steps: steps,
    activeIndex: activeIndex,
    source: WorldStepsSource.categories,
  );
});

bool _isPassedActive(
  String nodeId,
  String? activeId,
  List<CategoryEntity> categories,
) {
  if (activeId == null) return false;
  final int activeIdx = categories.indexWhere(
    (CategoryEntity c) => c.id == activeId,
  );
  if (activeIdx < 0) return false;
  final int nodeIdx = categories.indexWhere(
    (CategoryEntity c) => c.id == nodeId,
  );
  if (nodeIdx < 0) return false;
  return nodeIdx < activeIdx;
}

int _resolveActiveIndex(String? activeId, List<CategoryEntity> categories) {
  if (categories.isEmpty) return 0;
  if (activeId == null) return 0;
  final int idx = categories.indexWhere((CategoryEntity c) => c.id == activeId);
  if (idx < 0) return 0;
  return idx.clamp(0, categories.length - 1);
}

WorldStepKind _mapKind(CategoryNodeKind kind) {
  switch (kind) {
    case CategoryNodeKind.bossGate:
      return WorldStepKind.boss;
    case CategoryNodeKind.reward:
      return WorldStepKind.reward;
    case CategoryNodeKind.milestone:
      return WorldStepKind.milestone;
    case CategoryNodeKind.lesson:
    case CategoryNodeKind.mockTest:
      return WorldStepKind.regular;
  }
}

/// Last-resort fallback used only when the Quiz Hub stream errors
/// AND we have no previous snapshot to fall back on. The ids are
/// synthetic placeholders; tapping a node while the fallback is
/// active will route to /playground (see the router fallback
/// changes) rather than into a live quiz.
WorldStepsSnapshot _seedSnapshot(WorldStepsSource source) {
  return WorldStepsSnapshot(
    steps: const <WorldStep>[
      WorldStep(
        id: 'seed-0',
        kind: WorldStepKind.regular,
        subtitle: 'Foundations',
      ),
      WorldStep(id: 'seed-1', kind: WorldStepKind.regular, subtitle: 'Grammar'),
      WorldStep(
        id: 'seed-2',
        kind: WorldStepKind.regular,
        subtitle: 'Mathematics',
      ),
      WorldStep(
        id: 'seed-3',
        kind: WorldStepKind.milestone,
        subtitle: 'Library',
      ),
      WorldStep(
        id: 'seed-4',
        kind: WorldStepKind.reward,
        subtitle: 'Daily Reward',
      ),
      WorldStep(
        id: 'seed-5',
        kind: WorldStepKind.regular,
        subtitle: 'Mock Test',
      ),
      WorldStep(id: 'seed-6', kind: WorldStepKind.boss, subtitle: 'BCS Boss'),
    ],
    activeIndex: 0,
    source: source,
  );
}
