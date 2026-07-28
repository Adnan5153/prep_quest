import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/constants/playground_sizes.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_control_dropdown.dart';

class PlaygroundBackgroundControls extends StatelessWidget {
  const PlaygroundBackgroundControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Map Background Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'The Playground Background paints themed skies, parallax mountains, '
          'and ground gradients for each biome.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Biome',
          value: provider.playgroundBackgroundBiome,
          values: const <String, String>{
            'meadow': 'Meadow',
            'forest': 'Forest',
            'desert': 'Desert',
            'snow': 'Snow',
            'volcanic': 'Volcanic',
          },
          onChanged: (value) => provider.playgroundBackgroundBiome = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Parallax Offset '
          '${provider.playgroundBackgroundParallaxOffset.toStringAsFixed(2)}',
        ),
        Slider(
          min: 0,
          max:
              PlaygroundSizes.mapMountainParallaxBack *
              PlaygroundSizes.mapMountainBackWidth,
          value: provider.playgroundBackgroundParallaxOffset.clamp(
            0.0,
            PlaygroundSizes.mapMountainParallaxBack *
                PlaygroundSizes.mapMountainBackWidth,
          ),
          onChanged: (value) =>
              provider.playgroundBackgroundParallaxOffset = value,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Theme Preview',
          value: provider.playgroundBackgroundBrightness,
          values: const <String, String>{
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.playgroundBackgroundBrightness = value,
        ),
      ],
    );
  }
}
