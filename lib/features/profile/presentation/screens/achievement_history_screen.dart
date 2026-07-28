import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../router.dart';
import '../../../gamification/domain/entities/badge_entry.dart';
import '../../../gamification/presentation/constants/rewards_strings.dart';
import '../../../gamification/presentation/widgets/rewards_badge_tile.dart';
import '../constants/profile_strings.dart';
import '../providers/profile_providers.dart';

class AchievementHistoryScreen extends ConsumerWidget {
  const AchievementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<BadgeEntry> all = ref.watch(profileBadgesProvider);
    final int totalEarned =
        all.where((BadgeEntry b) => b.earnedAtIso.isNotEmpty).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(ProfileStrings.achievementsSectionTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.profile),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _SummaryCard(
                earned: totalEarned,
                total: all.length,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveBuilder.value<double>(
                        context,
                        mobile: double.infinity,
                        tablet: AppSizes.tabletMaxWidth.toDouble(),
                      ),
                    ),
                    child: all.isEmpty
                        ? const _EmptyAchievements()
                        : Column(
                            children: <Widget>[
                              for (final BadgeEntry badge in all)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: RewardsBadgeTile(
                                    badge: badge,
                                    isDark: isDark,
                                  ),
                                ),
                              const SizedBox(height: AppSpacing.xxl),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.earned, required this.total});

  final int earned;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double ratio = total == 0 ? 0 : earned / total;
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Achievements',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$earned of $total unlocked',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              backgroundColor:
                  theme.dividerColor.withValues(alpha: 0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            RewardsStrings.badgesSubtitle,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _EmptyAchievements extends StatelessWidget {
  const _EmptyAchievements();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.emoji_events_outlined, size: AppSizes.iconXl),
          const SizedBox(height: AppSpacing.md),
          Text(
            ProfileStrings.noAchievements,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassCard(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: const Text(ProfileStrings.noBadges),
          ),
          const SizedBox(height: AppSpacing.lg),
          SecondaryButton(
            text: 'Back to profile',
            onPressed: () => context.goNamed(AppRoutes.profile),
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}