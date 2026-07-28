import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_explanation_constants.dart';
import '../../providers/widget_builder_provider.dart';

class AiExplanationCardControls extends StatelessWidget {
  const AiExplanationCardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: AppSpacing.xl),
        Text(
          'AI Explanation Card Properties',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiExpTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.aiExpTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiExpSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.aiExpSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiExpBadgeLabel,
          decoration: const InputDecoration(labelText: 'Badge Label'),
          onChanged: (value) => provider.aiExpBadgeLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          value: provider.aiExpTone,
          decoration: const InputDecoration(labelText: 'Tone'),
          items: AiExplanationTone.values.map((tone) {
            return DropdownMenuItem(
              value: tone.name,
              child: Text(tone.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) provider.aiExpTone = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          title: const Text('Show Badge'),
          value: provider.aiExpShowBadge,
          onChanged: (value) => provider.aiExpShowBadge = value,
        ),
        SwitchListTile(
          title: const Text('Show Actions'),
          value: provider.aiExpShowActions,
          onChanged: (value) => provider.aiExpShowActions = value,
        ),
        SwitchListTile(
          title: const Text('Can Expand'),
          value: provider.aiExpCanExpand,
          onChanged: (value) => provider.aiExpCanExpand = value,
        ),
        SwitchListTile(
          title: const Text('Expanded'),
          value: provider.aiExpExpanded,
          onChanged: (value) => provider.aiExpExpanded = value,
        ),
        SwitchListTile(
          title: const Text('Long Content'),
          value: provider.aiExpLongContent,
          onChanged: (value) => provider.aiExpLongContent = value,
        ),
      ],
    );
  }
}
