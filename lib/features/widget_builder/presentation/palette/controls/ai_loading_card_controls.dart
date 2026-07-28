import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class AiLoadingCardControls extends StatelessWidget {
  const AiLoadingCardControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(height: AppSpacing.xl),
        Text(
          'AI Loading Card Properties',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.aiLoadingCardBrightness,
          decoration: const InputDecoration(labelText: 'Brightness'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'auto', child: Text('Auto')),
            DropdownMenuItem<String>(value: 'light', child: Text('Light')),
            DropdownMenuItem<String>(value: 'dark', child: Text('Dark')),
          ],
          onChanged: (value) {
            if (value != null) provider.aiLoadingCardBrightness = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiLoadingCardBodyLineCount.toString(),
          decoration: const InputDecoration(labelText: 'Body Line Count'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final int? parsed = int.tryParse(value);
            if (parsed != null && parsed >= 1 && parsed <= 6) {
              provider.aiLoadingCardBodyLineCount = parsed;
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiLoadingCardElevation.toString(),
          decoration: const InputDecoration(labelText: 'Elevation'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final double? parsed = double.tryParse(value);
            if (parsed != null && parsed >= 0 && parsed <= 12) {
              provider.aiLoadingCardElevation = parsed;
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.aiLoadingCardSemanticLabel ?? '',
          decoration: const InputDecoration(labelText: 'Semantic Label'),
          onChanged: (value) => provider.aiLoadingCardSemanticLabel =
              value.isEmpty ? null : value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Visibility', style: Theme.of(context).textTheme.titleSmall),
        SwitchListTile(
          title: const Text('Show Avatar'),
          value: provider.aiLoadingCardShowAvatar,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiLoadingCardShowAvatar = value,
        ),
        SwitchListTile(
          title: const Text('Show Title'),
          value: provider.aiLoadingCardShowTitle,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiLoadingCardShowTitle = value,
        ),
        SwitchListTile(
          title: const Text('Show Subtitle'),
          value: provider.aiLoadingCardShowSubtitle,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiLoadingCardShowSubtitle = value,
        ),
        SwitchListTile(
          title: const Text('Show Body'),
          value: provider.aiLoadingCardShowBody,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiLoadingCardShowBody = value,
        ),
        SwitchListTile(
          title: const Text('Show Footer'),
          value: provider.aiLoadingCardShowFooter,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiLoadingCardShowFooter = value,
        ),
        SwitchListTile(
          title: const Text('Animation Enabled'),
          value: provider.aiLoadingCardAnimationEnabled,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) => provider.aiLoadingCardAnimationEnabled = value,
        ),
      ],
    );
  }
}
