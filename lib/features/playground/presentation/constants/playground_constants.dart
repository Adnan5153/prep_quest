import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class PlaygroundDurations {
  const PlaygroundDurations._();

  static const Duration stateTransition = Duration(milliseconds: 240);
  static const Duration progressAnimation = Duration(milliseconds: 320);
  static const Duration ringPulseCycle = Duration(milliseconds: 1600);
  static const Duration badgeEntrance = Duration(milliseconds: 360);
  static const Duration iconBounce = Duration(milliseconds: 420);
  static const Duration pressFeedback = Duration(milliseconds: 120);
  static const Duration labelFade = Duration(milliseconds: 180);
  static const Duration hudValueTween = Duration(milliseconds: 320);
  static const Duration hudValueSwap = Duration(milliseconds: 220);
  static const Duration xpGain = Duration(milliseconds: 600);
  static const Duration coinGain = Duration(milliseconds: 600);
  static const Duration streakPulse = Duration(milliseconds: 1600);
  static const Duration heartsLowPulse = Duration(milliseconds: 2000);

  static const Duration cardEntrance = Duration(milliseconds: 280);
  static const Duration cardProgress = Duration(milliseconds: 360);
  static const Duration cardCelebration = Duration(milliseconds: 900);
  static const Duration missionCompletion = Duration(milliseconds: 320);
  static const Duration rewardPill = Duration(milliseconds: 200);
  static const Duration rewardChest = Duration(milliseconds: 1500);
  static const Duration rewardFloat = Duration(milliseconds: 1200);
  static const Duration rewardSparkle = Duration(milliseconds: 1800);
  static const Duration rewardPopupEntrance = Duration(milliseconds: 420);
  static const Duration xpOrbPulse = Duration(milliseconds: 1600);
  static const Duration coinHoverSpin = Duration(milliseconds: 2200);
  static const Duration chestLidLift = Duration(milliseconds: 600);
  static const Duration chestLightBeam = Duration(milliseconds: 400);
  static const Duration chestContentRise = Duration(milliseconds: 500);

  // ----- Progression -----
  static const Duration levelCardEntrance = Duration(milliseconds: 240);
  static const Duration levelCardProgress = Duration(milliseconds: 360);
  static const Duration challengeTileEntrance = Duration(milliseconds: 200);
  static const Duration challengeTileComplete = Duration(milliseconds: 360);
  static const Duration bossGatePulse = Duration(milliseconds: 1600);
  static const Duration bossGateOpening = Duration(milliseconds: 900);
  static const Duration bossGateShake = Duration(milliseconds: 600);
  static const Duration levelRewardDialogEntrance = Duration(milliseconds: 420);
  static const Duration levelRewardChestScale = Duration(milliseconds: 600);
  static const Duration levelRewardXpEntry = Duration(milliseconds: 400);
  static const Duration levelRewardCoinEntry = Duration(milliseconds: 400);
  static const Duration levelRewardFloatUp = Duration(milliseconds: 1200);
  static const Duration levelRewardCelebration = Duration(milliseconds: 1800);
  static const Duration progressPathReveal = Duration(milliseconds: 800);
  static const Duration progressPathPulse = Duration(milliseconds: 2200);
  static const Duration lockedLevelShimmer = Duration(milliseconds: 3200);
  static const Duration progressionStaggerStep = Duration(milliseconds: 80);
}

class PlaygroundCurves {
  const PlaygroundCurves._();

  static const Curve stateEase = Curves.easeOutCubic;
  static const Curve stateEnter = Curves.easeOutBack;
  static const Curve stateExit = Curves.easeInCubic;
  static const Curve rewardPop = Curves.elasticOut;
  static const Curve breathe = Curves.easeInOutSine;
  static const Curve hudEase = Curves.easeOutCubic;
  static const Curve hudPop = Curves.elasticOut;

  static const Curve cardEntrance = Curves.easeOutBack;
  static const Curve cardCelebration = Curves.elasticOut;

  static const Curve rewardPopupEntranceFade = Curves.easeOut;
}

class PlaygroundSheetDurations {
  const PlaygroundSheetDurations._();

