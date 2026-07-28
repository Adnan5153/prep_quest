import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/energy_indicator.dart';
import '../../../providers/widget_builder_provider.dart';

class EnergyIndicatorPreview extends StatelessWidget {
  const EnergyIndicatorPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controlled = _buildEnergy(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Energy Indicator', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: _ThemedTile(
                brightness: Brightness.light,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: EnergyIndicator(visual: controlled)),
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
                  child: Center(child: EnergyIndicator(visual: controlled)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'State Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _StateTile(remaining: 0, max: 5, label: 'Depleted'),
                  _StateTile(remaining: 1, max: 5, label: 'At Risk'),
                  _StateTile(remaining: 3, max: 5, label: 'Normal'),
                  _StateTile(remaining: 5, max: 5, label: 'Full'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Recharge Countdowns',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _RechargeTile(seconds: 65),
                  _RechargeTile(seconds: 600),
                  _RechargeTile(seconds: 1800),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

EnergyVisual _buildEnergy(WidgetBuilderProvider provider) {
  return EnergyVisual(
    remaining: provider.playgroundEnergyIndicatorRemaining,
    max: provider.playgroundEnergyIndicatorMax,
    rechargeSecondsRemaining: provider.playgroundEnergyIndicatorRechargeSeconds,
    isAnimatingRefill: provider.playgroundEnergyIndicatorIsAnimatingRefill,
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

class _StateTile extends StatelessWidget {
  const _StateTile({
    required this.remaining,
    required this.max,
    required this.label,
  });
  final int remaining;
  final int max;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 64,
            child: Center(
              child: EnergyIndicator(
                visual: EnergyVisual(
                  remaining: remaining,
                  max: max,
                  rechargeSecondsRemaining: 1800,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$label · $remaining/$max',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _RechargeTile extends StatelessWidget {
  const _RechargeTile({required this.seconds});
  final int seconds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 64,
            child: Center(
              child: EnergyIndicator(
                visual: EnergyVisual(
                  remaining: 1,
                  max: 5,
                  rechargeSecondsRemaining: seconds,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Recharge in ${_formatTime(seconds)}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return '$mm:$ss';
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
