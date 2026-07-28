import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../constants/playground_constants.dart';
import '../reward_chest.dart';
import 'reward_popup.dart';
import 'reward_popup_constants.dart';

class RewardPopupDialog {
  const RewardPopupDialog._();

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
    final isWide = RewardPopupSizing.isWide(context);
    return showDialog<void>(
      context: context,
      barrierColor:
          scrimColor ??
          PlaygroundColors.popupScrim.withValues(
            alpha: PlaygroundOpacity.rewardPopupScrim,
          ),
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isWide ? AppSpacing.huge : AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: RewardPopup(
            entries: entries,
            title: title,
            subtitle: subtitle,
            primaryLabel: primaryLabel,
            secondaryLabel: secondaryLabel,
            onPrimary: onPrimary == null
                ? null
                : () {
                    Navigator.of(dialogContext).pop();
                    onPrimary();
                  },
            onSecondary: onSecondary == null
                ? null
                : () {
                    Navigator.of(dialogContext).pop();
                    onSecondary();
                  },
            chestState: chestState,
            rarity: rarity,
            isDark: isDark,
            autoOpenChest: autoOpenChest,
          ),
        );
      },
    );
  }
}
