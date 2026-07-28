import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../features/playground/presentation/widgets/overlays/coin_counter.dart';
import '../../../providers/widget_builder_provider.dart';

class CoinCounterPreview extends StatelessWidget {
  const CoinCounterPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controlled = _buildCoin(provider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Coin Counter', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: _ThemedTile(
                brightness: Brightness.light,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: CoinCounter(visual: controlled)),
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
                  child: Center(child: CoinCounter(visual: controlled)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Balance Gallery',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: const <Widget>[
                  _BalanceTile(balance: 0),
                  _BalanceTile(balance: 120),
                  _BalanceTile(balance: 1840),
                  _BalanceTile(balance: 12500),
                  _BalanceTile(balance: 99999),
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
                  _GainTile(delta: 25, balance: 1840, isAnimating: true),
                  _GainTile(delta: 100, balance: 1840, isAnimating: true),
                  _GainTile(delta: 500, balance: 1840, isAnimating: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

CoinVisual _buildCoin(WidgetBuilderProvider provider) {
  return CoinVisual(
    balance: provider.playgroundCoinCounterBalance,
    gainDelta: provider.playgroundCoinCounterGainDelta,
    isAnimatingGain: provider.playgroundCoinCounterIsAnimatingGain,
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

class _BalanceTile extends StatelessWidget {
  const _BalanceTile({required this.balance});
  final int balance;

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
              child: CoinCounter(visual: CoinVisual(balance: balance)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('$balance coins', style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _GainTile extends StatelessWidget {
  const _GainTile({
    required this.delta,
    required this.balance,
    required this.isAnimating,
  });
  final int delta;
  final int balance;
  final bool isAnimating;

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
              child: CoinCounter(
                visual: CoinVisual(
                  balance: balance,
                  gainDelta: delta,
                  isAnimatingGain: isAnimating,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '+$delta coin gain',
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
