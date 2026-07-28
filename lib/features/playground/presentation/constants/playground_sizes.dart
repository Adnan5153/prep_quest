import 'package:flutter/material.dart';

import '../../../../../core/constants/app_blurs.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strokes.dart';
import '../../../../../core/widgets/widget_constants.dart';

class PlaygroundSizes {
  const PlaygroundSizes._();

  static const double nodeDiameter = 64.0;
  static const double nodeHitArea = AppSizes.minTapTarget;
  static const double nodeRingStrokeWidth = AppStrokes.thick;
  static const double nodeRingPadding = AppSizes.borderThin;
  static const double nodeProgressArcStroke = AppStrokes.medium;
  static const double nodeProgressArcSize = 18.0;
  static const double nodeBadgeSize = 20.0;
  static const double nodeBadgeOffset = 6.0;
  static const double nodeIconSize = 28.0;
  static const double nodeLabelMaxWidth = 140.0;
  static const double nodeLabelGap = 6.0;
  static const double nodeLabelHorizontalPadding = 10.0;
  static const double nodeLabelVerticalPadding = 4.0;
  static const double nodeGlowBlur = AppBlurs.lg;
  static const double nodeGlowSpread = 1.0;
  static const double nodeElevation = 3.0;
  static const double nodeShadowBlur = 8.0;
  static const double nodeShadowOffsetY = 2.0;
  static const double nodeScalePressed = 0.94;
  static const double nodeScaleHover = 1.04;

  // 3D bezel — outer rim sits outside the visible diameter; inner top edge
  // and bottom shadow give the lit / shaded hemispheres of the bezel.
  static const double nodeBezelOuter = 6.0;
  static const double nodeBezelInner = 2.0;
  static const double nodeBezelHighlightThickness = 1.5;

  // Floating shadow underneath the node on the map.
  static const double nodeFloatShadowBlur = 14.0;
  static const double nodeFloatShadowOffsetY = 4.0;

  // Idle breathing amplitude — modest per design rule (1.0 → 1.06 envelope).
  static const double nodeIdleBreathMin = 1.00;
  static const double nodeIdleBreathMax = 1.04;

  // Boss / hero scale boost applied on top of responsive diameter.
  static const double nodeBossScaleBoost = 1.12;

  static const double nodeDiameterTablet = 72.0;
  static const double nodeDiameterDesktop = 80.0;
  static const double nodeBadgeSizeTablet = 22.0;

  static const EdgeInsets nodeLabelPadding = EdgeInsets.symmetric(
    horizontal: nodeLabelHorizontalPadding,
    vertical: nodeLabelVerticalPadding,
  );

  static const Offset nodeShadowOffset = Offset(0, nodeShadowOffsetY);

  // ----- Decorations --------------------------------------------------------
  static const double treeWidth = 64.0;
  static const double treeHeight = 96.0;
  static const double treeTabletScale = 1.15;
  static const double treeDesktopScale = 1.30;

  static const double bushWidth = 56.0;
  static const double bushHeight = 36.0;
  static const double bushTabletScale = 1.15;
  static const double bushDesktopScale = 1.30;

  static const double cloudWidth = 120.0;
  static const double cloudHeight = 60.0;
  static const double cloudTabletScale = 1.20;
  static const double cloudDesktopScale = 1.40;

  static const double mountainBackScale = 1.30;
  static const double mountainMidScale = 1.10;
  static const double mountainFrontScale = 1.00;
  static const double mountainWidthBase = 240.0;
  static const double mountainHeightBase = 180.0;

  static const double riverHeight = 32.0;

  static const double bridgeWidth = 160.0;
  static const double bridgeHeight = 28.0;

  static const double flagWidth = 40.0;
  static const double flagHeight = 64.0;
  static const double flagPoleWidth = 2.5;

  static const double particleMaxRadius = 4.0;
  static const double particleMinRadius = 1.5;

  static const double decorationShadowBlur = 6.0;
  static const double decorationShadowOffsetY = 2.0;

  // ----- Buildings ----------------------------------------------------------
  static const double buildingAcademyWidth = 120.0;
  static const double buildingAcademyHeight = 96.0;
  static const double buildingLibraryWidth = 96.0;
  static const double buildingLibraryHeight = 96.0;
  static const double buildingTabletScale = 1.15;
  static const double buildingDesktopScale = 1.30;

