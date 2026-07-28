import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class AiHistorySectionControls extends StatelessWidget {
  const AiHistorySectionControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(height: AppSpacing.xl),
        Text(
          'AI History Section Properties',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHistoryHeaderTitle,
          decoration: const InputDecoration(labelText: 'Header Title'),
          onChanged: (value) => provider.aiHistoryHeaderTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHistoryHeaderSubtitle,
          decoration: const InputDecoration(labelText: 'Header Subtitle'),
          onChanged: (value) => provider.aiHistoryHeaderSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.aiHistoryState,
          decoration: const InputDecoration(labelText: 'State'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'ready', child: Text('Ready')),
            DropdownMenuItem<String>(value: 'empty', child: Text('Empty')),
            DropdownMenuItem<String>(value: 'loading', child: Text('Loading')),
            DropdownMenuItem<String>(value: 'error', child: Text('Error')),
          ],
          onChanged: (value) {
            if (value != null) provider.aiHistoryState = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHistoryLoadingItemCount.toString(),
          decoration: const InputDecoration(labelText: 'Loading Item Count'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final int? parsed = int.tryParse(value);
            if (parsed != null && parsed >= 1 && parsed <= 8) {
              provider.aiHistoryLoadingItemCount = parsed;
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          title: const Text('Show Header'),
          value: provider.aiHistoryShowHeader,
          onChanged: (value) => provider.aiHistoryShowHeader = value,
        ),
        SwitchListTile(
          title: const Text('Show "View All"'),
          value: provider.aiHistoryShowViewAll,
          onChanged: (value) => provider.aiHistoryShowViewAll = value,
        ),
        SwitchListTile(
          title: const Text('Show Category'),
          value: provider.aiHistoryShowCategory,
          onChanged: (value) => provider.aiHistoryShowCategory = value,
        ),
        SwitchListTile(
          title: const Text('Show Timestamp'),
          value: provider.aiHistoryShowTimestamp,
          onChanged: (value) => provider.aiHistoryShowTimestamp = value,
        ),
        SwitchListTile(
          title: const Text('Show Premium Badge'),
          value: provider.aiHistoryShowPremiumBadge,
          onChanged: (value) => provider.aiHistoryShowPremiumBadge = value,
        ),
        SwitchListTile(
          title: const Text('Show Favorite Indicator'),
          value: provider.aiHistoryShowFavorite,
          onChanged: (value) => provider.aiHistoryShowFavorite = value,
        ),
        SwitchListTile(
          title: const Text('Show Pinned Indicator'),
          value: provider.aiHistoryShowPinned,
          onChanged: (value) => provider.aiHistoryShowPinned = value,
        ),
        SwitchListTile(
          title: const Text('Show Leading Chevron'),
          value: provider.aiHistoryShowLeadingChevron,
          onChanged: (value) => provider.aiHistoryShowLeadingChevron = value,
        ),
      ],
    );
  }
}
