import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class PremiumBadgeControls extends StatelessWidget {
  const PremiumBadgeControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Premium Badge Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.badgeLabel,
          decoration: const InputDecoration(labelText: 'Label'),
          onChanged: (value) => provider.badgeLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.badgeStyle,
          decoration: const InputDecoration(labelText: 'Badge Style'),
          items: const [
            DropdownMenuItem(value: 'gold', child: Text('Gold')),
            DropdownMenuItem(value: 'amber', child: Text('Amber')),
            DropdownMenuItem(value: 'gradient', child: Text('Gradient')),
            DropdownMenuItem(value: 'outlined', child: Text('Outlined')),
            DropdownMenuItem(value: 'filled', child: Text('Filled')),
            DropdownMenuItem(value: 'glass', child: Text('Glass')),
            DropdownMenuItem(value: 'pill', child: Text('Pill')),
            DropdownMenuItem(value: 'compact', child: Text('Compact')),
          ],
          onChanged: (value) {
            if (value != null) provider.badgeStyle = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Icon'),
          value: provider.showBadgeIcon,
          onChanged: (value) => provider.showBadgeIcon = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable Animation'),
          value: provider.enableBadgeAnimation,
          onChanged: (value) => provider.enableBadgeAnimation = value,
        ),
      ],
    );
  }
}

class StatusChipControls extends StatelessWidget {
  const StatusChipControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Status Chip Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.chipLabel,
          decoration: const InputDecoration(labelText: 'Label'),
          onChanged: (value) => provider.chipLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.chipStatus,
          decoration: const InputDecoration(labelText: 'Status Type'),
          items: const [
            DropdownMenuItem(value: 'success', child: Text('Success')),
            DropdownMenuItem(value: 'warning', child: Text('Warning')),
            DropdownMenuItem(value: 'error', child: Text('Error')),
            DropdownMenuItem(value: 'info', child: Text('Info')),
            DropdownMenuItem(value: 'premium', child: Text('Premium')),
            DropdownMenuItem(value: 'locked', child: Text('Locked')),
            DropdownMenuItem(value: 'completed', child: Text('Completed')),
            DropdownMenuItem(value: 'pending', child: Text('Pending')),
            DropdownMenuItem(value: 'inProgress', child: Text('In Progress')),
            DropdownMenuItem(value: 'newStatus', child: Text('New')),
            DropdownMenuItem(value: 'live', child: Text('Live')),
            DropdownMenuItem(value: 'online', child: Text('Online')),
            DropdownMenuItem(value: 'offline', child: Text('Offline')),
            DropdownMenuItem(value: 'expired', child: Text('Expired')),
          ],
          onChanged: (value) {
            if (value != null) provider.chipStatus = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.chipVariant,
          decoration: const InputDecoration(labelText: 'Variant'),
          items: const [
            DropdownMenuItem(value: 'soft', child: Text('Soft')),
            DropdownMenuItem(value: 'filled', child: Text('Filled')),
            DropdownMenuItem(value: 'outlined', child: Text('Outlined')),
            DropdownMenuItem(value: 'glass', child: Text('Glass')),
            DropdownMenuItem(value: 'gradient', child: Text('Gradient')),
            DropdownMenuItem(value: 'pill', child: Text('Pill')),
          ],
          onChanged: (value) {
            if (value != null) provider.chipVariant = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.chipSize,
          decoration: const InputDecoration(labelText: 'Size'),
          items: const [
            DropdownMenuItem(value: 'small', child: Text('Small')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'large', child: Text('Large')),
          ],
          onChanged: (value) {
            if (value != null) provider.chipSize = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Icon'),
          value: provider.showChipIcon,
          onChanged: (value) => provider.showChipIcon = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enable Animation'),
          value: provider.enableChipAnimation,
          onChanged: (value) => provider.enableChipAnimation = value,
        ),
      ],
    );
  }
}

class TagChipControls extends StatelessWidget {
  const TagChipControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Tag Chip Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.tagLabel,
          decoration: const InputDecoration(labelText: 'Label'),
          onChanged: (value) => provider.tagLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.tagVariant,
          decoration: const InputDecoration(labelText: 'Variant'),
          items: const [
            DropdownMenuItem(value: 'soft', child: Text('Soft')),
            DropdownMenuItem(value: 'filled', child: Text('Filled')),
            DropdownMenuItem(value: 'outlined', child: Text('Outlined')),
            DropdownMenuItem(value: 'gradient', child: Text('Gradient')),
            DropdownMenuItem(value: 'glass', child: Text('Glass')),
            DropdownMenuItem(value: 'tonal', child: Text('Tonal')),
          ],
          onChanged: (value) {
            if (value != null) provider.tagVariant = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.tagSize,
          decoration: const InputDecoration(labelText: 'Size'),
          items: const [
            DropdownMenuItem(value: 'small', child: Text('Small')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'large', child: Text('Large')),
          ],
          onChanged: (value) {
            if (value != null) provider.tagSize = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.tagShape,
          decoration: const InputDecoration(labelText: 'Shape'),
          items: const [
            DropdownMenuItem(value: 'pill', child: Text('Pill')),
            DropdownMenuItem(value: 'rounded', child: Text('Rounded')),
            DropdownMenuItem(value: 'rectangle', child: Text('Rectangle')),
          ],
          onChanged: (value) {
            if (value != null) provider.tagShape = value;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Selected'),
          value: provider.isTagSelected,
          onChanged: (value) => provider.isTagSelected = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enabled'),
          value: provider.isTagEnabled,
          onChanged: (value) => provider.isTagEnabled = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Closable'),
          value: provider.isTagClosable,
          onChanged: (value) => provider.isTagClosable = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Leading Icon'),
          value: provider.showTagLeadingIcon,
          onChanged: (value) => provider.showTagLeadingIcon = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Trailing Icon'),
          value: provider.showTagTrailingIcon,
          onChanged: (value) => provider.showTagTrailingIcon = value,
        ),
      ],
    );
  }
}
