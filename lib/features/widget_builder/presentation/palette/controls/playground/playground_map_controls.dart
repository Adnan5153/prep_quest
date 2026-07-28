import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';
import 'playground_control_dropdown.dart';

class PlaygroundMapControls extends StatelessWidget {
  const PlaygroundMapControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Map Composition Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'The Playground Map composes the background, scroll view, '
          'particles, paths, nodes, buildings, and legend.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Biome',
          value: provider.playgroundMapBiome,
          values: const <String, String>{
            'meadow': 'Meadow',
            'forest': 'Forest',
            'desert': 'Desert',
            'snow': 'Snow',
            'volcanic': 'Volcanic',
          },
          onChanged: (value) => provider.playgroundMapBiome = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: provider.playgroundMapShowLegend,
          title: const Text('Show Legend'),
          onChanged: (value) => provider.playgroundMapShowLegend = value,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Focus Target',
          value: provider.playgroundMapFocusTarget,
          values: const <String, String>{
            'none': 'None',
            'current': 'Current Node',
            'boss': 'Boss Gate',
          },
          onChanged: (value) => provider.playgroundMapFocusTarget = value,
        ),
        const SizedBox(height: AppSpacing.md),
        PlaygroundControlDropdown(
          label: 'Theme Preview',
          value: provider.playgroundMapBrightness,
          values: const <String, String>{
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.playgroundMapBrightness = value,
        ),
      ],
    );
  }
}
