import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class AppBarControls extends StatelessWidget {
  const AppBarControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('App bar options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.subtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.subtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show leading avatar'),
          value: provider.showLeading,
          onChanged: (value) => provider.showLeading = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show accent stripe'),
          value: provider.showAccentStripe,
          onChanged: (value) => provider.showAccentStripe = value,
        ),
      ],
    );
  }
}
