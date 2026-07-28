import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../router.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_providers.dart';
import '../states/profile_state.dart';
import '../widgets/profile_action/profile_quick_actions.dart';
import '../widgets/profile_avatar/profile_avatar_card.dart';
import '../widgets/profile_badges/profile_badge_grid.dart';
import '../widgets/profile_energy/profile_energy_card.dart';
import '../widgets/profile_goal/profile_goal_card.dart';
import '../widgets/profile_header/profile_header_card.dart';
import '../widgets/profile_language/profile_language_card.dart';
import '../widgets/profile_progress/profile_coins_card.dart';
import '../widgets/profile_progress/profile_xp_progress_card.dart';
import '../widgets/profile_rank/profile_rank_card.dart';
import '../widgets/profile_stats/profile_stats_card.dart';
import '../constants/profile_strings.dart';

/// Primary Profile screen — single source of truth for the user's
/// identity, progression, and preferences.
///
/// Reads exclusively from [profileControllerProvider] so the screen
/// automatically reflects realtime updates and stays in sync with the
/// Playground HUD.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ProfileState state = ref.read(profileControllerProvider);
      if (state.status == ProfileStatus.unknown) {
        ref.read(profileControllerProvider.notifier).load();
      }
    });
  }

  void _onProfileChanged(ProfileState? previous, ProfileState next) {
    if (!mounted) return;
    if (next.lastSuccessMessage != null &&
        next.lastSuccessMessage != previous?.lastSuccessMessage) {
      AppSnackBar.showSuccess(context, next.lastSuccessMessage!);
    }
    if (next.errorMessage != null &&
        next.errorMessage != previous?.errorMessage) {
      AppSnackBar.showError(context, next.errorMessage!);
    }
  }

  void _onQuickAction(String id) {
    switch (id) {
      case ProfileStrings.aiTutorActionId:
        context.goNamed(AppRoutes.aiTutor);
        return;
      case ProfileStrings.rewardsActionId:
        context.goNamed(AppRoutes.rewards);
        return;
      case ProfileStrings.missionsActionId:
        context.goNamed(AppRoutes.missions);
        return;
      case ProfileStrings.streakActionId:
        context.goNamed(AppRoutes.streak);
        return;
      case ProfileStrings.searchActionId:
        context.goNamed(AppRoutes.search);
        return;
      case ProfileStrings.bookmarksActionId:
        context.goNamed(AppRoutes.bookmarks);
        return;
      case ProfileStrings.notesActionId:
        context.goNamed(AppRoutes.notes);
        return;
      case ProfileStrings.leaderboardActionId:
        context.goNamed(AppRoutes.leaderboard);
        return;
      default:
        AppSnackBar.showInfo(context, 'Quick action: $id');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileState>(profileControllerProvider, _onProfileChanged);
    final ProfileState state = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(ProfileStrings.screenTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => context.goNamed(AppRoutes.playground),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            tooltip: 'More',
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (String value) {
              switch (value) {
                case 'achievements':
                  context.goNamed(AppRoutes.profileAchievements);
                case 'statistics':
                  context.goNamed(AppRoutes.profileStatistics);
                case 'subscription':
                  context.pushNamed(AppRoutes.subscriptionPlans);
                case 'settings':
                  context.goNamed(AppRoutes.profileSettings);
              }
            },
            itemBuilder: (BuildContext context) =>
                const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'achievements',
                child: ListTile(
                  leading: Icon(Icons.emoji_events_outlined),
                  title: Text('Achievements'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'statistics',
                child: ListTile(
                  leading: Icon(Icons.bar_chart_outlined),
                  title: Text('Statistics'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'subscription',
                child: ListTile(
                  leading: Icon(Icons.workspace_premium_outlined),
                  title: Text('Subscription'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: state.status == ProfileStatus.initialLoading &&
                state.profile == null
            ? const Center(child: CircularProgressIndicator())
            : state.profile == null
                ? _ErrorState(
                    message:
                        state.errorMessage ?? ProfileStrings.loadingProfile,
                    onRetry: () =>
                        ref.read(profileControllerProvider.notifier).load(),
                  )
                : _Body(
                    profile: state.profile!,
                    onQuickAction: _onQuickAction,
                    isWorking: state.isWorking,
                  ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 3,
        onTap: (int index) => onDefaultBottomNavTap(context, index),
        notificationBadgeCount: ref.watch(notificationUnreadCountProvider),
        onNotificationTap: () => context.goNamed(AppRoutes.notifications),
        items: kDefaultBottomNavItems,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.profile,
    required this.onQuickAction,
    required this.isWorking,
  });

  final UserProfile profile;
  final ValueChanged<String> onQuickAction;
  final bool isWorking;

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

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= AppSizes.tabletMaxWidth;
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
                  ProfileAvatarCard(profile: profile),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileHeaderCard(profile: profile),
                  const SizedBox(height: AppSpacing.lg),
                  if (isWide)
                    _WideLayout(
                      profile: profile,
                      onQuickAction: onQuickAction,
                    )
                  else
                    _NarrowLayout(
                      profile: profile,
                      onQuickAction: onQuickAction,
                    ),
                  if (isWorking) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    const LinearProgressIndicator(),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({required this.profile, required this.onQuickAction});

  final UserProfile profile;
  final ValueChanged<String> onQuickAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ProfileQuickActions(profile: profile, onAction: onQuickAction),
        const SizedBox(height: AppSpacing.lg),
        ProfileXpProgressCard(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        ProfileStatsCard(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        ProfileGoalCard(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        ProfileLanguageCard(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        ProfileEnergyCard(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        ProfileCoinsCard(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        ProfileRankCard(profile: profile),
        const SizedBox(height: AppSpacing.lg),
        ProfileBadgeGrid(profile: profile),
      ],
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.profile, required this.onQuickAction});

  final UserProfile profile;
  final ValueChanged<String> onQuickAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ProfileQuickActions(profile: profile, onAction: onQuickAction),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  ProfileXpProgressCard(profile: profile),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileGoalCard(profile: profile),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileLanguageCard(profile: profile),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileRankCard(profile: profile),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  ProfileStatsCard(profile: profile),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileEnergyCard(profile: profile),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileCoinsCard(profile: profile),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ProfileBadgeGrid(profile: profile),
      ],
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, size: AppSizes.iconXl),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            SecondaryButton(
              text: ProfileStrings.retry,
              onPressed: onRetry,
              fullWidth: false,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
