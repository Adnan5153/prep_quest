import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../features/playground/presentation/constants/playground_constants.dart';
import '../../../../../../features/playground/presentation/widgets/rewards/reward_chest.dart';
import '../../../providers/widget_builder_provider.dart';

class RewardChestPreview extends StatelessWidget {
  const RewardChestPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.playgroundRewardChestBrightness);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Reward Chest', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Animated treasure chest with opening sequence and rarity banding',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              brightness: brightness,
              child: Center(child: _chestFromProvider(provider)),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'States Showcase',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _StateTile(label: 'Closed', state: RewardChestState.closed),
                  _StateTile(label: 'Opening', state: RewardChestState.opening),
                  _StateTile(label: 'Opened', state: RewardChestState.opened),
                  _StateTile(label: 'Locked', state: RewardChestState.locked),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Size Variants',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _SizeTile(label: 'Compact', size: RewardChestSize.compact),
                  _SizeTile(label: 'Standard', size: RewardChestSize.standard),
                  _SizeTile(label: 'Large', size: RewardChestSize.large),
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
              title: 'Glow Comparison',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _GlowTile(label: 'Glow On', showGlow: true),
                  _GlowTile(label: 'Glow Off', showGlow: false),
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

RewardChest _chestFromProvider(WidgetBuilderProvider provider) {
  return RewardChest(
    state: _mapState(provider.playgroundRewardChestState),
    size: _mapSize(provider.playgroundRewardChestSize),
    isDark: provider.playgroundRewardChestIsDark,
    rarity: _mapRarity(provider.playgroundRewardChestRarity),
    showGlow: provider.playgroundRewardChestShowGlow,
    autoOpen: provider.playgroundRewardChestAutoOpen,
    onTap: () {},
  );
}

RewardChest _chestWith({
  RewardChestState? state,
  RewardChestSize? size,
  bool? isDark,
  PlaygroundRarity? rarity,
  bool? showGlow,
  bool? autoOpen,
}) {
  return RewardChest(
    state: state ?? RewardChestState.closed,
    size: size ?? RewardChestSize.standard,
    isDark: isDark ?? false,
    rarity: rarity ?? PlaygroundRarity.legendary,
    showGlow: showGlow ?? true,
    autoOpen: autoOpen ?? false,
    onTap: () {},
  );
}

RewardChestState _mapState(String value) {
  switch (value) {
    case 'opening':
      return RewardChestState.opening;
    case 'opened':
      return RewardChestState.opened;
    case 'locked':
      return RewardChestState.locked;
    default:
      return RewardChestState.closed;
  }
}

RewardChestSize _mapSize(String value) {
  switch (value) {
    case 'compact':
      return RewardChestSize.compact;
    case 'large':
      return RewardChestSize.large;
    default:
      return RewardChestSize.standard;
  }
}

PlaygroundRarity _mapRarity(String value) {
  switch (value) {
    case 'rare':
      return PlaygroundRarity.rare;
    case 'epic':
      return PlaygroundRarity.epic;
    case 'common':
      return PlaygroundRarity.common;
    default:
      return PlaygroundRarity.legendary;
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

class _StateTile extends StatelessWidget {
  const _StateTile({required this.label, required this.state});

  final String label;
  final RewardChestState state;

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
              child: Center(child: _chestWith(state: state)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _SizeTile extends StatelessWidget {
  const _SizeTile({required this.label, required this.size});

  final String label;
  final RewardChestSize size;

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
              child: Center(child: _chestWith(size: size)),
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
              child: Center(child: _chestWith(rarity: rarity, isDark: true)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _GlowTile extends StatelessWidget {
  const _GlowTile({required this.label, required this.showGlow});

  final String label;
  final bool showGlow;

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
              child: Center(
                child: _chestWith(showGlow: showGlow, isDark: true),
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
              child: Center(child: _chestWith()),
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
