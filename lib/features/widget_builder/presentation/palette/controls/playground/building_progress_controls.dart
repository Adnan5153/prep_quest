import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class BuildingProgressControls extends StatelessWidget {
  const BuildingProgressControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Building Progress Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Progress Kind',
          value: provider.buildingProgressKind,
          values: const {
            'percent': 'Percent',
            'level': 'Level',
            'levelUp': 'Level Up',
          },
          onChanged: (value) => provider.buildingProgressKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Progress ${(provider.buildingProgressValue * 100).round()}%'),
        Slider(
          min: 0,
          max: 1,
          divisions: 20,
          value: provider.buildingProgressValue.clamp(0, 1),
          onChanged: (value) => provider.buildingProgressValue = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Level ${provider.buildingProgressLevel}'),
        Slider(
          min: 1,
          max: 10,
          divisions: 9,
          value: provider.buildingProgressLevel.toDouble().clamp(1, 10),
          onChanged: (value) => provider.buildingProgressLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Size ${provider.buildingProgressSize.round()} px'),
        Slider(
          min: 32,
          max: 120,
          divisions: 22,
          value: provider.buildingProgressSize.clamp(32, 120),
          onChanged: (value) => provider.buildingProgressSize = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.buildingProgressBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.buildingProgressBrightness = value,
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
