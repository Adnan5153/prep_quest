import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeRingControls extends StatelessWidget {
  const NodeRingControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Node Ring Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Ring State',
          value: provider.nodeRingState,
          values: const {
            'locked': 'Locked',
            'unlocked': 'Unlocked',
            'inProgress': 'In Progress',
            'completed': 'Completed',
            'boss': 'Boss',
            'premium': 'Premium',
            'seasonal': 'Seasonal',
            'event': 'Event',
            'disabled': 'Disabled',
            'unknown': 'Unknown',
          },
          onChanged: (value) => provider.nodeRingState = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Ring Style',
          value: provider.nodeRingKind,
          values: const {
            'solid': 'Solid',
            'gradient': 'Gradient',
            'dashed': 'Dashed',
            'glowing': 'Glowing',
          },
          onChanged: (value) => provider.nodeRingKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Diameter ${provider.nodeRingDiameter.round()} px'),
        Slider(
          min: 32,
          max: 160,
          divisions: 16,
          value: provider.nodeRingDiameter.clamp(32, 160),
          onChanged: (value) => provider.nodeRingDiameter = value,
        ),
        Text('Stroke ${provider.nodeRingStrokeWidth.toStringAsFixed(1)} px'),
        Slider(
          min: 1,
          max: 10,
          divisions: 9,
          value: provider.nodeRingStrokeWidth.clamp(1, 10),
          onChanged: (value) => provider.nodeRingStrokeWidth = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.nodeRingBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.nodeRingBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Glow'),
          value: provider.nodeRingGlow,
          onChanged: (value) => provider.nodeRingGlow = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Animate Pulse'),
          value: provider.nodeRingIsAnimated,
          onChanged: (value) => provider.nodeRingIsAnimated = value,
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
