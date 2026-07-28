import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/widget_constants.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';

class RewardPopupContainer extends StatelessWidget {
  const RewardPopupContainer({
    super.key,
    required this.maxWidth,
    required this.isDark,
    required this.rarity,
    required this.child,
  });

  final double maxWidth;
  final bool isDark;
  final PlaygroundRarity rarity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark
        ? PlaygroundColors.popupSurfaceDark
        : PlaygroundColors.popupSurfaceLight;
    final borderColor = isDark
        ? Colors.white.withValues(
            alpha: PlaygroundOpacity.rewardPopupOutlineDark,
          )
        : Colors.black.withValues(
            alpha: PlaygroundOpacity.rewardPopupOutlineLight,
          );
    final glowColor = rarity == PlaygroundRarity.legendary
        ? PlaygroundColors.rarityLegendary.withValues(
            alpha: PlaygroundOpacity.rewardPopupLegendaryGlow,
          )
        : rarity == PlaygroundRarity.epic
        ? PlaygroundColors.rarityEpic.withValues(
            alpha: PlaygroundOpacity.rewardPopupEpicGlow,
          )
        : Colors.transparent;

    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          minHeight: PlaygroundSizes.rewardPopupMinHeight,
          maxHeight: PlaygroundSizes.rewardPopupMaxHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(
              PlaygroundSizes.rewardPopupCornerRadius,
            ),
            border: Border.all(
              color: borderColor,
              width: WidgetConstants.outlineThickness,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.nodeDropShadow.withValues(
                  alpha: PlaygroundOpacity.rewardPopupShadow,
                ),
                blurRadius: PlaygroundSizes.rewardPopupShadowBlur,
                offset: Offset(0, PlaygroundSizes.rewardPopupShadowOffsetY),
              ),
              BoxShadow(
                color: glowColor,
                blurRadius: PlaygroundSizes.rewardChestGlowBlur,
                spreadRadius: PlaygroundSizes.rewardPopupShadowSpread,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              PlaygroundSizes.rewardPopupCornerRadius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
