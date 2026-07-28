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
import '../../domain/repositories/rewards_repository.dart';
import '../constants/rewards_strings.dart';
import '../providers/rewards_provider.dart';
import '../widgets/daily_reward_calendar.dart';

/// Renders the 7-day daily-reward calendar and a claim button.
class DailyRewardsScreen extends ConsumerStatefulWidget {
  const DailyRewardsScreen({super.key});

  @override
  ConsumerState<DailyRewardsScreen> createState() => _DailyRewardsScreenState();
}

class _DailyRewardsScreenState extends ConsumerState<DailyRewardsScreen> {
  static const List<DailyRewardTemplate> _templates =
      <DailyRewardTemplate>[
    DailyRewardTemplate(day: 1, xp: 25, coins: 10, title: 'Day 1'),
    DailyRewardTemplate(day: 2, xp: 35, coins: 15, title: 'Day 2'),
    DailyRewardTemplate(day: 3, xp: 50, coins: 20, title: 'Day 3'),
    DailyRewardTemplate(
        day: 4, xp: 75, coins: 30, title: 'Day 4', badgeIconKey: 'streak'),
    DailyRewardTemplate(day: 5, xp: 100, coins: 40, title: 'Day 5'),
    DailyRewardTemplate(day: 6, xp: 130, coins: 55, title: 'Day 6'),
    DailyRewardTemplate(
        day: 7,
        xp: 200,
        coins: 100,
        title: 'Day 7 (jackpot)',
        badgeIconKey: 'crown'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(rewardsControllerProvider.notifier).load();
    });
  }

  Future<void> _onClaim(int day) async {
    await ref.read(rewardsControllerProvider.notifier).claimDailyReward(day);
  }

  @override
  Widget build(BuildContext context) {
    final RewardsViewState state = ref.watch(rewardsControllerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(RewardsStrings.dailyTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.rewards),
        ),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.lg,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          RewardsStrings.dailySubtitle,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? AppColors.darkMuted
                                        : AppColors.lightMuted,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _StreakBanner(state: state),
                        const SizedBox(height: AppSpacing.lg),
                        DailyRewardCalendar(
                          templates: _templates,
                          state: state.snapshot,
                          onClaim: _onClaim,
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SecondaryButton(
                          text: RewardsStrings.dailyClaimToday,
                          icon: AppIcons.calendar,
                          onPressed: () => _onClaim(
                            state.snapshot.streak.currentDays + 1,
                          ),
                          fullWidth: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  const _StreakBanner({required this.state});

  final RewardsViewState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            AppIcons.fireFilled,
            color: AppColors.accent,
            size: AppSizes.iconLg,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  RewardsStrings.dailyCurrentTemplate.replaceAll(
                    '%d',
                    '${state.snapshot.streak.currentDays}',
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  RewardsStrings.dailyBestTemplate.replaceAll(
                    '%d',
                    '${state.snapshot.streak.bestDays}',
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}