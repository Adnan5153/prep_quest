import 'package:flutter/material.dart';

import '../../../../../core/widgets/responsive_builder.dart';
import '../../constants/playground_sizes.dart';
import '../decorations/playground_particle_layer.dart';
import '../painters/playground_path_painter.dart';
import 'playground_background.dart';
import 'playground_camera.dart';
import 'playground_legend.dart';
import 'playground_scroll_view.dart';

class PlaygroundMapNode {
  const PlaygroundMapNode({
    required this.id,
    required this.position,
    required this.builder,
  });

  final String id;
  final Offset position;
  final Widget Function(BuildContext context) builder;
}

class PlaygroundMapBuilding {
  const PlaygroundMapBuilding({
    required this.id,
    required this.position,
    required this.builder,
  });

  final String id;
  final Offset position;
  final Widget Function(BuildContext context) builder;
}

class PlaygroundMapDecoration {
  const PlaygroundMapDecoration({
    required this.position,
    required this.builder,
  });

  final Offset position;
  final Widget Function(BuildContext context) builder;
}

class PlaygroundMapAtmosphericDecoration {
  const PlaygroundMapAtmosphericDecoration({
    required this.position,
    required this.builder,
  });

  final Offset position;
  final Widget Function(BuildContext context) builder;
}

class PlaygroundMap extends StatefulWidget {
  const PlaygroundMap({
    super.key,
    required this.contentSize,
    this.biome = PlaygroundBiome.meadow,
    this.backgroundParallaxOffset = 0.0,
    this.segments = const <PlaygroundPathSegment>[],
    this.nodes = const <PlaygroundMapNode>[],
    this.buildings = const <PlaygroundMapBuilding>[],
    this.decorations = const <PlaygroundMapDecoration>[],
    this.atmosphericDecorations = const <PlaygroundMapAtmosphericDecoration>[],
    this.legendItems,
    this.focusTarget,
    this.camera,
    this.atmosphericOverlay,
  });

  final Size contentSize;
  final PlaygroundBiome biome;
  final double backgroundParallaxOffset;
  final List<PlaygroundPathSegment> segments;
  final List<PlaygroundMapNode> nodes;
  final List<PlaygroundMapBuilding> buildings;
  final List<PlaygroundMapDecoration> decorations;
  final List<PlaygroundMapAtmosphericDecoration> atmosphericDecorations;
  final List<LegendItem>? legendItems;
  final Offset? focusTarget;
  final PlaygroundCamera? camera;
  final Widget? atmosphericOverlay;

  @override
  State<PlaygroundMap> createState() => _PlaygroundMapState();
}

class _PlaygroundMapState extends State<PlaygroundMap>
    with SingleTickerProviderStateMixin {
  late final PlaygroundCamera _camera = widget.camera ?? PlaygroundCamera();

  @override
  void dispose() {
    if (widget.camera == null) {
      _camera.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final legendItems =
        widget.legendItems ??
        PlaygroundLegendDefaults.defaultItems(isDark: isDark);

    return RepaintBoundary(
      child: SizedBox.expand(
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: PlaygroundBackground(
                  biome: widget.biome,
                  parallaxOffset: widget.backgroundParallaxOffset,
                ),
              ),
              if (widget.atmosphericOverlay != null)
                Positioned.fill(child: widget.atmosphericOverlay!),
              _buildAtmosphericDecorationsLayer(),
              Positioned.fill(
                child: PlaygroundScrollView(
                  camera: _camera,
                  contentSize: widget.contentSize,
                  focusTarget: widget.focusTarget,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      _buildPathLayer(isDark),
                      _buildBuildingsLayer(),
                      _buildDecorationsLayer(),
                      _buildParticleLayer(isDark),
                      _buildNodesLayer(),
                    ],
                  ),
                ),
              ),
              if (legendItems.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: PlaygroundLegend(items: legendItems),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathLayer(bool isDark) {
    if (widget.segments.isEmpty) return const SizedBox.shrink();
    return Positioned.fill(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: PlaygroundPathPainter(
            segments: widget.segments,
            isDark: isDark,
          ),
        ),
      ),
    );
  }

  Widget _buildBuildingsLayer() {
    if (widget.buildings.isEmpty) return const SizedBox.shrink();
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          for (final building in widget.buildings)
            Positioned(
              left: building.position.dx,
              top: building.position.dy,
              child: KeyedSubtree(
                key: ValueKey<String>('building-${building.id}'),
                child: building.builder(context),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAtmosphericDecorationsLayer() {
    if (widget.atmosphericDecorations.isEmpty) return const SizedBox.shrink();
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          for (final decoration in widget.atmosphericDecorations)
            Positioned(
              left: decoration.position.dx,
              top: decoration.position.dy,
              child: IgnorePointer(child: decoration.builder(context)),
            ),
        ],
      ),
    );
  }

  Widget _buildDecorationsLayer() {
    if (widget.decorations.isEmpty) return const SizedBox.shrink();
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          for (final decoration in widget.decorations)
            Positioned(
              left: decoration.position.dx,
              top: decoration.position.dy,
              child: decoration.builder(context),
            ),
        ],
      ),
    );
  }

  Widget _buildParticleLayer(bool isDark) {
    if (widget.contentSize.width <= 0 || widget.contentSize.height <= 0) {
      return const SizedBox.shrink();
    }
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.mapTabletScale,
      desktop: PlaygroundSizes.mapDesktopScale,
    );
    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: Transform.scale(
            scale: scale,
            child: PlaygroundParticleLayer(
              bounds: Rect.fromLTWH(
                0,
                0,
                widget.contentSize.width,
                widget.contentSize.height,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNodesLayer() {
    if (widget.nodes.isEmpty) return const SizedBox.shrink();
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          for (final node in widget.nodes)
            Positioned(
              left: node.position.dx,
              top: node.position.dy,
              child: KeyedSubtree(
                key: ValueKey<String>('node-${node.id}'),
                child: node.builder(context),
              ),
            ),
        ],
      ),
    );
  }
}
