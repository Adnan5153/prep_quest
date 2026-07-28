import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/chest_entry.dart';
import '../../domain/enums/reward_enums.dart';
import '../constants/rewards_strings.dart';
import '../providers/rewards_provider.dart';
import '../widgets/rewards_celebration_dialogs.dart';
import '../widgets/rewards_hud_chip.dart';

/// Lists the user's reward chests and exposes an open action.
class RewardChestScreen extends ConsumerStatefulWidget {
  const RewardChestScreen({super.key});

  @override
  ConsumerState<RewardChestScreen> createState() => _RewardChestScreenState();
}

class _RewardChestScreenState extends ConsumerState<RewardChestScreen> {
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(rewardsControllerProvider.notifier).load();
    });
  }

  Future<void> _onOpen(String chestId) async {
    if (_opening) return;
    setState(() => _opening = true);
    final outcome =
        await ref.read(rewardsControllerProvider.notifier).openChest(chestId);
    if (!mounted) return;
    setState(() => _opening = false);
    if (outcome != null) {
      await ChestOpenCelebrationDialog.show(context, outcome: outcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RewardsViewState state = ref.watch(rewardsControllerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<ChestEntry> chests = state.snapshot.chests;
    return Scaffold(
      appBar: AppBar(
        title: const Text(RewardsStrings.chestTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.rewards),
        ),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : chests.isEmpty
                ? const _EmptyView()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveBuilder.value<double>(
                            context,
                            mobile: double.infinity,
                            tablet: AppSizes.tabletMaxWidth.toDouble(),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            for (final ChestEntry chest in chests)
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: AppSpacing.md),
                                child: _ChestCard(
                                  chest: chest,
                                  isDark: isDark,
                                  busy: _opening,
                                  onOpen: () => _onOpen(chest.id),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class _ChestCard extends StatelessWidget {
  const _ChestCard({
    required this.chest,
    required this.isDark,
    required this.busy,
    required this.onOpen,
  });

  final ChestEntry chest;
  final bool isDark;
  final bool busy;
  final VoidCallback onOpen;

  bool get _isOpenable =>
      chest.status == ChestStatus.locked ||
      chest.status == ChestStatus.opening;

  @override
  Widget build(BuildContext context) {
    final Color rarityColor = rewardsRarityColor(chest.rarity);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: rarityColor.withValues(alpha: 0.45),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: rarityColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.gem,
                  color: rarityColor,
                  size: AppSizes.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      chest.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    RewardsHudChip(
                      label: _statusLabel(),
                      value: chest.status.name,
                      icon: _statusIcon(),
                      color: rarityColor,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: _isOpenable && !busy ? onOpen : null,
            child: Text(_statusLabel()),
          ),
        ],
      ),
    );
  }

  String _statusLabel() {
    switch (chest.status) {
      case ChestStatus.locked:
        return RewardsStrings.chestAvailable;
      case ChestStatus.opening:
        return 'Opening…';
      case ChestStatus.opened:
        return RewardsStrings.chestOpened;
      case ChestStatus.claimed:
        return RewardsStrings.chestOpened;
    }
  }

  IconData _statusIcon() {
    switch (chest.status) {
      case ChestStatus.locked:
        return AppIcons.lockFilled;
      case ChestStatus.opening:
        return AppIcons.refresh;
      case ChestStatus.opened:
      case ChestStatus.claimed:
        return AppIcons.checkCircle;
    }
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(AppIcons.gem, size: AppSizes.iconXl),
            const SizedBox(height: AppSpacing.md),
            Text(
              RewardsStrings.chestEmpty,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}