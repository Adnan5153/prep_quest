import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class NodeBadgeControls extends StatelessWidget {
  const NodeBadgeControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Node Badge Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _dropdown(
          label: 'Badge Kind',
          value: provider.nodeBadgeKind,
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
          onChanged: (value) => provider.nodeBadgeKind = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Size ${provider.nodeBadgeSize.round()} px'),
        Slider(
          min: 16,
          max: 48,
          divisions: 16,
          value: provider.nodeBadgeSize.clamp(16, 48),
          onChanged: (value) => provider.nodeBadgeSize = value,
        ),
        Text('Offset ${provider.nodeBadgeOffset.round()} px'),
        Slider(
          min: 0,
          max: 16,
          divisions: 8,
          value: provider.nodeBadgeOffset.clamp(0, 16),
          onChanged: (value) => provider.nodeBadgeOffset = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.nodeBadgeBrightness,
          values: const {
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) => provider.nodeBadgeBrightness = value,
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