  static const Duration entrance = Duration(milliseconds: 240);
  static const Duration exit = Duration(milliseconds: 200);
  static const Duration reducedMotionFade = Duration(milliseconds: 80);
  static const Duration stagger = Duration(milliseconds: 80);
}

class PlaygroundSheetCurves {
  const PlaygroundSheetCurves._();

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve reducedMotion = Curves.linear;
}

class PlaygroundSheetOpacity {
  const PlaygroundSheetOpacity._();

  static const double scrim = 0.40;
  static const double outlineDark = 0.10;
  static const double outlineLight = 0.08;
  static const double shadow = 0.32;
  static const double handle = 0.45;
  static const double accentSurface = 0.12;
  static const double disabled = 0.45;
}

class PlaygroundSheetMotion {
  const PlaygroundSheetMotion._();

  static const double slideBegin = 0.08;
  static const double slideEnd = 0.0;
  static const double fadeBegin = 0.0;
  static const double fadeEnd = 1.0;
}

class PlaygroundNodeKind {
  const PlaygroundNodeKind._();

  static const String regular = 'regular';
  static const String boss = 'boss';
  static const String library = 'library';
  static const String premium = 'premium';
  static const String event = 'event';
  static const String daily = 'daily';
  static const String tournament = 'tournament';
  static const String seasonal = 'seasonal';
}

class PlaygroundOpacity {
  const PlaygroundOpacity._();

  static const double disabled = 0.45;
  static const double locked = 0.55;
  static const double dimmed = 0.7;
  static const double heartsLow = 0.55;
  static const double streakAtRisk = 0.75;
  static const double coinsAtZero = 0.6;

  static const double rewardPopupScrim = 0.58;
  static const double rewardPopupOutlineDark = 0.08;
  static const double rewardPopupOutlineLight = 0.06;
  static const double rewardPopupShadow = 0.45;
  static const double rewardPopupLegendaryGlow = 0.30;
  static const double rewardPopupEpicGlow = 0.20;
  static const double rewardPopupBadgeFill = 0.18;
  static const double rewardPopupBadgeBorder = 0.55;
  static const double rewardPopupBadgeGradientEnd = 0.55;
  static const double rewardPopupBadgeRing = 0.50;
  static const double rewardPopupBadgeGlow = 0.40;
  static const double rewardPopupCtaGradientEnd = 0.75;
  static const double rewardPopupCtaShadow = 0.40;
}

class RewardPopupEntranceValues {
  const RewardPopupEntranceValues._();

  static const double scaleBegin = 0.60;
  static const double scaleEnd = 1.0;
  static const double fadeBegin = 0.0;
  static const double fadeEnd = 1.0;
}

class PlaygroundColors {
  const PlaygroundColors._();

  static const Color xp = AppColors.accent;
  static const Color coin = AppColors.buildingGold;
  static const Color streak = AppColors.warning;
  static const Color hearts = AppColors.error;
  static const Color premiumChrome = AppColors.sparkleGold;
  static const Color heartsEmpty = AppColors.buildingLocked;

  static const Color completed = AppColors.success;
  static const Color gems = AppColors.info;
  static const Color progressTrack = AppColors.darkSurface;
  static const Color progressTrackLight = AppColors.lightSurface;
  static const Color completedGlow = AppColors.success;
  static const Color cardLockedSurface = AppColors.buildingLocked;
  static const Color cardPremiumStart = AppColors.accent;
  static const Color cardPremiumEnd = AppColors.buildingGold;
  static const Color cardGlowAccent = AppColors.sparkleGold;

  // ----- Path surface -----
  static const Color roadCompletedLight = Color(0xFF5ED8A4);
  static const Color roadCompletedDark = Color(0xFF2EAA78);
  static const Color roadActiveLight = Color(0xFF5BA0FF);
  static const Color roadActiveDark = Color(0xFF3B7CD9);
  static const Color roadLockedLight = Color(0xFF9C9690);
  static const Color roadLockedDark = Color(0xFF5C6168);
  static const Color roadHighlightLight = Color(0xFFFFFFFF);
  static const Color roadHighlightDark = Color(0xFFE4E7EB);
  static const Color roadShadowLight = Color(0x33000000);
  static const Color roadShadowDark = Color(0x66000000);
  static const Color roadGlowLight = Color(0x665BA0FF);
  static const Color roadGlowDark = Color(0xAA5BA0FF);

