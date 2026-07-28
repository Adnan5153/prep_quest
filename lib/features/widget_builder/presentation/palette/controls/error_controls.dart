import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class NetworkErrorControls extends StatelessWidget {
  const NetworkErrorControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Network Error Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: provider.errorType,
          decoration: const InputDecoration(labelText: 'Error Type'),
          items: const [
            DropdownMenuItem(value: 'noInternet', child: Text('No Internet')),
            DropdownMenuItem(
              value: 'connectionTimeout',
              child: Text('Connection Timeout'),
            ),
            DropdownMenuItem(
              value: 'serverUnavailable',
              child: Text('Server Unavailable'),
            ),
            DropdownMenuItem(
              value: 'requestFailed',
              child: Text('Request Failed'),
            ),
            DropdownMenuItem(value: 'apiError', child: Text('API Error')),
            DropdownMenuItem(value: 'offlineMode', child: Text('Offline Mode')),
          ],
          onChanged: (value) {
            if (value != null) provider.errorType = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.errorRetryText,
          decoration: const InputDecoration(labelText: 'Retry Text'),
          onChanged: (value) => provider.errorRetryText = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Illustration'),
          value: provider.showErrorIllustration,
          onChanged: (value) => provider.showErrorIllustration = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Icon'),
          value: provider.showErrorIcon,
          onChanged: (value) => provider.showErrorIcon = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Retry Button'),
          value: provider.showErrorRetryButton,
          onChanged: (value) => provider.showErrorRetryButton = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Loading State'),
          value: provider.isErrorLoading,
          onChanged: (value) => provider.isErrorLoading = value,
        ),
      ],
    );
  }
}
