import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../features/playground/presentation/constants/playground_constants.dart';
import '../../../../../../features/playground/presentation/widgets/rewards/xp_reward.dart';
import '../../../providers/widget_builder_provider.dart';

class XpRewardPreview extends StatelessWidget {
  const XpRewardPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.playgroundXpRewardBrightness);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('XP Reward', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Glowing experience orb with pulsing halo and level-up variant',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              brightness: brightness,
              child: Center(child: _xpFromProvider(provider)),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Size Variants',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _SizeTile(label: 'Compact', size: XpRewardSize.compact),
                  _SizeTile(label: 'Standard', size: XpRewardSize.standard),
                  _SizeTile(label: 'Large', size: XpRewardSize.large),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Layout Variants',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _LayoutTile(
                    label: 'Icon Only',
                    layout: XpRewardLayout.iconOnly,
                  ),
                  _LayoutTile(label: 'Compact', layout: XpRewardLayout.compact),
                  _LayoutTile(
                    label: 'Detailed',
                    layout: XpRewardLayout.detailed,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Rarity Variants',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _RarityTile(label: 'Common', rarity: PlaygroundRarity.common),
                  _RarityTile(label: 'Rare', rarity: PlaygroundRarity.rare),
                  _RarityTile(label: 'Epic', rarity: PlaygroundRarity.epic),
                  _RarityTile(
                    label: 'Legendary',
                    rarity: PlaygroundRarity.legendary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Level Up Comparison',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _LevelUpTile(label: 'Standard XP', levelUp: false),
                  _LevelUpTile(label: 'Level Up!', levelUp: true),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Responsive Widths',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _WidthTile(label: '320dp', width: 320),
                  _WidthTile(label: '480dp', width: 480),
                  _WidthTile(label: '640dp', width: 640),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

XpReward _xpFromProvider(WidgetBuilderProvider provider) {
  return XpReward(
    amount: provider.playgroundXpRewardAmount,
    size: _mapSize(provider.playgroundXpRewardSize),
    layout: _mapLayout(provider.playgroundXpRewardLayout),
    label: provider.playgroundXpRewardLabel,
    isDark: provider.playgroundXpRewardIsDark,
    rarity: _mapRarity(provider.playgroundXpRewardRarity),
    showGlow: provider.playgroundXpRewardShowGlow,
    showSparkle: provider.playgroundXpRewardShowSparkle,
    isAnimating: provider.playgroundXpRewardIsAnimating,
    isLevelUp: provider.playgroundXpRewardIsLevelUp,
  );
}

XpReward _xpWith({
  int? amount,
  XpRewardSize? size,
  XpRewardLayout? layout,
  String? label,
  bool? isDark,
  PlaygroundRarity? rarity,
  bool? showGlow,
  bool? showSparkle,
  bool? isAnimating,
  bool? isLevelUp,
}) {
  return XpReward(
    amount: amount ?? 1200,
    size: size ?? XpRewardSize.standard,
    layout: layout ?? XpRewardLayout.detailed,
    label: label ?? 'Quest Complete',
    isDark: isDark ?? false,
    rarity: rarity ?? PlaygroundRarity.common,
    showGlow: showGlow ?? true,
    showSparkle: showSparkle ?? true,
    isAnimating: isAnimating ?? false,
    isLevelUp: isLevelUp ?? false,
  );
}

XpRewardSize _mapSize(String value) {
  switch (value) {
    case 'compact':
      return XpRewardSize.compact;
    case 'large':
      return XpRewardSize.large;
    default:
      return XpRewardSize.standard;
  }
}

XpRewardLayout _mapLayout(String value) {
  switch (value) {
    case 'iconOnly':
      return XpRewardLayout.iconOnly;
    case 'compact':
      return XpRewardLayout.compact;
    default:
      return XpRewardLayout.detailed;
  }
}

PlaygroundRarity _mapRarity(String value) {
  switch (value) {
    case 'rare':
      return PlaygroundRarity.rare;
    case 'epic':
      return PlaygroundRarity.epic;
    case 'legendary':
      return PlaygroundRarity.legendary;
    default:
      return PlaygroundRarity.common;
  }
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

class _SizeTile extends StatelessWidget {
  const _SizeTile({required this.label, required this.size});

  final String label;
  final XpRewardSize size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(child: _xpWith(size: size)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _LayoutTile extends StatelessWidget {
  const _LayoutTile({required this.label, required this.layout});

  final String label;
  final XpRewardLayout layout;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(child: _xpWith(layout: layout)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _RarityTile extends StatelessWidget {
  const _RarityTile({required this.label, required this.rarity});

  final String label;
  final PlaygroundRarity rarity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.dark,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(child: _xpWith(rarity: rarity, isDark: true)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _LevelUpTile extends StatelessWidget {
  const _LevelUpTile({required this.label, required this.levelUp});

  final String label;
  final bool levelUp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: _xpWith(
                  isLevelUp: levelUp,
                  rarity: levelUp
                      ? PlaygroundRarity.legendary
                      : PlaygroundRarity.rare,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _WidthTile extends StatelessWidget {
  const _WidthTile({required this.label, required this.width});

  final String label;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: AppSpacing.sm),
        _ThemedTile(
          brightness: Brightness.light,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              width: width,
              child: Center(child: _xpWith()),
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemedTileRow extends StatelessWidget {
  const _ThemedTileRow({required this.brightness, required this.child});

  final _BrightnessMode brightness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (brightness) {
      case _BrightnessMode.light:
        return SizedBox(
          width: double.infinity,
          child: _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: child,
            ),
          ),
        );
      case _BrightnessMode.dark:
        return SizedBox(
          width: double.infinity,
          child: _ThemedTile(
            brightness: Brightness.dark,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: child,
            ),
          ),
        );
      case _BrightnessMode.sideBySide:
        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final halfWidth = wide ? (constraints.maxWidth - 12) / 2 : null;
            final tiles = <Widget>[
              SizedBox(
                width: halfWidth,
                child: _ThemedTile(
                  brightness: Brightness.light,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: child,
                  ),
                ),
              ),
              SizedBox(
                width: halfWidth,
                child: _ThemedTile(
                  brightness: Brightness.dark,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: child,
                  ),
                ),
              ),
            ];
            return wide
                ? Row(children: tiles)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      tiles[0],
                      const SizedBox(height: AppSpacing.lg),
                      tiles[1],
                    ],
                  );
          },
        );
    }
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

enum _BrightnessMode { light, dark, sideBySide }

_BrightnessMode _mapBrightness(String value) {
  switch (value) {
    case 'lightOnly':
      return _BrightnessMode.light;
    case 'darkOnly':
      return _BrightnessMode.dark;
    default:
      return _BrightnessMode.sideBySide;
  }
}
