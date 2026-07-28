import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class TreeControls extends StatelessWidget {
  const TreeControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Tree Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Kind',
          value: provider.treeKind,
          values: const {
            'oak': 'Oak',
            'pine': 'Pine',
            'palm': 'Palm',
            'blossom': 'Blossom',
            'autumn': 'Autumn',
          },
          onChanged: (value) => provider.treeKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Scale ${provider.treeScale.toStringAsFixed(2)}x'),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 15,
          value: provider.treeScale.clamp(0.5, 2.0),
          onChanged: (value) => provider.treeScale = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.treeBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.treeBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Sway Animation'),
          value: provider.treeSway,
          onChanged: (value) => provider.treeSway = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Sway Seed ${provider.treeSwaySeed}'),
        Slider(
          min: 0,
          max: 20,
          divisions: 20,
          value: provider.treeSwaySeed.toDouble().clamp(0, 20),
          onChanged: (value) => provider.treeSwaySeed = value.round(),
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
