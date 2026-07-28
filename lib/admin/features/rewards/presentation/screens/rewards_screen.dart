import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/reward_entity.dart';
import '../providers/rewards_provider.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<RewardSummary>> tables =
        ref.watch(rewardsListProvider);

    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Rewards', style: theme.textTheme.displayMedium),
                    const SizedBox(height: AdminSpacing.xs),
                    Text(
                      'Reward tables that grant XP, coins, hearts, gems. Hooked to conditions like level completion or boss defeat.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New table'),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.xl),
          Expanded(
            child: tables.when(
              data: (List<RewardSummary> list) {
                if (list.isEmpty) {
                  return const Center(child: Text('No reward tables yet.'));
                }
                return GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AdminSpacing.md,
                    mainAxisSpacing: AdminSpacing.md,
                    childAspectRatio: 2.4,
                  ),
                  itemCount: list.length,
                  itemBuilder: (BuildContext c, int i) =>
                      _TableCard(summary: list[i]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, _) => Center(child: Text('Failed: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCard extends ConsumerWidget {
  const _TableCard({required this.summary});

  final RewardSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<RewardTable> detail =
        ref.watch(rewardsDetailProvider(summary.id));
    return Container(
      padding: const EdgeInsets.all(AdminSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: detail.when(
        data: (RewardTable t) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(t.name, style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                ),
              ],
            ),
            Text(t.slug, style: theme.textTheme.bodySmall),
            const SizedBox(height: AdminSpacing.sm),
            Expanded(
              child: ListView.separated(
                itemCount: t.rules.length,
                separatorBuilder: (_, _) => const Divider(height: 8),
                itemBuilder: (BuildContext c, int i) =>
                    _RuleRow(rule: t.rules[i]),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, _) => Text('Failed: $e'),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.rule});

  final RewardRule rule;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md, vertical: AdminSpacing.sm),
      decoration: BoxDecoration(
        color: AdminPalette.ivory,
        borderRadius: BorderRadius.circular(AdminRadius.md),
      ),
      child: Row(
        children: <Widget>[
          Icon(_iconFor(rule.condition), size: 16),
          const SizedBox(width: AdminSpacing.sm),
          Expanded(
            child: Text(rule.condition.wire,
                style: theme.textTheme.labelMedium),
          ),
          if (rule.outcome.xp > 0) _Token(label: 'XP', value: rule.outcome.xp),
          if (rule.outcome.coins > 0)
            _Token(label: 'Coin', value: rule.outcome.coins),
          if (rule.outcome.hearts > 0)
            _Token(label: 'Heart', value: rule.outcome.hearts),
          if (rule.outcome.gems > 0)
            _Token(label: 'Gem', value: rule.outcome.gems),
        ],
      ),
    );
  }

  IconData _iconFor(RewardCondition c) {
    switch (c) {
      case RewardCondition.levelCompleted:
        return Icons.check_circle_outline;
      case RewardCondition.bossDefeated:
        return Icons.shield_outlined;
      case RewardCondition.streakReached:
        return Icons.local_fire_department_outlined;
      case RewardCondition.perfectScore:
        return Icons.star_outline;
      case RewardCondition.firstAttempt:
        return Icons.flag_outlined;
      case RewardCondition.eventCompleted:
        return Icons.celebration_outlined;
    }
  }
}

class _Token extends StatelessWidget {
  const _Token({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Text(
        '$label $value',
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}
