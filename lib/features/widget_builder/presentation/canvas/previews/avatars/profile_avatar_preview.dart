import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/profile_avatar.dart';
import '../../../providers/widget_builder_provider.dart';

class ProfileAvatarPreview extends StatelessWidget {
  const ProfileAvatarPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileAvatar(
              size: provider.avatarSize,
              initials: provider.avatarInitials,
              isOnline: provider.isAvatarOnline,
              showOnlineIndicator: true,
              showPremiumBadge: provider.showAvatarPremium,
              showVerifiedBadge: provider.showAvatarVerified,
              showEditButton: provider.showAvatarEdit,
              onTap: () {},
              onEdit: () {},
            ),
            const SizedBox(height: AppSpacing.xxl),
            const Text('Avatar Gallery'),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileAvatar(
                  size: 40,
                  initials: provider.avatarInitials,
                  showPremiumBadge: provider.showAvatarPremium,
                ),
                const SizedBox(width: AppSpacing.md),
                ProfileAvatar(
                  size: 60,
                  initials: provider.avatarInitials,
                  showOnlineIndicator: true,
                  isOnline: provider.isAvatarOnline,
                ),
                const SizedBox(width: AppSpacing.md),
                ProfileAvatar(
                  size: 100,
                  initials: provider.avatarInitials,
                  showEditButton: provider.showAvatarEdit,
                  onEdit: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
