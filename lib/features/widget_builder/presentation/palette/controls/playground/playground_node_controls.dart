import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class PlaygroundNodeControls extends StatelessWidget {
  const PlaygroundNodeControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Playground Node Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.playgroundNodeTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.playgroundNodeTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundNodeSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.playgroundNodeSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Ring State',
          value: provider.playgroundNodeRingState,
          values: const {
            'locked': 'Locked',
            'unlocked': 'Available',
            'inProgress': 'Current',
            'completed': 'Completed',
            'boss': 'Boss',
            'premium': 'Premium',
            'seasonal': 'Seasonal',
            'event': 'Event',
            'disabled': 'Disabled',
          },
          onChanged: (value) => provider.playgroundNodeRingState = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Ring Style',
          value: provider.playgroundNodeRingKind,
          values: const {
            'solid': 'Solid',
            'gradient': 'Gradient',
            'dashed': 'Dashed',
            'glowing': 'Glowing',
          },
          onChanged: (value) => provider.playgroundNodeRingKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Icon Kind',
          value: provider.playgroundNodeIconKind,
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
          onChanged: (value) => provider.playgroundNodeIconKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Icon Variant',
          value: provider.playgroundNodeIconVariant,
          values: const {
            'filled': 'Filled',
            'outlined': 'Outlined',
            'tonal': 'Tonal',
            'glyph': 'Glyph',
          },
          onChanged: (value) => provider.playgroundNodeIconVariant = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Badge Kind',
          value: provider.playgroundNodeBadgeKind,
          values: const {
            'boss': 'Boss',
            'library': 'Library',
            'premium': 'Premium',
            'event': 'Event',
            'daily': 'Daily',
            'tournament': 'Tournament',
            'seasonal': 'Seasonal',
            'xp': 'XP',
            'completed': 'Completed',
            'newBadge': 'New',
          },
          onChanged: (value) => provider.playgroundNodeBadgeKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Progress State',
          value: provider.playgroundNodeProgressState,
          values: const {
            'indeterminate': 'Indeterminate',
            'empty': 'Empty',
            'partial': 'Partial',
            'completed': 'Completed',
            'failed': 'Failed',
          },
          onChanged: (value) => provider.playgroundNodeProgressState = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Progress ${(provider.playgroundNodeProgress * 100).round()}%'),
        Slider(
          value: provider.playgroundNodeProgress.clamp(0.0, 1.0),
          onChanged: (value) => provider.playgroundNodeProgress = value,
        ),
        Text('Diameter ${provider.playgroundNodeDiameter.round()} px'),
        Slider(
          min: 48,
          max: 128,
          divisions: 10,
          value: provider.playgroundNodeDiameter.clamp(48, 128),
          onChanged: (value) => provider.playgroundNodeDiameter = value,
        ),
        _dropdown(
          label: 'Theme Preview',
          value: provider.playgroundNodeBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.playgroundNodeBrightness = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Progress'),
          value: provider.playgroundNodeShowProgress,
          onChanged: (value) => provider.playgroundNodeShowProgress = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Label'),
          value: provider.playgroundNodeShowLabel,
          onChanged: (value) => provider.playgroundNodeShowLabel = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Badge'),
          value: provider.playgroundNodeShowBadge,
          onChanged: (value) => provider.playgroundNodeShowBadge = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Interactive'),
          value: provider.playgroundNodeIsInteractive,
          onChanged: (value) => provider.playgroundNodeIsInteractive = value,
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
