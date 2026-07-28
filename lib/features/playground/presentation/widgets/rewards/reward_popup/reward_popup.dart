import 'package:flutter/material.dart';

import '../../../constants/playground_constants.dart';
import '../../../constants/playground_strings.dart';
import '../reward_chest.dart';
import 'reward_entry.dart';
import 'reward_popup_animation.dart';
import 'reward_popup_body.dart';
import 'reward_popup_constants.dart';
import 'reward_popup_container.dart';
import 'reward_popup_dialog.dart';

export 'reward_entry.dart';
export 'reward_entry_kind.dart';

class RewardPopup extends StatelessWidget {
  const RewardPopup({
    super.key,
    required this.entries,
    this.title,
    this.subtitle,
    this.primaryLabel,
    this.secondaryLabel,
    this.onPrimary,
    this.onSecondary,
    this.chestState = RewardChestState.opening,
    this.rarity = PlaygroundRarity.legendary,
    this.isDark = false,
    this.autoOpenChest = true,
    this.scrimColor,
  });

  final List<RewardEntry> entries;
  final String? title;
  final String? subtitle;
  final String? primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final RewardChestState chestState;
  final PlaygroundRarity rarity;
  final bool isDark;
  final bool autoOpenChest;
  final Color? scrimColor;

  static Future<void> show(
    BuildContext context, {
    required List<RewardEntry> entries,
    String? title,
    String? subtitle,
    String? primaryLabel,
    String? secondaryLabel,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    RewardChestState chestState = RewardChestState.opening,
    PlaygroundRarity rarity = PlaygroundRarity.legendary,
    bool isDark = false,
    bool autoOpenChest = true,
    Color? scrimColor,
  }) {
    return RewardPopupDialog.show(
      context,
      entries: entries,
      title: title,
      subtitle: subtitle,
      primaryLabel: primaryLabel,
      secondaryLabel: secondaryLabel,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      chestState: chestState,
      rarity: rarity,
      isDark: isDark,
      autoOpenChest: autoOpenChest,
      scrimColor: scrimColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title ?? PlaygroundStrings.rewardPopupTitle;
    final resolvedSubtitle = subtitle ?? PlaygroundStrings.rewardPopupSubtitle;
    final resolvedPrimary = primaryLabel ?? PlaygroundStrings.rewardPopupClaim;
    final resolvedSecondary =
        secondaryLabel ?? PlaygroundStrings.rewardPopupLater;
    final maxWidth = RewardPopupSizing.resolveMaxWidth(context);

    return RepaintBoundary(
      child: Semantics(
        label: title ?? PlaygroundStrings.rewardPopupSemantic,
        container: true,
        child: RewardPopupEntrance(
          child: RewardPopupContainer(
            maxWidth: maxWidth,
            isDark: isDark,
            rarity: rarity,
            child: RewardPopupBody(
              entries: entries,
              title: resolvedTitle,
              subtitle: resolvedSubtitle,
              primaryLabel: resolvedPrimary,
              secondaryLabel: resolvedSecondary,
              onPrimary: onPrimary,
              onSecondary: onSecondary,
              chestState: chestState,
              rarity: rarity,
              isDark: isDark,
              autoOpenChest: autoOpenChest,
            ),
          ),
        ),
      ),
    );
  }
}
