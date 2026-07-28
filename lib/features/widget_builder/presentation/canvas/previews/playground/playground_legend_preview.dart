import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/map/playground_legend.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_map_preview_data.dart';
import 'playground_preview_tile.dart';

class PlaygroundLegendPreview extends StatelessWidget {
  const PlaygroundLegendPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

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
            Text('Map Legend', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            PlaygroundPreviewTile(
              mode: provider.playgroundLegendBrightness,
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: _LegendStage(title: provider.playgroundLegendTitle),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendStage extends StatelessWidget {
  const _LegendStage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 360,
      height: PlaygroundMapPreviewFixtures.stageSize.height,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? const <Color>[Color(0xFF1F2233), Color(0xFF14151E)]
                      : const <Color>[Color(0xFFCFE9F8), Color(0xFFE7F2DA)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: PlaygroundLegend(
              items: PlaygroundLegendDefaults.defaultItems(isDark: isDark),
              title: title,
            ),
          ),
        ],
      ),
    );
  }
}