  // ----- Reward rarities -----
  static const Color rarityCommon = AppColors.buildingLocked;
  static const Color rarityRare = AppColors.info;
  static const Color rarityEpic = AppColors.academyPrimary;
  static const Color rarityLegendary = AppColors.sparkleGold;

  // ----- Coin surface -----
  static const Color coinHighlight = AppColors.nodeHighlight;
  static const Color coinRimLight = AppColors.windowGlow;
  static const Color coinRimDark = AppColors.trunkBrownDark;
  static const Color coinInsetShadow = AppColors.nodeInsetShadow;

  // ----- XP orb surface -----
  static const Color xpCore = AppColors.accent;
  static const Color xpEdge = AppColors.warning;
  static const Color xpHalo = AppColors.sparkleGold;

  // ----- Chest surface -----
  static const Color chestWoodLight = AppColors.plankLight;
  static const Color chestWoodDark = AppColors.trunkBrown;
  static const Color chestWoodShade = AppColors.trunkBrownDark;
  static const Color chestBand = AppColors.buildingGold;
  static const Color chestLock = AppColors.sparkleGold;
  static const Color chestGlow = AppColors.sparkleGold;

  // ----- Reward popup surface -----
  static const Color popupScrim = AppColors.darkBackground;
  static const Color popupSurfaceLight = AppColors.lightBackground;
  static const Color popupSurfaceDark = AppColors.darkSurface;
  static const Color popupAccent = AppColors.accent;

  // ----- Bottom sheet surface -----
  static const Color sheetScrim = AppColors.darkBackground;
  static const Color sheetSurfaceLight = AppColors.lightBackground;
  static const Color sheetSurfaceDark = AppColors.darkSurface;
  static const Color sheetAccent = AppColors.primary;
  static const Color sheetAccentSecondary = AppColors.accent;
  static const Color sheetAccentDestructive = AppColors.error;
  static const Color sheetAccentSuccess = AppColors.success;
  static const Color sheetAccentWarning = AppColors.warning;
  static const Color sheetAccentPremium = AppColors.sparkleGold;
  static const Color sheetHandleLight = AppColors.lightMuted;
  static const Color sheetHandleDark = AppColors.darkMuted;
  static const Color sheetOutlineLight = AppColors.lightMuted;
  static const Color sheetOutlineDark = AppColors.darkMuted;

  // ----- Progression surface -----
  static const Color progressionUnlocked = Color(0xFF3F7CCC);
  static const Color progressionInProgress = Color(0xFFF2A33A);
  static const Color progressionCompleted = Color(0xFF3FB37C);
  static const Color progressionLocked = Color(0xFFA7A7B2);
  static const Color progressionBoss = Color(0xFFB23A8A);
  static const Color progressionPremium = AppColors.sparkleGold;
  static const Color progressionEvent = Color(0xFF5BA0FF);
  static const Color progressionSeasonal = Color(0xFFE07B3A);
  static const Color progressionDaily = Color(0xFF7FD6A8);
  static const Color progressionTournament = Color(0xFFD7A86E);
  static const Color progressionGrayscale = Color(0xFF8E94A0);
  static const Color progressionSurfaceLight = AppColors.lightBackground;
  static const Color progressionSurfaceDark = AppColors.darkSurface;
  static const Color progressionAccentSurfaceLight = Color(0x143F7CCC);
  static const Color progressionAccentSurfaceDark = Color(0x1A3F7CCC);
  static const Color progressionHighlightLight = Color(0x80FFFFFF);
  static const Color progressionHighlightDark = Color(0x33FFFFFF);
  static const Color progressionDividerLight = Color(0x1F000000);
  static const Color progressionDividerDark = Color(0x26FFFFFF);
}

enum PlaygroundRarity { common, rare, epic, legendary }

class PlaygroundAlpha {
  const PlaygroundAlpha._();

  static const double glowFloor = 0.6;
  static const double glowAmplitude = 0.4;
  static const double radiusFloor = 0.5;
  static const double radiusAmplitude = 0.5;

