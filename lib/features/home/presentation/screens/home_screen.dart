import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../router.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../profile/presentation/states/profile_state.dart';
import '../providers/home_provider.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/daily_goal_card.dart';
import '../widgets/header_card.dart';
import '../widgets/premium_banner.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/recent_activity.dart';
import '../widgets/streak_card.dart';
import '../widgets/xp_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const int _homeTabIndex = 0;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    final AsyncValue<HomeSnapshot> async = ref.watch(homeControllerProvider);

    return Scaffold(
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load home: $e',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        data: (HomeSnapshot snap) => _HomeBody(snapshot: snap),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: HomeScreen._homeTabIndex,
        onTap: (int i) {
          if (i == HomeScreen._homeTabIndex) return;
          onDefaultBottomNavTap(context, i);
        },
        notificationBadgeCount: ref.watch(notificationUnreadCountProvider),
        onNotificationTap: () => context.goNamed(AppRoutes.notifications),
        items: kDefaultBottomNavItems,
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.snapshot});

  final HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final UserProfile? profile = snapshot.profile;
    final int totalXp = profile?.progression.totalXp ?? 0;
    final int level = profile?.progression.level ?? 1;
    final int xpInLevel = profile?.progression.xpInLevel ?? 0;
    final int xpForNextLevel = profile?.progression.xpForNextLevel ?? 100;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          HeaderCard(profile: snapshot.profile),
          const SizedBox(height: 12),
          XpCard(
            totalXp: totalXp,
            level: level,
            xpInLevel: xpInLevel,
            xpForNextLevel: xpForNextLevel,
          ),
          const SizedBox(height: 12),
          StreakCard(
            days: snapshot.streakDays,
            atRisk: snapshot.streakAtRisk,
          ),
          const SizedBox(height: 12),
          DailyGoalCard(missions: snapshot.missions),
          const SizedBox(height: 12),
          ContinueLearningCard(category: snapshot.continueLearning),
          const SizedBox(height: 16),
          QuickActionGrid(),
          const SizedBox(height: 16),
          RecentActivityList(entries: snapshot.coinLedger),
          const SizedBox(height: 16),
          PremiumBanner(isPremium: snapshot.isPremium),
          const SizedBox(height: 24),
          Container(
            height: 1,
            color: isDark
                ? AppColors.darkMuted.withValues(alpha: 0.2)
                : AppColors.lightMuted.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}