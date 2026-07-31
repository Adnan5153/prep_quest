import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/user_rewards_state.dart';
import '../providers/mission_provider.dart';
import '../providers/rewards_provider.dart';
import '../widgets/claim_reward_button.dart';
import '../widgets/daily_mission_card.dart';
import '../widgets/reward_history_tile.dart';
import '../widgets/streak_card.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RewardsViewState view = ref.watch(rewardsControllerProvider);
    final UserRewardsState snapshot = view.snapshot;
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _XpSection(snapshot: snapshot),
            const SizedBox(height: 16),
            StreakCard(state: snapshot.streak, isDark: isDark),
            const SizedBox(height: 16),
            _DailyRewardSection(snapshot: snapshot),
            const SizedBox(height: 16),
            const _MissionsSection(),
            const SizedBox(height: 16),
            _HistorySection(history: view.history, isDark: isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _XpSection extends StatelessWidget {
  const _XpSection({required this.snapshot});

  final UserRewardsState snapshot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final double progress = snapshot.level.nextLevelXP == 0
        ? 0
        : (snapshot.level.currentXP / snapshot.level.nextLevelXP)
            .clamp(0.0, 1.0);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Level ${snapshot.level.currentLevel}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${snapshot.totalXP} XP',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${snapshot.level.currentXP} / ${snapshot.level.nextLevelXP} XP to next level',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyRewardSection extends ConsumerWidget {
  const _DailyRewardSection({required this.snapshot});

  final UserRewardsState snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool todayClaimed =
        snapshot.streak.isTodayClaimed(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.accent, AppColors.warning],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Daily reward',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            todayClaimed
                ? 'Already claimed today — see you tomorrow!'
                : 'Open today\'s chest to earn coins + XP',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: ClaimRewardButton(
              enabled: !todayClaimed,
              onPressed: () {
                // Surface a tap target — the actual grant flows
                // through RewardsController.claimDaily once the
                // user reaches the daily-reward flow.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Daily chest opened')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionsSection extends ConsumerWidget {
  const _MissionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final MissionsViewState missions = ref.watch(missionsControllerProvider);
    final daily = missions.daily.take(3).toList();

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Today's missions",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (daily.isEmpty)
            Text(
              'No missions today — come back tomorrow.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              ),
            )
          else
            ...daily.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DailyMissionCard(mission: m, isDark: isDark),
                )),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.history, required this.isDark});

  final List history;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final recent = history.take(10).toList();
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Reward history',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (recent.isEmpty)
            Text(
              'No rewards yet — complete a quiz to start your streak.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              ),
            )
          else
            ...recent.map((entry) => RewardHistoryTile(
                  entry: entry,
                  isDark: isDark,
                )),
        ],
      ),
    );
  }
}