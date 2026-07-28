import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class AiHistoryTileControls extends StatelessWidget {
  const AiHistoryTileControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(height: AppSpacing.xl),
        Text(
          'AI History Tile Properties',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHistoryTileTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.aiHistoryTileTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHistoryTilePreview,
          decoration: const InputDecoration(labelText: 'Preview'),
          maxLines: 3,
          onChanged: (value) => provider.aiHistoryTilePreview = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHistoryTileTimestamp,
          decoration: const InputDecoration(labelText: 'Timestamp'),
          onChanged: (value) => provider.aiHistoryTileTimestamp = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHistoryTileSubtitle ?? '',
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) =>
              provider.aiHistoryTileSubtitle = value.isEmpty ? null : value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHistoryTileCategory ?? '',
          decoration: const InputDecoration(labelText: 'Category'),
          onChanged: (value) =>
              provider.aiHistoryTileCategory = value.isEmpty ? null : value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.aiHistoryTileEntryType,
          decoration: const InputDecoration(labelText: 'Entry Type'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'tutor', child: Text('Tutor')),
            DropdownMenuItem<String>(value: 'prompt', child: Text('Prompt')),
            DropdownMenuItem<String>(value: 'exam', child: Text('Exam')),
            DropdownMenuItem<String>(value: 'summary', child: Text('Summary')),
          ],
          onChanged: (value) {
            if (value != null) provider.aiHistoryTileEntryType = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.aiHistoryTileBrightness,
          decoration: const InputDecoration(labelText: 'Brightness'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'auto', child: Text('Auto')),
            DropdownMenuItem<String>(value: 'light', child: Text('Light')),
            DropdownMenuItem<String>(value: 'dark', child: Text('Dark')),
          ],
          onChanged: (value) {
            if (value != null) provider.aiHistoryTileBrightness = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Demo state', style: Theme.of(context).textTheme.titleSmall),
        SwitchListTile(
          title: const Text('Favorite'),
          value: provider.aiHistoryTileIsFavorite,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileIsFavorite = value,
        ),
        SwitchListTile(
          title: const Text('Pinned'),
          value: provider.aiHistoryTileIsPinned,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileIsPinned = value,
        ),
        SwitchListTile(
          title: const Text('Premium'),
          value: provider.aiHistoryTileIsPremium,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileIsPremium = value,
        ),
        SwitchListTile(
          title: const Text('Unread'),
          value: provider.aiHistoryTileIsUnread,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileIsUnread = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Visibility', style: Theme.of(context).textTheme.titleSmall),
        SwitchListTile(
          title: const Text('Show Category'),
          value: provider.aiHistoryTileShowCategory,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileShowCategory = value,
        ),
        SwitchListTile(
          title: const Text('Show Timestamp'),
          value: provider.aiHistoryTileShowTimestamp,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileShowTimestamp = value,
        ),
        SwitchListTile(
          title: const Text('Show Premium Badge'),
          value: provider.aiHistoryTileShowPremiumBadge,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileShowPremiumBadge = value,
        ),
        SwitchListTile(
          title: const Text('Show Favorite Indicator'),
          value: provider.aiHistoryTileShowFavorite,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileShowFavorite = value,
        ),
        SwitchListTile(
          title: const Text('Show Pinned Indicator'),
          value: provider.aiHistoryTileShowPinned,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileShowPinned = value,
        ),
        SwitchListTile(
          title: const Text('Show Trailing Chevron'),
          value: provider.aiHistoryTileShowLeadingChevron,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) =>
              provider.aiHistoryTileShowLeadingChevron = value,
        ),
        SwitchListTile(
          title: const Text('Dense Layout'),
          value: provider.aiHistoryTileDense,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiHistoryTileDense = value,
        ),
      ],
    );
  }
}
