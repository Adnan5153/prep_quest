import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class PlaygroundParticleLayerControls extends StatelessWidget {
  const PlaygroundParticleLayerControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Particle Layer Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Count ${provider.particleLayerCount}'),
        Slider(
          min: 1,
          max: 30,
          divisions: 29,
          value: provider.particleLayerCount.toDouble().clamp(1, 30),
          onChanged: (value) => provider.particleLayerCount = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Seed ${provider.particleLayerSeed}'),
        Slider(
          min: 0,
          max: 50,
          divisions: 50,
          value: provider.particleLayerSeed.toDouble().clamp(0, 50),
          onChanged: (value) => provider.particleLayerSeed = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.particleLayerBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.particleLayerBrightness = value,
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required Map<String, String> values,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: values.entries
          .map(
            (entry) =>
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          )
          .toList(),
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}
