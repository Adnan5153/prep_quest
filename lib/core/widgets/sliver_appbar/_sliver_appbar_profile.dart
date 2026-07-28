import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// A profile avatar widget for the SliverAppBar.
class SliverAppBarProfile extends StatelessWidget {
  const SliverAppBarProfile({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: const Hero(
          tag: 'profile_avatar',
          child: _ProfileAvatarContent(),
        ),
      ),
    );
  }
}

class _ProfileAvatarContent extends StatelessWidget {
  const _ProfileAvatarContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.iconXl,
      height: AppSizes.iconXl,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: Colors.white.withValues(alpha: .30)),
      ),
      child: const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: AppSizes.iconMd,
      ),
    );
  }
}
