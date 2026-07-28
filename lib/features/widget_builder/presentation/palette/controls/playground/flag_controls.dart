import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class FlagControls extends StatelessWidget {
  const FlagControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Flag Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Color',
          value: provider.flagColor,
          values: const {
            'red': 'Red',
            'green': 'Green',
            'gold': 'Gold',
            'premium': 'Premium',
            'event': 'Event',
            'seasonal': 'Seasonal',
          },
          onChanged: (value) => provider.flagColor = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Scale ${provider.flagScale.toStringAsFixed(2)}x'),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 15,
          value: provider.flagScale.clamp(0.5, 2.0),
          onChanged: (value) => provider.flagScale = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.flagBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.flagBrightness = value,
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
