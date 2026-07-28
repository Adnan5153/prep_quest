import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_background.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_map_preview_data.dart';
import 'playground_preview_tile.dart';

class PlaygroundBackgroundPreview extends StatelessWidget {
  const PlaygroundBackgroundPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final biome = PlaygroundMapPreviewFixtures.resolveBiome(
      provider.playgroundBackgroundBiome,
    );
    final parallax = provider.playgroundBackgroundParallaxOffset;
    final preview = AspectRatio(
      aspectRatio: PlaygroundMapPreviewFixtures.viewportAspectRatio,
      child: ClipRect(
        child: PlaygroundBackground(biome: biome, parallaxOffset: parallax),
      ),
    );
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Map Background', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            PlaygroundPreviewTile(
              mode: provider.playgroundBackgroundBrightness,
              padding: EdgeInsets.zero,
              aspectRatio: PlaygroundMapPreviewFixtures.viewportAspectRatio,
              child: preview,
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Biome Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _BiomeTile(label: 'Meadow', biome: PlaygroundBiome.meadow),
                  _BiomeTile(label: 'Forest', biome: PlaygroundBiome.forest),
                  _BiomeTile(label: 'Desert', biome: PlaygroundBiome.desert),
                  _BiomeTile(label: 'Snow', biome: PlaygroundBiome.snow),
                  _BiomeTile(
                    label: 'Volcanic',
                    biome: PlaygroundBiome.volcanic,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _BiomeTile extends StatelessWidget {
  const _BiomeTile({required this.label, required this.biome});
  final String label;
  final PlaygroundBiome biome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AspectRatio(
            aspectRatio: PlaygroundMapPreviewFixtures.viewportAspectRatio,
            child: ClipRect(child: PlaygroundBackground(biome: biome)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
