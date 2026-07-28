import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeLabelControls extends StatelessWidget {
  const NodeLabelControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Node Label Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.nodeLabelTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.nodeLabelTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.nodeLabelSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.nodeLabelSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Placement',
          value: provider.nodeLabelPlacement,
          values: const {'below': 'Below', 'above': 'Above'},
          onChanged: (value) => provider.nodeLabelPlacement = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Emphasis',
          value: provider.nodeLabelEmphasis,
          values: const {
            'normal': 'Normal',
            'strong': 'Strong',
            'subtle': 'Subtle',
          },
          onChanged: (value) => provider.nodeLabelEmphasis = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Max Width ${provider.nodeLabelMaxWidth.round()} px'),
        Slider(
          min: 80,
          max: 240,
          divisions: 16,
          value: provider.nodeLabelMaxWidth.clamp(80, 240),
          onChanged: (value) => provider.nodeLabelMaxWidth = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.nodeLabelBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.nodeLabelBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Visible'),
          value: provider.nodeLabelIsVisible,
          onChanged: (value) => provider.nodeLabelIsVisible = value,
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
