import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class AiResponseCardControls extends StatelessWidget {
  const AiResponseCardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(height: AppSpacing.xl),
        Text(
          'AI Response Card Properties',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiResponseTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.aiResponseTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiResponseSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.aiResponseSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.aiResponseType,
          decoration: const InputDecoration(labelText: 'Response Type'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'generic', child: Text('Generic')),
            DropdownMenuItem<String>(value: 'answer', child: Text('Answer')),
            DropdownMenuItem<String>(value: 'hint', child: Text('Hint')),
            DropdownMenuItem<String>(value: 'summary', child: Text('Summary')),
            DropdownMenuItem<String>(
              value: 'recommendation',
              child: Text('Recommendation'),
            ),
            DropdownMenuItem<String>(
              value: 'analysis',
              child: Text('Analysis'),
            ),
            DropdownMenuItem<String>(
              value: 'explanation',
              child: Text('Explanation'),
            ),
          ],
          onChanged: (value) {
            if (value != null) provider.aiResponseType = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiResponseBadgeLabel,
          decoration: const InputDecoration(
            labelText: 'Badge Label Override (empty = default)',
          ),
          onChanged: (value) => provider.aiResponseBadgeLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiResponseBody,
          decoration: const InputDecoration(labelText: 'Body'),
          maxLines: 6,
          onChanged: (value) => provider.aiResponseBody = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Body rendering', style: Theme.of(context).textTheme.titleSmall),
        SwitchListTile(
          title: const Text('Markdown'),
          value: provider.aiResponseMarkdown,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseMarkdown = value,
        ),
        SwitchListTile(
          title: const Text('Selectable Text'),
          value: provider.aiResponseSelectable,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseSelectable = value,
        ),
        SwitchListTile(
          title: const Text('Show Badge'),
          value: provider.aiResponseShowBadge,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseShowBadge = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Metadata', style: Theme.of(context).textTheme.titleSmall),
        SwitchListTile(
          title: const Text('Show Metadata Strip'),
          value: provider.aiResponseShowMetadata,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseShowMetadata = value,
        ),
        TextFormField(
          initialValue: provider.aiResponseMetadataModel,
          decoration: const InputDecoration(labelText: 'Model'),
          onChanged: (value) => provider.aiResponseMetadataModel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiResponseMetadataTimestamp,
          decoration: const InputDecoration(labelText: 'Timestamp'),
          onChanged: (value) => provider.aiResponseMetadataTimestamp = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiResponseMetadataCategory,
          decoration: const InputDecoration(labelText: 'Category'),
          onChanged: (value) => provider.aiResponseMetadataCategory = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.aiResponseMetadataConfidence,
          decoration: const InputDecoration(labelText: 'Confidence'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'high', child: Text('High')),
            DropdownMenuItem<String>(value: 'medium', child: Text('Medium')),
            DropdownMenuItem<String>(value: 'low', child: Text('Low')),
            DropdownMenuItem<String>(value: 'unknown', child: Text('Unknown')),
          ],
          onChanged: (value) {
            if (value != null) {
              provider.aiResponseMetadataConfidence = value;
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.aiResponseMetadataStatus,
          decoration: const InputDecoration(labelText: 'Status'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'fresh', child: Text('Fresh')),
            DropdownMenuItem<String>(
              value: 'delivered',
              child: Text('Delivered'),
            ),
            DropdownMenuItem<String>(
              value: 'streaming',
              child: Text('Streaming'),
            ),
            DropdownMenuItem<String>(value: 'failed', child: Text('Failed')),
            DropdownMenuItem<String>(
              value: 'archived',
              child: Text('Archived'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              provider.aiResponseMetadataStatus = value;
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Footer Actions', style: Theme.of(context).textTheme.titleSmall),
        SwitchListTile(
          title: const Text('Show Footer'),
          value: provider.aiResponseShowActions,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseShowActions = value,
        ),
        SwitchListTile(
          title: const Text('Copy'),
          value: provider.aiResponseActionCopy,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionCopy = value,
        ),
        SwitchListTile(
          title: const Text('Share'),
          value: provider.aiResponseActionShare,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionShare = value,
        ),
        SwitchListTile(
          title: const Text('Regenerate'),
          value: provider.aiResponseActionRegenerate,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionRegenerate = value,
        ),
        SwitchListTile(
          title: const Text('Favorite'),
          value: provider.aiResponseActionFavorite,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionFavorite = value,
        ),
        SwitchListTile(
          title: const Text('Like'),
          value: provider.aiResponseActionLike,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionLike = value,
        ),
        SwitchListTile(
          title: const Text('Dislike'),
          value: provider.aiResponseActionDislike,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionDislike = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Action State', style: Theme.of(context).textTheme.titleSmall),
        SwitchListTile(
          title: const Text('Favorite Active'),
          value: provider.aiResponseActionFavoriteActive,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionFavoriteActive = value,
        ),
        SwitchListTile(
          title: const Text('Like Active'),
          value: provider.aiResponseActionLikeActive,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionLikeActive = value,
        ),
        SwitchListTile(
          title: const Text('Dislike Active'),
          value: provider.aiResponseActionDislikeActive,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseActionDislikeActive = value,
        ),
        SwitchListTile(
          title: const Text('Can Expand'),
          value: provider.aiResponseCanExpand,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseCanExpand = value,
        ),
        SwitchListTile(
          title: const Text('Expanded'),
          value: provider.aiResponseExpanded,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiResponseExpanded = value,
        ),
      ],
    );
  }
}
