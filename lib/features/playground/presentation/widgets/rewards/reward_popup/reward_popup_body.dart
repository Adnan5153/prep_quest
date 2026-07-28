import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../reward_chest.dart';
import 'reward_entry.dart';
import 'reward_popup_actions.dart';
import 'reward_popup_header.dart';
import 'reward_popup_reward_list.dart';

class RewardPopupBody extends StatelessWidget {
  const RewardPopupBody({
    super.key,
    required this.entries,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
    required this.chestState,
    required this.rarity,
    required this.isDark,
    required this.autoOpenChest,
  });

  final List<RewardEntry> entries;
  final String title;
  final String subtitle;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final RewardChestState chestState;
  final PlaygroundRarity rarity;
  final bool isDark;
  final bool autoOpenChest;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: PlaygroundSizes.rewardPopupPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RepaintBoundary(
              child: RewardPopupHeader(
                title: title,
                subtitle: subtitle,
                titleColor: titleColor,
                mutedColor: mutedColor,
                rarity: rarity,
              ),
            ),
            const SizedBox(height: PlaygroundSizes.rewardPopupGap),
            Center(
              child: RepaintBoundary(
                child: RewardChest(
                  state: chestState,
                  rarity: rarity,
                  isDark: isDark,
                  autoOpen: autoOpenChest,
                ),
              ),
            ),
            if (entries.isNotEmpty) ...<Widget>[
              const SizedBox(height: PlaygroundSizes.rewardPopupGap),
              RewardPopupRewardList(entries: entries, isDark: isDark),
            ],
            const SizedBox(height: PlaygroundSizes.rewardPopupGap),
            RewardPopupActions(
              primaryLabel: primaryLabel,
              secondaryLabel: secondaryLabel,
              onPrimary: onPrimary,
              onSecondary: onSecondary,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}
