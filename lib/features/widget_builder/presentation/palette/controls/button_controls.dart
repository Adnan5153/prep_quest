import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class PrimaryButtonControls extends StatelessWidget {
  const PrimaryButtonControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Button Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.buttonText,
          decoration: const InputDecoration(labelText: 'Text'),
          onChanged: (value) => provider.buttonText = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.buttonVariant,
          decoration: const InputDecoration(labelText: 'Variant'),
          items: const [
            DropdownMenuItem(value: 'filled', child: Text('Filled')),
            DropdownMenuItem(value: 'gradient', child: Text('Gradient')),
            DropdownMenuItem(value: 'outlined', child: Text('Outlined')),
            DropdownMenuItem(value: 'tonal', child: Text('Tonal')),
          ],
          onChanged: (value) {
            if (value != null) provider.buttonVariant = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.buttonSize,
          decoration: const InputDecoration(labelText: 'Size'),
          items: const [
            DropdownMenuItem(value: 'small', child: Text('Small')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'large', child: Text('Large')),
          ],
          onChanged: (value) {
            if (value != null) provider.buttonSize = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.buttonShape,
          decoration: const InputDecoration(labelText: 'Shape'),
          items: const [
            DropdownMenuItem(value: 'rounded', child: Text('Rounded')),
            DropdownMenuItem(value: 'pill', child: Text('Pill')),
            DropdownMenuItem(value: 'rectangle', child: Text('Rectangle')),
          ],
          onChanged: (value) {
            if (value != null) provider.buttonShape = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enabled'),
          value: provider.isButtonEnabled,
          onChanged: (value) => provider.isButtonEnabled = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Loading'),
          value: provider.isButtonLoading,
          onChanged: (value) => provider.isButtonLoading = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Full Width'),
          value: provider.isButtonFullWidth,
          onChanged: (value) => provider.isButtonFullWidth = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Leading Icon'),
          value: provider.showButtonLeadingIcon,
          onChanged: (value) => provider.showButtonLeadingIcon = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Trailing Icon'),
          value: provider.showButtonTrailingIcon,
          onChanged: (value) => provider.showButtonTrailingIcon = value,
        ),
      ],
    );
  }
}

class SecondaryButtonControls extends StatelessWidget {
  const SecondaryButtonControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Secondary Button Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.secButtonText,
          decoration: const InputDecoration(labelText: 'Text'),
          onChanged: (value) => provider.secButtonText = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.secButtonVariant,
          decoration: const InputDecoration(labelText: 'Variant'),
          items: const [
            DropdownMenuItem(value: 'outlined', child: Text('Outlined')),
            DropdownMenuItem(value: 'tonal', child: Text('Tonal')),
            DropdownMenuItem(value: 'text', child: Text('Text')),
            DropdownMenuItem(value: 'glass', child: Text('Glass')),
          ],
          onChanged: (value) {
            if (value != null) provider.secButtonVariant = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.secButtonSize,
          decoration: const InputDecoration(labelText: 'Size'),
          items: const [
            DropdownMenuItem(value: 'small', child: Text('Small')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'large', child: Text('Large')),
          ],
          onChanged: (value) {
            if (value != null) provider.secButtonSize = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.secButtonShape,
          decoration: const InputDecoration(labelText: 'Shape'),
          items: const [
            DropdownMenuItem(value: 'rounded', child: Text('Rounded')),
            DropdownMenuItem(value: 'pill', child: Text('Pill')),
            DropdownMenuItem(value: 'rectangle', child: Text('Rectangle')),
          ],
          onChanged: (value) {
            if (value != null) provider.secButtonShape = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enabled'),
          value: provider.isSecButtonEnabled,
          onChanged: (value) => provider.isSecButtonEnabled = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Loading'),
          value: provider.isSecButtonLoading,
          onChanged: (value) => provider.isSecButtonLoading = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Full Width'),
          value: provider.isSecButtonFullWidth,
          onChanged: (value) => provider.isSecButtonFullWidth = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Leading Icon'),
          value: provider.showSecButtonLeadingIcon,
          onChanged: (value) => provider.showSecButtonLeadingIcon = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Trailing Icon'),
          value: provider.showSecButtonTrailingIcon,
          onChanged: (value) => provider.showSecButtonTrailingIcon = value,
        ),
      ],
    );
  }
}
