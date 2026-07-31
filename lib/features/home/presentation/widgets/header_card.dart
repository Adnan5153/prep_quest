import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../router.dart';
import '../../../profile/domain/entities/user_profile.dart';

/// Top banner on the home dashboard. Shows the signed-in user's
/// display name, avatar, and premium status. Falls back to a
/// sign-in CTA when no profile is available.
class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key, required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final UserProfile? profile = this.profile;
    final String name = profile?.displayName.isNotEmpty == true
        ? profile!.displayName
        : AppStrings.signInPrompt;
    final String? photoUrl =
        profile != null && profile.photoUrl.isNotEmpty ? profile.photoUrl : null;
    final bool isPremium = profile?.role == 'premium';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.goNamed(AppRoutes.profile),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? AppColors.darkMuted.withValues(alpha: 0.4)
                  : AppColors.lightMuted.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? Text(
                        _initials(name),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPremium ? AppStrings.premium : AppStrings.free,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isPremium
                            ? AppColors.accent
                            : AppColors.lightMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? AppColors.darkMuted
                    : AppColors.lightMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'G';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}