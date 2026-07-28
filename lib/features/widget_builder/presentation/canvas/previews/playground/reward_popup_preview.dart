import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../features/playground/presentation/constants/playground_constants.dart';
import '../../../../../../features/playground/presentation/widgets/rewards/reward_chest.dart';
import '../../../../../../features/playground/presentation/widgets/rewards/reward_popup.dart';
import '../../../providers/widget_builder_provider.dart';

class RewardPopupPreview extends StatelessWidget {
  const RewardPopupPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = _mapBrightness(provider.playgroundRewardPopupBrightness);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Reward Popup', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Reward summary dialog with chest and scrollable entries',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ThemedTileRow(
              brightness: brightness,
              child: _popupFromProvider(provider),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _Section(
              title: 'Entry Count Variants',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _EntryCountTile(count: 1),
                  _EntryCountTile(count: 2),
                  _EntryCountTile(count: 3),
                  _EntryCountTile(count: 4),
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
              title: 'Chest State Integration',
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _ChestStateTile(
                    label: 'Closed',
                    state: RewardChestState.closed,
                  ),
                  _ChestStateTile(
                    label: 'Opening',
                    state: RewardChestState.opening,
                  ),
                  _ChestStateTile(
                    label: 'Opened',
                    state: RewardChestState.opened,
                  ),
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
                  _WidthTile(label: '360dp', width: 360, provider: provider),
                  _WidthTile(label: '480dp', width: 480, provider: provider),
                  _WidthTile(label: '640dp', width: 640, provider: provider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<RewardEntry> _entriesFromProvider(
  WidgetBuilderProvider provider, {
  int? count,
}) {
  final limit = (count ?? provider.playgroundRewardPopupEntryCount).clamp(1, 4);
  final entries = <RewardEntry>[];
  for (var i = 1; i <= limit; i++) {
    final kind = _kindFor(provider, i);
    final amount = _amountFor(provider, i);
    final label = _labelFor(provider, i);
    final rarity = _rarityFor(provider, i);
    entries.add(
      RewardEntry(kind: kind, amount: amount, label: label, rarity: rarity),
    );
  }
  return entries;
}

RewardEntryKind _kindFor(WidgetBuilderProvider provider, int slot) {
  final value = switch (slot) {
    1 => provider.playgroundRewardPopupEntry1Kind,
    2 => provider.playgroundRewardPopupEntry2Kind,
    3 => provider.playgroundRewardPopupEntry3Kind,
    _ => provider.playgroundRewardPopupEntry4Kind,
  };
  return _mapKind(value);
}

int _amountFor(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return provider.playgroundRewardPopupEntry1Amount;
    case 2:
      return provider.playgroundRewardPopupEntry2Amount;
    case 3:
      return provider.playgroundRewardPopupEntry3Amount;
    default:
      return provider.playgroundRewardPopupEntry4Amount;
  }
}

String _labelFor(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return provider.playgroundRewardPopupEntry1Label;
    case 2:
      return provider.playgroundRewardPopupEntry2Label;
    case 3:
      return provider.playgroundRewardPopupEntry3Label;
    default:
      return provider.playgroundRewardPopupEntry4Label;
  }
}

PlaygroundRarity _rarityFor(WidgetBuilderProvider provider, int slot) {
  final value = switch (slot) {
    1 => provider.playgroundRewardPopupEntry1Rarity,
    2 => provider.playgroundRewardPopupEntry2Rarity,
    3 => provider.playgroundRewardPopupEntry3Rarity,
    _ => provider.playgroundRewardPopupEntry4Rarity,
  };
  return _mapRarity(value);
}

RewardEntryKind _mapKind(String value) {
  switch (value) {
    case 'coin':
      return RewardEntryKind.coin;
    case 'badge':
      return RewardEntryKind.badge;
    case 'custom':
      return RewardEntryKind.custom;
    default:
      return RewardEntryKind.xp;
  }
}

RewardChestState _mapChestState(String value) {
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

RewardPopup _popupFromProvider(WidgetBuilderProvider provider) {
  return RewardPopup(
    entries: _entriesFromProvider(provider),
    title: provider.playgroundRewardPopupTitle,
    subtitle: provider.playgroundRewardPopupSubtitle,
    primaryLabel: provider.playgroundRewardPopupPrimaryLabel,
    secondaryLabel: provider.playgroundRewardPopupSecondaryLabel,
    chestState: _mapChestState(provider.playgroundRewardPopupChestState),
    rarity: _mapRarity(provider.playgroundRewardPopupRarity),
    isDark: provider.playgroundRewardPopupIsDark,
    autoOpenChest: provider.playgroundRewardPopupAutoOpenChest,
    onPrimary: () {},
    onSecondary: () {},
  );
}

RewardPopup _popupWith({
  int? entryCount,
  bool? isDark,
  PlaygroundRarity? rarity,
  RewardChestState? chestState,
  bool? autoOpen,
}) {
  final count = (entryCount ?? 3).clamp(1, 4);
  final entries = <RewardEntry>[
    const RewardEntry(
      kind: RewardEntryKind.xp,
      amount: 1500,
      label: 'Quest XP',
      rarity: PlaygroundRarity.rare,
    ),
    const RewardEntry(
      kind: RewardEntryKind.coin,
      amount: 750,
      label: 'Gold Coins',
      rarity: PlaygroundRarity.epic,
    ),
    const RewardEntry(
      kind: RewardEntryKind.badge,
      amount: 1,
      label: 'Champion Badge',
      rarity: PlaygroundRarity.legendary,
    ),
    const RewardEntry(
      kind: RewardEntryKind.custom,
      amount: 1,
      label: 'Mystery Glyph',
      rarity: PlaygroundRarity.rare,
    ),
  ].take(count).toList(growable: false);
  return RewardPopup(
    entries: entries,
    title: 'Quest Complete!',
    subtitle: 'You earned amazing rewards.',
    primaryLabel: 'Claim All',
    secondaryLabel: 'Save for Later',
    chestState: chestState ?? RewardChestState.opening,
    rarity: rarity ?? PlaygroundRarity.epic,
    isDark: isDark ?? false,
    autoOpenChest: autoOpen ?? true,
    onPrimary: () {},
    onSecondary: () {},
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

class _EntryCountTile extends StatelessWidget {
  const _EntryCountTile({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: _popupWith(entryCount: count),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$count entries',
            style: Theme.of(context).textTheme.labelMedium,
          ),
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
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.dark,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: _popupWith(rarity: rarity, isDark: true),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _ChestStateTile extends StatelessWidget {
  const _ChestStateTile({required this.label, required this.state});

  final String label;
  final RewardChestState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ThemedTile(
            brightness: Brightness.light,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: _popupWith(chestState: state, autoOpen: false),
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
  const _WidthTile({
    required this.label,
    required this.width,
    required this.provider,
  });

  final String label;
  final double width;
  final WidgetBuilderProvider provider;

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
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: SizedBox(width: width, child: _popupFromProvider(provider)),
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
              padding: const EdgeInsets.all(AppSpacing.md),
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
              padding: const EdgeInsets.all(AppSpacing.md),
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
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: child,
                  ),
                ),
              ),
              SizedBox(
                width: halfWidth,
                child: _ThemedTile(
                  brightness: Brightness.dark,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
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
