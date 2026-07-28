import 'widget_builder_selection.dart';

/// Pure data class representing the state of the Widget Builder.
class WidgetBuilderState {
  const WidgetBuilderState({
    this.selection = WidgetBuilderSelection.primaryButton,
    this.label = 'Hello, Prep Quest',
    this.subtitle = 'Top navigation preview',
    this.showLeading = true,
    this.showAccentStripe = true,
    this.loadingTitle = 'Please Wait',
    this.loadingSubtitle = 'Fetching latest data...',
    this.showLoadingProgress = true,
    this.loadingProgressValue = 0.65,
    this.loaderType = 'lottie',
    this.badgeLabel = 'PREMIUM',
    this.showBadgeIcon = true,
    this.badgeStyle = 'gradient',
    this.enableBadgeAnimation = true,
    this.buttonText = 'Action Button',
    this.isButtonEnabled = true,
    this.isButtonLoading = false,
    this.buttonVariant = 'filled',
    this.buttonSize = 'medium',
    this.buttonShape = 'rounded',
    this.showButtonLeadingIcon = false,
    this.showButtonTrailingIcon = false,
    this.isButtonFullWidth = false,
    this.avatarSize = 80.0,
    this.avatarInitials = 'AY',
    this.isAvatarOnline = true,
    this.showAvatarPremium = true,
    this.showAvatarVerified = false,
    this.showAvatarEdit = false,
    this.simulatedDevice = 'mobile',
    this.isSimulatedLandscape = false,
    this.secButtonText = 'Secondary Action',
    this.isSecButtonEnabled = true,
    this.isSecButtonLoading = false,
    this.secButtonVariant = 'outlined',
    this.secButtonSize = 'medium',
    this.secButtonShape = 'rounded',
    this.showSecButtonLeadingIcon = false,
    this.showSecButtonTrailingIcon = false,
    this.isSecButtonFullWidth = false,
    this.chipLabel = 'Active',
    this.chipStatus = 'success',
    this.chipVariant = 'soft',
    this.chipSize = 'medium',
    this.showChipIcon = true,
    this.enableChipAnimation = true,
    this.currentStreakValue = 12,
    this.longestStreakValue = 45,
    this.streakProgressValue = 0.75,
    this.showWeeklyStreak = true,
    this.showStreakReward = true,
    this.showStreakMilestone = true,
    this.enableStreakAnimation = true,
    this.tagLabel = 'Educational',
    this.tagVariant = 'soft',
    this.tagSize = 'medium',
    this.tagShape = 'pill',
    this.isTagSelected = false,
    this.isTagEnabled = true,
    this.isTagClosable = false,
    this.showTagLeadingIcon = true,
    this.showTagTrailingIcon = false,
    this.headerTitle = 'Section Title',
    this.headerSubtitle = 'Optional secondary information',
    this.showHeaderSubtitle = true,
    this.showHeaderLeading = true,
    this.showHeaderTrailing = true,
    this.showHeaderDivider = false,
    this.headerActionType = 'text',
    this.headerActionText = 'VIEW ALL',
    this.constantsSearchQuery = '',
    this.currentXPValue = 450,
    this.requiredXPValue = 1000,
    this.currentLevelValue = 12,
    this.nextLevelValue = 13,
    this.xpBarVariant = 'rounded',
    this.showXPPercentage = true,
    this.showLevelBadge = true,
    this.showXPText = true,
    this.showXPBarAnimation = true,
    this.showXPBarGlow = false,
    this.showXPBarIcon = true,
    this.xpBarProgressValue = 0.45,
    this.errorType = 'noInternet',
    this.showErrorIllustration = true,
    this.showErrorIcon = true,
    this.showErrorRetryButton = true,
    this.isErrorLoading = false,
    this.errorRetryText = 'RETRY',
    this.cardTitle = 'Action Card',
    this.cardSubtitle = 'Interact to see animations',
    this.cardAnimationType = 'scale',
    this.cardVariant = 'filled',
    this.enableCardHover = true,
    this.enableCardGlow = false,
    this.enableCardGlass = false,
    this.aiButtonVariant = 'filled',
    this.aiButtonSize = 'medium',
    this.aiButtonState = 'enabled',
    this.aiButtonAnimation = 'none',
    this.showAiIcon = true,
    this.aiBubbleRole = 'ai',
    this.aiBubbleStyle = 'glass',
    this.aiBubbleState = 'staticResponse',
    this.aiBubbleMessage =
        'Here is your tailored explanation with a neat summary, bullet points, and a quick code example.',
    this.aiBubbleLongMessage = false,
    this.aiBubbleShowHeader = true,
    this.aiBubbleShowFooter = true,
    this.aiBubbleShowVerified = true,
    this.aiBubbleTimestamp = 'just now',
    this.aiBubbleModelLabel = 'AI Tutor',
    this.aiBubbleStreaming = false,
    this.aiBubbleError = false,
    this.aiBubbleTyping = false,
    this.aiAvatarStatus = 'idle',
    this.aiAvatarSize = 96.0,
    this.aiAvatarSpeed = 'normal',
    this.aiAvatarIntensity = 'normal',
    this.aiAvatarGlowEnabled = true,
    this.aiAvatarHaloEnabled = true,
    this.aiAvatarParticlesEnabled = true,
    this.aiAvatarShadowEnabled = true,
    this.aiAvatarBorderWidth = 0.0,
    this.aiExpTitle = 'Complexity Analysis',
    this.aiExpSubtitle = 'Time & Space Complexity',
    this.aiExpBadgeLabel = 'AI INSIGHT',
    this.aiExpTone = 'insight',
    this.aiExpShowBadge = true,
    this.aiExpShowActions = true,
    this.aiExpExpanded = true,
    this.aiExpCanExpand = true,
    this.aiExpLongContent = false,
    this.aiHintTitle = 'Exam Strategy',
    this.aiHintText =
        'Eliminate two obviously incorrect options to increase your success rate to 50%.',
    this.aiHintType = 'examStrategy',
    this.aiHintDifficulty = 'intermediate',
    this.aiHintTopic = 'Multiple Choice Techniques',
    this.aiHintQuickTip = 'Always read all options before selecting one.',
    this.aiHintShowBadge = true,
    this.aiHintShowActions = true,
    this.aiHintIsBookmarked = false,
    this.aiHintBadgeText,
    this.aiHistoryHeaderTitle = 'AI History',
    this.aiHistoryHeaderSubtitle = 'Recent tutor sessions',
    this.aiHistoryState = 'ready',
    this.aiHistoryShowCategory = true,
    this.aiHistoryShowTimestamp = true,
    this.aiHistoryShowPremiumBadge = true,
    this.aiHistoryShowFavorite = true,
    this.aiHistoryShowPinned = true,
    this.aiHistoryShowLeadingChevron = true,
    this.aiHistoryShowHeader = true,
    this.aiHistoryShowViewAll = true,
    this.aiHistoryLoadingItemCount = 4,
    this.aiHistoryTileTitle = 'B-Tree insertions',
    this.aiHistoryTilePreview =
        'A B-Tree of minimum degree `t=2` maintains sorted data and supports search, insert, and delete in logarithmic time.',
    this.aiHistoryTileTimestamp = '2 min ago',
    this.aiHistoryTileSubtitle = 'Data Structures',
    this.aiHistoryTileCategory = 'Tutor',
    this.aiHistoryTileEntryType = 'tutor',
    this.aiHistoryTileBrightness = 'auto',
    this.aiHistoryTileShowCategory = true,
    this.aiHistoryTileShowTimestamp = true,
    this.aiHistoryTileShowPremiumBadge = true,
    this.aiHistoryTileShowFavorite = true,
    this.aiHistoryTileShowPinned = true,
    this.aiHistoryTileShowLeadingChevron = true,
    this.aiHistoryTileDense = false,
    this.aiHistoryTileIsFavorite = true,
    this.aiHistoryTileIsPinned = true,
    this.aiHistoryTileIsPremium = false,
    this.aiHistoryTileIsUnread = true,
    this.aiLoadingCardBrightness = 'auto',
    this.aiLoadingCardBodyLineCount = 3,
    this.aiLoadingCardElevation = 0,
    this.aiLoadingCardAnimationEnabled = true,
    this.aiLoadingCardShowAvatar = true,
    this.aiLoadingCardShowTitle = true,
    this.aiLoadingCardShowSubtitle = true,
    this.aiLoadingCardShowBody = true,
    this.aiLoadingCardShowFooter = false,
    this.aiLoadingCardSemanticLabel,
    this.aiResponseTitle = 'AI Tutor',
    this.aiResponseSubtitle = 'Personalised explanation',
    this.aiResponseType = 'generic',
    this.aiResponseBadgeLabel = '',
    this.aiResponseBody =
        'Photosynthesis converts light energy into chemical energy. Chlorophyll absorbs red and blue light most efficiently, while green light is reflected — which is why most plants look green to us.',
    this.aiResponseMarkdown = false,
    this.aiResponseSelectable = false,
    this.aiResponseShowBadge = true,
    this.aiResponseShowMetadata = true,
    this.aiResponseShowActions = true,
    this.aiResponseMetadataModel = 'GPT-4o',
    this.aiResponseMetadataTimestamp = 'just now',
    this.aiResponseMetadataCategory = 'Biology',
    this.aiResponseMetadataConfidence = 'high',
    this.aiResponseMetadataStatus = 'delivered',
    this.aiResponseActionCopy = true,
    this.aiResponseActionShare = true,
    this.aiResponseActionRegenerate = true,
    this.aiResponseActionFavorite = true,
    this.aiResponseActionLike = true,
    this.aiResponseActionDislike = true,
    this.aiResponseActionFavoriteActive = false,
    this.aiResponseActionLikeActive = false,
    this.aiResponseActionDislikeActive = false,
    this.aiResponseCanExpand = false,
    this.aiResponseExpanded = false,
    this.playgroundNodeRingKind = 'gradient',
    this.playgroundNodeRingState = 'unlocked',
    this.playgroundNodeDiameter = 96.0,
    this.playgroundNodeIconKind = 'regular',
    this.playgroundNodeIconVariant = 'filled',
    this.playgroundNodeProgress = 0.42,
    this.playgroundNodeProgressState = 'partial',
    this.playgroundNodeTitle = 'Algebra Foundations',
    this.playgroundNodeSubtitle = '12 of 28 mastered',
    this.playgroundNodeShowProgress = true,
    this.playgroundNodeShowLabel = true,
    this.playgroundNodeShowBadge = true,
    this.playgroundNodeBadgeKind = 'xp',
    this.playgroundNodeLabelPlacement = 'below',
    this.playgroundNodeLabelEmphasis = 'normal',
    this.playgroundNodeIsInteractive = true,
    this.playgroundNodeBrightness = 'sideBySide',
    this.nodeRingState = 'unlocked',
    this.nodeRingKind = 'gradient',
    this.nodeRingDiameter = 96.0,
    this.nodeRingStrokeWidth = 4.0,
    this.nodeRingGlow = true,
    this.nodeRingIsAnimated = false,
    this.nodeRingBrightness = 'sideBySide',
    this.nodeIconKind = 'regular',
    this.nodeIconVariant = 'filled',
    this.nodeIconSize = 28.0,
    this.nodeIconIsEnabled = true,
    this.nodeIconBrightness = 'sideBySide',
    this.nodeBadgeKind = 'xp',
    this.nodeBadgeSize = 28.0,
    this.nodeBadgeOffset = 6.0,
    this.nodeBadgeBrightness = 'sideBySide',
    this.nodeLabelTitle = 'Algebra Foundations',
    this.nodeLabelSubtitle = '12 of 28 mastered',
    this.nodeLabelPlacement = 'below',
    this.nodeLabelEmphasis = 'normal',
    this.nodeLabelMaxWidth = 140.0,
    this.nodeLabelIsVisible = true,
    this.nodeLabelBrightness = 'sideBySide',
    this.nodeProgressValue = 0.42,
    this.nodeProgressState = 'partial',
    this.nodeProgressDiameter = 64.0,
    this.nodeProgressStrokeWidth = 4.0,
    this.nodeProgressShowLabel = true,
    this.nodeProgressCompletedLabel = 'Complete',
    this.nodeProgressBrightness = 'sideBySide',
    this.treeKind = 'oak',
    this.treeScale = 1.0,
    this.treeSway = true,
    this.treeSwaySeed = 0,
    this.treeBrightness = 'sideBySide',
    this.bushKind = 'round',
    this.bushScale = 1.0,
    this.bushSway = true,
    this.bushSwaySeed = 0,
    this.bushBrightness = 'sideBySide',
    this.cloudKind = 'fluffy',
    this.cloudScale = 1.0,
    this.cloudSeed = 0,
    this.cloudBrightness = 'sideBySide',
    this.mountainLayer = 'mid',
    this.mountainKind = 'rocky',
    this.mountainScale = 1.0,
    this.mountainBrightness = 'sideBySide',
    this.riverCurve = 'straight',
    this.riverHeight = 80.0,
    this.riverSeed = 0,
    this.riverBrightness = 'sideBySide',
    this.bridgeVariant = 'wooden',
    this.bridgeScale = 1.0,
    this.bridgeBrightness = 'sideBySide',
    this.pathBrightness = 'sideBySide',
    this.flagColor = 'red',
    this.flagScale = 1.0,
    this.flagBrightness = 'sideBySide',
    this.particlesKind = 'ambient',
    this.particlesCount = 12,
    this.particlesSeed = 7,
    this.particlesBrightness = 'sideBySide',
    this.particleLayerCount = 18,
    this.particleLayerSeed = 11,
    this.particleLayerBrightness = 'sideBySide',
    this.playgroundBuildingState = 'unlocked',
    this.playgroundBuildingTitle = 'Knowledge Hub',
    this.playgroundBuildingSubtitle = 'Tap to explore',
    this.playgroundBuildingProgress = 0.45,
    this.playgroundBuildingLevel = 1,
    this.playgroundBuildingIsInteractive = true,
    this.playgroundBuildingShowLabel = true,
    this.playgroundBuildingShowProgress = true,
    this.playgroundBuildingLabelPlacement = 'below',
    this.playgroundBuildingLabelEmphasis = 'normal',
    this.playgroundBuildingProgressKind = 'percent',
    this.playgroundBuildingScale = 1.0,
    this.playgroundBuildingBrightness = 'sideBySide',
    this.academyBuildingState = 'unlocked',
    this.academyBuildingProgress = 0.45,
    this.academyBuildingLevel = 1,
    this.academyBuildingShowLabel = true,
    this.academyBuildingShowProgress = true,
    this.academyBuildingLabelPlacement = 'below',
    this.academyBuildingLabelEmphasis = 'normal',
    this.academyBuildingProgressKind = 'percent',
    this.academyBuildingScale = 1.0,
    this.academyBuildingBrightness = 'sideBySide',
    this.libraryBuildingState = 'unlocked',
    this.libraryBuildingProgress = 0.45,
    this.libraryBuildingLevel = 1,
    this.libraryBuildingShowLabel = true,
    this.libraryBuildingShowProgress = true,
    this.libraryBuildingLabelPlacement = 'below',
    this.libraryBuildingLabelEmphasis = 'normal',
    this.libraryBuildingProgressKind = 'percent',
    this.libraryBuildingScale = 1.0,
    this.libraryBuildingBrightness = 'sideBySide',
    this.buildingLabelTitle = 'Algebra Foundations',
    this.buildingLabelSubtitle = 'Theory & lessons',
    this.buildingLabelPlacement = 'below',
    this.buildingLabelEmphasis = 'normal',
    this.buildingLabelMaxWidth = 160.0,
    this.buildingLabelIsVisible = true,
    this.buildingLabelBrightness = 'sideBySide',
    this.buildingProgressValue = 0.45,
    this.buildingProgressKind = 'percent',
    this.buildingProgressLevel = 1,
    this.buildingProgressSize = 56.0,
    this.buildingProgressBrightness = 'sideBySide',
    this.playgroundProfileSummaryDisplayName = 'Aarav Khan',
    this.playgroundProfileSummaryLevel = 14,
    this.playgroundProfileSummaryInitials = 'AK',
    this.playgroundProfileSummaryIsOnline = true,
    this.playgroundProfileSummaryIsPremium = false,
    this.playgroundProfileSummaryNotificationCount = 3,
    this.playgroundProfileSummaryLeagueName = 'Sapphire League',
    this.playgroundProfileSummaryBrightness = 'sideBySide',
    this.playgroundXpIndicatorTotalXp = 4720,
    this.playgroundXpIndicatorUserLevel = 14,
    this.playgroundXpIndicatorXpInLevel = 220,
    this.playgroundXpIndicatorXpForNextLevel = 500,
    this.playgroundXpIndicatorGainDelta = 0,
    this.playgroundXpIndicatorIsAnimatingGain = false,
    this.playgroundCoinCounterBalance = 1840,
    this.playgroundCoinCounterGainDelta = 0,
    this.playgroundCoinCounterIsAnimatingGain = false,
    this.playgroundEnergyIndicatorRemaining = 4,
    this.playgroundEnergyIndicatorMax = 5,
    this.playgroundEnergyIndicatorRechargeSeconds = 1800,
    this.playgroundEnergyIndicatorIsAnimatingRefill = false,
    this.playgroundStreakCardDays = 27,
    this.playgroundStreakCardIsAtRisk = false,
    this.playgroundStreakCardMilestoneReached = false,
    this.playgroundTopBarBrightness = 'sideBySide',
    this.playgroundLevelProgressCardLevel = 14,
    this.playgroundLevelProgressCardTotalStages = 6,
    this.playgroundLevelProgressCardCompletedStages = 2,
    this.playgroundLevelProgressCardTotalStars = 3,
    this.playgroundLevelProgressCardEarnedStars = 1,
    this.playgroundLevelProgressCardCurrentXP = 220,
    this.playgroundLevelProgressCardRequiredXP = 500,
    this.playgroundLevelProgressCardTitle = 'Ancient Civilizations',
    this.playgroundLevelProgressCardSubtitle =
        'Earn XP to reach the next stage',
    this.playgroundLevelProgressCardState = 'current',
    this.playgroundLevelProgressCardRewardKind = 'xp',
    this.playgroundLevelProgressCardRewardAmount = 250,
    this.playgroundLevelProgressCardBrightness = 'sideBySide',
    this.playgroundMissionCardTitle = 'Solve 5 Daily Quizzes',
    this.playgroundMissionCardDescription =
        'Answer 5 daily quiz questions to claim your reward.',
    this.playgroundMissionCardRequired = 5,
    this.playgroundMissionCardProgress = 3,
    this.playgroundMissionCardState = 'active',
    this.playgroundMissionCardTag = 'daily',
    this.playgroundMissionCardRewardKind = 'xp',
    this.playgroundMissionCardRewardAmount = 150,
    this.playgroundMissionCardTimerSeconds = 5400,
    this.playgroundMissionCardBrightness = 'sideBySide',
    this.playgroundCoinRewardAmount = 2500,
    this.playgroundCoinRewardSize = 'standard',
    this.playgroundCoinRewardLayout = 'detailed',
    this.playgroundCoinRewardLabel = 'Daily Coins',
    this.playgroundCoinRewardIsDark = false,
    this.playgroundCoinRewardRarity = 'epic',
    this.playgroundCoinRewardShowGlow = true,
    this.playgroundCoinRewardShowSparkle = true,
    this.playgroundCoinRewardIsAnimating = true,
    this.playgroundCoinRewardBrightness = 'sideBySide',
    this.playgroundXpRewardAmount = 1200,
    this.playgroundXpRewardSize = 'standard',
    this.playgroundXpRewardLayout = 'detailed',
    this.playgroundXpRewardLabel = 'Quest Complete',
    this.playgroundXpRewardIsDark = false,
    this.playgroundXpRewardRarity = 'rare',
    this.playgroundXpRewardShowGlow = true,
    this.playgroundXpRewardShowSparkle = true,
    this.playgroundXpRewardIsAnimating = true,
    this.playgroundXpRewardIsLevelUp = true,
    this.playgroundXpRewardBrightness = 'sideBySide',
    this.playgroundRewardChestState = 'closed',
    this.playgroundRewardChestSize = 'standard',
    this.playgroundRewardChestIsDark = false,
    this.playgroundRewardChestRarity = 'legendary',
    this.playgroundRewardChestShowGlow = true,
    this.playgroundRewardChestAutoOpen = false,
    this.playgroundRewardChestBrightness = 'sideBySide',
    this.playgroundRewardPopupTitle = 'Quest Complete!',
    this.playgroundRewardPopupSubtitle = 'You earned amazing rewards.',
    this.playgroundRewardPopupPrimaryLabel = 'Claim All',
    this.playgroundRewardPopupSecondaryLabel = 'Save for Later',
    this.playgroundRewardPopupIsDark = false,
    this.playgroundRewardPopupRarity = 'epic',
    this.playgroundRewardPopupChestState = 'closed',
    this.playgroundRewardPopupAutoOpenChest = true,
    this.playgroundRewardPopupEntryCount = 3,
    this.playgroundRewardPopupBrightness = 'sideBySide',
    this.playgroundRewardPopupEntry1Kind = 'xp',
    this.playgroundRewardPopupEntry1Amount = 1500,
    this.playgroundRewardPopupEntry1Label = 'Quest XP',
    this.playgroundRewardPopupEntry1Rarity = 'rare',
    this.playgroundRewardPopupEntry2Kind = 'coin',
    this.playgroundRewardPopupEntry2Amount = 750,
    this.playgroundRewardPopupEntry2Label = 'Gold Coins',
    this.playgroundRewardPopupEntry2Rarity = 'epic',
    this.playgroundRewardPopupEntry3Kind = 'badge',
    this.playgroundRewardPopupEntry3Amount = 1,
    this.playgroundRewardPopupEntry3Label = 'Champion Badge',
    this.playgroundRewardPopupEntry3Rarity = 'legendary',
    this.playgroundRewardPopupEntry4Kind = 'custom',
    this.playgroundRewardPopupEntry4Amount = 1,
    this.playgroundRewardPopupEntry4Label = 'Mystery Glyph',
    this.playgroundRewardPopupEntry4Rarity = 'rare',
    this.playgroundBackgroundBiome = 'meadow',
    this.playgroundBackgroundParallaxOffset = 0.0,
    this.playgroundBackgroundBrightness = 'sideBySide',
    this.playgroundCameraZoom = 1.0,
    this.playgroundCameraFocusTarget = 'center',
    this.playgroundCameraBrightness = 'sideBySide',
    this.playgroundLegendTitle = 'Map Legend',
    this.playgroundLegendBrightness = 'sideBySide',
    this.playgroundScrollViewZoom = 1.0,
    this.playgroundScrollViewFocusTarget = 'none',
    this.playgroundScrollViewBrightness = 'sideBySide',
    this.playgroundMapBiome = 'meadow',
    this.playgroundMapShowLegend = true,
    this.playgroundMapFocusTarget = 'none',
    this.playgroundMapBrightness = 'sideBySide',
  });

