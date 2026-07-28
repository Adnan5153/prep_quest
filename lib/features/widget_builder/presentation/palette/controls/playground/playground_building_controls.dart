import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class PlaygroundBuildingControls extends StatelessWidget {
  const PlaygroundBuildingControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Playground Building Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Building State',
          value: provider.playgroundBuildingState,
          values: const {
            'locked': 'Locked',
            'unlocked': 'Unlocked',
            'current': 'Current',
            'completed': 'Completed',
            'premium': 'Premium',
          },
          onChanged: (value) => provider.playgroundBuildingState = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundBuildingTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.playgroundBuildingTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundBuildingSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.playgroundBuildingSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Progress ${(provider.playgroundBuildingProgress * 100).round()}%',
        ),
        Slider(
          min: 0,
          max: 1,
          divisions: 20,
          value: provider.playgroundBuildingProgress.clamp(0, 1),
          onChanged: (value) => provider.playgroundBuildingProgress = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Level ${provider.playgroundBuildingLevel}'),
        Slider(
          min: 1,
          max: 10,
          divisions: 9,
          value: provider.playgroundBuildingLevel.toDouble().clamp(1, 10),
          onChanged: (value) =>
              provider.playgroundBuildingLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Label Placement',
          value: provider.playgroundBuildingLabelPlacement,
          values: const {'below': 'Below', 'above': 'Above'},
          onChanged: (value) =>
              provider.playgroundBuildingLabelPlacement = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Label Emphasis',
          value: provider.playgroundBuildingLabelEmphasis,
          values: const {
            'normal': 'Normal',
            'strong': 'Strong',
            'subtle': 'Subtle',
          },
          onChanged: (value) =>
              provider.playgroundBuildingLabelEmphasis = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Progress Kind',
          value: provider.playgroundBuildingProgressKind,
          values: const {
            'percent': 'Percent',
            'level': 'Level',
            'levelUp': 'Level Up',
          },
          onChanged: (value) => provider.playgroundBuildingProgressKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Scale ${(provider.playgroundBuildingScale * 100).round()}%'),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 15,
          value: provider.playgroundBuildingScale.clamp(0.5, 2.0),
          onChanged: (value) => provider.playgroundBuildingScale = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.playgroundBuildingBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.playgroundBuildingBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Is Interactive'),
          value: provider.playgroundBuildingIsInteractive,
          onChanged: (value) =>
              provider.playgroundBuildingIsInteractive = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Label'),
          value: provider.playgroundBuildingShowLabel,
          onChanged: (value) => provider.playgroundBuildingShowLabel = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Progress'),
          value: provider.playgroundBuildingShowProgress,
          onChanged: (value) => provider.playgroundBuildingShowProgress = value,
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
