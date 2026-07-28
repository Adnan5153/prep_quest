import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_spacing.dart';
import '../../../providers/widget_builder_provider.dart';

class RewardPopupControls extends StatelessWidget {
  const RewardPopupControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('Reward Popup Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: provider.playgroundRewardPopupTitle,
          decoration: const InputDecoration(labelText: 'Title'),
          onChanged: (value) => provider.playgroundRewardPopupTitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundRewardPopupSubtitle,
          decoration: const InputDecoration(labelText: 'Subtitle'),
          maxLines: 2,
          onChanged: (value) => provider.playgroundRewardPopupSubtitle = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundRewardPopupPrimaryLabel,
          decoration: const InputDecoration(labelText: 'Primary label'),
          onChanged: (value) =>
              provider.playgroundRewardPopupPrimaryLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.playgroundRewardPopupSecondaryLabel,
          decoration: const InputDecoration(labelText: 'Secondary label'),
          onChanged: (value) =>
              provider.playgroundRewardPopupSecondaryLabel = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Entries ${provider.playgroundRewardPopupEntryCount}'),
        Slider(
          min: 1,
          max: 4,
          divisions: 3,
          value: provider.playgroundRewardPopupEntryCount.toDouble().clamp(
            1,
            4,
          ),
          onChanged: (value) =>
              provider.playgroundRewardPopupEntryCount = value.round(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Rarity ${provider.playgroundRewardPopupRarity}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'common',
              'rare',
              'epic',
              'legendary',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundRewardPopupRarity == option,
                onSelected: (_) =>
                    provider.playgroundRewardPopupRarity = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Chest State ${provider.playgroundRewardPopupChestState}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'closed',
              'opening',
              'opened',
              'locked',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundRewardPopupChestState == option,
                onSelected: (_) =>
                    provider.playgroundRewardPopupChestState = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Dark surface'),
          value: provider.playgroundRewardPopupIsDark,
          onChanged: (value) => provider.playgroundRewardPopupIsDark = value,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Auto open chest'),
          value: provider.playgroundRewardPopupAutoOpenChest,
          onChanged: (value) =>
              provider.playgroundRewardPopupAutoOpenChest = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Brightness ${provider.playgroundRewardPopupBrightness}'),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: <Widget>[
            for (final option in const <String>[
              'sideBySide',
              'lightOnly',
              'darkOnly',
            ])
              ChoiceChip(
                label: Text(option),
                selected: provider.playgroundRewardPopupBrightness == option,
                onSelected: (_) =>
                    provider.playgroundRewardPopupBrightness = option,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Entries', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        for (var slot = 1; slot <= 4; slot++)
          Visibility(
            visible: provider.playgroundRewardPopupEntryCount >= slot,
            child: _EntryCard(slot: slot, provider: provider),
          ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.slot, required this.provider});

  final int slot;
  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final kindValue = _kindGetter(provider, slot)();
    final amountValue = _amountGetter(provider, slot)();
    final labelValue = _labelGetter(provider, slot)();
    final rarityValue = _rarityGetter(provider, slot)();
    final kindSetter = _kindSetter(provider, slot);
    final amountSetter = _amountSetter(provider, slot);
    final labelSetter = _labelSetter(provider, slot);
    final raritySetter = _raritySetter(provider, slot);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Entry $slot',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Kind $kindValue'),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: <Widget>[
                  for (final option in const <String>[
                    'xp',
                    'coin',
                    'badge',
                    'custom',
                  ])
                    ChoiceChip(
                      label: Text(option),
                      selected: kindValue == option,
                      onSelected: (_) => kindSetter(option),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Amount $amountValue'),
              Slider(
                min: 1,
                max: 5000,
                divisions: 100,
                value: amountValue.toDouble().clamp(1, 5000),
                onChanged: (value) => amountSetter(value.round()),
              ),
              TextFormField(
                initialValue: labelValue,
                decoration: const InputDecoration(labelText: 'Label'),
                onChanged: labelSetter,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Rarity $rarityValue'),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: <Widget>[
                  for (final option in const <String>[
                    'common',
                    'rare',
                    'epic',
                    'legendary',
                  ])
                    ChoiceChip(
                      label: Text(option),
                      selected: rarityValue == option,
                      onSelected: (_) => raritySetter(option),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String Function() _kindGetter(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return () => provider.playgroundRewardPopupEntry1Kind;
    case 2:
      return () => provider.playgroundRewardPopupEntry2Kind;
    case 3:
      return () => provider.playgroundRewardPopupEntry3Kind;
    default:
      return () => provider.playgroundRewardPopupEntry4Kind;
  }
}

int Function() _amountGetter(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return () => provider.playgroundRewardPopupEntry1Amount;
    case 2:
      return () => provider.playgroundRewardPopupEntry2Amount;
    case 3:
      return () => provider.playgroundRewardPopupEntry3Amount;
    default:
      return () => provider.playgroundRewardPopupEntry4Amount;
  }
}

String Function() _labelGetter(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return () => provider.playgroundRewardPopupEntry1Label;
    case 2:
      return () => provider.playgroundRewardPopupEntry2Label;
    case 3:
      return () => provider.playgroundRewardPopupEntry3Label;
    default:
      return () => provider.playgroundRewardPopupEntry4Label;
  }
}

String Function() _rarityGetter(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return () => provider.playgroundRewardPopupEntry1Rarity;
    case 2:
      return () => provider.playgroundRewardPopupEntry2Rarity;
    case 3:
      return () => provider.playgroundRewardPopupEntry3Rarity;
    default:
      return () => provider.playgroundRewardPopupEntry4Rarity;
  }
}

void Function(String) _kindSetter(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return (value) => provider.playgroundRewardPopupEntry1Kind = value;
    case 2:
      return (value) => provider.playgroundRewardPopupEntry2Kind = value;
    case 3:
      return (value) => provider.playgroundRewardPopupEntry3Kind = value;
    default:
      return (value) => provider.playgroundRewardPopupEntry4Kind = value;
  }
}

void Function(int) _amountSetter(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return (value) => provider.playgroundRewardPopupEntry1Amount = value;
    case 2:
      return (value) => provider.playgroundRewardPopupEntry2Amount = value;
    case 3:
      return (value) => provider.playgroundRewardPopupEntry3Amount = value;
    default:
      return (value) => provider.playgroundRewardPopupEntry4Amount = value;
  }
}

void Function(String) _labelSetter(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return (value) => provider.playgroundRewardPopupEntry1Label = value;
    case 2:
      return (value) => provider.playgroundRewardPopupEntry2Label = value;
    case 3:
      return (value) => provider.playgroundRewardPopupEntry3Label = value;
    default:
      return (value) => provider.playgroundRewardPopupEntry4Label = value;
  }
}

void Function(String) _raritySetter(WidgetBuilderProvider provider, int slot) {
  switch (slot) {
    case 1:
      return (value) => provider.playgroundRewardPopupEntry1Rarity = value;
    case 2:
      return (value) => provider.playgroundRewardPopupEntry2Rarity = value;
    case 3:
      return (value) => provider.playgroundRewardPopupEntry3Rarity = value;
    default:
      return (value) => provider.playgroundRewardPopupEntry4Rarity = value;
  }
}
