import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class MountainControls extends StatelessWidget {
  const MountainControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Mountain Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Layer',
          value: provider.mountainLayer,
          values: const {'back': 'Back', 'mid': 'Mid', 'front': 'Front'},
          onChanged: (value) => provider.mountainLayer = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Kind',
          value: provider.mountainKind,
          values: const {
            'rocky': 'Rocky',
            'snowy': 'Snowy',
            'sandy': 'Sandy',
            'volcanic': 'Volcanic',
          },
          onChanged: (value) => provider.mountainKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Scale ${provider.mountainScale.toStringAsFixed(2)}x'),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 15,
          value: provider.mountainScale.clamp(0.5, 2.0),
          onChanged: (value) => provider.mountainScale = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.mountainBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.mountainBrightness = value,
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
