import 'package:flutter/material.dart';

import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../constants/playground_constants.dart';
import '../../../constants/playground_sizes.dart';
import '../../../constants/playground_strings.dart';

class RewardPopupRarityStyles {
  const RewardPopupRarityStyles._();

  static Color color(PlaygroundRarity rarity) {
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

  static String label(PlaygroundRarity rarity) {
    switch (rarity) {
      case PlaygroundRarity.common:
        return PlaygroundStrings.rewardRarityCommon;
      case PlaygroundRarity.rare:
        return PlaygroundStrings.rewardRarityRare;
      case PlaygroundRarity.epic:
        return PlaygroundStrings.rewardRarityEpic;
      case PlaygroundRarity.legendary:
        return PlaygroundStrings.rewardRarityLegendary;
    }
  }
}

class RewardPopupSizing {
  const RewardPopupSizing._();

  static double resolveMaxWidth(BuildContext context) {
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: PlaygroundSizes.rewardPopupResponsiveScaleMobile,
      tablet: PlaygroundSizes.rewardPopupResponsiveScaleTablet,
      desktop: PlaygroundSizes.rewardPopupResponsiveScaleDesktop,
    );
    return PlaygroundSizes.rewardPopupMaxWidth * scale;
  }

  static bool isWide(BuildContext context) {
    return ResponsiveBuilder.isTablet(context);
  }
}