  static const double buildingHitArea = AppSizes.minTapTarget;
  static const double buildingBaseOffsetY = 6.0;

  static const double buildingRoofHeight = 28.0;
  static const double buildingWallHeight = 56.0;
  static const double buildingBaseHeight = 8.0;
  static const double buildingStairHeight = 6.0;

  static const double buildingShadowBlur = 14.0;
  static const double buildingShadowOffsetY = 4.0;

  static const double buildingWindowSize = 12.0;
  static const double buildingWindowPadding = 8.0;

  static const double buildingFlagPoleWidth = 2.0;
  static const double buildingFlagHeight = 14.0;

  static const double buildingLabelMaxWidth = 160.0;
  static const double buildingLabelGap = 8.0;
  static const double buildingLabelHorizontalPadding = 10.0;
  static const double buildingLabelVerticalPadding = 4.0;

  static const double buildingProgressSize = 56.0;
  static const double buildingProgressOffsetX = 8.0;
  static const double buildingProgressOffsetY = 4.0;

  static const double buildingScalePressed = 0.94;
  static const double buildingScaleHover = 1.04;
  static const double buildingIdleBreathMin = 1.00;
  static const double buildingIdleBreathMax = 1.02;

  static const EdgeInsets buildingLabelPadding = EdgeInsets.symmetric(
    horizontal: buildingLabelHorizontalPadding,
    vertical: buildingLabelVerticalPadding,
  );

  static const Offset buildingShadowOffset = Offset(0, buildingShadowOffsetY);

  // ----- HUD overlays ------------------------------------------------------
  static const double hudAvatarSize = 36.0;
  static const double hudTopBarHeight = 64.0;
  static const double hudIndicatorMinHeight = 44.0;
  static const double hudIndicatorMinWidth = 96.0;
  static const double hudHorizontalPadding = AppSpacing.md;
  static const double hudVerticalPadding = AppSpacing.sm;
  static const double hudInnerGap = AppSpacing.sm;
  static const double hudIconSize = 20.0;
  static const double hudValueFontSize = 16.0;
  static const double hudLabelFontSize = 12.0;
  static const double hudPressScale = 0.94;
  static const double hudTabletScale = 1.0;
  static const double hudDesktopScale = 1.0;
  static const double streakFlameSize = 20.0;
  static const double coinIconSize = 20.0;
  static const double heartIconSize = 18.0;
  static const double hudBorderRadius = AppRadius.lg;
  static const double hudBottomShadowBlur = 14.0;
  static const double hudBottomShadowOffsetY = 4.0;
  static const double hudGlassLightAlpha = 0.75;
  static const double hudGlassDarkAlpha = 0.55;
  static const double hudBlurSigma = AppBlurs.lg;
  static const double hudGainPillHeight = 24.0;
  static const double hudGainPillWidth = 56.0;
  static const double hudGainPillOffsetX = 8.0;
  static const double hudGainPillOffsetY = -10.0;
  static const double hudNotificationDotSize = 10.0;

  static const EdgeInsets hudSurfacePadding = EdgeInsets.symmetric(
    horizontal: hudHorizontalPadding,
    vertical: hudVerticalPadding,
  );

  static const EdgeInsets hudTopBarPadding = EdgeInsets.symmetric(
    horizontal: hudHorizontalPadding,
    vertical: hudVerticalPadding,
  );

  static const Offset hudBottomShadowOffset = Offset(0, hudBottomShadowOffsetY);

  // ----- Cards ---------------------------------------------------------------
  static const double cardCornerRadius = AppRadius.lg;
  static const double cardInnerCornerRadius = AppRadius.md;
  static const double cardPaddingHorizontal = AppSpacing.lg;
  static const double cardPaddingVertical = AppSpacing.md;
  static const double cardInnerGap = AppSpacing.sm;
  static const double cardStackGap = AppSpacing.xs;
  static const double cardElevation = AppSizes.cardElevation;
  static const double cardShadowBlur = 16.0;
  static const double cardShadowOffsetY = 6.0;
  static const double cardPremiumShadowBlur = AppBlurs.xxl;
  static const double cardPremiumShadowSpread = 1.0;
  static const double cardMaxWidth = 360.0;
  static const double cardMinWidth = 280.0;
  static const double cardMinHeight = AppSizes.cardMinHeight;
  static const double cardBorderWidth = WidgetConstants.outlineThickness;
  static const double cardPressScale = 0.98;
  static const double cardHoverScale = 1.02;
  static const double cardTabletScale = 1.05;
  static const double cardDesktopScale = 1.08;

