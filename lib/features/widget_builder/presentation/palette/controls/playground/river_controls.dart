import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class RiverControls extends StatelessWidget {
  const RiverControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('River Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Curve',
          value: provider.riverCurve,
          values: const {'straight': 'Straight', 'meander': 'Meander'},
          onChanged: (value) => provider.riverCurve = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Height ${provider.riverHeight.round()} px'),
        Slider(
          min: 40,
          max: 160,
          divisions: 12,
          value: provider.riverHeight.clamp(40, 160),
          onChanged: (value) => provider.riverHeight = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Seed ${provider.riverSeed}'),
        Slider(
          min: 0,
          max: 20,
          divisions: 20,
          value: provider.riverSeed.toDouble().clamp(0, 20),
          onChanged: (value) => provider.riverSeed = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.riverBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.riverBrightness = value,
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
