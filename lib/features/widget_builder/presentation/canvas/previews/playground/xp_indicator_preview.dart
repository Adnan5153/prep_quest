import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/xp_indicator.dart';
import '../../../providers/widget_builder_provider.dart';

class XpIndicatorPreview extends StatelessWidget {
  const XpIndicatorPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controlled = _buildXp(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('XP Indicator', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: _ThemedTile(
                brightness: Brightness.light,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: XpIndicator(visual: controlled)),
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
                  child: Center(child: XpIndicator(visual: controlled)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Progress Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _ProgressTile(progress: 0.1, level: 5),
                  _ProgressTile(progress: 0.25, level: 9),
                  _ProgressTile(progress: 0.5, level: 14),
                  _ProgressTile(progress: 0.75, level: 22),
                  _ProgressTile(progress: 1.0, level: 30),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Gain Animation',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _GainTile(delta: 25, isAnimating: true),
                  _GainTile(delta: 60, isAnimating: true),
                  _GainTile(delta: 120, isAnimating: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

XpVisual _buildXp(WidgetBuilderProvider provider) {
  return XpVisual(
    totalXp: provider.playgroundXpIndicatorTotalXp,
    userLevel: provider.playgroundXpIndicatorUserLevel,
    xpInLevel: provider.playgroundXpIndicatorXpInLevel,
    xpForNextLevel: provider.playgroundXpIndicatorXpForNextLevel,
    gainDelta: provider.playgroundXpIndicatorGainDelta,
    isAnimatingGain: provider.playgroundXpIndicatorIsAnimatingGain,
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

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({required this.progress, required this.level});
  final double progress;
  final int level;

  @override
  Widget build(BuildContext context) {
    final inLevel = (progress * 500).round();
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 64,
            child: Center(
              child: XpIndicator(
                visual: XpVisual(
                  totalXp: level * 500,
                  userLevel: level,
                  xpInLevel: inLevel,
                  xpForNextLevel: 500,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Level $level · ${(progress * 100).round()}%',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _GainTile extends StatelessWidget {
  const _GainTile({required this.delta, required this.isAnimating});
  final int delta;
  final bool isAnimating;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 64,
            child: Center(
              child: XpIndicator(
                visual: XpVisual(
                  totalXp: 5000,
                  userLevel: 14,
                  xpInLevel: 220,
                  xpForNextLevel: 500,
                  gainDelta: delta,
                  isAnimatingGain: isAnimating,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '+$delta XP gain',
            style: Theme.of(context).textTheme.labelSmall,
          ),
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