  static const double cardProgressHeight = 10.0;
  static const double cardProgressTrackHeight = 6.0;
  static const double cardProgressGlowBlur = 12.0;
  static const double cardProgressGlowSpread = 1.0;

  static const double cardStageDotSize = 18.0;
  static const double cardStageDotSpacing = AppSpacing.xs;
  static const double cardStageConnectorHeight = 2.0;

  static const double cardStarSize = AppSizes.iconSm;
  static const double cardStarSpacing = AppSpacing.xxs;
  static const double cardStarGroupMaxWidth =
      5 * (cardStarSize + cardStarSpacing);

  static const double cardRewardPillHeight = 32.0;
  static const double cardRewardPillRadius = AppRadius.pill;
  static const double cardRewardPillIconSize = AppSizes.iconXs;
  static const double cardRewardPillPaddingHorizontal = AppSpacing.sm;
  static const double cardRewardPillPaddingVertical = AppSpacing.xxs;

  static const double cardIconSize = AppSizes.iconMd;
  static const double cardLargeIconSize = AppSizes.iconLg;
  static const double cardBadgeSize = AppSizes.iconSm;
  static const double cardCompletedBadgeSize = AppSizes.iconMd;

  static const double cardTimerIconSize = AppSizes.iconXs;
  static const double cardTimerGap = AppSpacing.xxs;
  static const double cardTimerFontSize = 12.0;
  static const double cardTimerPaddingHorizontal = AppSpacing.sm;
  static const double cardTimerPaddingVertical = AppSpacing.xxs;

