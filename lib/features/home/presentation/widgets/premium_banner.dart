import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../router.dart';

/// Premium upgrade banner. Renders only when the user is on the free
/// tier — premium subscribers see nothing.
class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key, required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    if (isPremium) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.workspace_premium,
              color: AppColors.accent, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.homePremiumBannerTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.homePremiumBannerSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.darkOnSurface,
            ),
            onPressed: () => context.goNamed(AppRoutes.subscriptionPlans),
            child: Text(AppStrings.homePremiumBannerCta),
          ),
        ],
      ),
    );
  }
}