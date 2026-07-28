import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import '../rewards/coin_reward.dart';
import '../rewards/reward_chest.dart';
import '../rewards/xp_reward.dart';
import 'shared/playground_sheet_container.dart';
import 'shared/playground_sheet_entrance.dart';
import 'shared/playground_sheet_layout.dart';
import 'shared/playground_sheet_sections.dart';

enum RewardBottomSheetResult { claimed, continueExploring, dismissed }

class UnlockedItemVisual {
  const UnlockedItemVisual({
    required this.id,
    required this.name,
    this.description,
    this.icon = AppIcons.award,
    this.semanticLabel,
    this.rarityLabel,
  });

  final String id;
  final String name;
  final String? description;
  final IconData icon;
  final String? semanticLabel;
  final String? rarityLabel;
}

class RewardSheetVisual {
  const RewardSheetVisual({
    required this.summary,
    required this.earnedXp,
    required this.earnedCoins,
    required this.unlockedItems,
    this.title,
    this.bonusXp,
    this.bonusCoins,
    this.nextMilestoneLabel,
    this.autoOpenChest = true,
    this.rarity = PlaygroundRarity.legendary,
    this.showChest = true,
  });

  final String summary;
  final String? title;
  final int earnedXp;
  final int earnedCoins;
  final List<UnlockedItemVisual> unlockedItems;
  final int? bonusXp;
  final int? bonusCoins;
  final String? nextMilestoneLabel;
  final bool autoOpenChest;
  final PlaygroundRarity rarity;
  final bool showChest;
}

class RewardBottomSheet extends StatefulWidget {
  const RewardBottomSheet({
    super.key,
    required this.visual,
    this.onClaimRewards,
    this.onContinueExploring,
  });

  final RewardSheetVisual visual;
  final Future<void> Function()? onClaimRewards;
  final VoidCallback? onContinueExploring;

  static Future<RewardBottomSheetResult?> show(
    BuildContext context, {
    required RewardSheetVisual visual,
    Future<void> Function()? onClaimRewards,
    VoidCallback? onContinueExploring,
  }) {
    final layout = PlaygroundSheetLayout.resolve(context);
    return showModalBottomSheet<RewardBottomSheetResult>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: PlaygroundSheetOpacity.scrim,
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return _RewardSheetHost(
          layout: layout,
          visual: visual,
          onClaimRewards: onClaimRewards,
          onContinueExploring: onContinueExploring,
          busy: false,
        );
      },
    );
  }

  @override
  State<RewardBottomSheet> createState() => _RewardBottomSheetState();
}

class _RewardBottomSheetState extends State<RewardBottomSheet> {
  bool _busy = false;

  Future<void> _handleClaim() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onClaimRewards?.call();
    } catch (_) {
      setState(() => _busy = false);
      rethrow;
    }
    if (!mounted) return;
    Navigator.of(context).pop(RewardBottomSheetResult.claimed);
  }

  @override
  Widget build(BuildContext context) {
    return _RewardSheetHost(
      layout: PlaygroundSheetLayout.resolve(context),
      visual: widget.visual,
      onClaimRewards: _handleClaim,
      onContinueExploring: widget.onContinueExploring,
      busy: _busy,
    );
  }
}

class _RewardSheetHost extends StatelessWidget {
  const _RewardSheetHost({
    required this.layout,
    required this.visual,
    required this.onClaimRewards,
    required this.onContinueExploring,
    required this.busy,
  });

  final PlaygroundSheetLayout layout;
  final RewardSheetVisual visual;
  final Future<void> Function()? onClaimRewards;
  final VoidCallback? onContinueExploring;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetHeight = layout.maxHeight;
    final container = PlaygroundSheetContainer(
      semanticLabel: PlaygroundStrings.rewardSheetSemantic,
      layout: layout,
      height: sheetHeight,
      child: PlaygroundSheetFrame(
        layout: layout,
        semanticLabel: PlaygroundStrings.rewardSheetSemantic,
        content: _RewardSheetBody(visual: visual, isDark: isDark),
        actions: PlaygroundSheetActionRow(
          primaryLabel: PlaygroundStrings.rewardSheetCtaClaim,
          primaryIcon: AppIcons.arrowForward,
          onPrimary: () => onClaimRewards?.call(),
          primarySemantic: PlaygroundStrings.rewardSheetCtaClaim,
          primaryEnabled: !busy,
          secondaryLabel: PlaygroundStrings.rewardSheetCtaContinue,
          onSecondary: () {
            onContinueExploring?.call();
            Navigator.of(
              context,
            ).pop(RewardBottomSheetResult.continueExploring);
          },
          secondarySemantic: PlaygroundStrings.rewardSheetCtaContinue,
          secondaryEnabled: !busy,
          alignment: layout.deviceType == DeviceType.mobile
              ? PlaygroundSheetActionAlignment.stacked
              : PlaygroundSheetActionAlignment.horizontal,
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: PlaygroundSheetEntrance(height: sheetHeight, child: container),
    );
  }
}

class _RewardSheetBody extends StatelessWidget {
  const _RewardSheetBody({required this.visual, required this.isDark});