  final WidgetBuilderSelection selection;
  final String label;
  final String subtitle;
  final bool showLeading;
  final bool showAccentStripe;
  final String loadingTitle;
  final String loadingSubtitle;
  final bool showLoadingProgress;
  final double loadingProgressValue;
  final String loaderType;
  final String badgeLabel;
  final bool showBadgeIcon;
  final String badgeStyle;
  final bool enableBadgeAnimation;
  final String buttonText;
  final bool isButtonEnabled;
  final bool isButtonLoading;
  final String buttonVariant;
  final String buttonSize;
  final String buttonShape;
  final bool showButtonLeadingIcon;
  final bool showButtonTrailingIcon;
  final bool isButtonFullWidth;
  final double avatarSize;
  final String avatarInitials;
  final bool isAvatarOnline;
  final bool showAvatarPremium;
  final bool showAvatarVerified;
  final bool showAvatarEdit;
  final String simulatedDevice;
  final bool isSimulatedLandscape;
  final String secButtonText;
  final bool isSecButtonEnabled;
  final bool isSecButtonLoading;
  final String secButtonVariant;
  final String secButtonSize;
  final String secButtonShape;
  final bool showSecButtonLeadingIcon;
  final bool showSecButtonTrailingIcon;
  final bool isSecButtonFullWidth;
  final String chipLabel;
  final String chipStatus;
  final String chipVariant;
  final String chipSize;
  final bool showChipIcon;
  final bool enableChipAnimation;
  final int currentStreakValue;
  final int longestStreakValue;
  final double streakProgressValue;
  final bool showWeeklyStreak;
  final bool showStreakReward;
  final bool showStreakMilestone;
  final bool enableStreakAnimation;
  final String tagLabel;
  final String tagVariant;
  final String tagSize;
  final String tagShape;
  final bool isTagSelected;
  final bool isTagEnabled;
  final bool isTagClosable;
  final bool showTagLeadingIcon;
  final bool showTagTrailingIcon;
  final String headerTitle;
  final String headerSubtitle;
  final bool showHeaderSubtitle;
  final bool showHeaderLeading;
  final bool showHeaderTrailing;
  final bool showHeaderDivider;
  final String headerActionType;
  final String headerActionText;
  final String constantsSearchQuery;
  final int currentXPValue;
  final int requiredXPValue;
  final int currentLevelValue;
  final int nextLevelValue;
  final String xpBarVariant;
  final bool showXPPercentage;
  final bool showLevelBadge;
  final bool showXPText;
  final bool showXPBarAnimation;
  final bool showXPBarGlow;
  final bool showXPBarIcon;
  final double xpBarProgressValue;
  final String errorType;
  final bool showErrorIllustration;
  final bool showErrorIcon;
  final bool showErrorRetryButton;
  final bool isErrorLoading;
  final String errorRetryText;
  final String cardTitle;
  final String cardSubtitle;
  final String cardAnimationType;
  final String cardVariant;
  final bool enableCardHover;
  final bool enableCardGlow;
  final bool enableCardGlass;
  final String aiButtonVariant;
  final String aiButtonSize;
  final String aiButtonState;
  final String aiButtonAnimation;
  final bool showAiIcon;
  final String aiBubbleRole;
  final String aiBubbleStyle;
  final String aiBubbleState;
  final String aiBubbleMessage;
  final bool aiBubbleLongMessage;
  final bool aiBubbleShowHeader;
  final bool aiBubbleShowFooter;
  final bool aiBubbleShowVerified;
  final String aiBubbleTimestamp;
  final String aiBubbleModelLabel;
  final bool aiBubbleStreaming;
  final bool aiBubbleError;
  final bool aiBubbleTyping;
  final String aiAvatarStatus;
  final double aiAvatarSize;
  final String aiAvatarSpeed;
  final String aiAvatarIntensity;
  final bool aiAvatarGlowEnabled;
  final bool aiAvatarHaloEnabled;
  final bool aiAvatarParticlesEnabled;
  final bool aiAvatarShadowEnabled;
  final double aiAvatarBorderWidth;
  final String aiExpTitle;
  final String aiExpSubtitle;
  final String aiExpBadgeLabel;
  final String aiExpTone;
  final bool aiExpShowBadge;
  final bool aiExpShowActions;
  final bool aiExpExpanded;
  final bool aiExpCanExpand;
  final bool aiExpLongContent;
  final String aiHintTitle;
  final String aiHintText;
  final String aiHintType;
  final String aiHintDifficulty;
  final String? aiHintTopic;
  final String? aiHintQuickTip;
  final bool aiHintShowBadge;
  final bool aiHintShowActions;
  final bool aiHintIsBookmarked;
  final String? aiHintBadgeText;
  final String aiHistoryHeaderTitle;
  final String aiHistoryHeaderSubtitle;
  final String aiHistoryState;
  final bool aiHistoryShowCategory;
  final bool aiHistoryShowTimestamp;
  final bool aiHistoryShowPremiumBadge;
  final bool aiHistoryShowFavorite;
  final bool aiHistoryShowPinned;
  final bool aiHistoryShowLeadingChevron;
  final bool aiHistoryShowHeader;
  final bool aiHistoryShowViewAll;
  final int aiHistoryLoadingItemCount;
  final String aiHistoryTileTitle;
  final String aiHistoryTilePreview;
  final String aiHistoryTileTimestamp;
  final String? aiHistoryTileSubtitle;
  final String? aiHistoryTileCategory;
  final String aiHistoryTileEntryType;
  final String aiHistoryTileBrightness;
  final bool aiHistoryTileShowCategory;
  final bool aiHistoryTileShowTimestamp;
  final bool aiHistoryTileShowPremiumBadge;
  final bool aiHistoryTileShowFavorite;
  final bool aiHistoryTileShowPinned;
  final bool aiHistoryTileShowLeadingChevron;
  final bool aiHistoryTileDense;
  final bool aiHistoryTileIsFavorite;
  final bool aiHistoryTileIsPinned;
  final bool aiHistoryTileIsPremium;
  final bool aiHistoryTileIsUnread;
  final String aiLoadingCardBrightness;
  final int aiLoadingCardBodyLineCount;
  final double aiLoadingCardElevation;
  final bool aiLoadingCardAnimationEnabled;
  final bool aiLoadingCardShowAvatar;
  final bool aiLoadingCardShowTitle;
  final bool aiLoadingCardShowSubtitle;
  final bool aiLoadingCardShowBody;
  final bool aiLoadingCardShowFooter;
  final String? aiLoadingCardSemanticLabel;
  final String aiResponseTitle;
  final String aiResponseSubtitle;
  final String aiResponseType;
  final String aiResponseBadgeLabel;
  final String aiResponseBody;
  final bool aiResponseMarkdown;
  final bool aiResponseSelectable;
  final bool aiResponseShowBadge;
  final bool aiResponseShowMetadata;
  final bool aiResponseShowActions;
  final String aiResponseMetadataModel;
  final String aiResponseMetadataTimestamp;
  final String aiResponseMetadataCategory;
  final String aiResponseMetadataConfidence;
  final String aiResponseMetadataStatus;
  final bool aiResponseActionCopy;
  final bool aiResponseActionShare;
  final bool aiResponseActionRegenerate;
  final bool aiResponseActionFavorite;
  final bool aiResponseActionLike;
  final bool aiResponseActionDislike;
  final bool aiResponseActionFavoriteActive;
  final bool aiResponseActionLikeActive;
  final bool aiResponseActionDislikeActive;
  final bool aiResponseCanExpand;
  final bool aiResponseExpanded;

