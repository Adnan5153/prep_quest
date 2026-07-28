import 'package:flutter/material.dart';

import '../../../../../../../../features/playground/presentation/constants/playground_sizes.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/academy_building.dart';
import '../../../../../../../../features/playground/presentation/widgets/buildings/library_building.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/bush.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/flag.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/river.dart';
import '../../../../../../../../features/playground/presentation/widgets/decorations/tree.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_background.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_map.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_badge.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_icon.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_progress_indicator.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/node_ring.dart';
import '../../../../../../../../features/playground/presentation/widgets/nodes/playground_node.dart';
import '../../../../../../../../features/playground/presentation/widgets/painters/playground_path_painter.dart';

class PlaygroundMapPreviewFixtures {
  const PlaygroundMapPreviewFixtures._();

  static const Size contentSize = Size(960, 1280);
  static const Size stageSize = Size(360, 480);

  static const Offset startLandmark = Offset(160, 220);
  static const Offset centerLandmark = Offset(480, 640);
  static const Offset endLandmark = Offset(800, 1080);
  static const Offset currentNodeLandmark = Offset(360, 520);
  static const Offset intermediateLandmark = Offset(580, 760);
  static const Offset bossNodeLandmark = Offset(760, 980);
  static const Offset academyLandmark = Offset(220, 760);
  static const Offset libraryLandmark = Offset(700, 480);

  static PlaygroundBiome resolveBiome(String value) {
    switch (value) {
      case 'forest':
        return PlaygroundBiome.forest;
      case 'desert':
        return PlaygroundBiome.desert;
      case 'snow':
        return PlaygroundBiome.snow;
      case 'volcanic':
        return PlaygroundBiome.volcanic;
      default:
        return PlaygroundBiome.meadow;
    }
  }

  static Offset? resolveMapFocusTarget(String value) {
    switch (value) {
      case 'current':
        return currentNodeLandmark;
      case 'boss':
        return bossNodeLandmark;
      default:
        return null;
    }
  }

  static Offset resolveScrollViewFocusTarget(String value) {
    switch (value) {
      case 'start':
        return startLandmark;
      case 'end':
        return endLandmark;
      default:
        return centerLandmark;
    }
  }

  static Offset resolveCameraFocusTarget(String value, Size content) {
    switch (value) {
      case 'start':
        return startLandmark;
      case 'end':
        return endLandmark;
      default:
        return content.center(Offset.zero);
    }
  }

  static List<PlaygroundPathSegment> buildPathSegments() {
    return <PlaygroundPathSegment>[
      PlaygroundPathSegment(
        start: startLandmark,
        end: currentNodeLandmark,
        state: PlaygroundPathSegmentState.completed,
      ),
      PlaygroundPathSegment(
        start: currentNodeLandmark,
        end: intermediateLandmark,
        state: PlaygroundPathSegmentState.active,
      ),
      PlaygroundPathSegment(
        start: intermediateLandmark,
        end: endLandmark,
        state: PlaygroundPathSegmentState.locked,
      ),
    ];
  }

  static List<PlaygroundMapNode> buildNodes() {
    final currentVisual = NodeVisual(
      kind: NodeIconKind.regular,
      ringState: NodeRingState.inProgress,
      iconKind: NodeIconKind.regular,
      iconVariant: NodeIconVariant.filled,
      progress: 0.42,
      progressState: NodeProgressState.partial,
      title: 'Algebra Foundations',
      subtitle: '12 of 28 mastered',
      badgeKind: NodeBadgeKind.xp,
      isInteractive: true,
      showLabel: true,
      showProgress: true,
      showBadge: true,
    );
    final completedVisual = NodeVisual(
      kind: NodeIconKind.completed,
      ringState: NodeRingState.completed,
      iconKind: NodeIconKind.completed,
      iconVariant: NodeIconVariant.filled,
      progress: 1.0,
      progressState: NodeProgressState.completed,
      title: 'Fractions Lab',
      subtitle: 'Completed',
      badgeKind: NodeBadgeKind.completed,
      isInteractive: true,
      showLabel: true,
      showProgress: true,
      showBadge: true,
    );
    final bossVisual = NodeVisual(
      kind: NodeIconKind.boss,
      ringState: NodeRingState.boss,
      iconKind: NodeIconKind.boss,
      iconVariant: NodeIconVariant.filled,
      progress: 0.66,
      progressState: NodeProgressState.partial,
      title: 'Quadratic Boss Gate',
      subtitle: '3 attempts left',
      badgeKind: NodeBadgeKind.boss,
      isInteractive: true,
      showLabel: true,
      showProgress: true,
      showBadge: true,
    );
    return <PlaygroundMapNode>[
      PlaygroundMapNode(
        id: 'completed',
        position: const Offset(120, 220),
        builder: (_) => PlaygroundNode(visual: completedVisual),
      ),
      PlaygroundMapNode(
        id: 'current',
        position: currentNodeLandmark,
        builder: (_) => PlaygroundNode(visual: currentVisual),
      ),
      PlaygroundMapNode(
        id: 'boss',
        position: bossNodeLandmark,
        builder: (_) => PlaygroundNode(visual: bossVisual),
      ),
    ];
  }

  static List<PlaygroundMapBuilding> buildBuildings() {
    return <PlaygroundMapBuilding>[
      PlaygroundMapBuilding(
        id: 'academy',
        position: academyLandmark,
        builder: (_) => const AcademyBuilding(
          title: 'Knowledge Hub',
          subtitle: 'Theory & lessons',
          progress: 0.45,
          level: 1,
        ),
      ),
      PlaygroundMapBuilding(
        id: 'library',
        position: libraryLandmark,
        builder: (_) => const LibraryBuilding(
          title: 'Archive',
          subtitle: 'Reference library',
          progress: 0.72,
          level: 2,
        ),
      ),
    ];
  }

  static List<PlaygroundMapDecoration> buildDecorations() {
    return <PlaygroundMapDecoration>[
      PlaygroundMapDecoration(
        position: const Offset(80, 360),
        builder: (_) => const Tree(scale: 1.1),
      ),
      PlaygroundMapDecoration(
        position: const Offset(420, 320),
        builder: (_) => const Bush(scale: 1.0),
      ),
      PlaygroundMapDecoration(
        position: const Offset(640, 220),
        builder: (_) => const Tree(scale: 1.2),
      ),
      PlaygroundMapDecoration(
        position: const Offset(820, 700),
        builder: (_) => const Flag(),
      ),
      PlaygroundMapDecoration(
        position: const Offset(60, 920),
        builder: (_) => const River(),
      ),
      PlaygroundMapDecoration(
        position: const Offset(520, 980),
        builder: (_) => const Bush(scale: 0.9),
      ),
      PlaygroundMapDecoration(
        position: const Offset(880, 1100),
        builder: (_) => const Tree(scale: 1.0),
      ),
    ];
  }

  static const double viewportAspectRatio =
      PlaygroundSizes.mapSkyEndY * 1.4 / 1.0;
}
