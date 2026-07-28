import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class ProfileSummaryControls extends StatelessWidget {
  const ProfileSummaryControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Profile Summary Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.playgroundProfileSummaryDisplayName,
          decoration: const InputDecoration(labelText: 'Display name'),
          onChanged: (value) =>
              provider.playgroundProfileSummaryDisplayName = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundProfileSummaryInitials,
          decoration: const InputDecoration(labelText: 'Initials'),
          onChanged: (value) =>
              provider.playgroundProfileSummaryInitials = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Level ${provider.playgroundProfileSummaryLevel}'),
        Slider(
          min: 1,
          max: 50,
          divisions: 49,
          value: provider.playgroundProfileSummaryLevel.toDouble().clamp(1, 50),
          onChanged: (value) =>
              provider.playgroundProfileSummaryLevel = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Notifications ${provider.playgroundProfileSummaryNotificationCount}',
        ),
        Slider(
          min: 0,
          max: 20,
          divisions: 20,
          value: provider.playgroundProfileSummaryNotificationCount
              .toDouble()
              .clamp(0, 20),
          onChanged: (value) =>
              provider.playgroundProfileSummaryNotificationCount = value
                  .round(),
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundProfileSummaryLeagueName ?? '',
          decoration: const InputDecoration(labelText: 'League name'),
          onChanged: (value) {
            provider.playgroundProfileSummaryLeagueName = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Is Online'),
          value: provider.playgroundProfileSummaryIsOnline,
          onChanged: (value) =>
              provider.playgroundProfileSummaryIsOnline = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Is Premium'),
          value: provider.playgroundProfileSummaryIsPremium,
          onChanged: (value) =>
              provider.playgroundProfileSummaryIsPremium = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dropdown(
          label: 'Theme Preview',
          value: provider.playgroundProfileSummaryBrightness,
          values: const <String, String>{
            'lightOnly': 'Light',
            'darkOnly': 'Dark',
            'sideBySide': 'Side by Side',
          },
          onChanged: (value) =>
              provider.playgroundProfileSummaryBrightness = value,
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
            (entry) => DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            ),
          )
          .toList(),
      onChanged: (String? newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}