  final String playgroundNodeRingKind;
  final String playgroundNodeRingState;
  final double playgroundNodeDiameter;
  final String playgroundNodeIconKind;
  final String playgroundNodeIconVariant;
  final double playgroundNodeProgress;
  final String playgroundNodeProgressState;
  final String playgroundNodeTitle;
  final String playgroundNodeSubtitle;
  final bool playgroundNodeShowProgress;
  final bool playgroundNodeShowLabel;
  final bool playgroundNodeShowBadge;
  final String playgroundNodeBadgeKind;
  final String playgroundNodeLabelPlacement;
  final String playgroundNodeLabelEmphasis;
  final bool playgroundNodeIsInteractive;
  final String playgroundNodeBrightness;
  final String nodeRingState;
  final String nodeRingKind;
  final double nodeRingDiameter;
  final double nodeRingStrokeWidth;
  final bool nodeRingGlow;
  final bool nodeRingIsAnimated;
  final String nodeRingBrightness;
  final String nodeIconKind;
  final String nodeIconVariant;
  final double nodeIconSize;
  final bool nodeIconIsEnabled;
  final String nodeIconBrightness;
  final String nodeBadgeKind;
  final double nodeBadgeSize;
  final double nodeBadgeOffset;
  final String nodeBadgeBrightness;
  final String nodeLabelTitle;
  final String nodeLabelSubtitle;
  final String nodeLabelPlacement;
  final String nodeLabelEmphasis;
  final double nodeLabelMaxWidth;
  final bool nodeLabelIsVisible;
  final String nodeLabelBrightness;
  final double nodeProgressValue;
  final String nodeProgressState;
  final double nodeProgressDiameter;
  final double nodeProgressStrokeWidth;
  final bool nodeProgressShowLabel;
  final String nodeProgressCompletedLabel;
  final String nodeProgressBrightness;
  final String treeKind;
  final double treeScale;
  final bool treeSway;
  final int treeSwaySeed;
  final String treeBrightness;
  final String bushKind;
  final double bushScale;
  final bool bushSway;
  final int bushSwaySeed;
  final String bushBrightness;
  final String cloudKind;
  final double cloudScale;
  final int cloudSeed;
  final String cloudBrightness;
  final String mountainLayer;
  final String mountainKind;
  final double mountainScale;
  final String mountainBrightness;
  final String riverCurve;
  final double riverHeight;
  final int riverSeed;
  final String riverBrightness;
  final String bridgeVariant;
  final double bridgeScale;
  final String bridgeBrightness;
  final String pathBrightness;
  final String flagColor;
  final double flagScale;
  final String flagBrightness;
  final String particlesKind;
  final int particlesCount;
  final int particlesSeed;
  final String particlesBrightness;
  final int particleLayerCount;
  final int particleLayerSeed;
  final String particleLayerBrightness;
  final String playgroundBuildingState;
  final String playgroundBuildingTitle;
  final String playgroundBuildingSubtitle;
  final double playgroundBuildingProgress;
  final int playgroundBuildingLevel;
  final bool playgroundBuildingIsInteractive;
  final bool playgroundBuildingShowLabel;
  final bool playgroundBuildingShowProgress;
  final String playgroundBuildingLabelPlacement;
  final String playgroundBuildingLabelEmphasis;
  final String playgroundBuildingProgressKind;
  final double playgroundBuildingScale;
  final String playgroundBuildingBrightness;
  final String academyBuildingState;
  final double academyBuildingProgress;
  final int academyBuildingLevel;
  final bool academyBuildingShowLabel;
  final bool academyBuildingShowProgress;
  final String academyBuildingLabelPlacement;
  final String academyBuildingLabelEmphasis;
  final String academyBuildingProgressKind;
  final double academyBuildingScale;
  final String academyBuildingBrightness;
  final String libraryBuildingState;
  final double libraryBuildingProgress;
  final int libraryBuildingLevel;
  final bool libraryBuildingShowLabel;
  final bool libraryBuildingShowProgress;
  final String libraryBuildingLabelPlacement;
  final String libraryBuildingLabelEmphasis;
  final String libraryBuildingProgressKind;
  final double libraryBuildingScale;
  final String libraryBuildingBrightness;
  final String buildingLabelTitle;
  final String buildingLabelSubtitle;
  final String buildingLabelPlacement;
  final String buildingLabelEmphasis;
  final double buildingLabelMaxWidth;
  final bool buildingLabelIsVisible;
  final String buildingLabelBrightness;
  final double buildingProgressValue;
  final String buildingProgressKind;
  final int buildingProgressLevel;
  final double buildingProgressSize;
  final String buildingProgressBrightness;
  final String playgroundProfileSummaryDisplayName;
  final int playgroundProfileSummaryLevel;
  final String playgroundProfileSummaryInitials;
  final bool playgroundProfileSummaryIsOnline;
  final bool playgroundProfileSummaryIsPremium;
  final int playgroundProfileSummaryNotificationCount;
  final String? playgroundProfileSummaryLeagueName;
  final String playgroundProfileSummaryBrightness;
  final int playgroundXpIndicatorTotalXp;
  final int playgroundXpIndicatorUserLevel;
  final int playgroundXpIndicatorXpInLevel;
  final int playgroundXpIndicatorXpForNextLevel;
  final int playgroundXpIndicatorGainDelta;
  final bool playgroundXpIndicatorIsAnimatingGain;
  final int playgroundCoinCounterBalance;
  final int playgroundCoinCounterGainDelta;
  final bool playgroundCoinCounterIsAnimatingGain;
  final int playgroundEnergyIndicatorRemaining;
  final int playgroundEnergyIndicatorMax;
  final int playgroundEnergyIndicatorRechargeSeconds;
  final bool playgroundEnergyIndicatorIsAnimatingRefill;
  final int playgroundStreakCardDays;
  final bool playgroundStreakCardIsAtRisk;
  final bool playgroundStreakCardMilestoneReached;
  final String playgroundTopBarBrightness;

  final int playgroundLevelProgressCardLevel;
  final int playgroundLevelProgressCardTotalStages;
  final int playgroundLevelProgressCardCompletedStages;
  final int playgroundLevelProgressCardTotalStars;
  final int playgroundLevelProgressCardEarnedStars;
  final int playgroundLevelProgressCardCurrentXP;
  final int playgroundLevelProgressCardRequiredXP;
  final String playgroundLevelProgressCardTitle;
  final String playgroundLevelProgressCardSubtitle;
  final String playgroundLevelProgressCardState;
  final String playgroundLevelProgressCardRewardKind;
  final int playgroundLevelProgressCardRewardAmount;
  final String playgroundLevelProgressCardBrightness;

  final String playgroundMissionCardTitle;
  final String playgroundMissionCardDescription;
  final int playgroundMissionCardRequired;
  final int playgroundMissionCardProgress;
  final String playgroundMissionCardState;
  final String playgroundMissionCardTag;
  final String playgroundMissionCardRewardKind;
  final int playgroundMissionCardRewardAmount;
  final int playgroundMissionCardTimerSeconds;
  final String playgroundMissionCardBrightness;

  final int playgroundCoinRewardAmount;
  final String playgroundCoinRewardSize;
  final String playgroundCoinRewardLayout;
  final String playgroundCoinRewardLabel;
  final bool playgroundCoinRewardIsDark;
  final String playgroundCoinRewardRarity;
  final bool playgroundCoinRewardShowGlow;
  final bool playgroundCoinRewardShowSparkle;
  final bool playgroundCoinRewardIsAnimating;
  final String playgroundCoinRewardBrightness;

  final int playgroundXpRewardAmount;
  final String playgroundXpRewardSize;
  final String playgroundXpRewardLayout;
  final String playgroundXpRewardLabel;
  final bool playgroundXpRewardIsDark;
  final String playgroundXpRewardRarity;
  final bool playgroundXpRewardShowGlow;
  final bool playgroundXpRewardShowSparkle;
  final bool playgroundXpRewardIsAnimating;
  final bool playgroundXpRewardIsLevelUp;
  final String playgroundXpRewardBrightness;

  final String playgroundRewardChestState;
  final String playgroundRewardChestSize;
  final bool playgroundRewardChestIsDark;
  final String playgroundRewardChestRarity;
  final bool playgroundRewardChestShowGlow;
  final bool playgroundRewardChestAutoOpen;
  final String playgroundRewardChestBrightness;

