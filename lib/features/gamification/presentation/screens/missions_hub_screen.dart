import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/mission_entity.dart';
import '../../domain/enums/mission_enums.dart';
import '../constants/mission_strings.dart';
import '../providers/mission_provider.dart';
import '../widgets/mission_hub_card.dart';

/// Central hub that routes the user into the daily / weekly / monthly
/// mission screens.
class MissionsHubScreen extends ConsumerStatefulWidget {
  const MissionsHubScreen({super.key});

  @override
  ConsumerState<MissionsHubScreen> createState() => _MissionsHubScreenState();
}

class _MissionsHubScreenState extends ConsumerState<MissionsHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(missionsControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MissionsViewState state = ref.watch(missionsControllerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(MissionStrings.hubTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.rewards),
        ),
      ),
      body: SafeArea(child: _Body(state: state, isDark: isDark)),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.state, required this.isDark});

  final MissionsViewState state;
  final bool isDark;

  ({int xp, int coins, int completed, int total}) _summaryFor(
    List<MissionEntity> missions,
  ) {
    int xp = 0;
    int coins = 0;
    int completed = 0;
    for (final MissionEntity m in missions) {
      xp += m.rewardXp;
      coins += m.rewardCoins;
      if (m.isCompleted || m.isClaimed) completed += 1;
    }
    return (xp: xp, coins: coins, completed: completed, total: missions.length);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final double horizontalPadding = ResponsiveBuilder.value<double>(
      context,
      mobile: AppSpacing.lg,
      tablet: AppSpacing.xl,
      desktop: AppSpacing.xxl,
    );
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 720.0,
      desktop: 960.0,
    );

    final dailySummary = _summaryFor(state.daily);
    final weeklySummary = _summaryFor(state.weekly);
    final monthlySummary = _summaryFor(state.monthly);

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
                MissionStrings.hubSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              MissionHubCard(
                cadence: MissionCadence.daily,
                title: MissionStrings.hubDailyTitle,
                subtitle: MissionStrings.hubDailySubtitle,
                completedCount: dailySummary.completed,
                totalCount: dailySummary.total,
                totalRewardXp: dailySummary.xp,
                totalRewardCoins: dailySummary.coins,
                isDark: isDark,
                onTap: () => context.goNamed(AppRoutes.missionsDaily),
              ),
              const SizedBox(height: AppSpacing.md),
              MissionHubCard(
                cadence: MissionCadence.weekly,
                title: MissionStrings.hubWeeklyTitle,
                subtitle: MissionStrings.hubWeeklySubtitle,
                completedCount: weeklySummary.completed,
                totalCount: weeklySummary.total,
                totalRewardXp: weeklySummary.xp,
                totalRewardCoins: weeklySummary.coins,
                isDark: isDark,
                onTap: () => context.goNamed(AppRoutes.missionsWeekly),
              ),
              const SizedBox(height: AppSpacing.md),
              MissionHubCard(
                cadence: MissionCadence.monthly,
                title: MissionStrings.hubMonthlyTitle,
                subtitle: MissionStrings.hubMonthlySubtitle,
                completedCount: monthlySummary.completed,
                totalCount: monthlySummary.total,
                totalRewardXp: monthlySummary.xp,
                totalRewardCoins: monthlySummary.coins,
                isDark: isDark,
                onTap: () => context.goNamed(AppRoutes.missionsMonthly),
              ),
            ],
          ),
        ),
      ),
    );
  }
}