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
import '../widgets/mission_completed_dialog.dart';
import '../widgets/mission_empty_state.dart';
import '../widgets/mission_error_state.dart';
import '../widgets/mission_list.dart';
import '../widgets/mission_loading_state.dart';

/// Per-cadence mission screen.
///
/// The shared [CadenceMissionsBody] widget backs every cadence. Each
/// concrete screen supplies its [MissionCadence] and the AppBar title.
abstract class CadenceMissionsScreen extends ConsumerStatefulWidget {
  const CadenceMissionsScreen({super.key});

  MissionCadence get cadence;
  String get appBarTitle;
}

class DailyMissionsScreen extends CadenceMissionsScreen {
  const DailyMissionsScreen({super.key});

  @override
  MissionCadence get cadence => MissionCadence.daily;

  @override
  String get appBarTitle => MissionStrings.dailyScreenTitle;

  @override
  ConsumerState<CadenceMissionsScreen> createState() =>
      _CadenceMissionsScreenState();
}

class WeeklyMissionsScreen extends CadenceMissionsScreen {
  const WeeklyMissionsScreen({super.key});

  @override
  MissionCadence get cadence => MissionCadence.weekly;

  @override
  String get appBarTitle => MissionStrings.weeklyScreenTitle;

  @override
  ConsumerState<CadenceMissionsScreen> createState() =>
      _CadenceMissionsScreenState();
}

class MonthlyMissionsScreen extends CadenceMissionsScreen {
  const MonthlyMissionsScreen({super.key});

  @override
  MissionCadence get cadence => MissionCadence.monthly;

  @override
  String get appBarTitle => MissionStrings.monthlyScreenTitle;

  @override
  ConsumerState<CadenceMissionsScreen> createState() =>
      _CadenceMissionsScreenState();
}

class _CadenceMissionsScreenState extends ConsumerState<CadenceMissionsScreen> {
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

    ref.listen<MissionsViewState>(missionsControllerProvider,
        (MissionsViewState? previous, MissionsViewState next) {
      if (next.lastReward != null && previous?.lastReward == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          MissionCompletedDialog.show(
            context,
            reward: next.lastReward!,
            missionTitle: next.lastRewardMissionTitle,
          );
          ref.read(missionsControllerProvider.notifier).clearReward();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.missions),
        ),
      ),
      body: SafeArea(
        child: state.isLoading && !state.isReady
            ? const MissionLoadingState()
            : state.errorMessage != null && !state.isReady
                ? MissionErrorState(
                    message: state.errorMessage!,
                    onRetry: () =>
                        ref.read(missionsControllerProvider.notifier).load(),
                  )
                : _CadenceMissionsBody(
                    state: state,
                    isDark: isDark,
                    cadence: widget.cadence,
                  ),
      ),
    );
  }
}

class _CadenceMissionsBody extends ConsumerWidget {
  const _CadenceMissionsBody({
    required this.state,
    required this.isDark,
    required this.cadence,
  });

  final MissionsViewState state;
  final bool isDark;
  final MissionCadence cadence;

  ({List<MissionEntity> missions, DateTime? nextReset}) _resolve() {
    switch (cadence) {
      case MissionCadence.daily:
        return (missions: state.daily, nextReset: state.nextDailyReset);
      case MissionCadence.weekly:
        return (missions: state.weekly, nextReset: state.nextWeeklyReset);
      case MissionCadence.monthly:
        return (missions: state.monthly, nextReset: state.nextMonthlyReset);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolved = _resolve();
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
    if (resolved.missions.isEmpty) return const MissionEmptyState();
    void onClaim(String missionId) {
      ref.read(missionsControllerProvider.notifier).claim(missionId);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppSpacing.lg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: MissionList(
            cadence: cadence,
            missions: resolved.missions,
            nextReset: resolved.nextReset,
            isDark: isDark,
            onClaim: onClaim,
          ),
        ),
      ),
    );
  }
}