  final RewardSheetVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: <Widget>[
        PlaygroundSheetHeader(
          title: visual.title ?? PlaygroundStrings.rewardSheetTitle,
          subtitle: visual.summary,
          trailing: PlaygroundSheetRarityBadge(rarity: visual.rarity),
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.md),
        if (visual.showChest) ...<Widget>[
          Center(
            child: RewardChest(
              state: RewardChestState.opening,
              size: RewardChestSize.large,
              rarity: visual.rarity,
              isDark: isDark,
              showGlow: true,
              autoOpen: visual.autoOpenChest,
              semanticLabel: PlaygroundStrings.rewardPopupChestSemantic,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Row(
          children: <Widget>[
            Expanded(
              child: XpReward(
                amount: visual.earnedXp,
                size: XpRewardSize.standard,
                layout: XpRewardLayout.detailed,
                isDark: isDark,
                rarity: visual.rarity,
                showGlow: true,
                showSparkle: true,
                isAnimating: true,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: CoinReward(
                amount: visual.earnedCoins,
                size: CoinRewardSize.standard,
                layout: CoinRewardLayout.detailed,
                isDark: isDark,
                rarity: visual.rarity,
                showGlow: true,
                showSparkle: true,
                isAnimating: true,
              ),
            ),
          ],
        ),
        if (visual.bonusXp != null || visual.bonusCoins != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          _RewardBonusRow(
            bonusXp: visual.bonusXp,
            bonusCoins: visual.bonusCoins,
            isDark: isDark,
          ),
        ],
        if (visual.unlockedItems.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          _UnlockedItemsGrid(items: visual.unlockedItems, isDark: isDark),
        ],
        if (visual.nextMilestoneLabel != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: PlaygroundColors.sheetAccentSecondary.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
              borderRadius: PlaygroundSheetBorder.statRadius,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  AppIcons.star,
                  color: PlaygroundColors.sheetAccentSecondary,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '${PlaygroundStrings.rewardSheetNextMilestoneLabel}: '
                    '${visual.nextMilestoneLabel}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _RewardBonusRow extends StatelessWidget {
  const _RewardBonusRow({
    required this.bonusXp,
    required this.bonusCoins,
    required this.isDark,
  });

  final int? bonusXp;
  final int? bonusCoins;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (bonusXp != null && bonusXp! > 0)
          Expanded(
            child: PlaygroundSheetStatTile(
              icon: AppIcons.xp,
              iconColor: PlaygroundColors.xp,
              value: '+${bonusXp!}',
              label: PlaygroundStrings.rewardSheetBonusXpTemplate.replaceAll(
                '%d',
                '${bonusXp!}',
              ),
              accentFill: PlaygroundColors.xp.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
              isDark: isDark,
            ),
          ),
        if (bonusXp != null &&
            bonusXp! > 0 &&
            bonusCoins != null &&
            bonusCoins! > 0)
          const SizedBox(width: AppSpacing.sm),
        if (bonusCoins != null && bonusCoins! > 0)
          Expanded(
            child: PlaygroundSheetStatTile(
              icon: AppIcons.coinIcon,
              iconColor: PlaygroundColors.coin,
              value: '+${bonusCoins!}',
              label: PlaygroundStrings.rewardSheetBonusCoinTemplate.replaceAll(
                '%d',
                '${bonusCoins!}',
              ),
              accentFill: PlaygroundColors.coin.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
              isDark: isDark,
            ),
          ),
      ],
    );
  }
}

class _UnlockedItemsGrid extends StatelessWidget {
  const _UnlockedItemsGrid({required this.items, required this.isDark});

  final List<UnlockedItemVisual> items;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          PlaygroundStrings.rewardSheetUnlockedItemsLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: items
              .map(
                (item) => SizedBox(
                  width:
                      PlaygroundSizes.bottomSheetUnlockedTileSize +
                      AppSpacing.lg,
                  child: _UnlockedItemTile(item: item, isDark: isDark),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _UnlockedItemTile extends StatelessWidget {
  const _UnlockedItemTile({required this.item, required this.isDark});

  final UnlockedItemVisual item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          item.semanticLabel ??
          PlaygroundStrings.rewardSheetItemSemanticTemplate.replaceAll(
            '%s',
            item.name,
          ),
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: PlaygroundSizes.bottomSheetUnlockedTileSize,
            height: PlaygroundSizes.bottomSheetUnlockedTileSize,
            decoration: BoxDecoration(
              color: PlaygroundColors.sheetAccentSecondary.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
              borderRadius: PlaygroundSheetBorder.unlockedRadius,
              border: Border.all(
                color: PlaygroundColors.sheetAccentSecondary.withValues(
                  alpha: 0.4,
                ),
                width: PlaygroundSizes.bottomSheetBorderWidth,
              ),
            ),
            child: Icon(
              item.icon,
              color: PlaygroundColors.sheetAccentSecondary,
              size: PlaygroundSizes.bottomSheetUnlockedTileIconSize,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.name,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isDark
                  ? AppColors.darkOnSurface
                  : AppColors.lightOnSurface,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.rarityLabel != null)
            Text(
              item.rarityLabel!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
