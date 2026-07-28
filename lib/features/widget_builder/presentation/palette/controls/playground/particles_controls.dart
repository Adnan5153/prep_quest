import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class ParticlesControls extends StatelessWidget {
  const ParticlesControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Pool Particles Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Kind',
          value: provider.particlesKind,
          values: const {
            'leaf': 'Leaf',
            'sparkle': 'Sparkle',
            'dust': 'Dust',
            'star': 'Star',
            'ambient': 'Ambient',
          },
          onChanged: (value) => provider.particlesKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Count ${provider.particlesCount}'),
        Slider(
          min: 1,
          max: 30,
          divisions: 29,
          value: provider.particlesCount.toDouble().clamp(1, 30),
          onChanged: (value) => provider.particlesCount = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Seed ${provider.particlesSeed}'),
        Slider(
          min: 0,
          max: 50,
          divisions: 50,
          value: provider.particlesSeed.toDouble().clamp(0, 50),
          onChanged: (value) => provider.particlesSeed = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.particlesBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.particlesBrightness = value,
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