  static const double cardTagIconSize = AppSizes.iconXs;
  static const double cardTagFontSize = 11.0;
  static const double cardTagPaddingHorizontal = AppSpacing.sm;
  static const double cardTagPaddingVertical = AppSpacing.xxs;
  static const double cardTagCornerRadius = AppRadius.pill;

  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: cardPaddingHorizontal,
    vertical: cardPaddingVertical,
  );

  static const EdgeInsets cardRewardPillPadding = EdgeInsets.symmetric(
    horizontal: cardRewardPillPaddingHorizontal,
    vertical: cardRewardPillPaddingVertical,
  );

  static const EdgeInsets cardTimerPadding = EdgeInsets.symmetric(
    horizontal: cardTimerPaddingHorizontal,
    vertical: cardTimerPaddingVertical,
  );

  static const EdgeInsets cardTagPadding = EdgeInsets.symmetric(
    horizontal: cardTagPaddingHorizontal,
    vertical: cardTagPaddingVertical,
  );

  static const Offset cardShadowOffset = Offset(0, cardShadowOffsetY);

  // ----- Rewards ------------------------------------------------------------
  static const double rewardCoinSizeCompact = 24.0;
  static const double rewardCoinSizeStandard = 44.0;
  static const double rewardCoinSizeLarge = 72.0;
  static const double rewardCoinBorderWidth = 2.0;
  static const double rewardCoinSparkleSize = 12.0;
  static const double rewardCoinDetailLabelFontSize = 12.0;
  static const double rewardCoinRimInset = 4.0;
  static const double rewardCoinHighlightBlur = 6.0;

  static const double rewardXpOrbSizeCompact = 24.0;
  static const double rewardXpOrbSizeStandard = 44.0;
  static const double rewardXpOrbSizeLarge = 72.0;
  static const double rewardXpHaloExpand = 1.35;
  static const double rewardXpCoreRatio = 0.55;
  static const double rewardXpDetailLabelFontSize = 12.0;
  static const double rewardXpLevelBadgeFontSize = 11.0;

  static const double rewardChestSizeCompact = 56.0;
  static const double rewardChestSizeStandard = 96.0;
  static const double rewardChestSizeLarge = 132.0;
  static const double rewardChestLidRatio = 0.42;
  static const double rewardChestBandHeight = 6.0;
  static const double rewardChestLockSize = 12.0;
  static const double rewardChestLightBeamWidth = 28.0;
  static const double rewardChestTopInset = 6.0;
  static const double rewardChestGlowBlur = AppBlurs.xxl;
  static const double rewardChestWoodStrokeWidth = AppStrokes.thin;
  static const double rewardChestLockCornerRadius = 2.0;
  static const double rewardChestShadowBlur = 10.0;
  static const double rewardChestBodyLeftInsetRatio = 0.06;
  static const double rewardChestBodyRightInsetRatio = 0.94;
  static const double rewardChestBodyBottomRatio = 0.92;
  static const double rewardChestBodyBandRatio = 0.40;
  static const double rewardChestLidBandRatio = 0.20;
  static const double rewardChestLidBottomInsetRatio = 0.15;
  static const double rewardChestLockWidthRatio = 1.4;
  static const double rewardChestKeyWidthRatio = 0.3;
  static const double rewardChestKeyHeightRatio = 0.8;
  static const double rewardChestKeyVerticalOffsetRatio = 0.6;
  static const double rewardChestShadowWidthRatio = 0.78;
  static const double rewardChestShadowHeightRatio = 0.10;
  static const double rewardChestShadowCenterRatio = 0.96;
  static const double rewardChestBeamHeightRatio = 0.60;
  static const double rewardChestBeamTopWidthRatio = 0.40;
  static const double rewardChestBeamStart = 0.55;
  static const double rewardChestBeamMaxOpacity = 0.85;
  static const double rewardChestOpeningSparkleStart = 0.05;
  static const double rewardChestOpeningSparkleEnd = 0.90;
  static const double rewardChestOpenedSparkleThreshold = 0.99;
  static const double rewardChestSparkleScaleStart = 0.60;
  static const double rewardChestSparkleScaleAmplitude = 0.40;
  static const double rewardChestSparkleLiftRatio = 0.45;
  static const double rewardChestSparkleSizeRatio = 0.10;
  static const double rewardChestSparkleFieldExpand = 1.20;
  static const double rewardChestSparkleSpreadHorizontalRatio = 0.30;
  static const double rewardChestSparkleSpreadVerticalRatio = 0.10;
  static const double rewardChestSparkleOffsetTopRatio = 0.05;
  static const double rewardChestSparkleOffsetOuterRightRatio = 0.32;
  static const double rewardChestSparkleOffsetCenterHorizontalRatio = 0.05;
  static const double rewardChestSparkleOffsetCenterTopRatio = 0.18;
  static const double rewardChestSparkleOffsetInnerRightRatio = 0.20;
  static const double rewardChestSparkleDelayStep = 0.15;
  static const double rewardChestGlowExpand = 1.60;
  static const double rewardChestGlowInnerAlpha = 0.45;
  static const double rewardChestLockedDimAlpha = 0.45;
  static const double rewardChestLockBadgeIconSizeRatio = 0.18;
  static const double rewardChestLockBadgeOffsetRightRatio = 0.10;
  static const double rewardChestLockBadgeOffsetTopRatio = 0.10;
  static const double rewardChestLockBadgePadding = AppSpacing.xs;
  static const double rewardChestLockBadgeBorderWidth = AppSizes.borderThin;

  static const double rewardPopupMaxWidth = 420.0;
  static const double rewardPopupMinHeight = 200.0;
  static const double rewardPopupMaxHeight = 480.0;
  static const double rewardPopupCornerRadius = 28.0;
  static const double rewardPopupShadowBlur = 28.0;
  static const double rewardPopupShadowOffsetY = 8.0;
  static const double rewardPopupTitleFontSize = 24.0;
  static const double rewardPopupSubtitleFontSize = 14.0;
  static const double rewardPopupCtaHeight = 48.0;
  static const double rewardPopupCtaRadius = 14.0;
  static const double rewardPopupCtaFontSize = 16.0;
  static const double rewardPopupListMaxHeight = 220.0;
  static const double rewardPopupBadgeFontSize = 11.0;
  static const double rewardPopupBadgeHeight = 24.0;
  static const double rewardPopupBadgeRadius = AppRadius.pill;
  static const double rewardPopupGap = AppSpacing.xl;
  static const double rewardPopupActionGap = AppSpacing.md;
  static const double rewardPopupInsetHorizontal = AppSpacing.lg;
  static const double rewardPopupInsetVertical = AppSpacing.lg;

  static const EdgeInsets rewardPopupPadding = EdgeInsets.symmetric(
    horizontal: rewardPopupInsetHorizontal,
    vertical: rewardPopupInsetVertical,
  );

  static const EdgeInsets rewardPopupCtaPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
  );

  static const EdgeInsets rewardPopupBadgePadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
    vertical: AppSpacing.xxs,
  );

  static const double rewardPopupResponsiveScaleMobile = 1.0;
  static const double rewardPopupResponsiveScaleTablet = 1.0;
  static const double rewardPopupResponsiveScaleDesktop = 1.1;

  static const double rewardPopupShadowSpread = 1.0;
  static const double rewardPopupTitleLineHeight = 1.15;
  static const double rewardPopupSubtitleLineHeight = 1.35;
  static const double rewardPopupBadgeLetterSpacing = 0.7;
  static const double rewardPopupCtaLetterSpacing = 0.4;
  static const double rewardPopupBadgeGlowBlur = 10.0;
  static const double rewardPopupBadgeGlowSpread = 1.0;
  static const double rewardPopupCtaShadowBlur = 14.0;
  static const double rewardPopupCtaShadowSpread = 1.0;

  // ----- Map ----------------------------------------------------------------
  static const double mapSkyStartY = 0.0;
  static const double mapSkyEndY = 0.62;
  static const double mapGroundStartY = 0.62;
  static const double mapGroundEndY = 1.0;

  static const double mapMountainBackWidth = 360.0;
  static const double mapMountainBackHeight = 220.0;
  static const double mapMountainMidWidth = 320.0;
  static const double mapMountainMidHeight = 200.0;
  static const double mapMountainFrontWidth = 280.0;
  static const double mapMountainFrontHeight = 180.0;

  static const double mapMountainParallaxBack = 0.20;
  static const double mapMountainParallaxMid = 0.40;
  static const double mapMountainParallaxFront = 0.60;

  static const double mapStrokeWidthCompleted = AppStrokes.heavy;
  static const double mapStrokeWidthActive = AppStrokes.heavy;
  static const double mapStrokeWidthDashed = AppStrokes.thick;
  static const double mapStrokeWidthFuture = AppStrokes.medium;

  static const double mapPathGlowBlur = AppBlurs.lg;
  static const double mapPathGlowSpread = 1.0;

  static const double roadStrokeWidth = 6.0;
  static const double roadStrokeWidthLocked = 4.0;
  static const double roadShadowBlur = AppBlurs.md;
  static const double roadShadowSpread = 1.0;
  static const double roadHighlightInset = 1.0;
  static const double roadHighlightThickness = 1.5;
  static const double roadTravelHighlightStroke = 2.5;
  static const double roadSparkTrailLength = 0.45;
  static const double roadSparkTrailStroke = 2.0;
  static const double roadTravelHeadRadius = 4.0;
  static const double roadActiveGlowBlur = AppBlurs.lg;
  static const double roadCompletedGlowBlur = AppBlurs.md;
  static const double roadGlowExpand = 1.30;
  static const double roadGlowExpandActive = 1.40;
  static const double roadDashOffsetScale = 1.0;
  static const double roadSparkleDensity = 0.20;
  static const double roadShimmerBandRatio = 0.10;
  static const double roadShimmerBandAlpha = 0.55;

  static const double mapNodeGlowBlur = AppBlurs.xl;
  static const double mapNodeGlowSpread = 2.0;
  static const double mapNodeGlowRadiusScale = 1.45;

  static const double mapLegendCornerRadius = AppRadius.lg;
  static const double mapLegendBlurSigma = AppBlurs.lg;
  static const double mapLegendShadowBlur = AppBlurs.xl;
  static const double mapLegendShadowOffsetY = 6.0;
  static const double mapLegendIconSize = 20.0;
  static const double mapLegendTextFontSize = 12.0;
  static const double mapLegendTitleFontSize = 14.0;
  static const double mapLegendItemHeight = 36.0;
  static const double mapLegendItemPaddingHorizontal = AppSpacing.sm;
  static const double mapLegendItemPaddingVertical = AppSpacing.xs;
  static const double mapLegendItemRadius = AppRadius.md;
  static const double mapLegendItemGap = AppSpacing.xs;
  static const double mapLegendDotSize = 12.0;
  static const double mapLegendToggleSize = 44.0;

  static const double mapCameraDefaultZoom = 1.0;
  static const double mapCameraFocusZoom = 1.30;
  static const double mapCameraMinScale = 0.85;
  static const double mapCameraMaxScale = 2.20;
  static const double mapCameraBoundaryFactor = 1.20;
  static const double mapCameraSnapVelocityThreshold = 240.0;

  static const double mapInteractiveMaxScaleTablet = 1.60;
  static const double mapInteractiveMaxScaleDesktop = 2.00;
  static const double mapInteractiveMinScaleTablet = 0.90;
  static const double mapInteractiveMinScaleDesktop = 0.85;

  static const double mapTabletScale = 1.05;
  static const double mapDesktopScale = 1.10;

  static const EdgeInsets mapLegendPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  );

  static const EdgeInsets mapLegendItemPadding = EdgeInsets.symmetric(
    horizontal: mapLegendItemPaddingHorizontal,
    vertical: mapLegendItemPaddingVertical,
  );

  static const Offset mapLegendShadowOffset = Offset(0, mapLegendShadowOffsetY);

  // ----- Bottom sheets ------------------------------------------------------
  static const double bottomSheetCornerRadius = 24.0;
  static const double bottomSheetElevation = 8.0;
  static const double bottomSheetShadowBlur = 24.0;
  static const double bottomSheetShadowOffsetY = 6.0;

  static const double bottomSheetMinHeight = 240.0;
  static const double bottomSheetIdealHeight = 360.0;
  static const double bottomSheetMaxHeight = 540.0;
  static const double bottomSheetHeaderHeight = 200.0;

  static const double bottomSheetHandleWidth = 48.0;
  static const double bottomSheetHandleHeight = 4.0;
  static const double bottomSheetHandleRadius = 2.0;

  static const double bottomSheetPaddingHorizontal = 20.0;
  static const double bottomSheetPaddingVertical = 16.0;
  static const double bottomSheetHeaderGap = 16.0;
  static const double bottomSheetSectionGap = 16.0;
  static const double bottomSheetItemGap = 12.0;

  static const double bottomSheetActionHeight = 48.0;
  static const double bottomSheetActionGap = 12.0;
  static const double bottomSheetActionRadius = 12.0;

  static const double bottomSheetMobileMaxWidth = 480.0;
  static const double bottomSheetTabletMaxWidth = 560.0;
  static const double bottomSheetDesktopMaxWidth = 640.0;

  static const double bottomSheetStatTileHeight = 72.0;
  static const double bottomSheetStatTileRadius = 16.0;
  static const double bottomSheetStatTileIconSize = 28.0;
  static const double bottomSheetStatTilePaddingHorizontal = 14.0;
  static const double bottomSheetStatTilePaddingVertical = 12.0;
  static const double bottomSheetStatTileGap = 10.0;

  static const double bottomSheetProgressHeight = 8.0;
  static const double bottomSheetProgressRadius = 4.0;
  static const double bottomSheetProgressTrackAlpha = 0.12;

  static const double bottomSheetHeroHeight = 160.0;
  static const double bottomSheetHeroRadius = 20.0;

  static const double bottomSheetQuickActionHeight = 56.0;
  static const double bottomSheetQuickActionRadius = 16.0;
  static const double bottomSheetQuickActionIconSize = 22.0;

  static const double bottomSheetRarityBadgeHeight = 28.0;
  static const double bottomSheetRarityBadgeRadius = 14.0;
  static const double bottomSheetRarityBadgeIconSize = 16.0;
  static const double bottomSheetRarityBadgePaddingHorizontal = 10.0;

  static const double bottomSheetUnlockedTileSize = 72.0;
  static const double bottomSheetUnlockedTileRadius = 16.0;
  static const double bottomSheetUnlockedTileIconSize = 28.0;

  static const double bottomSheetBorderWidth = 1.0;
  static const double bottomSheetDividerHeight = 1.0;

  static const double bottomSheetSectionStaggerCap = 5.0;

  // ----- Progression widgets -------------------------------------------------
  static const double progressPathSegmentHeight = 6.0;
  static const double progressPathSegmentRadius = AppRadius.pill;
  static const double progressPathSegmentGap = AppSpacing.xs;
  static const double progressPathMinWidth = 240.0;
  static const double progressPathMaxWidth = 480.0;
  static const double progressPathMinHeight = 48.0;
  static const double progressPathLabelGap = AppSpacing.xs;
  static const double progressPathLabelFontSize = 12.0;
  static const double progressPathMilestoneFontSize = 14.0;
  static const double progressPathPercentFontSize = 13.0;
  static const double progressPathPulseBlur = AppBlurs.md;

  static const double levelCardMinHeight = AppSizes.cardMinHeight;
  static const double levelCardMaxWidth = 420.0;
  static const double levelCardMinWidth = 280.0;
  static const double levelCardPaddingHorizontal = AppSpacing.lg;
  static const double levelCardPaddingVertical = AppSpacing.md;
  static const double levelCardCornerRadius = AppRadius.lg;
  static const double levelCardInnerCornerRadius = AppRadius.md;
  static const double levelCardShadowBlur = 18.0;
  static const double levelCardShadowOffsetY = 6.0;
  static const double levelCardPremiumShadowBlur = AppBlurs.xxl;
  static const double levelCardPremiumShadowSpread = 2.0;
  static const double levelCardTitleFontSize = 18.0;
  static const double levelCardSubtitleFontSize = 13.0;
  static const double levelCardProgressHeight = 8.0;
  static const double levelCardProgressRadius = AppRadius.pill;
  static const double levelCardIconSize = AppSizes.iconMd;
  static const double levelCardDifficultyDotSize = 8.0;
  static const double levelCardDifficultyDotGap = AppSpacing.xxs;
  static const double levelCardRewardPillHeight = 26.0;
  static const double levelCardRewardPillIconSize = AppSizes.iconXs;
  static const double levelCardRewardPillFontSize = 12.0;
  static const double levelCardTimerFontSize = 12.0;
  static const double levelCardTagFontSize = 11.0;
  static const double levelCardPressScale = 0.98;
  static const double levelCardHoverScale = 1.02;
  static const double levelCardGlowBlur = AppBlurs.md;
  static const double levelCardPremiumGlowBlur = AppBlurs.lg;
  static const double levelCardTabletScale = 1.05;
  static const double levelCardDesktopScale = 1.08;

  static const double challengeTileMinHeight = 72.0;
  static const double challengeTileMaxWidth = 360.0;
  static const double challengeTilePaddingHorizontal = AppSpacing.md;
  static const double challengeTilePaddingVertical = AppSpacing.sm;
  static const double challengeTileCornerRadius = AppRadius.md;
  static const double challengeTileShadowBlur = 10.0;
  static const double challengeTileShadowOffsetY = 3.0;
  static const double challengeTileIconSize = AppSizes.iconMd;
  static const double challengeTileTitleFontSize = 15.0;
  static const double challengeTileSubtitleFontSize = 12.0;
  static const double challengeTileRewardFontSize = 12.0;
  static const double challengeTileDifficultyDotSize = 6.0;
  static const double challengeTileDifficultyDotGap = AppSpacing.xxs;
  static const double challengeTileLeadingGap = AppSpacing.md;
  static const double challengeTileRewardGap = AppSpacing.sm;
  static const double challengeTilePressScale = 0.97;
  static const double challengeTileHoverScale = 1.02;
  static const double challengeTileHighlightBlur = AppBlurs.sm;

  static const double bossGateWidth = 240.0;
  static const double bossGateHeight = 180.0;
  static const double bossGatePillarWidth = 36.0;
  static const double bossGateArchRadius = 96.0;
  static const double bossGateLockSize = 36.0;
  static const double bossGateChainLength = 36.0;
  static const double bossGateChainStrokeWidth = AppStrokes.regular;
  static const double bossGateGlowBlur = AppBlurs.xxl;
  static const double bossGateGlowSpread = 2.0;
  static const double bossGateShadowBlur = AppBlurs.xl;
  static const double bossGateShadowOffsetY = 8.0;
  static const double bossGateShakeAmplitude = 6.0;
  static const double bossGateTabletScale = 1.10;
  static const double bossGateDesktopScale = 1.20;

  static const double lockedLevelWidth = 240.0;
  static const double lockedLevelHeight = 72.0;
  static const double lockedLevelIconSize = AppSizes.iconMd;
  static const double lockedLevelPaddingHorizontal = AppSpacing.md;
  static const double lockedLevelPaddingVertical = AppSpacing.sm;
  static const double lockedLevelCornerRadius = AppRadius.md;
  static const double lockedLevelShimmerBlur = AppBlurs.sm;
  static const double lockedLevelShimmerHeight = 1.5;
  static const double lockedLevelRequirementFontSize = 12.0;
  static const double lockedLevelIconOffset = AppSpacing.xs;

  static const double levelRewardDialogMaxWidth = 420.0;
  static const double levelRewardDialogMinHeight = 240.0;
  static const double levelRewardDialogCornerRadius = 28.0;
  static const double levelRewardDialogShadowBlur = 28.0;
  static const double levelRewardDialogShadowOffsetY = 10.0;
  static const double levelRewardDialogPaddingHorizontal = AppSpacing.xl;
  static const double levelRewardDialogPaddingVertical = AppSpacing.xl;
  static const double levelRewardDialogTitleFontSize = 24.0;
  static const double levelRewardDialogSubtitleFontSize = 14.0;
  static const double levelRewardDialogChestSize = 132.0;
  static const double levelRewardDialogChestOffsetY = AppSpacing.lg;
  static const double levelRewardDialogOrbSize = 56.0;
  static const double levelRewardDialogOrbGap = AppSpacing.md;
  static const double levelRewardDialogCtaHeight = 52.0;
  static const double levelRewardDialogCtaRadius = 16.0;
  static const double levelRewardDialogCtaFontSize = 16.0;
  static const double levelRewardDialogParticleRadius = 80.0;
  static const double levelRewardDialogParticleMinSize = 4.0;
  static const double levelRewardDialogParticleMaxSize = 8.0;
  static const double levelRewardDialogScrimAlpha = 0.58;
  static const double levelRewardDialogTabletScale = 1.05;
  static const double levelRewardDialogDesktopScale = 1.10;
  static const double levelRewardDialogResponsiveMobileWidth = 360.0;
  static const double levelRewardDialogResponsiveTabletWidth = 480.0;
  static const double levelRewardDialogResponsiveDesktopWidth = 560.0;
  static const double levelRewardDialogFloatUpDistance = 60.0;

  static const EdgeInsets levelCardPadding = EdgeInsets.symmetric(
    horizontal: levelCardPaddingHorizontal,
    vertical: levelCardPaddingVertical,
  );

  static const EdgeInsets challengeTilePadding = EdgeInsets.symmetric(
    horizontal: challengeTilePaddingHorizontal,
    vertical: challengeTilePaddingVertical,
  );

  static const EdgeInsets lockedLevelPadding = EdgeInsets.symmetric(
    horizontal: lockedLevelPaddingHorizontal,
    vertical: lockedLevelPaddingVertical,
  );

  static const EdgeInsets levelRewardDialogPadding = EdgeInsets.symmetric(
    horizontal: levelRewardDialogPaddingHorizontal,
    vertical: levelRewardDialogPaddingVertical,
  );

  static const Offset levelCardShadowOffset = Offset(0, levelCardShadowOffsetY);

  static const Offset challengeTileShadowOffset = Offset(
    0,
    challengeTileShadowOffsetY,
  );

  static const Offset bossGateShadowOffset = Offset(0, bossGateShadowOffsetY);

  static const Offset levelRewardDialogShadowOffset = Offset(
    0,
    levelRewardDialogShadowOffsetY,
  );

  // ---------------------------------------------------------------------------
  // Playground screen stage
  // ---------------------------------------------------------------------------

  static const double mapWorldWidth = 360.0;
  static const double mapWorldHeight = 820.0;
  static const double mapWorldFocusY = 320.0;
  static const double mapParallaxMobile = 0.0;
  static const double mapParallaxTablet = 0.12;
  static const double mapParallaxDesktop = 0.20;

  // ---------------------------------------------------------------------------
  // World layout engine
  // ---------------------------------------------------------------------------

  static const double worldStepRegular = 132.0;
  static const double worldStepBoss = 240.0;
  static const double worldStepReward = 168.0;
  static const double worldStepMilestone = 196.0;
  static const double worldTopPadding = 96.0;
  static const double worldBottomPadding = 220.0;
  static const double worldCurveAmplitude = 90.0;
  static const double worldCurveJitter = 36.0;
  static const double worldNodeSway = 24.0;
  static const double worldDecorationRadius = 110.0;
  static const double worldMountainEdgeOffset = 12.0;
  static const double worldCloudBandStart = 0.0;
  static const double worldCloudBandEnd = 320.0;
}
