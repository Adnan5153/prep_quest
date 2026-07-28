import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class LoadingControls extends StatelessWidget {
  const LoadingControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Loading Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.loadingTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.loadingTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.loadingSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          onChanged: (value) => provider.loadingSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.loaderType,
          decoration: const InputDecoration(labelText: 'Loader Type'),
          items: const [
            DropdownMenuItem(value: 'lottie', child: Text('Lottie')),
            DropdownMenuItem(value: 'circular', child: Text('Circular')),
            DropdownMenuItem(value: 'linear', child: Text('Linear')),
          ],
          onChanged: (value) {
            if (value != null) provider.loaderType = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Progress'),
          value: provider.showLoadingProgress,
          onChanged: (value) => provider.showLoadingProgress = value,
        ),
        if (provider.showLoadingProgress) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Progress: ${(provider.loadingProgressValue * 100).toInt()}%',
            style: theme.textTheme.labelMedium,
          ),
          Slider.adaptive(
            value: provider.loadingProgressValue,
            onChanged: (value) => provider.loadingProgressValue = value,
          ),
        ],
      ],
    );
  }
}
