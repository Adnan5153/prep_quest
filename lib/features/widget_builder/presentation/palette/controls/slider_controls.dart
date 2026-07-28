import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class WidgetConstantsControls extends StatelessWidget {
  const WidgetConstantsControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Documentation Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.constantsSearchQuery,
          decoration: const InputDecoration(
            labelText: 'Search constants',
            prefixIcon: Icon(Icons.search_rounded),
            hintText: 'e.g. Elevation, Opacity...',
          ),
          onChanged: (value) => provider.constantsSearchQuery = value,
        ),
      ],
    );
  }
}
