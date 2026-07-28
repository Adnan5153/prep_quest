import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class LibraryBuildingControls extends StatelessWidget {
  const LibraryBuildingControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Library Building Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Building State',
          value: provider.libraryBuildingState,
          values: const {
            'locked': 'Locked',
            'unlocked': 'Unlocked',
            'current': 'Current',
            'completed': 'Completed',
            'premium': 'Premium',
          },
          onChanged: (value) => provider.libraryBuildingState = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Progress ${(provider.libraryBuildingProgress * 100).round()}%'),
        Slider(
          min: 0,
          max: 1,
          divisions: 20,
          value: provider.libraryBuildingProgress.clamp(0, 1),
          onChanged: (value) => provider.libraryBuildingProgress = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Level ${provider.libraryBuildingLevel}'),
        Slider(
          min: 1,
          max: 10,
          divisions: 9,
          value: provider.libraryBuildingLevel.toDouble().clamp(1, 10),
          onChanged: (value) => provider.libraryBuildingLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Label Placement',
          value: provider.libraryBuildingLabelPlacement,
          values: const {'below': 'Below', 'above': 'Above'},
          onChanged: (value) => provider.libraryBuildingLabelPlacement = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Label Emphasis',
          value: provider.libraryBuildingLabelEmphasis,
          values: const {
            'normal': 'Normal',
            'strong': 'Strong',
            'subtle': 'Subtle',
          },
          onChanged: (value) => provider.libraryBuildingLabelEmphasis = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Progress Kind',
          value: provider.libraryBuildingProgressKind,
          values: const {
            'percent': 'Percent',
            'level': 'Level',
            'levelUp': 'Level Up',
          },
          onChanged: (value) => provider.libraryBuildingProgressKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Scale ${(provider.libraryBuildingScale * 100).round()}%'),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 15,
          value: provider.libraryBuildingScale.clamp(0.5, 2.0),
          onChanged: (value) => provider.libraryBuildingScale = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.libraryBuildingBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.libraryBuildingBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Label'),
          value: provider.libraryBuildingShowLabel,
          onChanged: (value) => provider.libraryBuildingShowLabel = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Progress'),
          value: provider.libraryBuildingShowProgress,
          onChanged: (value) => provider.libraryBuildingShowProgress = value,
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