  static const double shadow = 0.20;
  static const double dust = 0.85;
  static const double blossomTint = 0.85;
  static const double chestShadow = 0.55;
  static const double treeHighlight = 0.55;
  static const double treeCanopyBlend = 0.40;
  static const double treeCanopyHighlightBlend = 0.60;

  static const double bridgePlankHighlight = 0.50;
  static const double bridgePlankShadow = 0.35;
  static const double bridgeRopeHighlight = 0.30;

  static const double flagWaveHighlight = 0.55;
  static const double flagWaveShade = 0.65;

  static const double riverFoamHighlight = 0.30;
  static const double riverFoamShadow = 0.20;
  static const double riverFoamLight = 0.40;
  static const double riverBedShade = 0.60;
  static const double cloudHighlight = 0.20;

  static const double windowFrameDark = 0.40;
  static const double windowMullion = 0.30;
  static const double archLight = 0.30;
  static const double roofEdgeShade = 0.30;
  static const double premiumGlowAlpha = 0.55;
  static const double lockedOverlay = 0.40;
  static const double bookSpine = 0.85;
  static const double bookShelfFrame = 0.45;

  static const double streakCore = 0.85;
  static const double xpOrbHalo = 0.55;
  static const double coinRewardGlow = 0.55;

  static const double roadShadowAlpha = 0.30;
  static const double roadHighlightAlphaLight = 0.55;
  static const double roadHighlightAlphaDark = 0.30;
  static const double roadGlowAlphaFloor = 0.55;
  static const double roadGlowAlphaAmplitude = 0.25;
  static const double roadDashOpacityLight = 0.65;
  static const double roadDashOpacityDark = 0.75;
  static const double roadTravelHighlightAlpha = 0.85;
  static const double roadSparkTrailAlpha = 0.65;
  static const double roadTravelHeadAlpha = 1.0;

  static const double progressionSegmentFloor = 0.30;
  static const double progressionSegmentActive = 0.85;
  static const double progressionSegmentCompleted = 1.0;
  static const double progressionLockedOverlay = 0.55;
  static const double bossGatePulseFloor = 0.55;
  static const double bossGatePulseAmplitude = 0.30;
  static const double bossGateLockAlpha = 0.65;
  static const double bossGateUnlockGlowAlpha = 0.85;
  static const double levelCardPremiumGlow = 0.45;
  static const double challengeTileHighlightAlpha = 0.45;
  static const double progressPathDashAlphaLight = 0.65;
  static const double progressPathDashAlphaDark = 0.75;
}

class PlaygroundGlowPulse {
  const PlaygroundGlowPulse._();

  static const double radiusFloor = 0.5;
  static const double radiusAmplitude = 0.5;
  static const double alphaFloor = 0.6;
  static const double alphaAmplitude = 0.4;
}

class PlaygroundPathPulse {
  const PlaygroundPathPulse._();

  static const double glowAlphaFloor = 0.55;
  static const double glowAlphaAmplitude = 0.25;
  static const double glowRadiusFloor = 0.92;
  static const double glowRadiusAmplitude = 0.18;
  static const double dashOffsetAmplitude = 1.0;
  static const double travelHeadFloor = 0.55;
  static const double travelHeadAmplitude = 0.45;
  static const double shimmerFloor = 0.55;
  static const double shimmerAmplitude = 0.45;
}

class PlaygroundDashTokens {
  const PlaygroundDashTokens._();

  static const double mapDashLength = 10.0;
  static const double mapDashGap = 6.0;
  static const double legendDashLength = 4.0;
  static const double legendDashGap = 3.0;
  static const double legendDashStrokeWidth = 2.0;
  static const double roadDashLength = 8.0;
  static const double roadDashGap = 6.0;
  static const double roadTravelDashLength = 14.0;
  static const double roadTravelDashGap = 6.0;
}

class PlaygroundBezelTokens {
  const PlaygroundBezelTokens._();

  static const double highlightAlphaDark = 0.22;
  static const double highlightAlphaLight = 0.55;
  static const double shadowAlphaDark = 0.40;
  static const double shadowAlphaLight = 0.28;
  static const double insetAlphaDark = 0.55;
  static const double insetAlphaLight = 0.30;

