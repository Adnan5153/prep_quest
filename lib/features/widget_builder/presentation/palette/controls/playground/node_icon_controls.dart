import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeIconControls extends StatelessWidget {
  const NodeIconControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Node Icon Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Icon Kind',
          value: provider.nodeIconKind,
          values: const {
            'regular': 'Regular',
            'boss': 'Boss',
            'library': 'Library',
            'premium': 'Premium',
            'event': 'Event',
            'daily': 'Daily',
            'tournament': 'Tournament',
            'seasonal': 'Seasonal',
            'completed': 'Completed',
            'locked': 'Locked',
            'unknown': 'Unknown',
          },
          onChanged: (value) => provider.nodeIconKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Variant',
          value: provider.nodeIconVariant,
          values: const {
            'filled': 'Filled',
            'outlined': 'Outlined',
            'tonal': 'Tonal',
            'glyph': 'Glyph',
          },
          onChanged: (value) => provider.nodeIconVariant = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Size ${provider.nodeIconSize.round()} px'),
        Slider(
          min: 12,
          max: 64,
          divisions: 13,
          value: provider.nodeIconSize.clamp(12, 64),
          onChanged: (value) => provider.nodeIconSize = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.nodeIconBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.nodeIconBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enabled'),
          value: provider.nodeIconIsEnabled,
          onChanged: (value) => provider.nodeIconIsEnabled = value,
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
