import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_background.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_camera.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_legend.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_map.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_map_preview_data.dart';
import 'playground_preview_tile.dart';

class PlaygroundMapPreview extends StatefulWidget {
  const PlaygroundMapPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  State<PlaygroundMapPreview> createState() => _PlaygroundMapPreviewState();
}

class _PlaygroundMapPreviewState extends State<PlaygroundMapPreview> {
  late final PlaygroundCamera _camera = PlaygroundCamera();

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final biome = PlaygroundMapPreviewFixtures.resolveBiome(
      widget.provider.playgroundMapBiome,
    );
    final focusTarget = PlaygroundMapPreviewFixtures.resolveMapFocusTarget(
      widget.provider.playgroundMapFocusTarget,
    );
    final showLegend = widget.provider.playgroundMapShowLegend;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Map Composition', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            PlaygroundPreviewTile(
              mode: widget.provider.playgroundMapBrightness,
              padding: EdgeInsets.zero,
              child: _MapStage(
                camera: _camera,
                biome: biome,
                focusTarget: focusTarget,
                showLegend: showLegend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapStage extends StatelessWidget {
  const _MapStage({
    required this.camera,
    required this.biome,
    required this.focusTarget,
    required this.showLegend,
  });

  final PlaygroundCamera camera;
  final PlaygroundBiome biome;
  final Offset? focusTarget;
  final bool showLegend;

  @override
  Widget build(BuildContext context) {
    final segments = PlaygroundMapPreviewFixtures.buildPathSegments();
    final nodes = PlaygroundMapPreviewFixtures.buildNodes();
    final buildings = PlaygroundMapPreviewFixtures.buildBuildings();
    final decorations = PlaygroundMapPreviewFixtures.buildDecorations();
    return SizedBox(
      width: PlaygroundMapPreviewFixtures.stageSize.width,
      height: PlaygroundMapPreviewFixtures.stageSize.height,
      child: ClipRect(
        child: PlaygroundMap(
          contentSize: PlaygroundMapPreviewFixtures.contentSize,
          biome: biome,
          camera: camera,
          segments: segments,
          nodes: nodes,
          buildings: buildings,
          decorations: decorations,
          focusTarget: focusTarget,
          legendItems: showLegend
              ? PlaygroundLegendDefaults.defaultItems(
                  isDark: Theme.of(context).brightness == Brightness.dark,
                )
              : null,
        ),
      ),
    );
  }
}
