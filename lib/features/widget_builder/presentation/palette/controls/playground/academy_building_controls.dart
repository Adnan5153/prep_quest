import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class AcademyBuildingControls extends StatelessWidget {
  const AcademyBuildingControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Academy Building Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Building State',
          value: provider.academyBuildingState,
          values: const {
            'locked': 'Locked',
            'unlocked': 'Unlocked',
            'current': 'Current',
            'completed': 'Completed',
            'premium': 'Premium',
          },
          onChanged: (value) => provider.academyBuildingState = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Progress ${(provider.academyBuildingProgress * 100).round()}%'),
        Slider(
          min: 0,
          max: 1,
          divisions: 20,
          value: provider.academyBuildingProgress.clamp(0, 1),
          onChanged: (value) => provider.academyBuildingProgress = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Level ${provider.academyBuildingLevel}'),
        Slider(
          min: 1,
          max: 10,
          divisions: 9,
          value: provider.academyBuildingLevel.toDouble().clamp(1, 10),
          onChanged: (value) => provider.academyBuildingLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Label Placement',
          value: provider.academyBuildingLabelPlacement,
          values: const {'below': 'Below', 'above': 'Above'},
          onChanged: (value) => provider.academyBuildingLabelPlacement = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Label Emphasis',
          value: provider.academyBuildingLabelEmphasis,
          values: const {
            'normal': 'Normal',
            'strong': 'Strong',
            'subtle': 'Subtle',
          },
          onChanged: (value) => provider.academyBuildingLabelEmphasis = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Progress Kind',
          value: provider.academyBuildingProgressKind,
          values: const {
            'percent': 'Percent',
            'level': 'Level',
            'levelUp': 'Level Up',
          },
          onChanged: (value) => provider.academyBuildingProgressKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Scale ${(provider.academyBuildingScale * 100).round()}%'),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 15,
          value: provider.academyBuildingScale.clamp(0.5, 2.0),
          onChanged: (value) => provider.academyBuildingScale = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.academyBuildingBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.academyBuildingBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Label'),
          value: provider.academyBuildingShowLabel,
          onChanged: (value) => provider.academyBuildingShowLabel = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Progress'),
          value: provider.academyBuildingShowProgress,
          onChanged: (value) => provider.academyBuildingShowProgress = value,
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
