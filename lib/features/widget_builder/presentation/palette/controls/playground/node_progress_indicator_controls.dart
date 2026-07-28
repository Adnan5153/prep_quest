import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeProgressIndicatorControls extends StatelessWidget {
  const NodeProgressIndicatorControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Node Progress Indicator Options',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Progress State',
          value: provider.nodeProgressState,
          values: const {
            'indeterminate': 'Indeterminate',
            'empty': 'Empty',
            'partial': 'Partial',
            'completed': 'Completed',
            'failed': 'Failed',
          },
          onChanged: (value) => provider.nodeProgressState = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Progress ${(provider.nodeProgressValue * 100).round()}%'),
        Slider(
          value: provider.nodeProgressValue.clamp(0.0, 1.0),
          onChanged: (value) => provider.nodeProgressValue = value,
        ),
        Text('Diameter ${provider.nodeProgressDiameter.round()} px'),
        Slider(
          min: 32,
          max: 128,
          divisions: 12,
          value: provider.nodeProgressDiameter.clamp(32, 128),
          onChanged: (value) => provider.nodeProgressDiameter = value,
        ),
        Text(
          'Stroke ${provider.nodeProgressStrokeWidth.toStringAsFixed(1)} px',
        ),
        Slider(
          min: 1,
          max: 8,
          divisions: 7,
          value: provider.nodeProgressStrokeWidth.clamp(1, 8),
          onChanged: (value) => provider.nodeProgressStrokeWidth = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.nodeProgressCompletedLabel,
          decoration: const InputDecoration(labelText: 'Completed Label'),
          onChanged: (value) => provider.nodeProgressCompletedLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.nodeProgressBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.nodeProgressBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Label'),
          value: provider.nodeProgressShowLabel,
          onChanged: (value) => provider.nodeProgressShowLabel = value,
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
