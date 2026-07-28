import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/painters/playground_path_painter.dart'
    show PlaygroundPathSegment, PlaygroundPathSegmentState;
import '../constants/playground_sizes.dart';

enum WorldStepKind { regular, reward, milestone, boss }

class WorldStep {
  const WorldStep({
    required this.kind,
    this.subtitle = '',
    this.isCompleted = false,
  });

  final WorldStepKind kind;
  final String subtitle;
  final bool isCompleted;
}

enum WorldDecorationKind {
  tree,
  pine,
  bush,
  floweringBush,
  cloud,
  mountain,
  river,
  flag,
  bridge,
}

class WorldDecorationPlacement {
  const WorldDecorationPlacement({
    required this.kind,
    required this.position,
    required this.scale,
  });

  final WorldDecorationKind kind;
  final Offset position;
  final double scale;
}

class WorldMilestonePlacement {
  const WorldMilestonePlacement({
    required this.id,
    required this.kind,
    required this.position,
  });

  final String id;
  final WorldStepKind kind;
  final Offset position;
}

class WorldNodePlacement {
  const WorldNodePlacement({
    required this.id,
    required this.step,
    required this.position,
    required this.isActive,
    required this.isLocked,
  });

  final String id;
  final WorldStep step;
  final Offset position;
  final bool isActive;
  final bool isLocked;
}

class WorldLayoutSpec {
  const WorldLayoutSpec({
    required this.worldSize,
    required this.segments,
    required this.nodes,
    required this.milestones,
    required this.decorations,
    required this.activeNodeIndex,
  });

  final Size worldSize;
  final List<PlaygroundPathSegment> segments;
  final List<WorldNodePlacement> nodes;
  final List<WorldMilestonePlacement> milestones;
  final List<WorldDecorationPlacement> decorations;
  final int activeNodeIndex;

  Offset get focusAnchor {
    if (nodes.isEmpty) return worldSize.center(Offset.zero);
    final n = nodes[activeNodeIndex.clamp(0, nodes.length - 1)];
    return n.position +
        const Offset(
          PlaygroundSizes.nodeDiameter / 2,
          PlaygroundSizes.nodeDiameter / 2,
        );
  }
}

class WorldLayout {
  WorldLayout._();

  static WorldLayoutSpec build({
    required List<WorldStep> steps,
    int activeIndex = 0,
    int seed = 17,
    double? worldWidth,
  }) {
    final layoutWidth = worldWidth ?? PlaygroundSizes.mapWorldWidth;

    if (steps.isEmpty) {
      return WorldLayoutSpec(
        worldSize: Size(
          layoutWidth,
          PlaygroundSizes.worldTopPadding + PlaygroundSizes.worldBottomPadding,
        ),
        segments: const <PlaygroundPathSegment>[],
        nodes: const <WorldNodePlacement>[],
        milestones: const <WorldMilestonePlacement>[],
        decorations: const <WorldDecorationPlacement>[],
        activeNodeIndex: 0,
      );
    }

    final random = math.Random(seed);
    final width = layoutWidth;
    final topPadding = PlaygroundSizes.worldTopPadding;
    final bottomPadding = PlaygroundSizes.worldBottomPadding;
    final midX = width / 2;

    final nodes = <WorldNodePlacement>[];
    final segments = <PlaygroundPathSegment>[];
    final milestones = <WorldMilestonePlacement>[];
    final decorations = <WorldDecorationPlacement>[];

    var cursorY = topPadding;
    var prevAnchor = Offset(midX, cursorY);
    final laneX = <double>[width * 0.32, midX, width * 0.68];
    var lastLane = 1;

    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      final laneDelta = _nextLaneDelta(step.kind, lastLane, random);
      lastLane = (lastLane + laneDelta).clamp(0, 2);
      final nodeX =
          laneX[lastLane] +
          (random.nextDouble() - 0.5) * PlaygroundSizes.worldNodeSway;

      final stepHeight = _stepHeight(step.kind);
      cursorY += stepHeight;

      final nodeY = cursorY;
      final anchor = Offset(nodeX, nodeY);

      final isActive = i == activeIndex;
      final isLocked = i > activeIndex;

      nodes.add(
        WorldNodePlacement(
          id: 'node-$i',
          step: step,
          position:
              anchor +
              const Offset(
                -PlaygroundSizes.nodeDiameter / 2,
                -PlaygroundSizes.nodeDiameter / 2,
              ),
          isActive: isActive,
          isLocked: isLocked,
        ),
      );

      if (i > 0) {
        final a = _curveControl(
          start: prevAnchor,
          end: anchor,
          amplitude:
              PlaygroundSizes.worldCurveAmplitude +
              (random.nextDouble() - 0.5) * PlaygroundSizes.worldCurveJitter,
          seed: random,
        );
        final b = _curveControl(
          start: anchor,
          end: prevAnchor,
          amplitude:
              PlaygroundSizes.worldCurveAmplitude +
              (random.nextDouble() - 0.5) * PlaygroundSizes.worldCurveJitter,
          seed: random,
        );
        segments.add(
          PlaygroundPathSegment(
            start: prevAnchor,
            end: anchor,
            state: step.isCompleted
                ? PlaygroundPathSegmentState.completed
                : isActive
                ? PlaygroundPathSegmentState.active
                : PlaygroundPathSegmentState.locked,
            controlA: a,
            controlB: b,
          ),
        );
      }

      if (step.kind == WorldStepKind.milestone) {
        final side = i.isEven ? -1.0 : 1.0;
        final bx = (midX + side * width * 0.32).clamp(
          40.0,
          width - PlaygroundSizes.buildingAcademyWidth - 40.0,
        );
        milestones.add(
          WorldMilestonePlacement(
            id: 'milestone-$i',
            kind: step.kind,
            position: Offset(bx, anchor.dy - 80),
          ),
        );
      }

      decorations.addAll(
        _clusterAround(
          anchor: anchor,
          kind: step.kind,
          random: random,
          activeIndex: i,
          total: steps.length,
        ),
      );

      prevAnchor = anchor;
    }

