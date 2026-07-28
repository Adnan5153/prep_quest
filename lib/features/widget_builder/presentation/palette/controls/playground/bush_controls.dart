import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class BushControls extends StatelessWidget {
  const BushControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Bush Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Kind',
          value: provider.bushKind,
          values: const {
            'round': 'Round',
            'hedge': 'Hedge',
            'flowering': 'Flowering',
            'snow': 'Snow',
          },
          onChanged: (value) => provider.bushKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Scale ${provider.bushScale.toStringAsFixed(2)}x'),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 15,
          value: provider.bushScale.clamp(0.5, 2.0),
          onChanged: (value) => provider.bushScale = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.bushBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.bushBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Sway Animation'),
          value: provider.bushSway,
          onChanged: (value) => provider.bushSway = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Sway Seed ${provider.bushSwaySeed}'),
        Slider(
          min: 0,
          max: 20,
          divisions: 20,
          value: provider.bushSwaySeed.toDouble().clamp(0, 20),
          onChanged: (value) => provider.bushSwaySeed = value.round(),
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
