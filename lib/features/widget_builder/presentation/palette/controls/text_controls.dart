import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class TitleWithActionControls extends StatelessWidget {
  const TitleWithActionControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Header Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.headerTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.headerTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.headerSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.headerSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.headerActionType,
          decoration: const InputDecoration(labelText: 'Action Type'),
          items: const [
            DropdownMenuItem(value: 'text', child: Text('Text Button')),
            DropdownMenuItem(value: 'icon', child: Text('Icon Button')),
            DropdownMenuItem(value: 'custom', child: Text('Custom Widget')),
          ],
          onChanged: (value) {
            if (value != null) provider.headerActionType = value;
          },
        ),
        if (provider.headerActionType == 'text') ...[
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            initialValue: provider.headerActionText,
            decoration: const InputDecoration(labelText: 'Action Text'),
            onChanged: (value) => provider.headerActionText = value,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Subtitle'),
          value: provider.showHeaderSubtitle,
          onChanged: (value) => provider.showHeaderSubtitle = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Leading Icon'),
          value: provider.showHeaderLeading,
          onChanged: (value) => provider.showHeaderLeading = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Divider'),
          value: provider.showHeaderDivider,
          onChanged: (value) => provider.showHeaderDivider = value,
        ),
      ],
    );
  }
}
