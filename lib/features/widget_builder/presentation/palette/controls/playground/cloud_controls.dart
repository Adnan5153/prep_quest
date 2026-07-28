import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class CloudControls extends StatelessWidget {
  const CloudControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Cloud Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Kind',
          value: provider.cloudKind,
          values: const {
            'fluffy': 'Fluffy',
            'thin': 'Thin',
            'storm': 'Storm',
            'golden': 'Golden',
          },
          onChanged: (value) => provider.cloudKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Scale ${provider.cloudScale.toStringAsFixed(2)}x'),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 15,
          value: provider.cloudScale.clamp(0.5, 2.0),
          onChanged: (value) => provider.cloudScale = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Seed ${provider.cloudSeed}'),
        Slider(
          min: 0,
          max: 20,
          divisions: 20,
          value: provider.cloudSeed.toDouble().clamp(0, 20),
          onChanged: (value) => provider.cloudSeed = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.cloudBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.cloudBrightness = value,
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