  static const double bezelGlowAlpha = 0.85;
  static const double glowIntensityBoss = 1.0;
  static const double glowIntensityPremium = 0.9;
  static const double glowIntensityInProgress = 0.85;
  static const double glowIntensitySeasonal = 0.8;
  static const double glowIntensityEvent = 0.7;
  static const double glowIntensityUnlocked = 0.6;
  static const double glowIntensityMultiplier = 0.45;
}

class PlaygroundGradientStops {
  const PlaygroundGradientStops._();

  static const List<double> bezel3Stop = <double>[0.0, 0.55, 1.0];
  static const List<double> wood3Stop = <double>[0.0, 0.55, 1.0];
  static const List<double> hairline = <double>[0.0, 1.0];
  static const List<double> waterTwoStop = <double>[0.0, 1.0];
}

class PlaygroundNodeStatusTokens {
  const PlaygroundNodeStatusTokens._();

  static const String locked = 'locked';
  static const String unlocked = 'unlocked';
  static const String inProgress = 'inProgress';
  static const String completed = 'completed';
  static const String boss = 'boss';
  static const String premium = 'premium';
  static const String event = 'event';
  static const String seasonal = 'seasonal';
  static const String daily = 'daily';
}

enum PlaygroundChallengeKind { reading, quiz, miniBoss, aiTask, mock }

class PlaygroundProgressionDifficulty {
  const PlaygroundProgressionDifficulty._();

  static const String easy = 'easy';
  static const String medium = 'medium';
  static const String hard = 'hard';
  static const String expert = 'expert';
}

class PlaygroundBuildingPalette {
  const PlaygroundBuildingPalette._();

  static const List<Color> academy = <Color>[
    AppColors.academyShade,
    AppColors.academyPrimary,
    AppColors.academyHighlight,
  ];

  static const List<Color> library = <Color>[
    AppColors.libraryShade,
    AppColors.libraryPrimary,
    AppColors.libraryHighlight,
  ];

  static const List<Color> academyRoof = <Color>[
    AppColors.academyRoof,
    AppColors.academyShade,
  ];

  static const List<Color> libraryRoof = <Color>[
    AppColors.libraryRoof,
    AppColors.libraryShade,
  ];
}

class PlaygroundNodeDefaults {
  const PlaygroundNodeDefaults._();

  static const double minProgress = 0.0;
  static const double maxProgress = 1.0;
  static const int defaultBadgeCountCap = 1;
}

class PlaygroundDecorationDurations {
  const PlaygroundDecorationDurations._();

  static const Duration windSway = Duration(milliseconds: 4200);
  static const Duration cloudDrift = Duration(milliseconds: 12000);
  static const Duration riverFlow = Duration(milliseconds: 2400);
  static const Duration flagWave = Duration(milliseconds: 2200);
  static const Duration particleCycle = Duration(milliseconds: 6000);
  static const Duration sparkleCycle = Duration(milliseconds: 3000);
}

class PlaygroundDecorationCurves {
  const PlaygroundDecorationCurves._();

  static const Curve sway = Curves.easeInOutSine;
  static const Curve drift = Curves.linear;
  static const Curve flow = Curves.linear;
  static const Curve wave = Curves.easeInOutSine;
}

class PlaygroundDecorationLimits {
  const PlaygroundDecorationLimits._();

  static const int maxAmbientParticles = 24;
  static const int maxClouds = 6;
  static const double cloudOverlap = 0.20;
  static const double maxSwayAmplitude = 0.05;
}

class PlaygroundBuildingState {
  const PlaygroundBuildingState._();

  static const String locked = 'locked';
  static const String unlocked = 'unlocked';
  static const String current = 'current';
  static const String completed = 'completed';
  static const String premium = 'premium';
}

class PlaygroundBuildingCenter {
  const PlaygroundBuildingCenter._();

  static const String academy = 'academy';
  static const String library = 'library';
}

class PlaygroundBuildingDurations {
  const PlaygroundBuildingDurations._();

