import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../router.dart';
import '../../domain/entities/badge_entry.dart';
import '../constants/rewards_strings.dart';
import '../providers/rewards_provider.dart';
import '../widgets/rewards_badge_tile.dart';

/// Full badge collection with favorite toggle and filter pills.
class BadgeCollectionScreen extends ConsumerStatefulWidget {
  const BadgeCollectionScreen({super.key});

  @override
  ConsumerState<BadgeCollectionScreen> createState() =>
      _BadgeCollectionScreenState();
}

class _BadgeCollectionScreenState
    extends ConsumerState<BadgeCollectionScreen> {
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(rewardsControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final RewardsViewState state = ref.watch(rewardsControllerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<BadgeEntry> badges = _showFavoritesOnly
        ? state.snapshot.badges
            .where((BadgeEntry b) => b.isFavorite)
            .toList(growable: false)
        : state.snapshot.badges;
    return Scaffold(
      appBar: AppBar(
        title: const Text(RewardsStrings.badgesTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.rewards),
        ),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          RewardsStrings.badgesSubtitle,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? AppColors.darkMuted
                                        : AppColors.lightMuted,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          children: <Widget>[
                            _FilterChip(
                              label: RewardsStrings.badgesFilterAll,
                              selected: !_showFavoritesOnly,
                              onTap: () => setState(
                                  () => _showFavoritesOnly = false),
                            ),
                            _FilterChip(
                              label: RewardsStrings.badgesFilterFavorites,
                              selected: _showFavoritesOnly,
                              onTap: () => setState(
                                  () => _showFavoritesOnly = true),
                            ),
                          ],
                        ),
                      ],
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
                          child: badges.isEmpty
                              ? _EmptyState(
                                  message: _showFavoritesOnly
                                      ? 'No favorite badges yet.'
                                      : RewardsStrings.hubEmptyBadges,
                                )
                              : Column(
                                  children: <Widget>[
                                    for (final BadgeEntry badge in badges)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppSpacing.sm,
                                        ),
                                        child: RewardsBadgeTile(
                                          badge: badge,
                                          isDark: isDark,
                                          onFavoriteToggle: () => ref
                                              .read(rewardsControllerProvider
                                                  .notifier)
                                              .toggleFavorite(badge.id),
                                        ),
                                      ),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected
                ? AppColors.accent
                : Theme.of(context).colorScheme.outline,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected
                    ? AppColors.accent
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(AppIcons.badgeStar, size: AppSizes.iconXl),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SecondaryButton(
            text: 'Back to rewards',
            icon: AppIcons.arrowForward,
            onPressed: () => context.goNamed(AppRoutes.rewards),
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}