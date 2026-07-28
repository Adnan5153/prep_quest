import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/streak_card.dart';
import '../../../providers/widget_builder_provider.dart';

class StreakCardOverlayPreview extends StatelessWidget {
  const StreakCardOverlayPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controlled = _buildStreak(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Streak Card Overlay', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: _ThemedTile(
                brightness: Brightness.light,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: StreakCard(visual: controlled)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: _ThemedTile(
                brightness: Brightness.dark,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: StreakCard(visual: controlled)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Streak Lengths',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _StreakTile(days: 1, label: 'Day 1'),
                  _StreakTile(days: 7, label: 'Week'),
                  _StreakTile(days: 27, label: 'Month'),
                  _StreakTile(days: 100, label: 'Century'),
                  _StreakTile(days: 365, label: 'Year'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'State Combinations',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _StateTile(days: 7, isAtRisk: false, milestoneReached: false),
                  _StateTile(days: 7, isAtRisk: true, milestoneReached: false),
                  _StateTile(days: 30, isAtRisk: false, milestoneReached: true),
                  _StateTile(days: 100, isAtRisk: true, milestoneReached: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

StreakVisual _buildStreak(WidgetBuilderProvider provider) {
  return StreakVisual(
    days: provider.playgroundStreakCardDays,
    isAtRisk: provider.playgroundStreakCardIsAtRisk,
    milestoneReached: provider.playgroundStreakCardMilestoneReached,
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _StreakTile extends StatelessWidget {
  const _StreakTile({required this.days, required this.label});
  final int days;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 64,
            child: Center(
              child: StreakCard(visual: StreakVisual(days: days)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$label · $days days',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _StateTile extends StatelessWidget {
  const _StateTile({
    required this.days,
    required this.isAtRisk,
    required this.milestoneReached,
  });
  final int days;
  final bool isAtRisk;
  final bool milestoneReached;

  @override
  Widget build(BuildContext context) {
    final buffer = StringBuffer();
    if (isAtRisk) buffer.write('At Risk');
    if (milestoneReached) {
      if (buffer.isNotEmpty) buffer.write(' · ');
      buffer.write('Milestone');
    }
    final label = buffer.isEmpty ? 'Stable' : buffer.toString();
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 64,
            child: Center(
              child: StreakCard(
                visual: StreakVisual(
                  days: days,
                  isAtRisk: isAtRisk,
                  milestoneReached: milestoneReached,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ThemedTile extends StatelessWidget {
  const _ThemedTile({required this.brightness, required this.child});
  final Brightness brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.dark
            ? const Color(0xFF15151B)
            : const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(data: theme, child: child),
    );
  }
}
