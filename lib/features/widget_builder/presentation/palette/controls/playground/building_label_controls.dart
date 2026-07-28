import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class BuildingLabelControls extends StatelessWidget {
  const BuildingLabelControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Building Label Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.buildingLabelTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.buildingLabelTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.buildingLabelSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.buildingLabelSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Placement',
          value: provider.buildingLabelPlacement,
          values: const {'below': 'Below', 'above': 'Above'},
          onChanged: (value) => provider.buildingLabelPlacement = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Emphasis',
          value: provider.buildingLabelEmphasis,
          values: const {
            'normal': 'Normal',
            'strong': 'Strong',
            'subtle': 'Subtle',
          },
          onChanged: (value) => provider.buildingLabelEmphasis = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Max Width ${provider.buildingLabelMaxWidth.round()} px'),
        Slider(
          min: 80,
          max: 240,
          divisions: 16,
          value: provider.buildingLabelMaxWidth.clamp(80, 240),
          onChanged: (value) => provider.buildingLabelMaxWidth = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.buildingLabelBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.buildingLabelBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Is Visible'),
          value: provider.buildingLabelIsVisible,
          onChanged: (value) => provider.buildingLabelIsVisible = value,
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
