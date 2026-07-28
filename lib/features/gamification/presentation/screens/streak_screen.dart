import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../router.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/enums/streak_enums.dart';
import '../constants/streak_strings.dart';
import '../providers/streak_provider.dart';
import '../widgets/daily_login_banner.dart';
import '../widgets/rewards_celebration_dialogs.dart';
import '../../domain/entities/reward_outcome.dart';
import '../widgets/streak_bonus.dart';
import '../widgets/streak_counter.dart';
import '../widgets/streak_progress.dart';
import '../widgets/streak_recovery_dialog.dart';

/// Streak hub — surfaces the counter, milestone progress, the bonus
/// ledger, and the daily-login banner. Sub-screens (calendar,
/// recovery) are reachable from inline actions.
class StreakScreen extends ConsumerStatefulWidget {
  const StreakScreen({super.key});

  @override
  ConsumerState<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends ConsumerState<StreakScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(streakControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final StreakViewState state = ref.watch(streakControllerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<StreakViewState>(streakControllerProvider,
        (StreakViewState? previous, StreakViewState next) {
      if (next.lastOutcome != null && previous?.lastOutcome == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _maybeCelebrate(next);
          ref.read(streakControllerProvider.notifier).clearOutcome();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(StreakStrings.hubTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.rewards),
        ),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null && !state.isReady
                ? _ErrorState(
                    message: state.errorMessage!,
                    onRetry: () =>
                        ref.read(streakControllerProvider.notifier).load(),
                  )
                : _Body(state: state, isDark: isDark),
      ),
    );
  }

  void _maybeCelebrate(StreakViewState next) {
    final RewardOutcome? outcome = next.lastOutcome;
    if (outcome == null) return;
    if (outcome.celebration.showLevelUpDialog) {
      LevelUpCelebrationDialog.show(context, outcome: outcome);
    } else if (outcome.celebration.showBadgeUnlock) {
      BadgeUnlockCelebrationDialog.show(context, outcome: outcome);
    }
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.state, required this.isDark});

  final StreakViewState state;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreakCounter(
            state: state.snapshot,
            isDark: isDark,
            onTap: () => _openRecovery(context, ref),
          ),
          const SizedBox(height: AppSpacing.md),
          StreakProgress(state: state.snapshot, isDark: isDark),
          const SizedBox(height: AppSpacing.md),
          DailyLoginBanner(
            state: state.snapshot,
            onClaim: () async {
              await ref
                  .read(streakControllerProvider.notifier)
                  .claimToday();
            },
            onRecover: () => _openRecovery(context, ref),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: SecondaryButton(
                  text: StreakStrings.calendarTitle,
                  icon: AppIcons.calendar,
                  onPressed: () =>
                      context.goNamed(AppRoutes.streakCalendar),
                  fullWidth: false,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SecondaryButton(
                  text: StreakStrings.recoveryTitle,
                  icon: AppIcons.shield,
                  onPressed: () => _openRecovery(context, ref),
                  fullWidth: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            StreakStrings.bonusSectionTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            StreakStrings.bonusSectionSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          if (state.bonusLedger.isEmpty)
            const _EmptyBonus()
          else
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: <Widget>[
                for (final StreakEntity e in state.bonusLedger)
                  SizedBox(
                    width: 260,
                    child: StreakBonus(
                      bonus: e,
                      unlocked: state.snapshot.currentDays >= e.day,
                      isDark: isDark,
                      onClaim: () => ref
                          .read(streakControllerProvider.notifier)
                          .claimBonus(day: e.day, type: e.type),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  void _openRecovery(BuildContext context, WidgetRef ref) {
    StreakRecoveryDialog.show(
      context,
      onConfirm: (RecoveryMethod method) {
        ref
            .read(streakControllerProvider.notifier)
            .recover(method: method);
      },
    );
  }
}

class _EmptyBonus extends StatelessWidget {
  const _EmptyBonus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        StreakStrings.emptyBonus,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
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
              text: StreakStrings.retry,
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