import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../router.dart';
import '../constants/streak_strings.dart';
import '../providers/streak_provider.dart';
import '../widgets/streak_calendar/calendar_grid.dart';

/// Monthly-style 30-day streak calendar.
class StreakCalendarScreen extends ConsumerStatefulWidget {
  const StreakCalendarScreen({super.key});

  @override
  ConsumerState<StreakCalendarScreen> createState() =>
      _StreakCalendarScreenState();
}

class _StreakCalendarScreenState
    extends ConsumerState<StreakCalendarScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(StreakStrings.calendarTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.streak),
        ),
      ),
      body: SafeArea(
        child: state.isLoading && !state.isReady
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      StreakStrings.calendarSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Expanded(
                      child: CalendarGrid(
                        days: state.snapshot.calendarDays,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}