    final worldHeight = cursorY + bottomPadding;

    return WorldLayoutSpec(
      worldSize: Size(width, worldHeight),
      segments: segments,
      nodes: nodes,
      milestones: milestones,
      decorations: decorations,
      activeNodeIndex: activeIndex,
    );
  }

  static double _stepHeight(WorldStepKind kind) {
    switch (kind) {
      case WorldStepKind.regular:
        return PlaygroundSizes.worldStepRegular;
      case WorldStepKind.reward:
        return PlaygroundSizes.worldStepReward;
      case WorldStepKind.milestone:
        return PlaygroundSizes.worldStepMilestone;
      case WorldStepKind.boss:
        return PlaygroundSizes.worldStepBoss;
    }
  }

  static int _nextLaneDelta(WorldStepKind kind, int lastLane, math.Random r) {
    if (kind == WorldStepKind.boss) return 0;
    if (kind == WorldStepKind.milestone) {
      final n = r.nextInt(2);
      if (n == 0 && lastLane > 0) return -1;
      if (n == 1 && lastLane < 2) return 1;
      return 0;
    }
    final n = r.nextInt(3);
    if (n == 0 && lastLane > 0) return -1;
    if (n == 1 && lastLane < 2) return 1;
    return 0;
  }

  static Offset _curveControl({
    required Offset start,
    required Offset end,
    required double amplitude,
    required math.Random seed,
  }) {
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = math.sqrt(dx * dx + dy * dy).clamp(1.0, double.infinity);
    final nx = -dy / length;
    final ny = dx / length;
    final offset = amplitude * (seed.nextDouble() < 0.5 ? -1 : 1);
    return Offset(mid.dx + nx * offset, mid.dy + ny * offset);
  }

  static List<WorldDecorationPlacement> _clusterAround({
    required Offset anchor,
    required WorldStepKind kind,
    required math.Random random,
    required int activeIndex,
    required int total,
  }) {
    final out = <WorldDecorationPlacement>[];
    final radius = PlaygroundSizes.worldDecorationRadius;

    if (kind == WorldStepKind.regular || kind == WorldStepKind.reward) {
      final treeCount = 3 + random.nextInt(3);
      for (var i = 0; i < treeCount; i++) {
        final angle = random.nextDouble() * math.pi * 2;
        final r = radius * (0.4 + random.nextDouble() * 0.7);
        final pos = Offset(
          anchor.dx + math.cos(angle) * r,
          anchor.dy + math.sin(angle) * r,
        );
        out.add(
          WorldDecorationPlacement(
            kind: i == 0 ? WorldDecorationKind.pine : WorldDecorationKind.tree,
            position: pos,
            scale: 0.85 + random.nextDouble() * 0.4,
          ),
        );
      }
      final bushCount = 2 + random.nextInt(3);
      for (var i = 0; i < bushCount; i++) {
        final angle = random.nextDouble() * math.pi * 2;
        final r = radius * (0.3 + random.nextDouble() * 0.5);
        out.add(
          WorldDecorationPlacement(
            kind: i == 0
                ? WorldDecorationKind.floweringBush
                : WorldDecorationKind.bush,
            position: Offset(
              anchor.dx + math.cos(angle) * r,
              anchor.dy + math.sin(angle) * r,
            ),
            scale: 0.8 + random.nextDouble() * 0.3,
          ),
        );
      }
    }

    if (kind == WorldStepKind.boss) {
      out.add(
        WorldDecorationPlacement(
          kind: WorldDecorationKind.flag,
          position: anchor + const Offset(60, -40),
          scale: 1.1,
        ),
      );
    }

    if (kind == WorldStepKind.milestone) {
      out.add(
        WorldDecorationPlacement(
          kind: WorldDecorationKind.flag,
          position: anchor + const Offset(50, -30),
          scale: 1.0,
        ),
      );
    }

    if (activeIndex == 0 && anchor.dy < PlaygroundSizes.worldCloudBandEnd) {
      final cx = anchor.dx + (random.nextDouble() - 0.5) * 120;
      out.add(
        WorldDecorationPlacement(
          kind: WorldDecorationKind.cloud,
          position: Offset(cx, 40 + random.nextDouble() * 60),
          scale: 1.0 + random.nextDouble() * 0.6,
        ),
      );
    }

    return out;
  }

  static const List<WorldDecorationKind> cloudKinds = <WorldDecorationKind>[
    WorldDecorationKind.cloud,
  ];

  static bool isCloud(WorldDecorationKind kind) => cloudKinds.contains(kind);

  static bool isMountain(WorldDecorationKind kind) =>
      kind == WorldDecorationKind.mountain;

  static bool isRiver(WorldDecorationKind kind) =>
      kind == WorldDecorationKind.river;

  static bool isBridge(WorldDecorationKind kind) =>
      kind == WorldDecorationKind.bridge;
}
