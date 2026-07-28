import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import 'shared/playground_sheet_container.dart';
import 'shared/playground_sheet_entrance.dart';
import 'shared/playground_sheet_layout.dart';
import 'shared/playground_sheet_sections.dart';

enum BossBottomSheetResult { started, practiceRequested, dismissed }

enum BossDifficulty { introductory, standard, advanced, legendary }

class BossRequirementVisual {
  const BossRequirementVisual({
    required this.label,
    required this.completed,
    this.semanticLabel,
  });

  final String label;
  final bool completed;
  final String? semanticLabel;
}

class BossSheetVisual {
  const BossSheetVisual({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.description,
    required this.recommendedXp,
    required this.questionCount,
    required this.heartsPenalty,
    required this.xpReward,
    required this.coinReward,
    required this.requirements,
    this.rewardsIcon = AppIcons.crown,
    this.rarity = PlaygroundRarity.legendary,
    this.isUnlocked = true,
    this.semanticLocked,
  });

  final String id;
  final String title;
  final BossDifficulty difficulty;
  final String description;
  final int recommendedXp;
  final int questionCount;
  final int heartsPenalty;
  final int xpReward;
  final int coinReward;
  final List<BossRequirementVisual> requirements;
  final IconData rewardsIcon;
  final PlaygroundRarity rarity;
  final bool isUnlocked;
  final String? semanticLocked;

  bool get meetsRequirements =>
      requirements.isNotEmpty && requirements.every((r) => r.completed);

  bool get canStart => isUnlocked && meetsRequirements;

  String get difficultyLabel => _difficultyLabel(difficulty);
}

String _difficultyLabel(BossDifficulty difficulty) {
  switch (difficulty) {
    case BossDifficulty.introductory:
      return 'Introductory';
    case BossDifficulty.standard:
      return 'Standard';
    case BossDifficulty.advanced:
      return 'Advanced';
    case BossDifficulty.legendary:
      return 'Legendary';
  }
}

class BossBottomSheet extends StatelessWidget {
  const BossBottomSheet({
    super.key,
    required this.visual,
    this.onStartBattle,
    this.onPracticeMore,
  });

  final BossSheetVisual visual;
  final VoidCallback? onStartBattle;
  final VoidCallback? onPracticeMore;

