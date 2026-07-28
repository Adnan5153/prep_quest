import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

class ProfileAvatarControls extends StatelessWidget {
  const ProfileAvatarControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text('Avatar Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.avatarInitials,
          decoration: const InputDecoration(labelText: 'Initials'),
          onChanged: (value) => provider.avatarInitials = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Size: ${provider.avatarSize.toInt()}px',
          style: theme.textTheme.labelMedium,
        ),
        Slider.adaptive(
          value: provider.avatarSize,
          min: 32,
          max: 160,
          onChanged: (value) => provider.avatarSize = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Online Status'),
          value: provider.isAvatarOnline,
          onChanged: (value) => provider.isAvatarOnline = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Premium Badge'),
          value: provider.showAvatarPremium,
          onChanged: (value) => provider.showAvatarPremium = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Verified Badge'),
          value: provider.showAvatarVerified,
          onChanged: (value) => provider.showAvatarVerified = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Edit Button'),
          value: provider.showAvatarEdit,
          onChanged: (value) => provider.showAvatarEdit = value,
        ),
      ],
    );
  }
}