  static const Duration idleParallax = Duration(milliseconds: 4400);
  static const Duration levelUpPulse = Duration(milliseconds: 800);
  static const Duration tapFeedback = Duration(milliseconds: 120);
  static const Duration bossEntrance = Duration(milliseconds: 900);
  static const Duration windowBlink = Duration(milliseconds: 3200);
  static const Duration flagWave = Duration(milliseconds: 2200);
  static const Duration floatCycle = Duration(milliseconds: 2600);
}

class PlaygroundBuildingCurves {
  const PlaygroundBuildingCurves._();

  static const Curve breath = Curves.easeInOutSine;
  static const Curve entrance = Curves.easeOutBack;
  static const Curve tap = Curves.easeOut;
  static const Curve levelUp = Curves.easeOutBack;
}

class PlaygroundBuildingOpacity {
  const PlaygroundBuildingOpacity._();

  static const double locked = 0.55;
  static const double completed = 1.0;
  static const double premium = 1.0;
  static const double ambientParticle = 0.7;
}

class PlaygroundMapDurations {
  const PlaygroundMapDurations._();

  static const Duration cameraFocus = Duration(milliseconds: 520);
  static const Duration cameraSnap = Duration(milliseconds: 320);
  static const Duration cameraZoom = Duration(milliseconds: 420);
  static const Duration legendCollapse = Duration(milliseconds: 280);
  static const Duration legendExpand = Duration(milliseconds: 280);
  static const Duration backgroundParallax = Duration(milliseconds: 12000);
  static const Duration pathReveal = Duration(milliseconds: 800);
  static const Duration nodeGlow = Duration(milliseconds: 1600);
}

class PlaygroundPathDurations {
  const PlaygroundPathDurations._();

  static const Duration reveal = Duration(milliseconds: 800);
  static const Duration glowCycle = Duration(milliseconds: 1800);
  static const Duration dashMarch = Duration(milliseconds: 1200);
  static const Duration travelHighlight = Duration(milliseconds: 2400);
  static const Duration shimmer = Duration(milliseconds: 2200);
  static const Duration sparkleCycle = Duration(milliseconds: 2600);
}

class PlaygroundPathCurves {
  const PlaygroundPathCurves._();

  static const Curve reveal = Curves.easeInOutCubic;
  static const Curve glow = Curves.easeInOutSine;
  static const Curve dashMarch = Curves.linear;
  static const Curve travel = Curves.easeInOutSine;
  static const Curve shimmer = Curves.easeInOutSine;
}

class PlaygroundMapCurves {
  const PlaygroundMapCurves._();

  static const Curve cameraFocus = Curves.easeOutCubic;
  static const Curve cameraSnap = Curves.easeOutCubic;
  static const Curve cameraZoom = Curves.easeInOutCubic;
  static const Curve legendCollapse = Curves.easeInCubic;
  static const Curve legendExpand = Curves.easeOutCubic;
}

class PlaygroundMapOpacity {
  const PlaygroundMapOpacity._();

  static const double skyOverlay = 0.0;
  static const double ground = 1.0;
  static const double mountainBack = 0.55;
  static const double mountainMid = 0.80;
  static const double mountainFront = 1.00;
  static const double cameraGlow = 0.35;
  static const double legendBackdropLight = 0.85;
  static const double legendBackdropDark = 0.70;
  static const double legendScrim = 0.18;
  static const double pathCompleted = 1.0;
  static const double pathLocked = 0.50;
  static const double pathActive = 1.0;
  static const double pathDashed = 0.65;
}

class PlaygroundMapLimits {
  const PlaygroundMapLimits._();

  static const double minZoom = 0.85;
  static const double maxZoom = 2.20;
  static const double defaultZoom = 1.0;
  static const double focusZoom = 1.30;
  static const int legendColumnsMobile = 1;
  static const int legendColumnsTablet = 2;
  static const int legendColumnsDesktop = 3;
  static const double legendCollapsedSize = 48.0;
  static const double legendExpandedMaxHeight = 280.0;
  static const double cameraFocusPadding = 64.0;
  static const double cameraSnapTolerance = 12.0;
}

class PlaygroundMapPadding {
  const PlaygroundMapPadding._();

  static const double legendInsetHorizontal = 12.0;
  static const double legendInsetVertical = 12.0;
  static const double legendItemGap = 8.0;
  static const double cameraSafeInset = 16.0;
}
