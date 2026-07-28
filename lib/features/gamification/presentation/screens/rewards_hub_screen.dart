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
import '../widgets/reward_history_tile.dart';
import '../widgets/rewards_badge_tile.dart';
import '../widgets/rewards_hud_chip.dart';

/// Central landing screen for the rewards feature.
class RewardsHubScreen extends ConsumerStatefulWidget {
  const RewardsHubScreen({super.key});

  @override
  ConsumerState<RewardsHubScreen> createState() => _RewardsHubScreenState();
}

class _RewardsHubScreenState extends ConsumerState<RewardsHubScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(RewardsStrings.hubTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.profile),
        ),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null && !state.isReady
                ? _ErrorState(
                    message: state.errorMessage!,
                    onRetry: () =>
                        ref.read(rewardsControllerProvider.notifier).load(),
                  )
                : _Body(state: state, isDark: isDark),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.isDark});

  final RewardsViewState state;
  final bool isDark;

  Color get _foreground =>
      isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

  Color get _muted => isDark ? AppColors.darkMuted : AppColors.lightMuted;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = ResponsiveBuilder.value<double>(
      context,
      mobile: AppSpacing.lg,
      tablet: AppSpacing.xl,
      desktop: AppSpacing.xxl,
    );
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );
    final List<BadgeEntry> badges = state.snapshot.badges;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppSpacing.lg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                RewardsStrings.hubSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _muted,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              _BalanceSummary(state: state, isDark: isDark),
              const SizedBox(height: AppSpacing.lg),
              _QuickActions(isDark: isDark),
              const SizedBox(height: AppSpacing.lg),
              Text(
                RewardsStrings.hubSectionBadges,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _foreground,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (badges.isEmpty)
                _EmptyState(message: RewardsStrings.hubEmptyBadges)
              else
                _BadgeStrip(
                  badges: badges.take(4).toList(growable: false),
                  isDark: isDark,
                ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                RewardsStrings.hubSectionHistory,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _foreground,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (state.history.isEmpty)
                _EmptyState(message: RewardsStrings.hubEmptyHistory)
              else
                Column(
                  children: <Widget>[
                    for (final dynamic entry in state.history.take(5))
                      RewardHistoryTile(
                        entry: entry,
                        isDark: isDark,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({required this.state, required this.isDark});

  final RewardsViewState state;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            RewardsStrings.hubSectionBalance,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: <Widget>[
              RewardsHudChip(
                label: RewardsStrings.xpLabel,
                value: '${state.snapshot.totalXP}',
                icon: AppIcons.xp,
                color: AppColors.accent,
                isDark: isDark,
              ),
              RewardsHudChip(
                label: RewardsStrings.coinsLabel,
                value: '${state.snapshot.totalCoins}',
                icon: AppIcons.coinIcon,
                color: AppColors.warning,
                isDark: isDark,
              ),
              RewardsHudChip(
                label: RewardsStrings.levelLabel,
                value: '${state.snapshot.level.currentLevel}',
                icon: AppIcons.crown,
                color: AppColors.info,
                isDark: isDark,
              ),
              RewardsHudChip(
                label: RewardsStrings.streakLabel,
                value: '${state.snapshot.streak.currentDays}',
                icon: AppIcons.fireFilled,
                color: AppColors.error,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        _ActionButton(
          label: RewardsStrings.hubActionDaily,
          icon: AppIcons.calendar,
          routeName: AppRoutes.rewardsDaily,
        ),
        _ActionButton(
          label: RewardsStrings.hubActionBadges,
          icon: AppIcons.badgeStar,
          routeName: AppRoutes.rewardsBadges,
        ),
        _ActionButton(
          label: RewardsStrings.hubActionHistory,
          icon: AppIcons.star,
          routeName: AppRoutes.rewardsHistory,
        ),
        _ActionButton(
          label: RewardsStrings.hubActionChests,
          icon: AppIcons.gem,
          routeName: AppRoutes.rewardsChest,
        ),
        _ActionButton(
          label: 'Missions',
          icon: AppIcons.mission,
          routeName: AppRoutes.missions,
        ),
        _ActionButton(
          label: 'Streak',
          icon: AppIcons.streak,
          routeName: AppRoutes.streak,
        ),
        _ActionButton(
          label: 'Leaderboard',
          icon: AppIcons.trophy,
          routeName: AppRoutes.leaderboard,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.routeName,
  });

  final String label;
  final IconData icon;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      text: label,
      icon: icon,
      onPressed: () => context.goNamed(routeName),
      fullWidth: false,
    );
  }
}

class _BadgeStrip extends StatelessWidget {
  const _BadgeStrip({required this.badges, required this.isDark});

  final List<BadgeEntry> badges;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: <Widget>[
        for (final BadgeEntry badge in badges)
          SizedBox(
            width: 280,
            child: RewardsBadgeTile(
              badge: badge,
              isDark: isDark,
              onFavoriteToggle: () => _toggle(context, badge.id),
            ),
          ),
      ],
    );
  }

  void _toggle(BuildContext context, String badgeId) {
    final ProviderContainer container = ProviderScope.containerOf(context);
    container.read(rewardsControllerProvider.notifier).toggleFavorite(badgeId);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface
            .withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(AppIcons.error, size: AppSizes.iconXl),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              text: 'Retry',
              onPressed: onRetry,
              fullWidth: false,
              icon: AppIcons.refresh,
            ),
          ],
        ),
      ),
    );
  }
}