  final String playgroundRewardPopupTitle;
  final String playgroundRewardPopupSubtitle;
  final String playgroundRewardPopupPrimaryLabel;
  final String playgroundRewardPopupSecondaryLabel;
  final bool playgroundRewardPopupIsDark;
  final String playgroundRewardPopupRarity;
  final String playgroundRewardPopupChestState;
  final bool playgroundRewardPopupAutoOpenChest;
  final int playgroundRewardPopupEntryCount;
  final String playgroundRewardPopupBrightness;
  final String playgroundRewardPopupEntry1Kind;
  final int playgroundRewardPopupEntry1Amount;
  final String playgroundRewardPopupEntry1Label;
  final String playgroundRewardPopupEntry1Rarity;
  final String playgroundRewardPopupEntry2Kind;
  final int playgroundRewardPopupEntry2Amount;
  final String playgroundRewardPopupEntry2Label;
  final String playgroundRewardPopupEntry2Rarity;
  final String playgroundRewardPopupEntry3Kind;
  final int playgroundRewardPopupEntry3Amount;
  final String playgroundRewardPopupEntry3Label;
  final String playgroundRewardPopupEntry3Rarity;
  final String playgroundRewardPopupEntry4Kind;
  final int playgroundRewardPopupEntry4Amount;
  final String playgroundRewardPopupEntry4Label;
  final String playgroundRewardPopupEntry4Rarity;
  final String playgroundBackgroundBiome;
  final double playgroundBackgroundParallaxOffset;
  final String playgroundBackgroundBrightness;
  final double playgroundCameraZoom;
  final String playgroundCameraFocusTarget;
  final String playgroundCameraBrightness;
  final String playgroundLegendTitle;
  final String playgroundLegendBrightness;
  final double playgroundScrollViewZoom;
  final String playgroundScrollViewFocusTarget;
  final String playgroundScrollViewBrightness;
  final String playgroundMapBiome;
  final bool playgroundMapShowLegend;
  final String playgroundMapFocusTarget;
  final String playgroundMapBrightness;

