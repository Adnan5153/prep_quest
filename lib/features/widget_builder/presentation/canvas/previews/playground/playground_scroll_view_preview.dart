import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/constants/playground_sizes.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_background.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_camera.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_legend.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_scroll_view.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_map_preview_data.dart';
import 'playground_preview_tile.dart';

class PlaygroundScrollViewPreview extends StatefulWidget {
  const PlaygroundScrollViewPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  State<PlaygroundScrollViewPreview> createState() =>
      _PlaygroundScrollViewPreviewState();
}

class _PlaygroundScrollViewPreviewState
    extends State<PlaygroundScrollViewPreview> {
  late final PlaygroundCamera _camera = _createInitialCamera();
  String _lastSyncedFocusTarget = 'none';
  double _lastSyncedZoom = 1.0;

  PlaygroundCamera _createInitialCamera() {
    final zoom = widget.provider.playgroundScrollViewZoom.clamp(
      PlaygroundSizes.mapCameraMinScale,
      PlaygroundSizes.mapCameraMaxScale,
    );
    return PlaygroundCamera(zoom: zoom);
  }

  @override
  void didUpdateWidget(covariant PlaygroundScrollViewPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncFromProvider();
  }

  void _syncFromProvider() {
    final provider = widget.provider;
    final clamped = provider.playgroundScrollViewZoom.clamp(
      PlaygroundSizes.mapCameraMinScale,
      PlaygroundSizes.mapCameraMaxScale,
    );
    if (clamped != _lastSyncedZoom) {
      _lastSyncedZoom = clamped;
      _camera.setZoom(clamped);
    }
    final target = provider.playgroundScrollViewFocusTarget;
    if (target == _lastSyncedFocusTarget) return;
    _lastSyncedFocusTarget = target;
    if (target == 'none') return;
    final offset = PlaygroundMapPreviewFixtures.resolveScrollViewFocusTarget(
      target,
    );
    _camera.focusOn(
      target: offset,
      viewport: PlaygroundMapPreviewFixtures.stageSize,
      content: PlaygroundMapPreviewFixtures.contentSize,
    );
  }

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Map Scroll View', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            PlaygroundPreviewTile(
              mode: widget.provider.playgroundScrollViewBrightness,
              padding: EdgeInsets.zero,
              child: _ScrollStage(camera: _camera),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrollStage extends StatelessWidget {
  const _ScrollStage({required this.camera});
  final PlaygroundCamera camera;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: PlaygroundMapPreviewFixtures.stageSize.width,
      height: PlaygroundMapPreviewFixtures.stageSize.height,
      child: ClipRect(
        child: PlaygroundScrollView(
          camera: camera,
          contentSize: PlaygroundMapPreviewFixtures.contentSize,
          focusTarget: null,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              const Positioned.fill(
                child: PlaygroundBackground(biome: PlaygroundBiome.meadow),
              ),
              Positioned(
                left: 40,
                right: 40,
                top: 100,
                height: 80,
                child: _mapCard(
                  isDark: isDark,
                  title: 'Quest Stage 1',
                  subtitle: 'Drag to pan · pinch to zoom',
                ),
              ),
              Positioned(
                left: 40,
                right: 40,
                top: 240,
                height: 80,
                child: _mapCard(
                  isDark: isDark,
                  title: 'Boss Gate',
                  subtitle: 'Final challenge',
                ),
              ),
              Positioned(
                left: 40,
                right: 40,
                top: 380,
                height: 80,
                child: _mapCard(
                  isDark: isDark,
                  title: 'Treasure Vault',
                  subtitle: 'Reward chamber',
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: PlaygroundLegend(
                  items: PlaygroundLegendDefaults.defaultItems(isDark: isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mapCard({
    required bool isDark,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xCC1E2230) : const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0x44FFFFFF) : const Color(0x33000000),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
