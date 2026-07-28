import 'package:flutter/material.dart';

import '../../features/playground/presentation/constants/playground_constants.dart';
import 'app_colors.dart';

/// Centralized gradient recipes used by painters and decoration widgets.
///
/// Painters and widgets must source their gradients from this file. Tokens
/// reference [AppColors] and [PlaygroundColors] so palettes stay in sync.
class AppGradients {
  const AppGradients._();

  static const LinearGradient xpBar = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[PlaygroundColors.xpCore, PlaygroundColors.xpEdge],
  );

  static const LinearGradient premiumCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      PlaygroundColors.cardPremiumStart,
      PlaygroundColors.cardPremiumEnd,
    ],
  );

  static const LinearGradient skyLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.skyLight, AppColors.lightBackground],
  );

  static const LinearGradient skyDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.skyDark, AppColors.darkBackground],
  );

  static const LinearGradient woodDiagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[AppColors.trunkBrown, AppColors.trunkBrownDark],
  );

  static const LinearGradient chestWood = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      PlaygroundColors.chestWoodLight,
      PlaygroundColors.chestWoodDark,
      PlaygroundColors.chestWoodShade,
    ],
    stops: <double>[0.0, 0.55, 1.0],
  );

  static const LinearGradient mountainBack = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.mountainStone, AppColors.mountainStoneDark],
  );

  static const LinearGradient mountainMid = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.snowCap, AppColors.mountainStone],
  );

  static const LinearGradient mountainFront = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.foliageGreenLight, AppColors.foliageGreenDark],
  );

  static LinearGradient water({required bool isDark}) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      isDark ? AppColors.waterDark : AppColors.waterLight,
      AppColors.waterFoam,
    ],
  );

  static RadialGradient radialGlow(Color color, {double radius = 0.9}) =>
      RadialGradient(
        colors: <Color>[
          color.withValues(alpha: PlaygroundAlpha.glowFloor),
          color.withValues(alpha: 0.0),
        ],
        radius: radius,
      );
}