  WidgetBuilderState copyWith({
    WidgetBuilderSelection? selection,
    String? label,
    String? subtitle,
    bool? showLeading,
    bool? showAccentStripe,
    String? loadingTitle,
    String? loadingSubtitle,
    bool? showLoadingProgress,
    double? loadingProgressValue,
    String? loaderType,
    String? badgeLabel,
    bool? showBadgeIcon,
    String? badgeStyle,
    bool? enableBadgeAnimation,
    String? buttonText,
    bool? isButtonEnabled,
    bool? isButtonLoading,
    String? buttonVariant,
    String? buttonSize,
    String? buttonShape,
    bool? showButtonLeadingIcon,
    bool? showButtonTrailingIcon,
    bool? isButtonFullWidth,
    double? avatarSize,
    String? avatarInitials,
    bool? isAvatarOnline,
    bool? showAvatarPremium,
    bool? showAvatarVerified,
    bool? showAvatarEdit,
    String? simulatedDevice,
    bool? isSimulatedLandscape,
    String? secButtonText,
    bool? isSecButtonEnabled,
    bool? isSecButtonLoading,
    String? secButtonVariant,
    String? secButtonSize,
    String? secButtonShape,
    bool? showSecButtonLeadingIcon,
    bool? showSecButtonTrailingIcon,
    bool? isSecButtonFullWidth,
    String? chipLabel,
    String? chipStatus,
    String? chipVariant,
    String? chipSize,
    bool? showChipIcon,
    bool? enableChipAnimation,
    int? currentStreakValue,
    int? longestStreakValue,
    double? streakProgressValue,
    bool? showWeeklyStreak,
    bool? showStreakReward,
    bool? showStreakMilestone,
    bool? enableStreakAnimation,
    String? tagLabel,
    String? tagVariant,
    String? tagSize,
    String? tagShape,
    bool? isTagSelected,
    bool? isTagEnabled,
    bool? isTagClosable,
    bool? showTagLeadingIcon,
    bool? showTagTrailingIcon,
    String? headerTitle,
    String? headerSubtitle,
    bool? showHeaderSubtitle,
    bool? showHeaderLeading,
    bool? showHeaderTrailing,
    bool? showHeaderDivider,
    String? headerActionType,
    String? headerActionText,
    String? constantsSearchQuery,
    int? currentXPValue,
    int? requiredXPValue,
    int? currentLevelValue,
    int? nextLevelValue,
    String? xpBarVariant,
    bool? showXPPercentage,
    bool? showLevelBadge,
    bool? showXPText,
    bool? showXPBarAnimation,
    bool? showXPBarGlow,
    bool? showXPBarIcon,
    double? xpBarProgressValue,
    String? errorType,
    bool? showErrorIllustration,
    bool? showErrorIcon,
    bool? showErrorRetryButton,
    bool? isErrorLoading,
    String? errorRetryText,
    String? cardTitle,
    String? cardSubtitle,
    String? cardAnimationType,
    String? cardVariant,
    bool? enableCardHover,
    bool? enableCardGlow,
    bool? enableCardGlass,
    String? aiButtonVariant,
    String? aiButtonSize,
    String? aiButtonState,
    String? aiButtonAnimation,
    bool? showAiIcon,
    String? aiBubbleRole,
    String? aiBubbleStyle,
    String? aiBubbleState,
    String? aiBubbleMessage,
    bool? aiBubbleLongMessage,
    bool? aiBubbleShowHeader,
    bool? aiBubbleShowFooter,
    bool? aiBubbleShowVerified,
    String? aiBubbleTimestamp,
    String? aiBubbleModelLabel,
    bool? aiBubbleStreaming,
    bool? aiBubbleError,
    bool? aiBubbleTyping,
    String? aiAvatarStatus,
    double? aiAvatarSize,
    String? aiAvatarSpeed,
    String? aiAvatarIntensity,
    bool? aiAvatarGlowEnabled,
    bool? aiAvatarHaloEnabled,
    bool? aiAvatarParticlesEnabled,
    bool? aiAvatarShadowEnabled,
    double? aiAvatarBorderWidth,
    String? aiExpTitle,
    String? aiExpSubtitle,
    String? aiExpBadgeLabel,
    String? aiExpTone,
    bool? aiExpShowBadge,
    bool? aiExpShowActions,
    bool? aiExpExpanded,
    bool? aiExpCanExpand,
    bool? aiExpLongContent,
    String? aiHintTitle,
    String? aiHintText,
    String? aiHintType,
    String? aiHintDifficulty,
    String? aiHintTopic,
    String? aiHintQuickTip,
    bool? aiHintShowBadge,
    bool? aiHintShowActions,
    bool? aiHintIsBookmarked,
    String? aiHintBadgeText,
    String? aiHistoryHeaderTitle,
    String? aiHistoryHeaderSubtitle,
    String? aiHistoryState,
    bool? aiHistoryShowCategory,
    bool? aiHistoryShowTimestamp,
    bool? aiHistoryShowPremiumBadge,
    bool? aiHistoryShowFavorite,
    bool? aiHistoryShowPinned,
    bool? aiHistoryShowLeadingChevron,
    bool? aiHistoryShowHeader,
    bool? aiHistoryShowViewAll,
    int? aiHistoryLoadingItemCount,
    String? aiHistoryTileTitle,
    String? aiHistoryTilePreview,
    String? aiHistoryTileTimestamp,
    String? aiHistoryTileSubtitle,
    String? aiHistoryTileCategory,
    String? aiHistoryTileEntryType,
    String? aiHistoryTileBrightness,
    bool? aiHistoryTileShowCategory,
    bool? aiHistoryTileShowTimestamp,
    bool? aiHistoryTileShowPremiumBadge,
    bool? aiHistoryTileShowFavorite,
    bool? aiHistoryTileShowPinned,
    bool? aiHistoryTileShowLeadingChevron,
    bool? aiHistoryTileDense,
    bool? aiHistoryTileIsFavorite,
    bool? aiHistoryTileIsPinned,
    bool? aiHistoryTileIsPremium,
    bool? aiHistoryTileIsUnread,
    String? aiLoadingCardBrightness,
    int? aiLoadingCardBodyLineCount,
    double? aiLoadingCardElevation,
    bool? aiLoadingCardAnimationEnabled,
    bool? aiLoadingCardShowAvatar,
    bool? aiLoadingCardShowTitle,
    bool? aiLoadingCardShowSubtitle,
    bool? aiLoadingCardShowBody,
    bool? aiLoadingCardShowFooter,
    String? aiLoadingCardSemanticLabel,
    String? aiResponseTitle,
    String? aiResponseSubtitle,
    String? aiResponseType,
    String? aiResponseBadgeLabel,
    String? aiResponseBody,
    bool? aiResponseMarkdown,
    bool? aiResponseSelectable,
    bool? aiResponseShowBadge,
    bool? aiResponseShowMetadata,
    bool? aiResponseShowActions,
    String? aiResponseMetadataModel,
    String? aiResponseMetadataTimestamp,
    String? aiResponseMetadataCategory,
    String? aiResponseMetadataConfidence,
    String? aiResponseMetadataStatus,
    bool? aiResponseActionCopy,
    bool? aiResponseActionShare,
    bool? aiResponseActionRegenerate,
    bool? aiResponseActionFavorite,
    bool? aiResponseActionLike,
    bool? aiResponseActionDislike,
    bool? aiResponseActionFavoriteActive,
    bool? aiResponseActionLikeActive,
    bool? aiResponseActionDislikeActive,
    bool? aiResponseCanExpand,
    bool? aiResponseExpanded,
    String? playgroundNodeRingKind,
    String? playgroundNodeRingState,
    double? playgroundNodeDiameter,
    String? playgroundNodeIconKind,
    String? playgroundNodeIconVariant,
    double? playgroundNodeProgress,
    String? playgroundNodeProgressState,
    String? playgroundNodeTitle,
    String? playgroundNodeSubtitle,
    bool? playgroundNodeShowProgress,
    bool? playgroundNodeShowLabel,
    bool? playgroundNodeShowBadge,
    String? playgroundNodeBadgeKind,
    String? playgroundNodeLabelPlacement,
    String? playgroundNodeLabelEmphasis,
    bool? playgroundNodeIsInteractive,
    String? playgroundNodeBrightness,
    String? nodeRingState,
    String? nodeRingKind,
    double? nodeRingDiameter,
    double? nodeRingStrokeWidth,
    bool? nodeRingGlow,
    bool? nodeRingIsAnimated,
    String? nodeRingBrightness,
    String? nodeIconKind,
    String? nodeIconVariant,
    double? nodeIconSize,
    bool? nodeIconIsEnabled,
    String? nodeIconBrightness,
    String? nodeBadgeKind,
    double? nodeBadgeSize,
    double? nodeBadgeOffset,
    String? nodeBadgeBrightness,
    String? nodeLabelTitle,
    String? nodeLabelSubtitle,
    String? nodeLabelPlacement,
    String? nodeLabelEmphasis,
    double? nodeLabelMaxWidth,
    bool? nodeLabelIsVisible,
    String? nodeLabelBrightness,
    double? nodeProgressValue,
    String? nodeProgressState,
    double? nodeProgressDiameter,
    double? nodeProgressStrokeWidth,
    bool? nodeProgressShowLabel,
    String? nodeProgressCompletedLabel,
    String? nodeProgressBrightness,
    String? treeKind,
    double? treeScale,
    bool? treeSway,
    int? treeSwaySeed,
    String? treeBrightness,
    String? bushKind,
    double? bushScale,
    bool? bushSway,
    int? bushSwaySeed,
    String? bushBrightness,
    String? cloudKind,
    double? cloudScale,
    int? cloudSeed,
    String? cloudBrightness,
    String? mountainLayer,
    String? mountainKind,
    double? mountainScale,
    String? mountainBrightness,
    String? riverCurve,
    double? riverHeight,
    int? riverSeed,
    String? riverBrightness,
    String? bridgeVariant,
    double? bridgeScale,
    String? bridgeBrightness,
    String? pathBrightness,
    String? flagColor,
    double? flagScale,
    String? flagBrightness,
    String? particlesKind,
    int? particlesCount,
    int? particlesSeed,
    String? particlesBrightness,
    int? particleLayerCount,
    int? particleLayerSeed,
    String? particleLayerBrightness,
    String? playgroundBuildingState,
    String? playgroundBuildingTitle,
    String? playgroundBuildingSubtitle,
    double? playgroundBuildingProgress,
    int? playgroundBuildingLevel,
    bool? playgroundBuildingIsInteractive,
    bool? playgroundBuildingShowLabel,
    bool? playgroundBuildingShowProgress,
    String? playgroundBuildingLabelPlacement,
    String? playgroundBuildingLabelEmphasis,
    String? playgroundBuildingProgressKind,
    double? playgroundBuildingScale,
    String? playgroundBuildingBrightness,
    String? academyBuildingState,
    double? academyBuildingProgress,
    int? academyBuildingLevel,
    bool? academyBuildingShowLabel,
    bool? academyBuildingShowProgress,
    String? academyBuildingLabelPlacement,
    String? academyBuildingLabelEmphasis,
    String? academyBuildingProgressKind,
    double? academyBuildingScale,
    String? academyBuildingBrightness,
    String? libraryBuildingState,
    double? libraryBuildingProgress,
    int? libraryBuildingLevel,
    bool? libraryBuildingShowLabel,
    bool? libraryBuildingShowProgress,
    String? libraryBuildingLabelPlacement,
    String? libraryBuildingLabelEmphasis,
    String? libraryBuildingProgressKind,
    double? libraryBuildingScale,
    String? libraryBuildingBrightness,
    String? buildingLabelTitle,
    String? buildingLabelSubtitle,
    String? buildingLabelPlacement,
    String? buildingLabelEmphasis,
    double? buildingLabelMaxWidth,
    bool? buildingLabelIsVisible,
    String? buildingLabelBrightness,
    double? buildingProgressValue,
    String? buildingProgressKind,
    int? buildingProgressLevel,
    double? buildingProgressSize,
    String? buildingProgressBrightness,
    String? playgroundProfileSummaryDisplayName,
    int? playgroundProfileSummaryLevel,
    String? playgroundProfileSummaryInitials,
    bool? playgroundProfileSummaryIsOnline,
    bool? playgroundProfileSummaryIsPremium,
    int? playgroundProfileSummaryNotificationCount,
    String? playgroundProfileSummaryLeagueName,
    String? playgroundProfileSummaryBrightness,
    int? playgroundXpIndicatorTotalXp,
    int? playgroundXpIndicatorUserLevel,
    int? playgroundXpIndicatorXpInLevel,
    int? playgroundXpIndicatorXpForNextLevel,
    int? playgroundXpIndicatorGainDelta,
    bool? playgroundXpIndicatorIsAnimatingGain,
    int? playgroundCoinCounterBalance,
    int? playgroundCoinCounterGainDelta,
    bool? playgroundCoinCounterIsAnimatingGain,
    int? playgroundEnergyIndicatorRemaining,
    int? playgroundEnergyIndicatorMax,
    int? playgroundEnergyIndicatorRechargeSeconds,
    bool? playgroundEnergyIndicatorIsAnimatingRefill,
    int? playgroundStreakCardDays,
    bool? playgroundStreakCardIsAtRisk,
    bool? playgroundStreakCardMilestoneReached,
    String? playgroundTopBarBrightness,
    int? playgroundLevelProgressCardLevel,
    int? playgroundLevelProgressCardTotalStages,
    int? playgroundLevelProgressCardCompletedStages,
    int? playgroundLevelProgressCardTotalStars,
    int? playgroundLevelProgressCardEarnedStars,
    int? playgroundLevelProgressCardCurrentXP,
    int? playgroundLevelProgressCardRequiredXP,
    String? playgroundLevelProgressCardTitle,
    String? playgroundLevelProgressCardSubtitle,
    String? playgroundLevelProgressCardState,
    String? playgroundLevelProgressCardRewardKind,
    int? playgroundLevelProgressCardRewardAmount,
    String? playgroundLevelProgressCardBrightness,
    String? playgroundMissionCardTitle,
    String? playgroundMissionCardDescription,
    int? playgroundMissionCardRequired,
    int? playgroundMissionCardProgress,
    String? playgroundMissionCardState,
    String? playgroundMissionCardTag,
    String? playgroundMissionCardRewardKind,
    int? playgroundMissionCardRewardAmount,
    int? playgroundMissionCardTimerSeconds,
    String? playgroundMissionCardBrightness,
    int? playgroundCoinRewardAmount,
    String? playgroundCoinRewardSize,
    String? playgroundCoinRewardLayout,
    String? playgroundCoinRewardLabel,
    bool? playgroundCoinRewardIsDark,
    String? playgroundCoinRewardRarity,
    bool? playgroundCoinRewardShowGlow,
    bool? playgroundCoinRewardShowSparkle,
    bool? playgroundCoinRewardIsAnimating,
    String? playgroundCoinRewardBrightness,
    int? playgroundXpRewardAmount,
    String? playgroundXpRewardSize,
    String? playgroundXpRewardLayout,
    String? playgroundXpRewardLabel,
    bool? playgroundXpRewardIsDark,
    String? playgroundXpRewardRarity,
    bool? playgroundXpRewardShowGlow,
    bool? playgroundXpRewardShowSparkle,
    bool? playgroundXpRewardIsAnimating,
    bool? playgroundXpRewardIsLevelUp,
    String? playgroundXpRewardBrightness,
    String? playgroundRewardChestState,
    String? playgroundRewardChestSize,
    bool? playgroundRewardChestIsDark,
    String? playgroundRewardChestRarity,
    bool? playgroundRewardChestShowGlow,
    bool? playgroundRewardChestAutoOpen,
    String? playgroundRewardChestBrightness,
    String? playgroundRewardPopupTitle,
    String? playgroundRewardPopupSubtitle,
    String? playgroundRewardPopupPrimaryLabel,
    String? playgroundRewardPopupSecondaryLabel,
    bool? playgroundRewardPopupIsDark,
    String? playgroundRewardPopupRarity,
    String? playgroundRewardPopupChestState,
    bool? playgroundRewardPopupAutoOpenChest,
    int? playgroundRewardPopupEntryCount,
    String? playgroundRewardPopupBrightness,
    String? playgroundRewardPopupEntry1Kind,
    int? playgroundRewardPopupEntry1Amount,
    String? playgroundRewardPopupEntry1Label,
    String? playgroundRewardPopupEntry1Rarity,
    String? playgroundRewardPopupEntry2Kind,
    int? playgroundRewardPopupEntry2Amount,
    String? playgroundRewardPopupEntry2Label,
    String? playgroundRewardPopupEntry2Rarity,
    String? playgroundRewardPopupEntry3Kind,
    int? playgroundRewardPopupEntry3Amount,
    String? playgroundRewardPopupEntry3Label,
    String? playgroundRewardPopupEntry3Rarity,
    String? playgroundRewardPopupEntry4Kind,
    int? playgroundRewardPopupEntry4Amount,
    String? playgroundRewardPopupEntry4Label,
    String? playgroundRewardPopupEntry4Rarity,
    String? playgroundBackgroundBiome,
    double? playgroundBackgroundParallaxOffset,
    String? playgroundBackgroundBrightness,
    double? playgroundCameraZoom,
    String? playgroundCameraFocusTarget,
    String? playgroundCameraBrightness,
    String? playgroundLegendTitle,
    String? playgroundLegendBrightness,
    double? playgroundScrollViewZoom,
    String? playgroundScrollViewFocusTarget,
    String? playgroundScrollViewBrightness,
    String? playgroundMapBiome,
    bool? playgroundMapShowLegend,
    String? playgroundMapFocusTarget,
    String? playgroundMapBrightness,
  }) {
    return WidgetBuilderState(
      selection: selection ?? this.selection,
      label: label ?? this.label,
      subtitle: subtitle ?? this.subtitle,
      showLeading: showLeading ?? this.showLeading,
      showAccentStripe: showAccentStripe ?? this.showAccentStripe,
      loadingTitle: loadingTitle ?? this.loadingTitle,
      loadingSubtitle: loadingSubtitle ?? this.loadingSubtitle,
      showLoadingProgress: showLoadingProgress ?? this.showLoadingProgress,
      loadingProgressValue: loadingProgressValue ?? this.loadingProgressValue,
      loaderType: loaderType ?? this.loaderType,
      badgeLabel: badgeLabel ?? this.badgeLabel,
      showBadgeIcon: showBadgeIcon ?? this.showBadgeIcon,
      badgeStyle: badgeStyle ?? this.badgeStyle,
      enableBadgeAnimation: enableBadgeAnimation ?? this.enableBadgeAnimation,
      buttonText: buttonText ?? this.buttonText,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isButtonLoading: isButtonLoading ?? this.isButtonLoading,
      buttonVariant: buttonVariant ?? this.buttonVariant,
      buttonSize: buttonSize ?? this.buttonSize,
      buttonShape: buttonShape ?? this.buttonShape,
      showButtonLeadingIcon:
          showButtonLeadingIcon ?? this.showButtonLeadingIcon,
      showButtonTrailingIcon:
          showButtonTrailingIcon ?? this.showButtonTrailingIcon,
      isButtonFullWidth: isButtonFullWidth ?? this.isButtonFullWidth,
      avatarSize: avatarSize ?? this.avatarSize,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      isAvatarOnline: isAvatarOnline ?? this.isAvatarOnline,
      showAvatarPremium: showAvatarPremium ?? this.showAvatarPremium,
      showAvatarVerified: showAvatarVerified ?? this.showAvatarVerified,
      showAvatarEdit: showAvatarEdit ?? this.showAvatarEdit,
      simulatedDevice: simulatedDevice ?? this.simulatedDevice,
      isSimulatedLandscape: isSimulatedLandscape ?? this.isSimulatedLandscape,
      secButtonText: secButtonText ?? this.secButtonText,
      isSecButtonEnabled: isSecButtonEnabled ?? this.isSecButtonEnabled,
      isSecButtonLoading: isSecButtonLoading ?? this.isSecButtonLoading,
      secButtonVariant: secButtonVariant ?? this.secButtonVariant,
      secButtonSize: secButtonSize ?? this.secButtonSize,
      secButtonShape: secButtonShape ?? this.secButtonShape,
      showSecButtonLeadingIcon:
          showSecButtonLeadingIcon ?? this.showSecButtonLeadingIcon,
      showSecButtonTrailingIcon:
          showSecButtonTrailingIcon ?? this.showSecButtonTrailingIcon,
      isSecButtonFullWidth: isSecButtonFullWidth ?? this.isSecButtonFullWidth,
      chipLabel: chipLabel ?? this.chipLabel,
      chipStatus: chipStatus ?? this.chipStatus,
      chipVariant: chipVariant ?? this.chipVariant,
      chipSize: chipSize ?? this.chipSize,
      showChipIcon: showChipIcon ?? this.showChipIcon,
      enableChipAnimation: enableChipAnimation ?? this.enableChipAnimation,
      currentStreakValue: currentStreakValue ?? this.currentStreakValue,
      longestStreakValue: longestStreakValue ?? this.longestStreakValue,
      streakProgressValue: streakProgressValue ?? this.streakProgressValue,
      showWeeklyStreak: showWeeklyStreak ?? this.showWeeklyStreak,
      showStreakReward: showStreakReward ?? this.showStreakReward,
      showStreakMilestone: showStreakMilestone ?? this.showStreakMilestone,
      enableStreakAnimation:
          enableStreakAnimation ?? this.enableStreakAnimation,
      tagLabel: tagLabel ?? this.tagLabel,
      tagVariant: tagVariant ?? this.tagVariant,
      tagSize: tagSize ?? this.tagSize,
      tagShape: tagShape ?? this.tagShape,
      isTagSelected: isTagSelected ?? this.isTagSelected,
      isTagEnabled: isTagEnabled ?? this.isTagEnabled,
      isTagClosable: isTagClosable ?? this.isTagClosable,
      showTagLeadingIcon: showTagLeadingIcon ?? this.showTagLeadingIcon,
      showTagTrailingIcon: showTagTrailingIcon ?? this.showTagTrailingIcon,
      headerTitle: headerTitle ?? this.headerTitle,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      showHeaderSubtitle: showHeaderSubtitle ?? this.showHeaderSubtitle,
      showHeaderLeading: showHeaderLeading ?? this.showHeaderLeading,
      showHeaderTrailing: showHeaderTrailing ?? this.showHeaderTrailing,
      showHeaderDivider: showHeaderDivider ?? this.showHeaderDivider,
      headerActionType: headerActionType ?? this.headerActionType,
      headerActionText: headerActionText ?? this.headerActionText,
      constantsSearchQuery: constantsSearchQuery ?? this.constantsSearchQuery,
      currentXPValue: currentXPValue ?? this.currentXPValue,
      requiredXPValue: requiredXPValue ?? this.requiredXPValue,
      currentLevelValue: currentLevelValue ?? this.currentLevelValue,
      nextLevelValue: nextLevelValue ?? this.nextLevelValue,
      xpBarVariant: xpBarVariant ?? this.xpBarVariant,
      showXPPercentage: showXPPercentage ?? this.showXPPercentage,
      showLevelBadge: showLevelBadge ?? this.showLevelBadge,
      showXPText: showXPText ?? this.showXPText,
      showXPBarAnimation: showXPBarAnimation ?? this.showXPBarAnimation,
      showXPBarGlow: showXPBarGlow ?? this.showXPBarGlow,
      showXPBarIcon: showXPBarIcon ?? this.showXPBarIcon,
      xpBarProgressValue: xpBarProgressValue ?? this.xpBarProgressValue,
      errorType: errorType ?? this.errorType,
      showErrorIllustration:
          showErrorIllustration ?? this.showErrorIllustration,
      showErrorIcon: showErrorIcon ?? this.showErrorIcon,
      showErrorRetryButton: showErrorRetryButton ?? this.showErrorRetryButton,
      isErrorLoading: isErrorLoading ?? this.isErrorLoading,
      errorRetryText: errorRetryText ?? this.errorRetryText,
      cardTitle: cardTitle ?? this.cardTitle,
      cardSubtitle: cardSubtitle ?? this.cardSubtitle,
      cardAnimationType: cardAnimationType ?? this.cardAnimationType,
      cardVariant: cardVariant ?? this.cardVariant,
      enableCardHover: enableCardHover ?? this.enableCardHover,
      enableCardGlow: enableCardGlow ?? this.enableCardGlow,
      enableCardGlass: enableCardGlass ?? this.enableCardGlass,
      aiButtonVariant: aiButtonVariant ?? this.aiButtonVariant,
      aiButtonSize: aiButtonSize ?? this.aiButtonSize,
      aiButtonState: aiButtonState ?? this.aiButtonState,
      aiButtonAnimation: aiButtonAnimation ?? this.aiButtonAnimation,
      showAiIcon: showAiIcon ?? this.showAiIcon,
      aiBubbleRole: aiBubbleRole ?? this.aiBubbleRole,
      aiBubbleStyle: aiBubbleStyle ?? this.aiBubbleStyle,
      aiBubbleState: aiBubbleState ?? this.aiBubbleState,
      aiBubbleMessage: aiBubbleMessage ?? this.aiBubbleMessage,
      aiBubbleLongMessage: aiBubbleLongMessage ?? this.aiBubbleLongMessage,
      aiBubbleShowHeader: aiBubbleShowHeader ?? this.aiBubbleShowHeader,
      aiBubbleShowFooter: aiBubbleShowFooter ?? this.aiBubbleShowFooter,
      aiBubbleShowVerified: aiBubbleShowVerified ?? this.aiBubbleShowVerified,
      aiBubbleTimestamp: aiBubbleTimestamp ?? this.aiBubbleTimestamp,
      aiBubbleModelLabel: aiBubbleModelLabel ?? this.aiBubbleModelLabel,
      aiBubbleStreaming: aiBubbleStreaming ?? this.aiBubbleStreaming,
      aiBubbleError: aiBubbleError ?? this.aiBubbleError,
      aiBubbleTyping: aiBubbleTyping ?? this.aiBubbleTyping,
      aiAvatarStatus: aiAvatarStatus ?? this.aiAvatarStatus,
      aiAvatarSize: aiAvatarSize ?? this.aiAvatarSize,
      aiAvatarSpeed: aiAvatarSpeed ?? this.aiAvatarSpeed,
      aiAvatarIntensity: aiAvatarIntensity ?? this.aiAvatarIntensity,
      aiAvatarGlowEnabled: aiAvatarGlowEnabled ?? this.aiAvatarGlowEnabled,
      aiAvatarHaloEnabled: aiAvatarHaloEnabled ?? this.aiAvatarHaloEnabled,
      aiAvatarParticlesEnabled:
          aiAvatarParticlesEnabled ?? this.aiAvatarParticlesEnabled,
      aiAvatarShadowEnabled:
          aiAvatarShadowEnabled ?? this.aiAvatarShadowEnabled,
      aiAvatarBorderWidth: aiAvatarBorderWidth ?? this.aiAvatarBorderWidth,
      aiExpTitle: aiExpTitle ?? this.aiExpTitle,
      aiExpSubtitle: aiExpSubtitle ?? this.aiExpSubtitle,
      aiExpBadgeLabel: aiExpBadgeLabel ?? this.aiExpBadgeLabel,
      aiExpTone: aiExpTone ?? this.aiExpTone,
      aiExpShowBadge: aiExpShowBadge ?? this.aiExpShowBadge,
      aiExpShowActions: aiExpShowActions ?? this.aiExpShowActions,
      aiExpExpanded: aiExpExpanded ?? this.aiExpExpanded,
      aiExpCanExpand: aiExpCanExpand ?? this.aiExpCanExpand,
      aiExpLongContent: aiExpLongContent ?? this.aiExpLongContent,
      aiHintTitle: aiHintTitle ?? this.aiHintTitle,
      aiHintText: aiHintText ?? this.aiHintText,
      aiHintType: aiHintType ?? this.aiHintType,
      aiHintDifficulty: aiHintDifficulty ?? this.aiHintDifficulty,
      aiHintTopic: aiHintTopic ?? this.aiHintTopic,
      aiHintQuickTip: aiHintQuickTip ?? this.aiHintQuickTip,
      aiHintShowBadge: aiHintShowBadge ?? this.aiHintShowBadge,
      aiHintShowActions: aiHintShowActions ?? this.aiHintShowActions,
      aiHintIsBookmarked: aiHintIsBookmarked ?? this.aiHintIsBookmarked,
      aiHintBadgeText: aiHintBadgeText ?? this.aiHintBadgeText,
      aiHistoryHeaderTitle: aiHistoryHeaderTitle ?? this.aiHistoryHeaderTitle,
      aiHistoryHeaderSubtitle:
          aiHistoryHeaderSubtitle ?? this.aiHistoryHeaderSubtitle,
      aiHistoryState: aiHistoryState ?? this.aiHistoryState,
      aiHistoryShowCategory:
          aiHistoryShowCategory ?? this.aiHistoryShowCategory,
      aiHistoryShowTimestamp:
          aiHistoryShowTimestamp ?? this.aiHistoryShowTimestamp,
      aiHistoryShowPremiumBadge:
          aiHistoryShowPremiumBadge ?? this.aiHistoryShowPremiumBadge,
      aiHistoryShowFavorite:
          aiHistoryShowFavorite ?? this.aiHistoryShowFavorite,
      aiHistoryShowPinned: aiHistoryShowPinned ?? this.aiHistoryShowPinned,
      aiHistoryShowLeadingChevron:
          aiHistoryShowLeadingChevron ?? this.aiHistoryShowLeadingChevron,
      aiHistoryShowHeader: aiHistoryShowHeader ?? this.aiHistoryShowHeader,
      aiHistoryShowViewAll: aiHistoryShowViewAll ?? this.aiHistoryShowViewAll,
      aiHistoryLoadingItemCount:
          aiHistoryLoadingItemCount ?? this.aiHistoryLoadingItemCount,
      aiHistoryTileTitle: aiHistoryTileTitle ?? this.aiHistoryTileTitle,
      aiHistoryTilePreview: aiHistoryTilePreview ?? this.aiHistoryTilePreview,
      aiHistoryTileTimestamp:
          aiHistoryTileTimestamp ?? this.aiHistoryTileTimestamp,
      aiHistoryTileSubtitle:
          aiHistoryTileSubtitle ?? this.aiHistoryTileSubtitle,
      aiHistoryTileCategory:
          aiHistoryTileCategory ?? this.aiHistoryTileCategory,
      aiHistoryTileEntryType:
          aiHistoryTileEntryType ?? this.aiHistoryTileEntryType,
      aiHistoryTileBrightness:
          aiHistoryTileBrightness ?? this.aiHistoryTileBrightness,
      aiHistoryTileShowCategory:
          aiHistoryTileShowCategory ?? this.aiHistoryTileShowCategory,
      aiHistoryTileShowTimestamp:
          aiHistoryTileShowTimestamp ?? this.aiHistoryTileShowTimestamp,
      aiHistoryTileShowPremiumBadge:
          aiHistoryTileShowPremiumBadge ?? this.aiHistoryTileShowPremiumBadge,
      aiHistoryTileShowFavorite:
          aiHistoryTileShowFavorite ?? this.aiHistoryTileShowFavorite,
      aiHistoryTileShowPinned:
          aiHistoryTileShowPinned ?? this.aiHistoryTileShowPinned,
      aiHistoryTileShowLeadingChevron:
          aiHistoryTileShowLeadingChevron ??
          this.aiHistoryTileShowLeadingChevron,
      aiHistoryTileDense: aiHistoryTileDense ?? this.aiHistoryTileDense,
      aiHistoryTileIsFavorite:
          aiHistoryTileIsFavorite ?? this.aiHistoryTileIsFavorite,
      aiHistoryTileIsPinned:
          aiHistoryTileIsPinned ?? this.aiHistoryTileIsPinned,
      aiHistoryTileIsPremium:
          aiHistoryTileIsPremium ?? this.aiHistoryTileIsPremium,
      aiHistoryTileIsUnread:
          aiHistoryTileIsUnread ?? this.aiHistoryTileIsUnread,
      aiLoadingCardBrightness:
          aiLoadingCardBrightness ?? this.aiLoadingCardBrightness,
      aiLoadingCardBodyLineCount:
          aiLoadingCardBodyLineCount ?? this.aiLoadingCardBodyLineCount,
      aiLoadingCardElevation:
          aiLoadingCardElevation ?? this.aiLoadingCardElevation,
      aiLoadingCardAnimationEnabled:
          aiLoadingCardAnimationEnabled ?? this.aiLoadingCardAnimationEnabled,
      aiLoadingCardShowAvatar:
          aiLoadingCardShowAvatar ?? this.aiLoadingCardShowAvatar,
      aiLoadingCardShowTitle:
          aiLoadingCardShowTitle ?? this.aiLoadingCardShowTitle,
      aiLoadingCardShowSubtitle:
          aiLoadingCardShowSubtitle ?? this.aiLoadingCardShowSubtitle,
      aiLoadingCardShowBody:
          aiLoadingCardShowBody ?? this.aiLoadingCardShowBody,
      aiLoadingCardShowFooter:
          aiLoadingCardShowFooter ?? this.aiLoadingCardShowFooter,
      aiLoadingCardSemanticLabel:
          aiLoadingCardSemanticLabel ?? this.aiLoadingCardSemanticLabel,
      aiResponseTitle: aiResponseTitle ?? this.aiResponseTitle,
      aiResponseSubtitle: aiResponseSubtitle ?? this.aiResponseSubtitle,
      aiResponseType: aiResponseType ?? this.aiResponseType,
      aiResponseBadgeLabel: aiResponseBadgeLabel ?? this.aiResponseBadgeLabel,
      aiResponseBody: aiResponseBody ?? this.aiResponseBody,
      aiResponseMarkdown: aiResponseMarkdown ?? this.aiResponseMarkdown,
      aiResponseSelectable: aiResponseSelectable ?? this.aiResponseSelectable,
      aiResponseShowBadge: aiResponseShowBadge ?? this.aiResponseShowBadge,
      aiResponseShowMetadata:
          aiResponseShowMetadata ?? this.aiResponseShowMetadata,
      aiResponseShowActions:
          aiResponseShowActions ?? this.aiResponseShowActions,
      aiResponseMetadataModel:
          aiResponseMetadataModel ?? this.aiResponseMetadataModel,
      aiResponseMetadataTimestamp:
          aiResponseMetadataTimestamp ?? this.aiResponseMetadataTimestamp,
      aiResponseMetadataCategory:
          aiResponseMetadataCategory ?? this.aiResponseMetadataCategory,
      aiResponseMetadataConfidence:
          aiResponseMetadataConfidence ?? this.aiResponseMetadataConfidence,
      aiResponseMetadataStatus:
          aiResponseMetadataStatus ?? this.aiResponseMetadataStatus,
      aiResponseActionCopy: aiResponseActionCopy ?? this.aiResponseActionCopy,
      aiResponseActionShare:
          aiResponseActionShare ?? this.aiResponseActionShare,
      aiResponseActionRegenerate:
          aiResponseActionRegenerate ?? this.aiResponseActionRegenerate,
      aiResponseActionFavorite:
          aiResponseActionFavorite ?? this.aiResponseActionFavorite,
      aiResponseActionLike: aiResponseActionLike ?? this.aiResponseActionLike,
      aiResponseActionDislike:
          aiResponseActionDislike ?? this.aiResponseActionDislike,
      aiResponseActionFavoriteActive:
          aiResponseActionFavoriteActive ?? this.aiResponseActionFavoriteActive,
      aiResponseActionLikeActive:
          aiResponseActionLikeActive ?? this.aiResponseActionLikeActive,
      aiResponseActionDislikeActive:
          aiResponseActionDislikeActive ?? this.aiResponseActionDislikeActive,
      aiResponseCanExpand: aiResponseCanExpand ?? this.aiResponseCanExpand,
      aiResponseExpanded: aiResponseExpanded ?? this.aiResponseExpanded,
      playgroundNodeRingKind:
          playgroundNodeRingKind ?? this.playgroundNodeRingKind,
      playgroundNodeRingState:
          playgroundNodeRingState ?? this.playgroundNodeRingState,
      playgroundNodeDiameter:
          playgroundNodeDiameter ?? this.playgroundNodeDiameter,
      playgroundNodeIconKind:
          playgroundNodeIconKind ?? this.playgroundNodeIconKind,
      playgroundNodeIconVariant:
          playgroundNodeIconVariant ?? this.playgroundNodeIconVariant,
      playgroundNodeProgress:
          playgroundNodeProgress ?? this.playgroundNodeProgress,
      playgroundNodeProgressState:
          playgroundNodeProgressState ?? this.playgroundNodeProgressState,
      playgroundNodeTitle: playgroundNodeTitle ?? this.playgroundNodeTitle,
      playgroundNodeSubtitle:
          playgroundNodeSubtitle ?? this.playgroundNodeSubtitle,
      playgroundNodeShowProgress:
          playgroundNodeShowProgress ?? this.playgroundNodeShowProgress,
      playgroundNodeShowLabel:
          playgroundNodeShowLabel ?? this.playgroundNodeShowLabel,
      playgroundNodeShowBadge:
          playgroundNodeShowBadge ?? this.playgroundNodeShowBadge,
      playgroundNodeBadgeKind:
          playgroundNodeBadgeKind ?? this.playgroundNodeBadgeKind,
      playgroundNodeLabelPlacement:
          playgroundNodeLabelPlacement ?? this.playgroundNodeLabelPlacement,
      playgroundNodeLabelEmphasis:
          playgroundNodeLabelEmphasis ?? this.playgroundNodeLabelEmphasis,
      playgroundNodeIsInteractive:
          playgroundNodeIsInteractive ?? this.playgroundNodeIsInteractive,
      playgroundNodeBrightness:
          playgroundNodeBrightness ?? this.playgroundNodeBrightness,
      nodeRingState: nodeRingState ?? this.nodeRingState,
      nodeRingKind: nodeRingKind ?? this.nodeRingKind,
      nodeRingDiameter: nodeRingDiameter ?? this.nodeRingDiameter,
      nodeRingStrokeWidth: nodeRingStrokeWidth ?? this.nodeRingStrokeWidth,
      nodeRingGlow: nodeRingGlow ?? this.nodeRingGlow,
      nodeRingIsAnimated: nodeRingIsAnimated ?? this.nodeRingIsAnimated,
      nodeRingBrightness: nodeRingBrightness ?? this.nodeRingBrightness,
      nodeIconKind: nodeIconKind ?? this.nodeIconKind,
      nodeIconVariant: nodeIconVariant ?? this.nodeIconVariant,
      nodeIconSize: nodeIconSize ?? this.nodeIconSize,
      nodeIconIsEnabled: nodeIconIsEnabled ?? this.nodeIconIsEnabled,
      nodeIconBrightness: nodeIconBrightness ?? this.nodeIconBrightness,
      nodeBadgeKind: nodeBadgeKind ?? this.nodeBadgeKind,
      nodeBadgeSize: nodeBadgeSize ?? this.nodeBadgeSize,
      nodeBadgeOffset: nodeBadgeOffset ?? this.nodeBadgeOffset,
      nodeBadgeBrightness: nodeBadgeBrightness ?? this.nodeBadgeBrightness,
      nodeLabelTitle: nodeLabelTitle ?? this.nodeLabelTitle,
      nodeLabelSubtitle: nodeLabelSubtitle ?? this.nodeLabelSubtitle,
      nodeLabelPlacement: nodeLabelPlacement ?? this.nodeLabelPlacement,
      nodeLabelEmphasis: nodeLabelEmphasis ?? this.nodeLabelEmphasis,
      nodeLabelMaxWidth: nodeLabelMaxWidth ?? this.nodeLabelMaxWidth,
      nodeLabelIsVisible: nodeLabelIsVisible ?? this.nodeLabelIsVisible,
      nodeLabelBrightness: nodeLabelBrightness ?? this.nodeLabelBrightness,
      nodeProgressValue: nodeProgressValue ?? this.nodeProgressValue,
      nodeProgressState: nodeProgressState ?? this.nodeProgressState,
      nodeProgressDiameter: nodeProgressDiameter ?? this.nodeProgressDiameter,
      nodeProgressStrokeWidth:
          nodeProgressStrokeWidth ?? this.nodeProgressStrokeWidth,
      nodeProgressShowLabel:
          nodeProgressShowLabel ?? this.nodeProgressShowLabel,
      nodeProgressCompletedLabel:
          nodeProgressCompletedLabel ?? this.nodeProgressCompletedLabel,
      nodeProgressBrightness:
          nodeProgressBrightness ?? this.nodeProgressBrightness,
      treeKind: treeKind ?? this.treeKind,
      treeScale: treeScale ?? this.treeScale,
      treeSway: treeSway ?? this.treeSway,
      treeSwaySeed: treeSwaySeed ?? this.treeSwaySeed,
      treeBrightness: treeBrightness ?? this.treeBrightness,
      bushKind: bushKind ?? this.bushKind,
      bushScale: bushScale ?? this.bushScale,
      bushSway: bushSway ?? this.bushSway,
      bushSwaySeed: bushSwaySeed ?? this.bushSwaySeed,
      bushBrightness: bushBrightness ?? this.bushBrightness,
      cloudKind: cloudKind ?? this.cloudKind,
      cloudScale: cloudScale ?? this.cloudScale,
      cloudSeed: cloudSeed ?? this.cloudSeed,
      cloudBrightness: cloudBrightness ?? this.cloudBrightness,
      mountainLayer: mountainLayer ?? this.mountainLayer,
      mountainKind: mountainKind ?? this.mountainKind,
      mountainScale: mountainScale ?? this.mountainScale,
      mountainBrightness: mountainBrightness ?? this.mountainBrightness,
      riverCurve: riverCurve ?? this.riverCurve,
      riverHeight: riverHeight ?? this.riverHeight,
      riverSeed: riverSeed ?? this.riverSeed,
      riverBrightness: riverBrightness ?? this.riverBrightness,
      bridgeVariant: bridgeVariant ?? this.bridgeVariant,
      bridgeScale: bridgeScale ?? this.bridgeScale,
      bridgeBrightness: bridgeBrightness ?? this.bridgeBrightness,
      pathBrightness: pathBrightness ?? this.pathBrightness,
      flagColor: flagColor ?? this.flagColor,
      flagScale: flagScale ?? this.flagScale,
      flagBrightness: flagBrightness ?? this.flagBrightness,
      particlesKind: particlesKind ?? this.particlesKind,
      particlesCount: particlesCount ?? this.particlesCount,
      particlesSeed: particlesSeed ?? this.particlesSeed,
      particlesBrightness: particlesBrightness ?? this.particlesBrightness,
      particleLayerCount: particleLayerCount ?? this.particleLayerCount,
      particleLayerSeed: particleLayerSeed ?? this.particleLayerSeed,
      particleLayerBrightness:
          particleLayerBrightness ?? this.particleLayerBrightness,
      playgroundBuildingState:
          playgroundBuildingState ?? this.playgroundBuildingState,
      playgroundBuildingTitle:
          playgroundBuildingTitle ?? this.playgroundBuildingTitle,
      playgroundBuildingSubtitle:
          playgroundBuildingSubtitle ?? this.playgroundBuildingSubtitle,
      playgroundBuildingProgress:
          playgroundBuildingProgress ?? this.playgroundBuildingProgress,
      playgroundBuildingLevel:
          playgroundBuildingLevel ?? this.playgroundBuildingLevel,
      playgroundBuildingIsInteractive:
          playgroundBuildingIsInteractive ??
          this.playgroundBuildingIsInteractive,
      playgroundBuildingShowLabel:
          playgroundBuildingShowLabel ?? this.playgroundBuildingShowLabel,
      playgroundBuildingShowProgress:
          playgroundBuildingShowProgress ?? this.playgroundBuildingShowProgress,
      playgroundBuildingLabelPlacement:
          playgroundBuildingLabelPlacement ??
          this.playgroundBuildingLabelPlacement,
      playgroundBuildingLabelEmphasis:
          playgroundBuildingLabelEmphasis ??
          this.playgroundBuildingLabelEmphasis,
      playgroundBuildingProgressKind:
          playgroundBuildingProgressKind ?? this.playgroundBuildingProgressKind,
      playgroundBuildingScale:
          playgroundBuildingScale ?? this.playgroundBuildingScale,
      playgroundBuildingBrightness:
          playgroundBuildingBrightness ?? this.playgroundBuildingBrightness,
      academyBuildingState: academyBuildingState ?? this.academyBuildingState,
      academyBuildingProgress:
          academyBuildingProgress ?? this.academyBuildingProgress,
      academyBuildingLevel: academyBuildingLevel ?? this.academyBuildingLevel,
      academyBuildingShowLabel:
          academyBuildingShowLabel ?? this.academyBuildingShowLabel,
      academyBuildingShowProgress:
          academyBuildingShowProgress ?? this.academyBuildingShowProgress,
      academyBuildingLabelPlacement:
          academyBuildingLabelPlacement ?? this.academyBuildingLabelPlacement,
      academyBuildingLabelEmphasis:
          academyBuildingLabelEmphasis ?? this.academyBuildingLabelEmphasis,
      academyBuildingProgressKind:
          academyBuildingProgressKind ?? this.academyBuildingProgressKind,
      academyBuildingScale: academyBuildingScale ?? this.academyBuildingScale,
      academyBuildingBrightness:
          academyBuildingBrightness ?? this.academyBuildingBrightness,
      libraryBuildingState: libraryBuildingState ?? this.libraryBuildingState,
      libraryBuildingProgress:
          libraryBuildingProgress ?? this.libraryBuildingProgress,
      libraryBuildingLevel: libraryBuildingLevel ?? this.libraryBuildingLevel,
      libraryBuildingShowLabel:
          libraryBuildingShowLabel ?? this.libraryBuildingShowLabel,
      libraryBuildingShowProgress:
          libraryBuildingShowProgress ?? this.libraryBuildingShowProgress,
      libraryBuildingLabelPlacement:
          libraryBuildingLabelPlacement ?? this.libraryBuildingLabelPlacement,
      libraryBuildingLabelEmphasis:
          libraryBuildingLabelEmphasis ?? this.libraryBuildingLabelEmphasis,
      libraryBuildingProgressKind:
          libraryBuildingProgressKind ?? this.libraryBuildingProgressKind,
      libraryBuildingScale: libraryBuildingScale ?? this.libraryBuildingScale,
      libraryBuildingBrightness:
          libraryBuildingBrightness ?? this.libraryBuildingBrightness,
      buildingLabelTitle: buildingLabelTitle ?? this.buildingLabelTitle,
      buildingLabelSubtitle:
          buildingLabelSubtitle ?? this.buildingLabelSubtitle,
      buildingLabelPlacement:
          buildingLabelPlacement ?? this.buildingLabelPlacement,
      buildingLabelEmphasis:
          buildingLabelEmphasis ?? this.buildingLabelEmphasis,
      buildingLabelMaxWidth:
          buildingLabelMaxWidth ?? this.buildingLabelMaxWidth,
      buildingLabelIsVisible:
          buildingLabelIsVisible ?? this.buildingLabelIsVisible,
      buildingLabelBrightness:
          buildingLabelBrightness ?? this.buildingLabelBrightness,
      buildingProgressValue:
          buildingProgressValue ?? this.buildingProgressValue,
      buildingProgressKind: buildingProgressKind ?? this.buildingProgressKind,
      buildingProgressLevel:
          buildingProgressLevel ?? this.buildingProgressLevel,
      buildingProgressSize: buildingProgressSize ?? this.buildingProgressSize,
      buildingProgressBrightness:
          buildingProgressBrightness ?? this.buildingProgressBrightness,
      playgroundProfileSummaryDisplayName:
          playgroundProfileSummaryDisplayName ??
          this.playgroundProfileSummaryDisplayName,
      playgroundProfileSummaryLevel:
          playgroundProfileSummaryLevel ?? this.playgroundProfileSummaryLevel,
      playgroundProfileSummaryInitials:
          playgroundProfileSummaryInitials ??
          this.playgroundProfileSummaryInitials,
      playgroundProfileSummaryIsOnline:
          playgroundProfileSummaryIsOnline ??
          this.playgroundProfileSummaryIsOnline,
      playgroundProfileSummaryIsPremium:
          playgroundProfileSummaryIsPremium ??
          this.playgroundProfileSummaryIsPremium,
      playgroundProfileSummaryNotificationCount:
          playgroundProfileSummaryNotificationCount ??
          this.playgroundProfileSummaryNotificationCount,
      playgroundProfileSummaryLeagueName:
          playgroundProfileSummaryLeagueName ??
          this.playgroundProfileSummaryLeagueName,
      playgroundProfileSummaryBrightness:
          playgroundProfileSummaryBrightness ??
          this.playgroundProfileSummaryBrightness,
      playgroundXpIndicatorTotalXp:
          playgroundXpIndicatorTotalXp ?? this.playgroundXpIndicatorTotalXp,
      playgroundXpIndicatorUserLevel:
          playgroundXpIndicatorUserLevel ?? this.playgroundXpIndicatorUserLevel,
      playgroundXpIndicatorXpInLevel:
          playgroundXpIndicatorXpInLevel ?? this.playgroundXpIndicatorXpInLevel,
      playgroundXpIndicatorXpForNextLevel:
          playgroundXpIndicatorXpForNextLevel ??
          this.playgroundXpIndicatorXpForNextLevel,
      playgroundXpIndicatorGainDelta:
          playgroundXpIndicatorGainDelta ?? this.playgroundXpIndicatorGainDelta,
      playgroundXpIndicatorIsAnimatingGain:
          playgroundXpIndicatorIsAnimatingGain ??
          this.playgroundXpIndicatorIsAnimatingGain,
      playgroundCoinCounterBalance:
          playgroundCoinCounterBalance ?? this.playgroundCoinCounterBalance,
      playgroundCoinCounterGainDelta:
          playgroundCoinCounterGainDelta ?? this.playgroundCoinCounterGainDelta,
      playgroundCoinCounterIsAnimatingGain:
          playgroundCoinCounterIsAnimatingGain ??
          this.playgroundCoinCounterIsAnimatingGain,
      playgroundEnergyIndicatorRemaining:
          playgroundEnergyIndicatorRemaining ??
          this.playgroundEnergyIndicatorRemaining,
      playgroundEnergyIndicatorMax:
          playgroundEnergyIndicatorMax ?? this.playgroundEnergyIndicatorMax,
      playgroundEnergyIndicatorRechargeSeconds:
          playgroundEnergyIndicatorRechargeSeconds ??
          this.playgroundEnergyIndicatorRechargeSeconds,
      playgroundEnergyIndicatorIsAnimatingRefill:
          playgroundEnergyIndicatorIsAnimatingRefill ??
          this.playgroundEnergyIndicatorIsAnimatingRefill,
      playgroundStreakCardDays:
          playgroundStreakCardDays ?? this.playgroundStreakCardDays,
      playgroundStreakCardIsAtRisk:
          playgroundStreakCardIsAtRisk ?? this.playgroundStreakCardIsAtRisk,
      playgroundStreakCardMilestoneReached:
          playgroundStreakCardMilestoneReached ??
          this.playgroundStreakCardMilestoneReached,
      playgroundTopBarBrightness:
          playgroundTopBarBrightness ?? this.playgroundTopBarBrightness,
      playgroundLevelProgressCardLevel:
          playgroundLevelProgressCardLevel ??
          this.playgroundLevelProgressCardLevel,
      playgroundLevelProgressCardTotalStages:
          playgroundLevelProgressCardTotalStages ??
          this.playgroundLevelProgressCardTotalStages,
      playgroundLevelProgressCardCompletedStages:
          playgroundLevelProgressCardCompletedStages ??
          this.playgroundLevelProgressCardCompletedStages,
      playgroundLevelProgressCardTotalStars:
          playgroundLevelProgressCardTotalStars ??
          this.playgroundLevelProgressCardTotalStars,
      playgroundLevelProgressCardEarnedStars:
          playgroundLevelProgressCardEarnedStars ??
          this.playgroundLevelProgressCardEarnedStars,
      playgroundLevelProgressCardCurrentXP:
          playgroundLevelProgressCardCurrentXP ??
          this.playgroundLevelProgressCardCurrentXP,
      playgroundLevelProgressCardRequiredXP:
          playgroundLevelProgressCardRequiredXP ??
          this.playgroundLevelProgressCardRequiredXP,
      playgroundLevelProgressCardTitle:
          playgroundLevelProgressCardTitle ??
          this.playgroundLevelProgressCardTitle,
      playgroundLevelProgressCardSubtitle:
          playgroundLevelProgressCardSubtitle ??
          this.playgroundLevelProgressCardSubtitle,
      playgroundLevelProgressCardState:
          playgroundLevelProgressCardState ??
          this.playgroundLevelProgressCardState,
      playgroundLevelProgressCardRewardKind:
          playgroundLevelProgressCardRewardKind ??
          this.playgroundLevelProgressCardRewardKind,
      playgroundLevelProgressCardRewardAmount:
          playgroundLevelProgressCardRewardAmount ??
          this.playgroundLevelProgressCardRewardAmount,
      playgroundLevelProgressCardBrightness:
          playgroundLevelProgressCardBrightness ??
          this.playgroundLevelProgressCardBrightness,
      playgroundMissionCardTitle:
          playgroundMissionCardTitle ?? this.playgroundMissionCardTitle,
      playgroundMissionCardDescription:
          playgroundMissionCardDescription ??
          this.playgroundMissionCardDescription,
      playgroundMissionCardRequired:
          playgroundMissionCardRequired ?? this.playgroundMissionCardRequired,
      playgroundMissionCardProgress:
          playgroundMissionCardProgress ?? this.playgroundMissionCardProgress,
      playgroundMissionCardState:
          playgroundMissionCardState ?? this.playgroundMissionCardState,
      playgroundMissionCardTag:
          playgroundMissionCardTag ?? this.playgroundMissionCardTag,
      playgroundMissionCardRewardKind:
          playgroundMissionCardRewardKind ??
          this.playgroundMissionCardRewardKind,
      playgroundMissionCardRewardAmount:
          playgroundMissionCardRewardAmount ??
          this.playgroundMissionCardRewardAmount,
      playgroundMissionCardTimerSeconds:
          playgroundMissionCardTimerSeconds ??
          this.playgroundMissionCardTimerSeconds,
      playgroundMissionCardBrightness:
          playgroundMissionCardBrightness ??
          this.playgroundMissionCardBrightness,
      playgroundCoinRewardAmount:
          playgroundCoinRewardAmount ?? this.playgroundCoinRewardAmount,
      playgroundCoinRewardSize:
          playgroundCoinRewardSize ?? this.playgroundCoinRewardSize,
      playgroundCoinRewardLayout:
          playgroundCoinRewardLayout ?? this.playgroundCoinRewardLayout,
      playgroundCoinRewardLabel:
          playgroundCoinRewardLabel ?? this.playgroundCoinRewardLabel,
      playgroundCoinRewardIsDark:
          playgroundCoinRewardIsDark ?? this.playgroundCoinRewardIsDark,
      playgroundCoinRewardRarity:
          playgroundCoinRewardRarity ?? this.playgroundCoinRewardRarity,
      playgroundCoinRewardShowGlow:
          playgroundCoinRewardShowGlow ?? this.playgroundCoinRewardShowGlow,
      playgroundCoinRewardShowSparkle:
          playgroundCoinRewardShowSparkle ??
          this.playgroundCoinRewardShowSparkle,
      playgroundCoinRewardIsAnimating:
          playgroundCoinRewardIsAnimating ??
          this.playgroundCoinRewardIsAnimating,
      playgroundCoinRewardBrightness:
          playgroundCoinRewardBrightness ?? this.playgroundCoinRewardBrightness,
      playgroundXpRewardAmount:
          playgroundXpRewardAmount ?? this.playgroundXpRewardAmount,
      playgroundXpRewardSize:
          playgroundXpRewardSize ?? this.playgroundXpRewardSize,
      playgroundXpRewardLayout:
          playgroundXpRewardLayout ?? this.playgroundXpRewardLayout,
      playgroundXpRewardLabel:
          playgroundXpRewardLabel ?? this.playgroundXpRewardLabel,
      playgroundXpRewardIsDark:
          playgroundXpRewardIsDark ?? this.playgroundXpRewardIsDark,
      playgroundXpRewardRarity:
          playgroundXpRewardRarity ?? this.playgroundXpRewardRarity,
      playgroundXpRewardShowGlow:
          playgroundXpRewardShowGlow ?? this.playgroundXpRewardShowGlow,
      playgroundXpRewardShowSparkle:
          playgroundXpRewardShowSparkle ?? this.playgroundXpRewardShowSparkle,
      playgroundXpRewardIsAnimating:
          playgroundXpRewardIsAnimating ?? this.playgroundXpRewardIsAnimating,
      playgroundXpRewardIsLevelUp:
          playgroundXpRewardIsLevelUp ?? this.playgroundXpRewardIsLevelUp,
      playgroundXpRewardBrightness:
          playgroundXpRewardBrightness ?? this.playgroundXpRewardBrightness,
      playgroundRewardChestState:
          playgroundRewardChestState ?? this.playgroundRewardChestState,
      playgroundRewardChestSize:
          playgroundRewardChestSize ?? this.playgroundRewardChestSize,
      playgroundRewardChestIsDark:
          playgroundRewardChestIsDark ?? this.playgroundRewardChestIsDark,
      playgroundRewardChestRarity:
          playgroundRewardChestRarity ?? this.playgroundRewardChestRarity,
      playgroundRewardChestShowGlow:
          playgroundRewardChestShowGlow ?? this.playgroundRewardChestShowGlow,
      playgroundRewardChestAutoOpen:
          playgroundRewardChestAutoOpen ?? this.playgroundRewardChestAutoOpen,
      playgroundRewardChestBrightness:
          playgroundRewardChestBrightness ??
          this.playgroundRewardChestBrightness,
      playgroundRewardPopupTitle:
          playgroundRewardPopupTitle ?? this.playgroundRewardPopupTitle,
      playgroundRewardPopupSubtitle:
          playgroundRewardPopupSubtitle ?? this.playgroundRewardPopupSubtitle,
      playgroundRewardPopupPrimaryLabel:
          playgroundRewardPopupPrimaryLabel ??
          this.playgroundRewardPopupPrimaryLabel,
      playgroundRewardPopupSecondaryLabel:
          playgroundRewardPopupSecondaryLabel ??
          this.playgroundRewardPopupSecondaryLabel,
      playgroundRewardPopupIsDark:
          playgroundRewardPopupIsDark ?? this.playgroundRewardPopupIsDark,
      playgroundRewardPopupRarity:
          playgroundRewardPopupRarity ?? this.playgroundRewardPopupRarity,
      playgroundRewardPopupChestState:
          playgroundRewardPopupChestState ??
          this.playgroundRewardPopupChestState,
      playgroundRewardPopupAutoOpenChest:
          playgroundRewardPopupAutoOpenChest ??
          this.playgroundRewardPopupAutoOpenChest,
      playgroundRewardPopupEntryCount:
          playgroundRewardPopupEntryCount ??
          this.playgroundRewardPopupEntryCount,
      playgroundRewardPopupBrightness:
          playgroundRewardPopupBrightness ??
          this.playgroundRewardPopupBrightness,
      playgroundRewardPopupEntry1Kind:
          playgroundRewardPopupEntry1Kind ??
          this.playgroundRewardPopupEntry1Kind,
      playgroundRewardPopupEntry1Amount:
          playgroundRewardPopupEntry1Amount ??
          this.playgroundRewardPopupEntry1Amount,
      playgroundRewardPopupEntry1Label:
          playgroundRewardPopupEntry1Label ??
          this.playgroundRewardPopupEntry1Label,
      playgroundRewardPopupEntry1Rarity:
          playgroundRewardPopupEntry1Rarity ??
          this.playgroundRewardPopupEntry1Rarity,
      playgroundRewardPopupEntry2Kind:
          playgroundRewardPopupEntry2Kind ??
          this.playgroundRewardPopupEntry2Kind,
      playgroundRewardPopupEntry2Amount:
          playgroundRewardPopupEntry2Amount ??
          this.playgroundRewardPopupEntry2Amount,
      playgroundRewardPopupEntry2Label:
          playgroundRewardPopupEntry2Label ??
          this.playgroundRewardPopupEntry2Label,
      playgroundRewardPopupEntry2Rarity:
          playgroundRewardPopupEntry2Rarity ??
          this.playgroundRewardPopupEntry2Rarity,
      playgroundRewardPopupEntry3Kind:
          playgroundRewardPopupEntry3Kind ??
          this.playgroundRewardPopupEntry3Kind,
      playgroundRewardPopupEntry3Amount:
          playgroundRewardPopupEntry3Amount ??
          this.playgroundRewardPopupEntry3Amount,
      playgroundRewardPopupEntry3Label:
          playgroundRewardPopupEntry3Label ??
          this.playgroundRewardPopupEntry3Label,
      playgroundRewardPopupEntry3Rarity:
          playgroundRewardPopupEntry3Rarity ??
          this.playgroundRewardPopupEntry3Rarity,
      playgroundRewardPopupEntry4Kind:
          playgroundRewardPopupEntry4Kind ??
          this.playgroundRewardPopupEntry4Kind,
      playgroundRewardPopupEntry4Amount:
          playgroundRewardPopupEntry4Amount ??
          this.playgroundRewardPopupEntry4Amount,
      playgroundRewardPopupEntry4Label:
          playgroundRewardPopupEntry4Label ??
          this.playgroundRewardPopupEntry4Label,
      playgroundRewardPopupEntry4Rarity:
          playgroundRewardPopupEntry4Rarity ??
          this.playgroundRewardPopupEntry4Rarity,
      playgroundBackgroundBiome:
          playgroundBackgroundBiome ?? this.playgroundBackgroundBiome,
      playgroundBackgroundParallaxOffset:
          playgroundBackgroundParallaxOffset ??
          this.playgroundBackgroundParallaxOffset,
      playgroundBackgroundBrightness:
          playgroundBackgroundBrightness ?? this.playgroundBackgroundBrightness,
      playgroundCameraZoom: playgroundCameraZoom ?? this.playgroundCameraZoom,
      playgroundCameraFocusTarget:
          playgroundCameraFocusTarget ?? this.playgroundCameraFocusTarget,
      playgroundCameraBrightness:
          playgroundCameraBrightness ?? this.playgroundCameraBrightness,
      playgroundLegendTitle:
          playgroundLegendTitle ?? this.playgroundLegendTitle,
      playgroundLegendBrightness:
          playgroundLegendBrightness ?? this.playgroundLegendBrightness,
      playgroundScrollViewZoom:
          playgroundScrollViewZoom ?? this.playgroundScrollViewZoom,
      playgroundScrollViewFocusTarget:
          playgroundScrollViewFocusTarget ??
          this.playgroundScrollViewFocusTarget,
      playgroundScrollViewBrightness:
          playgroundScrollViewBrightness ?? this.playgroundScrollViewBrightness,
      playgroundMapBiome: playgroundMapBiome ?? this.playgroundMapBiome,
      playgroundMapShowLegend:
          playgroundMapShowLegend ?? this.playgroundMapShowLegend,
      playgroundMapFocusTarget:
          playgroundMapFocusTarget ?? this.playgroundMapFocusTarget,
      playgroundMapBrightness:
          playgroundMapBrightness ?? this.playgroundMapBrightness,
    );
  }
}