  static Future<BossBottomSheetResult?> show(
    BuildContext context, {
    required BossSheetVisual visual,
    VoidCallback? onStartBattle,
    VoidCallback? onPracticeMore,
  }) {
    final layout = PlaygroundSheetLayout.resolve(context);
    return showModalBottomSheet<BossBottomSheetResult>(
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
        return _BossSheetHost(
          layout: layout,
          visual: visual,
          onStartBattle: onStartBattle,
          onPracticeMore: onPracticeMore,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _BossSheetHost(
      layout: PlaygroundSheetLayout.resolve(context),
      visual: visual,
      onStartBattle: onStartBattle,
      onPracticeMore: onPracticeMore,
    );
  }
}

class _BossSheetHost extends StatelessWidget {
  const _BossSheetHost({
    required this.layout,
    required this.visual,
    required this.onStartBattle,
    required this.onPracticeMore,
  });

  final PlaygroundSheetLayout layout;
  final BossSheetVisual visual;
  final VoidCallback? onStartBattle;
  final VoidCallback? onPracticeMore;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetHeight = layout.maxHeight;
    final container = PlaygroundSheetContainer(
      semanticLabel: visual.isUnlocked
          ? PlaygroundStrings.bossSheetReadySemantic
          : (visual.semanticLocked ??
                PlaygroundStrings.bossSheetLockedSemantic),
      layout: layout,
      height: sheetHeight,
      child: PlaygroundSheetFrame(
        layout: layout,
        semanticLabel: visual.isUnlocked
            ? PlaygroundStrings.bossSheetReadySemantic
            : (visual.semanticLocked ??
                  PlaygroundStrings.bossSheetLockedSemantic),
        content: _BossSheetBody(visual: visual, isDark: isDark),
        actions: PlaygroundSheetActionRow(
          primaryLabel: PlaygroundStrings.bossSheetCtaStart,
          primaryIcon: AppIcons.arrowForward,
          onPrimary: () {
            onStartBattle?.call();
            Navigator.of(context).pop(BossBottomSheetResult.started);
          },
          primaryEnabled: visual.canStart,
          primarySemantic: PlaygroundStrings.bossSheetCtaStart,
          secondaryLabel: PlaygroundStrings.bossSheetCtaPractice,
          onSecondary: () {
            onPracticeMore?.call();
            Navigator.of(context).pop(BossBottomSheetResult.practiceRequested);
          },
          secondarySemantic: PlaygroundStrings.bossSheetCtaPractice,
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

class _BossSheetBody extends StatelessWidget {
  const _BossSheetBody({required this.visual, required this.isDark});

  final BossSheetVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: <Widget>[
        PlaygroundSheetHeader(
          title: visual.title,
          subtitle: visual.description,
          trailing: PlaygroundSheetRarityBadge(
            rarity: visual.rarity,
            icon: visual.rewardsIcon,
          ),
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.md),
        _BossHero(visual: visual, isDark: isDark),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: PlaygroundSheetStatTile(
                icon: AppIcons.target,
                iconColor: PlaygroundColors.sheetAccentDestructive,
                value: PlaygroundStrings.bossSheetQuestionsTemplate.replaceAll(
                  '%d',
                  '${visual.questionCount}',
                ),
                label: PlaygroundStrings.bossSheetQuestionsLabel,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PlaygroundSheetStatTile(
                icon: AppIcons.heart,
                iconColor: PlaygroundColors.hearts,
                value: PlaygroundStrings.bossSheetHeartsPenaltyTemplate
                    .replaceAll('%d', '${visual.heartsPenalty}'),
                label: PlaygroundStrings.bossSheetHeartsPenaltyLabel,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            Expanded(
              child: PlaygroundSheetStatTile(
                icon: AppIcons.xp,
                iconColor: PlaygroundColors.xp,
                value: '${visual.xpReward}',
                label: PlaygroundStrings.bossSheetRecommendedXpLabel,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: PlaygroundSheetStatTile(
                icon: AppIcons.coinIcon,
                iconColor: PlaygroundColors.coin,
                value: '${visual.coinReward}',
                label: PlaygroundStrings.bossSheetRewardsLabel,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          PlaygroundStrings.bossSheetRequirementsLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...visual.requirements.map(
          (req) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: _BossRequirementTile(requirement: req, isDark: isDark),
          ),
        ),
        if (!visual.isUnlocked) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: PlaygroundColors.sheetAccentWarning.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
              borderRadius: PlaygroundSheetBorder.statRadius,
              border: Border.all(
                color: PlaygroundColors.sheetAccentWarning.withValues(
                  alpha: 0.4,
                ),
                width: PlaygroundSizes.bottomSheetBorderWidth,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  AppIcons.lockFilled,
                  color: PlaygroundColors.sheetAccentWarning,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    visual.semanticLocked ??
                        PlaygroundStrings.bossSheetLockedSemantic,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: PlaygroundColors.sheetAccentWarning,
                      fontWeight: FontWeight.w800,
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

class _BossHero extends StatelessWidget {
  const _BossHero({required this.visual, required this.isDark});

  final BossSheetVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = _rarityColor(visual.rarity);
    return Semantics(
      label:
          '${PlaygroundStrings.bossSheetRarityBadgeLabel}: '
          '${visual.difficultyLabel}',
      container: true,
      child: Container(
        height: PlaygroundSizes.bottomSheetHeroHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              color.withValues(alpha: PlaygroundSheetOpacity.accentSurface),
              PlaygroundColors.sheetAccentSecondary.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: PlaygroundSheetBorder.heroRadius,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.6),
                  width: 2.0,
                ),
              ),
              child: Icon(
                visual.rewardsIcon,
                color: color,
                size: AppSizes.iconXl,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    visual.difficultyLabel,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${PlaygroundStrings.bossSheetRecommendedXpLabel} • '
                    '${visual.recommendedXp}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _rarityColor(PlaygroundRarity rarity) {
    switch (rarity) {
      case PlaygroundRarity.common:
        return PlaygroundColors.rarityCommon;
      case PlaygroundRarity.rare:
        return PlaygroundColors.rarityRare;
      case PlaygroundRarity.epic:
        return PlaygroundColors.rarityEpic;
      case PlaygroundRarity.legendary:
        return PlaygroundColors.rarityLegendary;
    }
  }
}

class _BossRequirementTile extends StatelessWidget {
  const _BossRequirementTile({required this.requirement, required this.isDark});

  final BossRequirementVisual requirement;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = requirement.completed
        ? PlaygroundColors.sheetAccentSuccess
        : (isDark ? AppColors.darkMuted : AppColors.lightMuted);
    return Semantics(
      label: requirement.semanticLabel ?? requirement.label,
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: PlaygroundSheetOpacity.accentSurface),
          borderRadius: PlaygroundSheetBorder.statRadius,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              requirement.completed
                  ? AppIcons.checkCircle
                  : AppIcons.lockFilled,
              color: color,
              size: AppSizes.iconSm,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                requirement.label,
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
    );
  }
}
