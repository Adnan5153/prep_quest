import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_hint_card/ai_hint_constants.dart';
import '../../providers/widget_builder_provider.dart';

class AiHintCardControls extends StatelessWidget {
  const AiHintCardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: AppSpacing.xl),
        Text(
          'AI Hint Card Properties',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHintTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.aiHintTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHintText,
          decoration: const InputDecoration(labelText: 'Hint Text'),
          maxLines: 3,
          onChanged: (value) => provider.aiHintText = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          value: provider.aiHintType,
          decoration: const InputDecoration(labelText: 'Hint Type'),
          items: AiHintType.values.map((type) {
            return DropdownMenuItem(
              value: type.name,
              child: Text(AiHintConstants.labelForType(type)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) provider.aiHintType = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          value: provider.aiHintDifficulty,
          decoration: const InputDecoration(labelText: 'Difficulty'),
          items: AiHintDifficulty.values.map((difficulty) {
            return DropdownMenuItem(
              value: difficulty.name,
              child: Text(difficulty.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) provider.aiHintDifficulty = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHintTopic,
          decoration: const InputDecoration(labelText: 'Topic (Optional)'),
          onChanged: (value) =>
              provider.aiHintTopic = value.isEmpty ? null : value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHintQuickTip,
          decoration: const InputDecoration(labelText: 'Quick Tip (Optional)'),
          onChanged: (value) =>
              provider.aiHintQuickTip = value.isEmpty ? null : value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiHintBadgeText,
          decoration: const InputDecoration(
            labelText: 'Custom Badge Text (Optional)',
          ),
          onChanged: (value) =>
              provider.aiHintBadgeText = value.isEmpty ? null : value,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          title: const Text('Show Badge'),
          value: provider.aiHintShowBadge,
          onChanged: (value) => provider.aiHintShowBadge = value,
        ),
        SwitchListTile(
          title: const Text('Show Actions'),
          value: provider.aiHintShowActions,
          onChanged: (value) => provider.aiHintShowActions = value,
        ),
        SwitchListTile(
          title: const Text('Is Bookmarked'),
          value: provider.aiHintIsBookmarked,
          onChanged: (value) => provider.aiHintIsBookmarked = value,
        ),
      ],
    );
  }
}
