import 'package:flutter/foundation.dart';
import 'widget_builder_state.dart';
import 'widget_builder_controller.dart';
import 'widget_builder_selection.dart';

export 'widget_builder_state.dart';
export 'widget_builder_controller.dart';
export 'widget_builder_selection.dart';

/// State holder for the widget builder canvas.
///
/// Implements [ChangeNotifier] so the screen can rebuild without pulling
/// in a full state-management package just yet.
class WidgetBuilderProvider extends ChangeNotifier {
  WidgetBuilderProvider({
    WidgetBuilderSelection initial = WidgetBuilderSelection.primaryButton,
  }) : _state = WidgetBuilderState(selection: initial) {
    _controller = WidgetBuilderController(_updateState);
  }

  WidgetBuilderState _state;
  late final WidgetBuilderController _controller;

  WidgetBuilderState get state => _state;
  WidgetBuilderController get controller => _controller;

  void _updateState(WidgetBuilderState Function(WidgetBuilderState) updater) {
    final newState = updater(_state);
    if (newState != _state) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Legacy getters for backward compatibility during refactoring
  WidgetBuilderSelection get selection => _state.selection;
  String get label => _state.label;
  String get subtitle => _state.subtitle;
  bool get showLeading => _state.showLeading;
  bool get showAccentStripe => _state.showAccentStripe;
  String get loadingTitle => _state.loadingTitle;
  String get loadingSubtitle => _state.loadingSubtitle;
  bool get showLoadingProgress => _state.showLoadingProgress;
  double get loadingProgressValue => _state.loadingProgressValue;
  String get loaderType => _state.loaderType;
  String get badgeLabel => _state.badgeLabel;
  bool get showBadgeIcon => _state.showBadgeIcon;
  String get badgeStyle => _state.badgeStyle;
  bool get enableBadgeAnimation => _state.enableBadgeAnimation;
  String get buttonText => _state.buttonText;
  bool get isButtonEnabled => _state.isButtonEnabled;
  bool get isButtonLoading => _state.isButtonLoading;
  String get buttonVariant => _state.buttonVariant;
  String get buttonSize => _state.buttonSize;
  String get buttonShape => _state.buttonShape;
  bool get showButtonLeadingIcon => _state.showButtonLeadingIcon;
  bool get showButtonTrailingIcon => _state.showButtonTrailingIcon;
  bool get isButtonFullWidth => _state.isButtonFullWidth;
  double get avatarSize => _state.avatarSize;
  String get avatarInitials => _state.avatarInitials;
  bool get isAvatarOnline => _state.isAvatarOnline;
  bool get showAvatarPremium => _state.showAvatarPremium;
  bool get showAvatarVerified => _state.showAvatarVerified;
  bool get showAvatarEdit => _state.showAvatarEdit;
  String get simulatedDevice => _state.simulatedDevice;
  bool get isSimulatedLandscape => _state.isSimulatedLandscape;
  String get secButtonText => _state.secButtonText;
  bool get isSecButtonEnabled => _state.isSecButtonEnabled;
  bool get isSecButtonLoading => _state.isSecButtonLoading;
  String get secButtonVariant => _state.secButtonVariant;
  String get secButtonSize => _state.secButtonSize;
  String get secButtonShape => _state.secButtonShape;
  bool get showSecButtonLeadingIcon => _state.showSecButtonLeadingIcon;
  bool get showSecButtonTrailingIcon => _state.showSecButtonTrailingIcon;
  bool get isSecButtonFullWidth => _state.isSecButtonFullWidth;
  String get chipLabel => _state.chipLabel;
  String get chipStatus => _state.chipStatus;
  String get chipVariant => _state.chipVariant;
  String get chipSize => _state.chipSize;
  bool get showChipIcon => _state.showChipIcon;
  bool get enableChipAnimation => _state.enableChipAnimation;
  int get currentStreakValue => _state.currentStreakValue;
  int get longestStreakValue => _state.longestStreakValue;
  double get streakProgressValue => _state.streakProgressValue;
  bool get showWeeklyStreak => _state.showWeeklyStreak;
  bool get showStreakReward => _state.showStreakReward;
  bool get showStreakMilestone => _state.showStreakMilestone;
  bool get enableStreakAnimation => _state.enableStreakAnimation;
  String get tagLabel => _state.tagLabel;
  String get tagVariant => _state.tagVariant;
  String get tagSize => _state.tagSize;
  String get tagShape => _state.tagShape;
  bool get isTagSelected => _state.isTagSelected;
  bool get isTagEnabled => _state.isTagEnabled;
  bool get isTagClosable => _state.isTagClosable;
  bool get showTagLeadingIcon => _state.showTagLeadingIcon;
  bool get showTagTrailingIcon => _state.showTagTrailingIcon;
  String get headerTitle => _state.headerTitle;
  String get headerSubtitle => _state.headerSubtitle;
  bool get showHeaderSubtitle => _state.showHeaderSubtitle;
  bool get showHeaderLeading => _state.showHeaderLeading;
  bool get showHeaderTrailing => _state.showHeaderTrailing;
  bool get showHeaderDivider => _state.showHeaderDivider;
  String get headerActionType => _state.headerActionType;
  String get headerActionText => _state.headerActionText;
  String get constantsSearchQuery => _state.constantsSearchQuery;
  int get currentXPValue => _state.currentXPValue;
  int get requiredXPValue => _state.requiredXPValue;
  int get currentLevelValue => _state.currentLevelValue;
  int get nextLevelValue => _state.nextLevelValue;
  String get xpBarVariant => _state.xpBarVariant;
  bool get showXPPercentage => _state.showXPPercentage;
  bool get showLevelBadge => _state.showLevelBadge;
  bool get showXPText => _state.showXPText;
  bool get showXPBarAnimation => _state.showXPBarAnimation;
  bool get showXPBarGlow => _state.showXPBarGlow;
  bool get showXPBarIcon => _state.showXPBarIcon;
  double get xpBarProgressValue => _state.xpBarProgressValue;
  String get errorType => _state.errorType;
  bool get showErrorIllustration => _state.showErrorIllustration;
  bool get showErrorIcon => _state.showErrorIcon;
  bool get showErrorRetryButton => _state.showErrorRetryButton;
  bool get isErrorLoading => _state.isErrorLoading;
  String get errorRetryText => _state.errorRetryText;
  String get cardTitle => _state.cardTitle;
  String get cardSubtitle => _state.cardSubtitle;
  String get cardAnimationType => _state.cardAnimationType;
  String get cardVariant => _state.cardVariant;
  bool get enableCardHover => _state.enableCardHover;
  bool get enableCardGlow => _state.enableCardGlow;
  bool get enableCardGlass => _state.enableCardGlass;

  String get aiExpTitle => _state.aiExpTitle;
  String get aiExpSubtitle => _state.aiExpSubtitle;
  String get aiExpBadgeLabel => _state.aiExpBadgeLabel;
  String get aiExpTone => _state.aiExpTone;
  bool get aiExpShowBadge => _state.aiExpShowBadge;
  bool get aiExpShowActions => _state.aiExpShowActions;
  bool get aiExpExpanded => _state.aiExpExpanded;
  bool get aiExpCanExpand => _state.aiExpCanExpand;
  bool get aiExpLongContent => _state.aiExpLongContent;

  String get aiHintTitle => _state.aiHintTitle;
  String get aiHintText => _state.aiHintText;
  String get aiHintType => _state.aiHintType;
  String get aiHintDifficulty => _state.aiHintDifficulty;
  String? get aiHintTopic => _state.aiHintTopic;
  String? get aiHintQuickTip => _state.aiHintQuickTip;
  bool get aiHintShowBadge => _state.aiHintShowBadge;
  bool get aiHintShowActions => _state.aiHintShowActions;
  bool get aiHintIsBookmarked => _state.aiHintIsBookmarked;
  String? get aiHintBadgeText => _state.aiHintBadgeText;

  String get aiHistoryHeaderTitle => _state.aiHistoryHeaderTitle;
  String get aiHistoryHeaderSubtitle => _state.aiHistoryHeaderSubtitle;
  String get aiHistoryState => _state.aiHistoryState;
  bool get aiHistoryShowCategory => _state.aiHistoryShowCategory;
  bool get aiHistoryShowTimestamp => _state.aiHistoryShowTimestamp;
  bool get aiHistoryShowPremiumBadge => _state.aiHistoryShowPremiumBadge;
  bool get aiHistoryShowFavorite => _state.aiHistoryShowFavorite;
  bool get aiHistoryShowPinned => _state.aiHistoryShowPinned;
  bool get aiHistoryShowLeadingChevron => _state.aiHistoryShowLeadingChevron;
  bool get aiHistoryShowHeader => _state.aiHistoryShowHeader;
  bool get aiHistoryShowViewAll => _state.aiHistoryShowViewAll;
  int get aiHistoryLoadingItemCount => _state.aiHistoryLoadingItemCount;
  String get aiHistoryTileTitle => _state.aiHistoryTileTitle;
  String get aiHistoryTilePreview => _state.aiHistoryTilePreview;
  String get aiHistoryTileTimestamp => _state.aiHistoryTileTimestamp;
  String? get aiHistoryTileSubtitle => _state.aiHistoryTileSubtitle;
  String? get aiHistoryTileCategory => _state.aiHistoryTileCategory;
  String get aiHistoryTileEntryType => _state.aiHistoryTileEntryType;
  String get aiHistoryTileBrightness => _state.aiHistoryTileBrightness;
  bool get aiHistoryTileShowCategory => _state.aiHistoryTileShowCategory;
  bool get aiHistoryTileShowTimestamp => _state.aiHistoryTileShowTimestamp;
  bool get aiHistoryTileShowPremiumBadge =>
      _state.aiHistoryTileShowPremiumBadge;
  bool get aiHistoryTileShowFavorite => _state.aiHistoryTileShowFavorite;
  bool get aiHistoryTileShowPinned => _state.aiHistoryTileShowPinned;
  bool get aiHistoryTileShowLeadingChevron =>
      _state.aiHistoryTileShowLeadingChevron;
  bool get aiHistoryTileDense => _state.aiHistoryTileDense;
  bool get aiHistoryTileIsFavorite => _state.aiHistoryTileIsFavorite;
  bool get aiHistoryTileIsPinned => _state.aiHistoryTileIsPinned;
  bool get aiHistoryTileIsPremium => _state.aiHistoryTileIsPremium;
  bool get aiHistoryTileIsUnread => _state.aiHistoryTileIsUnread;
  String get aiLoadingCardBrightness => _state.aiLoadingCardBrightness;
  int get aiLoadingCardBodyLineCount => _state.aiLoadingCardBodyLineCount;
  double get aiLoadingCardElevation => _state.aiLoadingCardElevation;
  bool get aiLoadingCardAnimationEnabled =>
      _state.aiLoadingCardAnimationEnabled;
  bool get aiLoadingCardShowAvatar => _state.aiLoadingCardShowAvatar;
  bool get aiLoadingCardShowTitle => _state.aiLoadingCardShowTitle;
  bool get aiLoadingCardShowSubtitle => _state.aiLoadingCardShowSubtitle;
  bool get aiLoadingCardShowBody => _state.aiLoadingCardShowBody;
  bool get aiLoadingCardShowFooter => _state.aiLoadingCardShowFooter;
  String? get aiLoadingCardSemanticLabel => _state.aiLoadingCardSemanticLabel;
  String get aiResponseTitle => _state.aiResponseTitle;
  String get aiResponseSubtitle => _state.aiResponseSubtitle;
  String get aiResponseType => _state.aiResponseType;
  String get aiResponseBadgeLabel => _state.aiResponseBadgeLabel;
  String get aiResponseBody => _state.aiResponseBody;
  bool get aiResponseMarkdown => _state.aiResponseMarkdown;
  bool get aiResponseSelectable => _state.aiResponseSelectable;
  bool get aiResponseShowBadge => _state.aiResponseShowBadge;
  bool get aiResponseShowMetadata => _state.aiResponseShowMetadata;
  bool get aiResponseShowActions => _state.aiResponseShowActions;
  String get aiResponseMetadataModel => _state.aiResponseMetadataModel;
  String get aiResponseMetadataTimestamp => _state.aiResponseMetadataTimestamp;
  String get aiResponseMetadataCategory => _state.aiResponseMetadataCategory;
  String get aiResponseMetadataConfidence =>
      _state.aiResponseMetadataConfidence;
  String get aiResponseMetadataStatus => _state.aiResponseMetadataStatus;
  bool get aiResponseActionCopy => _state.aiResponseActionCopy;
  bool get aiResponseActionShare => _state.aiResponseActionShare;
  bool get aiResponseActionRegenerate => _state.aiResponseActionRegenerate;
  bool get aiResponseActionFavorite => _state.aiResponseActionFavorite;
  bool get aiResponseActionLike => _state.aiResponseActionLike;
  bool get aiResponseActionDislike => _state.aiResponseActionDislike;
  bool get aiResponseActionFavoriteActive =>
      _state.aiResponseActionFavoriteActive;
  bool get aiResponseActionLikeActive => _state.aiResponseActionLikeActive;
  bool get aiResponseActionDislikeActive =>
      _state.aiResponseActionDislikeActive;
  bool get aiResponseCanExpand => _state.aiResponseCanExpand;
  bool get aiResponseExpanded => _state.aiResponseExpanded;

  String get playgroundNodeRingKind => _state.playgroundNodeRingKind;
  String get playgroundNodeRingState => _state.playgroundNodeRingState;
  double get playgroundNodeDiameter => _state.playgroundNodeDiameter;
  String get playgroundNodeIconKind => _state.playgroundNodeIconKind;
  String get playgroundNodeIconVariant => _state.playgroundNodeIconVariant;
  double get playgroundNodeProgress => _state.playgroundNodeProgress;
  String get playgroundNodeProgressState => _state.playgroundNodeProgressState;
  String get playgroundNodeTitle => _state.playgroundNodeTitle;
  String get playgroundNodeSubtitle => _state.playgroundNodeSubtitle;
  bool get playgroundNodeShowProgress => _state.playgroundNodeShowProgress;
  bool get playgroundNodeShowLabel => _state.playgroundNodeShowLabel;
  bool get playgroundNodeShowBadge => _state.playgroundNodeShowBadge;
  String get playgroundNodeBadgeKind => _state.playgroundNodeBadgeKind;
  String get playgroundNodeLabelPlacement =>
      _state.playgroundNodeLabelPlacement;
  String get playgroundNodeLabelEmphasis => _state.playgroundNodeLabelEmphasis;
  bool get playgroundNodeIsInteractive => _state.playgroundNodeIsInteractive;
  String get playgroundNodeBrightness => _state.playgroundNodeBrightness;
  String get nodeRingState => _state.nodeRingState;
  String get nodeRingKind => _state.nodeRingKind;
  double get nodeRingDiameter => _state.nodeRingDiameter;
  double get nodeRingStrokeWidth => _state.nodeRingStrokeWidth;
  bool get nodeRingGlow => _state.nodeRingGlow;
  bool get nodeRingIsAnimated => _state.nodeRingIsAnimated;
  String get nodeRingBrightness => _state.nodeRingBrightness;
  String get nodeIconKind => _state.nodeIconKind;
  String get nodeIconVariant => _state.nodeIconVariant;
  double get nodeIconSize => _state.nodeIconSize;
  bool get nodeIconIsEnabled => _state.nodeIconIsEnabled;
  String get nodeIconBrightness => _state.nodeIconBrightness;
  String get nodeBadgeKind => _state.nodeBadgeKind;
  double get nodeBadgeSize => _state.nodeBadgeSize;
  double get nodeBadgeOffset => _state.nodeBadgeOffset;
  String get nodeBadgeBrightness => _state.nodeBadgeBrightness;
  String get nodeLabelTitle => _state.nodeLabelTitle;
  String get nodeLabelSubtitle => _state.nodeLabelSubtitle;
  String get nodeLabelPlacement => _state.nodeLabelPlacement;
  String get nodeLabelEmphasis => _state.nodeLabelEmphasis;
  double get nodeLabelMaxWidth => _state.nodeLabelMaxWidth;
  bool get nodeLabelIsVisible => _state.nodeLabelIsVisible;
  String get nodeLabelBrightness => _state.nodeLabelBrightness;
  double get nodeProgressValue => _state.nodeProgressValue;
  String get nodeProgressState => _state.nodeProgressState;
  double get nodeProgressDiameter => _state.nodeProgressDiameter;
  double get nodeProgressStrokeWidth => _state.nodeProgressStrokeWidth;
  bool get nodeProgressShowLabel => _state.nodeProgressShowLabel;
  String get nodeProgressCompletedLabel => _state.nodeProgressCompletedLabel;
  String get nodeProgressBrightness => _state.nodeProgressBrightness;
  String get treeKind => _state.treeKind;
  double get treeScale => _state.treeScale;
  bool get treeSway => _state.treeSway;
  int get treeSwaySeed => _state.treeSwaySeed;
  String get treeBrightness => _state.treeBrightness;
  String get bushKind => _state.bushKind;
  double get bushScale => _state.bushScale;
  bool get bushSway => _state.bushSway;
  int get bushSwaySeed => _state.bushSwaySeed;
  String get bushBrightness => _state.bushBrightness;
  String get cloudKind => _state.cloudKind;
  double get cloudScale => _state.cloudScale;
  int get cloudSeed => _state.cloudSeed;
  String get cloudBrightness => _state.cloudBrightness;
  String get mountainLayer => _state.mountainLayer;
  String get mountainKind => _state.mountainKind;
  double get mountainScale => _state.mountainScale;
  String get mountainBrightness => _state.mountainBrightness;
  String get riverCurve => _state.riverCurve;
  double get riverHeight => _state.riverHeight;
  int get riverSeed => _state.riverSeed;
  String get riverBrightness => _state.riverBrightness;
  String get bridgeVariant => _state.bridgeVariant;
  double get bridgeScale => _state.bridgeScale;
  String get bridgeBrightness => _state.bridgeBrightness;
  String get pathBrightness => _state.pathBrightness;
  String get flagColor => _state.flagColor;
  double get flagScale => _state.flagScale;
  String get flagBrightness => _state.flagBrightness;
  String get particlesKind => _state.particlesKind;
  int get particlesCount => _state.particlesCount;
  int get particlesSeed => _state.particlesSeed;
  String get particlesBrightness => _state.particlesBrightness;
  int get particleLayerCount => _state.particleLayerCount;
  int get particleLayerSeed => _state.particleLayerSeed;
  String get particleLayerBrightness => _state.particleLayerBrightness;
  String get playgroundBuildingState => _state.playgroundBuildingState;
  String get playgroundBuildingTitle => _state.playgroundBuildingTitle;
  String get playgroundBuildingSubtitle => _state.playgroundBuildingSubtitle;
  double get playgroundBuildingProgress => _state.playgroundBuildingProgress;
  int get playgroundBuildingLevel => _state.playgroundBuildingLevel;
  bool get playgroundBuildingIsInteractive =>
      _state.playgroundBuildingIsInteractive;
  bool get playgroundBuildingShowLabel => _state.playgroundBuildingShowLabel;
  bool get playgroundBuildingShowProgress =>
      _state.playgroundBuildingShowProgress;
  String get playgroundBuildingLabelPlacement =>
      _state.playgroundBuildingLabelPlacement;
  String get playgroundBuildingLabelEmphasis =>
      _state.playgroundBuildingLabelEmphasis;
  String get playgroundBuildingProgressKind =>
      _state.playgroundBuildingProgressKind;
  double get playgroundBuildingScale => _state.playgroundBuildingScale;
  String get playgroundBuildingBrightness =>
      _state.playgroundBuildingBrightness;
  String get academyBuildingState => _state.academyBuildingState;
  double get academyBuildingProgress => _state.academyBuildingProgress;
  int get academyBuildingLevel => _state.academyBuildingLevel;
  bool get academyBuildingShowLabel => _state.academyBuildingShowLabel;
  bool get academyBuildingShowProgress => _state.academyBuildingShowProgress;
  String get academyBuildingLabelPlacement =>
      _state.academyBuildingLabelPlacement;
  String get academyBuildingLabelEmphasis =>
      _state.academyBuildingLabelEmphasis;
  String get academyBuildingProgressKind => _state.academyBuildingProgressKind;
  double get academyBuildingScale => _state.academyBuildingScale;
  String get academyBuildingBrightness => _state.academyBuildingBrightness;
  String get libraryBuildingState => _state.libraryBuildingState;
  double get libraryBuildingProgress => _state.libraryBuildingProgress;
  int get libraryBuildingLevel => _state.libraryBuildingLevel;
  bool get libraryBuildingShowLabel => _state.libraryBuildingShowLabel;
  bool get libraryBuildingShowProgress => _state.libraryBuildingShowProgress;
  String get libraryBuildingLabelPlacement =>
      _state.libraryBuildingLabelPlacement;
  String get libraryBuildingLabelEmphasis =>
      _state.libraryBuildingLabelEmphasis;
  String get libraryBuildingProgressKind => _state.libraryBuildingProgressKind;
  double get libraryBuildingScale => _state.libraryBuildingScale;
  String get libraryBuildingBrightness => _state.libraryBuildingBrightness;
  String get buildingLabelTitle => _state.buildingLabelTitle;
  String get buildingLabelSubtitle => _state.buildingLabelSubtitle;
  String get buildingLabelPlacement => _state.buildingLabelPlacement;
  String get buildingLabelEmphasis => _state.buildingLabelEmphasis;
  double get buildingLabelMaxWidth => _state.buildingLabelMaxWidth;
  bool get buildingLabelIsVisible => _state.buildingLabelIsVisible;
  String get buildingLabelBrightness => _state.buildingLabelBrightness;
  double get buildingProgressValue => _state.buildingProgressValue;
  String get buildingProgressKind => _state.buildingProgressKind;
  int get buildingProgressLevel => _state.buildingProgressLevel;
  double get buildingProgressSize => _state.buildingProgressSize;
  String get buildingProgressBrightness => _state.buildingProgressBrightness;
  String get playgroundProfileSummaryDisplayName =>
      _state.playgroundProfileSummaryDisplayName;
  int get playgroundProfileSummaryLevel => _state.playgroundProfileSummaryLevel;
  String get playgroundProfileSummaryInitials =>
      _state.playgroundProfileSummaryInitials;
  bool get playgroundProfileSummaryIsOnline =>
      _state.playgroundProfileSummaryIsOnline;
  bool get playgroundProfileSummaryIsPremium =>
      _state.playgroundProfileSummaryIsPremium;
  int get playgroundProfileSummaryNotificationCount =>
      _state.playgroundProfileSummaryNotificationCount;
  String? get playgroundProfileSummaryLeagueName =>
      _state.playgroundProfileSummaryLeagueName;
  String get playgroundProfileSummaryBrightness =>
      _state.playgroundProfileSummaryBrightness;
  int get playgroundXpIndicatorTotalXp => _state.playgroundXpIndicatorTotalXp;
  int get playgroundXpIndicatorUserLevel =>
      _state.playgroundXpIndicatorUserLevel;
  int get playgroundXpIndicatorXpInLevel =>
      _state.playgroundXpIndicatorXpInLevel;
  int get playgroundXpIndicatorXpForNextLevel =>
      _state.playgroundXpIndicatorXpForNextLevel;
  int get playgroundXpIndicatorGainDelta =>
      _state.playgroundXpIndicatorGainDelta;
  bool get playgroundXpIndicatorIsAnimatingGain =>
      _state.playgroundXpIndicatorIsAnimatingGain;
  int get playgroundCoinCounterBalance => _state.playgroundCoinCounterBalance;
  int get playgroundCoinCounterGainDelta =>
      _state.playgroundCoinCounterGainDelta;
  bool get playgroundCoinCounterIsAnimatingGain =>
      _state.playgroundCoinCounterIsAnimatingGain;
  int get playgroundEnergyIndicatorRemaining =>
      _state.playgroundEnergyIndicatorRemaining;
  int get playgroundEnergyIndicatorMax => _state.playgroundEnergyIndicatorMax;
  int get playgroundEnergyIndicatorRechargeSeconds =>
      _state.playgroundEnergyIndicatorRechargeSeconds;
  bool get playgroundEnergyIndicatorIsAnimatingRefill =>
      _state.playgroundEnergyIndicatorIsAnimatingRefill;
  int get playgroundStreakCardDays => _state.playgroundStreakCardDays;
  bool get playgroundStreakCardIsAtRisk => _state.playgroundStreakCardIsAtRisk;
  bool get playgroundStreakCardMilestoneReached =>
      _state.playgroundStreakCardMilestoneReached;
  String get playgroundTopBarBrightness => _state.playgroundTopBarBrightness;
  int get playgroundLevelProgressCardLevel =>
      _state.playgroundLevelProgressCardLevel;
  int get playgroundLevelProgressCardTotalStages =>
      _state.playgroundLevelProgressCardTotalStages;
  int get playgroundLevelProgressCardCompletedStages =>
      _state.playgroundLevelProgressCardCompletedStages;
  int get playgroundLevelProgressCardTotalStars =>
      _state.playgroundLevelProgressCardTotalStars;
  int get playgroundLevelProgressCardEarnedStars =>
      _state.playgroundLevelProgressCardEarnedStars;
  int get playgroundLevelProgressCardCurrentXP =>
      _state.playgroundLevelProgressCardCurrentXP;
  int get playgroundLevelProgressCardRequiredXP =>
      _state.playgroundLevelProgressCardRequiredXP;
  String get playgroundLevelProgressCardTitle =>
      _state.playgroundLevelProgressCardTitle;
  String get playgroundLevelProgressCardSubtitle =>
      _state.playgroundLevelProgressCardSubtitle;
  String get playgroundLevelProgressCardState =>
      _state.playgroundLevelProgressCardState;
  String get playgroundLevelProgressCardRewardKind =>
      _state.playgroundLevelProgressCardRewardKind;
  int get playgroundLevelProgressCardRewardAmount =>
      _state.playgroundLevelProgressCardRewardAmount;
  String get playgroundLevelProgressCardBrightness =>
      _state.playgroundLevelProgressCardBrightness;
  String get playgroundMissionCardTitle => _state.playgroundMissionCardTitle;
  String get playgroundMissionCardDescription =>
      _state.playgroundMissionCardDescription;
  int get playgroundMissionCardRequired => _state.playgroundMissionCardRequired;
  int get playgroundMissionCardProgress => _state.playgroundMissionCardProgress;
  String get playgroundMissionCardState => _state.playgroundMissionCardState;
  String get playgroundMissionCardTag => _state.playgroundMissionCardTag;
  String get playgroundMissionCardRewardKind =>
      _state.playgroundMissionCardRewardKind;
  int get playgroundMissionCardRewardAmount =>
      _state.playgroundMissionCardRewardAmount;
  int get playgroundMissionCardTimerSeconds =>
      _state.playgroundMissionCardTimerSeconds;
  String get playgroundMissionCardBrightness =>
      _state.playgroundMissionCardBrightness;

  int get playgroundCoinRewardAmount => _state.playgroundCoinRewardAmount;
  String get playgroundCoinRewardSize => _state.playgroundCoinRewardSize;
  String get playgroundCoinRewardLayout => _state.playgroundCoinRewardLayout;
  String get playgroundCoinRewardLabel => _state.playgroundCoinRewardLabel;
  bool get playgroundCoinRewardIsDark => _state.playgroundCoinRewardIsDark;
  String get playgroundCoinRewardRarity => _state.playgroundCoinRewardRarity;
  bool get playgroundCoinRewardShowGlow => _state.playgroundCoinRewardShowGlow;
  bool get playgroundCoinRewardShowSparkle =>
      _state.playgroundCoinRewardShowSparkle;
  bool get playgroundCoinRewardIsAnimating =>
      _state.playgroundCoinRewardIsAnimating;
  String get playgroundCoinRewardBrightness =>
      _state.playgroundCoinRewardBrightness;
  int get playgroundXpRewardAmount => _state.playgroundXpRewardAmount;
  String get playgroundXpRewardSize => _state.playgroundXpRewardSize;
  String get playgroundXpRewardLayout => _state.playgroundXpRewardLayout;
  String get playgroundXpRewardLabel => _state.playgroundXpRewardLabel;
  bool get playgroundXpRewardIsDark => _state.playgroundXpRewardIsDark;
  String get playgroundXpRewardRarity => _state.playgroundXpRewardRarity;
  bool get playgroundXpRewardShowGlow => _state.playgroundXpRewardShowGlow;
  bool get playgroundXpRewardShowSparkle =>
      _state.playgroundXpRewardShowSparkle;
  bool get playgroundXpRewardIsAnimating =>
      _state.playgroundXpRewardIsAnimating;
  bool get playgroundXpRewardIsLevelUp => _state.playgroundXpRewardIsLevelUp;
  String get playgroundXpRewardBrightness =>
      _state.playgroundXpRewardBrightness;
  String get playgroundRewardChestState => _state.playgroundRewardChestState;
  String get playgroundRewardChestSize => _state.playgroundRewardChestSize;
  bool get playgroundRewardChestIsDark => _state.playgroundRewardChestIsDark;
  String get playgroundRewardChestRarity => _state.playgroundRewardChestRarity;
  bool get playgroundRewardChestShowGlow =>
      _state.playgroundRewardChestShowGlow;
  bool get playgroundRewardChestAutoOpen =>
      _state.playgroundRewardChestAutoOpen;
  String get playgroundRewardChestBrightness =>
      _state.playgroundRewardChestBrightness;
  String get playgroundRewardPopupTitle => _state.playgroundRewardPopupTitle;
  String get playgroundRewardPopupSubtitle =>
      _state.playgroundRewardPopupSubtitle;
  String get playgroundRewardPopupPrimaryLabel =>
      _state.playgroundRewardPopupPrimaryLabel;
  String get playgroundRewardPopupSecondaryLabel =>
      _state.playgroundRewardPopupSecondaryLabel;
  bool get playgroundRewardPopupIsDark => _state.playgroundRewardPopupIsDark;
  String get playgroundRewardPopupRarity => _state.playgroundRewardPopupRarity;
  String get playgroundRewardPopupChestState =>
      _state.playgroundRewardPopupChestState;
  bool get playgroundRewardPopupAutoOpenChest =>
      _state.playgroundRewardPopupAutoOpenChest;
  int get playgroundRewardPopupEntryCount =>
      _state.playgroundRewardPopupEntryCount;
  String get playgroundRewardPopupBrightness =>
      _state.playgroundRewardPopupBrightness;
  String get playgroundRewardPopupEntry1Kind =>
      _state.playgroundRewardPopupEntry1Kind;
  int get playgroundRewardPopupEntry1Amount =>
      _state.playgroundRewardPopupEntry1Amount;
  String get playgroundRewardPopupEntry1Label =>
      _state.playgroundRewardPopupEntry1Label;
  String get playgroundRewardPopupEntry1Rarity =>
      _state.playgroundRewardPopupEntry1Rarity;
  String get playgroundRewardPopupEntry2Kind =>
      _state.playgroundRewardPopupEntry2Kind;
  int get playgroundRewardPopupEntry2Amount =>
      _state.playgroundRewardPopupEntry2Amount;
  String get playgroundRewardPopupEntry2Label =>
      _state.playgroundRewardPopupEntry2Label;
  String get playgroundRewardPopupEntry2Rarity =>
      _state.playgroundRewardPopupEntry2Rarity;
  String get playgroundRewardPopupEntry3Kind =>
      _state.playgroundRewardPopupEntry3Kind;
  int get playgroundRewardPopupEntry3Amount =>
      _state.playgroundRewardPopupEntry3Amount;
  String get playgroundRewardPopupEntry3Label =>
      _state.playgroundRewardPopupEntry3Label;
  String get playgroundRewardPopupEntry3Rarity =>
      _state.playgroundRewardPopupEntry3Rarity;
  String get playgroundRewardPopupEntry4Kind =>
      _state.playgroundRewardPopupEntry4Kind;
  int get playgroundRewardPopupEntry4Amount =>
      _state.playgroundRewardPopupEntry4Amount;
  String get playgroundRewardPopupEntry4Label =>
      _state.playgroundRewardPopupEntry4Label;
  String get playgroundRewardPopupEntry4Rarity =>
      _state.playgroundRewardPopupEntry4Rarity;
  String get playgroundBackgroundBiome => _state.playgroundBackgroundBiome;
  double get playgroundBackgroundParallaxOffset =>
      _state.playgroundBackgroundParallaxOffset;
  String get playgroundBackgroundBrightness =>
      _state.playgroundBackgroundBrightness;
  double get playgroundCameraZoom => _state.playgroundCameraZoom;
  String get playgroundCameraFocusTarget => _state.playgroundCameraFocusTarget;
  String get playgroundCameraBrightness => _state.playgroundCameraBrightness;
  String get playgroundLegendTitle => _state.playgroundLegendTitle;
  String get playgroundLegendBrightness => _state.playgroundLegendBrightness;
  double get playgroundScrollViewZoom => _state.playgroundScrollViewZoom;
  String get playgroundScrollViewFocusTarget =>
      _state.playgroundScrollViewFocusTarget;
  String get playgroundScrollViewBrightness =>
      _state.playgroundScrollViewBrightness;
  String get playgroundMapBiome => _state.playgroundMapBiome;
  bool get playgroundMapShowLegend => _state.playgroundMapShowLegend;
  String get playgroundMapFocusTarget => _state.playgroundMapFocusTarget;
  String get playgroundMapBrightness => _state.playgroundMapBrightness;

  /// Legacy setters for backward compatibility during refactoring
  set selection(WidgetBuilderSelection value) =>
      _controller.setSelection(value);
  set label(String value) => _controller.setLabel(value);
  set subtitle(String value) => _controller.setSubtitle(value);
  set showLeading(bool value) => _controller.setShowLeading(value);
  set showAccentStripe(bool value) => _controller.setShowAccentStripe(value);
  set loadingTitle(String value) => _controller.setLoadingTitle(value);
  set loadingSubtitle(String value) => _controller.setLoadingSubtitle(value);
  set showLoadingProgress(bool value) =>
      _controller.setShowLoadingProgress(value);
  set loadingProgressValue(double value) =>
      _controller.setLoadingProgressValue(value);
  set loaderType(String value) => _controller.setLoaderType(value);
  set badgeLabel(String value) => _controller.setBadgeLabel(value);
  set showBadgeIcon(bool value) => _controller.setShowBadgeIcon(value);
  set badgeStyle(String value) => _controller.setBadgeStyle(value);
  set enableBadgeAnimation(bool value) =>
      _controller.setEnableBadgeAnimation(value);
  set buttonText(String value) => _controller.setButtonText(value);
  set isButtonEnabled(bool value) => _controller.setIsButtonEnabled(value);
  set isButtonLoading(bool value) => _controller.setIsButtonLoading(value);
  set buttonVariant(String value) => _controller.setButtonVariant(value);
  set buttonSize(String value) => _controller.setButtonSize(value);
  set buttonShape(String value) => _controller.setButtonShape(value);
  set showButtonLeadingIcon(bool value) =>
      _controller.setShowButtonLeadingIcon(value);
  set showButtonTrailingIcon(bool value) =>
      _controller.setShowButtonTrailingIcon(value);
  set isButtonFullWidth(bool value) => _controller.setIsButtonFullWidth(value);
  set avatarSize(double value) => _controller.setAvatarSize(value);
  set avatarInitials(String value) => _controller.setAvatarInitials(value);
  set isAvatarOnline(bool value) => _controller.setIsAvatarOnline(value);
  set showAvatarPremium(bool value) => _controller.setShowAvatarPremium(value);
  set showAvatarVerified(bool value) =>
      _controller.setShowAvatarVerified(value);
  set showAvatarEdit(bool value) => _controller.setShowAvatarEdit(value);
  set simulatedDevice(String value) => _controller.setSimulatedDevice(value);
  set isSimulatedLandscape(bool value) =>
      _controller.setIsSimulatedLandscape(value);
  set secButtonText(String value) => _controller.setSecButtonText(value);
  set isSecButtonEnabled(bool value) =>
      _controller.setIsSecButtonEnabled(value);
  set isSecButtonLoading(bool value) =>
      _controller.setIsSecButtonLoading(value);
  set secButtonVariant(String value) => _controller.setSecButtonVariant(value);
  set secButtonSize(String value) => _controller.setSecButtonSize(value);
  set secButtonShape(String value) => _controller.setSecButtonShape(value);
  set showSecButtonLeadingIcon(bool value) =>
      _controller.setShowSecButtonLeadingIcon(value);
  set showSecButtonTrailingIcon(bool value) =>
      _controller.setShowSecButtonTrailingIcon(value);
  set isSecButtonFullWidth(bool value) =>
      _controller.setIsSecButtonFullWidth(value);
  set chipLabel(String value) => _controller.setChipLabel(value);
  set chipStatus(String value) => _controller.setChipStatus(value);
  set chipVariant(String value) => _controller.setChipVariant(value);
  set chipSize(String value) => _controller.setChipSize(value);
  set showChipIcon(bool value) => _controller.setShowChipIcon(value);
  set enableChipAnimation(bool value) =>
      _controller.setEnableChipAnimation(value);
  set currentStreakValue(int value) => _controller.setCurrentStreakValue(value);
  set longestStreakValue(int value) => _controller.setLongestStreakValue(value);
  set streakProgressValue(double value) =>
      _controller.setStreakProgressValue(value);
  set showWeeklyStreak(bool value) => _controller.setShowWeeklyStreak(value);
  set showStreakReward(bool value) => _controller.setShowStreakReward(value);
  set showStreakMilestone(bool value) =>
      _controller.setShowStreakMilestone(value);
  set enableStreakAnimation(bool value) =>
      _controller.setEnableStreakAnimation(value);
  set tagLabel(String value) => _controller.setTagLabel(value);
  set tagVariant(String value) => _controller.setTagVariant(value);
  set tagSize(String value) => _controller.setTagSize(value);
  set tagShape(String value) => _controller.setTagShape(value);
  set isTagSelected(bool value) => _controller.setIsTagSelected(value);
  set isTagEnabled(bool value) => _controller.setIsTagEnabled(value);
  set isTagClosable(bool value) => _controller.setIsTagClosable(value);
  set showTagLeadingIcon(bool value) =>
      _controller.setShowTagLeadingIcon(value);
  set showTagTrailingIcon(bool value) =>
      _controller.setShowTagTrailingIcon(value);
  set headerTitle(String value) => _controller.setHeaderTitle(value);
  set headerSubtitle(String value) => _controller.setHeaderSubtitle(value);
  set showHeaderSubtitle(bool value) =>
      _controller.setShowHeaderSubtitle(value);
  set showHeaderLeading(bool value) => _controller.setShowHeaderLeading(value);
  set showHeaderTrailing(bool value) =>
      _controller.setShowHeaderTrailing(value);
  set showHeaderDivider(bool value) => _controller.setShowHeaderDivider(value);
  set headerActionType(String value) => _controller.setHeaderActionType(value);
  set headerActionText(String value) => _controller.setHeaderActionText(value);
  set constantsSearchQuery(String value) =>
      _controller.setConstantsSearchQuery(value);
  set currentXPValue(int value) => _controller.setCurrentXPValue(value);
  set requiredXPValue(int value) => _controller.setRequiredXPValue(value);
  set currentLevelValue(int value) => _controller.setCurrentLevelValue(value);
  set nextLevelValue(int value) => _controller.setNextLevelValue(value);
  set xpBarVariant(String value) => _controller.setXpBarVariant(value);
  set showXPPercentage(bool value) => _controller.setShowXPPercentage(value);
  set showLevelBadge(bool value) => _controller.setShowLevelBadge(value);
  set showXPText(bool value) => _controller.setShowXPText(value);
  set showXPBarAnimation(bool value) =>
      _controller.setShowXPBarAnimation(value);
  set showXPBarGlow(bool value) => _controller.setShowXPBarGlow(value);
  set showXPBarIcon(bool value) => _controller.setShowXPBarIcon(value);
  set xpBarProgressValue(double value) =>
      _controller.setXpBarProgressValue(value);
  set errorType(String value) => _controller.setErrorType(value);
  set showErrorIllustration(bool value) =>
      _controller.setShowErrorIllustration(value);
  set showErrorIcon(bool value) => _controller.setShowErrorIcon(value);
  set showErrorRetryButton(bool value) =>
      _controller.setShowErrorRetryButton(value);
  set isErrorLoading(bool value) => _controller.setIsErrorLoading(value);
  set errorRetryText(String value) => _controller.setErrorRetryText(value);
  set cardTitle(String value) => _controller.setCardTitle(value);
  set cardSubtitle(String value) => _controller.setCardSubtitle(value);
  set cardAnimationType(String value) =>
      _controller.setCardAnimationType(value);
  set cardVariant(String value) => _controller.setCardVariant(value);
  set enableCardHover(bool value) => _controller.setEnableCardHover(value);
  set enableCardGlow(bool value) => _controller.setEnableCardGlow(value);
  set enableCardGlass(bool value) => _controller.setEnableCardGlass(value);

  set aiExpTitle(String value) => _controller.setAiExpTitle(value);
  set aiExpSubtitle(String value) => _controller.setAiExpSubtitle(value);
  set aiExpBadgeLabel(String value) => _controller.setAiExpBadgeLabel(value);
  set aiExpTone(String value) => _controller.setAiExpTone(value);
  set aiExpShowBadge(bool value) => _controller.setAiExpShowBadge(value);
  set aiExpShowActions(bool value) => _controller.setAiExpShowActions(value);
  set aiExpExpanded(bool value) => _controller.setAiExpExpanded(value);
  set aiExpCanExpand(bool value) => _controller.setAiExpCanExpand(value);
  set aiExpLongContent(bool value) => _controller.setAiExpLongContent(value);

  set aiHintTitle(String value) => _controller.setAiHintTitle(value);
  set aiHintText(String value) => _controller.setAiHintText(value);
  set aiHintType(String value) => _controller.setAiHintType(value);
  set aiHintDifficulty(String value) => _controller.setAiHintDifficulty(value);
  set aiHintTopic(String? value) => _controller.setAiHintTopic(value);
  set aiHintQuickTip(String? value) => _controller.setAiHintQuickTip(value);
  set aiHintShowBadge(bool value) => _controller.setAiHintShowBadge(value);
  set aiHintShowActions(bool value) => _controller.setAiHintShowActions(value);
  set aiHintIsBookmarked(bool value) =>
      _controller.setAiHintIsBookmarked(value);
  set aiHintBadgeText(String? value) => _controller.setAiHintBadgeText(value);

  set aiHistoryHeaderTitle(String value) =>
      _controller.setAiHistoryHeaderTitle(value);
  set aiHistoryHeaderSubtitle(String value) =>
      _controller.setAiHistoryHeaderSubtitle(value);
  set aiHistoryState(String value) => _controller.setAiHistoryState(value);
  set aiHistoryShowCategory(bool value) =>
      _controller.setAiHistoryShowCategory(value);
  set aiHistoryShowTimestamp(bool value) =>
      _controller.setAiHistoryShowTimestamp(value);
  set aiHistoryShowPremiumBadge(bool value) =>
      _controller.setAiHistoryShowPremiumBadge(value);
  set aiHistoryShowFavorite(bool value) =>
      _controller.setAiHistoryShowFavorite(value);
  set aiHistoryShowPinned(bool value) =>
      _controller.setAiHistoryShowPinned(value);
  set aiHistoryShowLeadingChevron(bool value) =>
      _controller.setAiHistoryShowLeadingChevron(value);
  set aiHistoryShowHeader(bool value) =>
      _controller.setAiHistoryShowHeader(value);
  set aiHistoryShowViewAll(bool value) =>
      _controller.setAiHistoryShowViewAll(value);
  set aiHistoryLoadingItemCount(int value) =>
      _controller.setAiHistoryLoadingItemCount(value);
  set aiHistoryTileTitle(String value) =>
      _controller.setAiHistoryTileTitle(value);
  set aiHistoryTilePreview(String value) =>
      _controller.setAiHistoryTilePreview(value);
  set aiHistoryTileTimestamp(String value) =>
      _controller.setAiHistoryTileTimestamp(value);
  set aiHistoryTileSubtitle(String? value) =>
      _controller.setAiHistoryTileSubtitle(value);
  set aiHistoryTileCategory(String? value) =>
      _controller.setAiHistoryTileCategory(value);
  set aiHistoryTileEntryType(String value) =>
      _controller.setAiHistoryTileEntryType(value);
  set aiHistoryTileBrightness(String value) =>
      _controller.setAiHistoryTileBrightness(value);
  set aiHistoryTileShowCategory(bool value) =>
      _controller.setAiHistoryTileShowCategory(value);
  set aiHistoryTileShowTimestamp(bool value) =>
      _controller.setAiHistoryTileShowTimestamp(value);
  set aiHistoryTileShowPremiumBadge(bool value) =>
      _controller.setAiHistoryTileShowPremiumBadge(value);
  set aiHistoryTileShowFavorite(bool value) =>
      _controller.setAiHistoryTileShowFavorite(value);
  set aiHistoryTileShowPinned(bool value) =>
      _controller.setAiHistoryTileShowPinned(value);
  set aiHistoryTileShowLeadingChevron(bool value) =>
      _controller.setAiHistoryTileShowLeadingChevron(value);
  set aiHistoryTileDense(bool value) =>
      _controller.setAiHistoryTileDense(value);
  set aiHistoryTileIsFavorite(bool value) =>
      _controller.setAiHistoryTileIsFavorite(value);
  set aiHistoryTileIsPinned(bool value) =>
      _controller.setAiHistoryTileIsPinned(value);
  set aiHistoryTileIsPremium(bool value) =>
      _controller.setAiHistoryTileIsPremium(value);
  set aiHistoryTileIsUnread(bool value) =>
      _controller.setAiHistoryTileIsUnread(value);
  set aiLoadingCardBrightness(String value) =>
      _controller.setAiLoadingCardBrightness(value);
  set aiLoadingCardBodyLineCount(int value) =>
      _controller.setAiLoadingCardBodyLineCount(value);
  set aiLoadingCardElevation(double value) =>
      _controller.setAiLoadingCardElevation(value);
  set aiLoadingCardAnimationEnabled(bool value) =>
      _controller.setAiLoadingCardAnimationEnabled(value);
  set aiLoadingCardShowAvatar(bool value) =>
      _controller.setAiLoadingCardShowAvatar(value);
  set aiLoadingCardShowTitle(bool value) =>
      _controller.setAiLoadingCardShowTitle(value);
  set aiLoadingCardShowSubtitle(bool value) =>
      _controller.setAiLoadingCardShowSubtitle(value);
  set aiLoadingCardShowBody(bool value) =>
      _controller.setAiLoadingCardShowBody(value);
  set aiLoadingCardShowFooter(bool value) =>
      _controller.setAiLoadingCardShowFooter(value);
  set aiLoadingCardSemanticLabel(String? value) =>
      _controller.setAiLoadingCardSemanticLabel(value);
  set aiResponseTitle(String value) => _controller.setAiResponseTitle(value);
  set aiResponseSubtitle(String value) =>
      _controller.setAiResponseSubtitle(value);
  set aiResponseType(String value) => _controller.setAiResponseType(value);
  set aiResponseBadgeLabel(String value) =>
      _controller.setAiResponseBadgeLabel(value);
  set aiResponseBody(String value) => _controller.setAiResponseBody(value);
  set aiResponseMarkdown(bool value) =>
      _controller.setAiResponseMarkdown(value);
  set aiResponseSelectable(bool value) =>
      _controller.setAiResponseSelectable(value);
  set aiResponseShowBadge(bool value) =>
      _controller.setAiResponseShowBadge(value);
  set aiResponseShowMetadata(bool value) =>
      _controller.setAiResponseShowMetadata(value);
  set aiResponseShowActions(bool value) =>
      _controller.setAiResponseShowActions(value);
  set aiResponseMetadataModel(String value) =>
      _controller.setAiResponseMetadataModel(value);
  set aiResponseMetadataTimestamp(String value) =>
      _controller.setAiResponseMetadataTimestamp(value);
  set aiResponseMetadataCategory(String value) =>
      _controller.setAiResponseMetadataCategory(value);
  set aiResponseMetadataConfidence(String value) =>
      _controller.setAiResponseMetadataConfidence(value);
  set aiResponseMetadataStatus(String value) =>
      _controller.setAiResponseMetadataStatus(value);
  set aiResponseActionCopy(bool value) =>
      _controller.setAiResponseActionCopy(value);
  set aiResponseActionShare(bool value) =>
      _controller.setAiResponseActionShare(value);
  set aiResponseActionRegenerate(bool value) =>
      _controller.setAiResponseActionRegenerate(value);
  set aiResponseActionFavorite(bool value) =>
      _controller.setAiResponseActionFavorite(value);
  set aiResponseActionLike(bool value) =>
      _controller.setAiResponseActionLike(value);
  set aiResponseActionDislike(bool value) =>
      _controller.setAiResponseActionDislike(value);
  set aiResponseActionFavoriteActive(bool value) =>
      _controller.setAiResponseActionFavoriteActive(value);
  set aiResponseActionLikeActive(bool value) =>
      _controller.setAiResponseActionLikeActive(value);
  set aiResponseActionDislikeActive(bool value) =>
      _controller.setAiResponseActionDislikeActive(value);
  set aiResponseCanExpand(bool value) =>
      _controller.setAiResponseCanExpand(value);
  set aiResponseExpanded(bool value) =>
      _controller.setAiResponseExpanded(value);

  set playgroundNodeRingKind(String value) =>
      _controller.setPlaygroundNodeRingKind(value);
  set playgroundNodeRingState(String value) =>
      _controller.setPlaygroundNodeRingState(value);
  set playgroundNodeDiameter(double value) =>
      _controller.setPlaygroundNodeDiameter(value);
  set playgroundNodeIconKind(String value) =>
      _controller.setPlaygroundNodeIconKind(value);
  set playgroundNodeIconVariant(String value) =>
      _controller.setPlaygroundNodeIconVariant(value);
  set playgroundNodeProgress(double value) =>
      _controller.setPlaygroundNodeProgress(value);
  set playgroundNodeProgressState(String value) =>
      _controller.setPlaygroundNodeProgressState(value);
  set playgroundNodeTitle(String value) =>
      _controller.setPlaygroundNodeTitle(value);
  set playgroundNodeSubtitle(String value) =>
      _controller.setPlaygroundNodeSubtitle(value);
  set playgroundNodeShowProgress(bool value) =>
      _controller.setPlaygroundNodeShowProgress(value);
  set playgroundNodeShowLabel(bool value) =>
      _controller.setPlaygroundNodeShowLabel(value);
  set playgroundNodeShowBadge(bool value) =>
      _controller.setPlaygroundNodeShowBadge(value);
  set playgroundNodeBadgeKind(String value) =>
      _controller.setPlaygroundNodeBadgeKind(value);
  set playgroundNodeLabelPlacement(String value) =>
      _controller.setPlaygroundNodeLabelPlacement(value);
  set playgroundNodeLabelEmphasis(String value) =>
      _controller.setPlaygroundNodeLabelEmphasis(value);
  set playgroundNodeIsInteractive(bool value) =>
      _controller.setPlaygroundNodeIsInteractive(value);
  set playgroundNodeBrightness(String value) =>
      _controller.setPlaygroundNodeBrightness(value);
  set nodeRingState(String value) => _controller.setNodeRingState(value);
  set nodeRingKind(String value) => _controller.setNodeRingKind(value);
  set nodeRingDiameter(double value) => _controller.setNodeRingDiameter(value);
  set nodeRingStrokeWidth(double value) =>
      _controller.setNodeRingStrokeWidth(value);
  set nodeRingGlow(bool value) => _controller.setNodeRingGlow(value);
  set nodeRingIsAnimated(bool value) =>
      _controller.setNodeRingIsAnimated(value);
  set nodeRingBrightness(String value) =>
      _controller.setNodeRingBrightness(value);
  set nodeIconKind(String value) => _controller.setNodeIconKind(value);
  set nodeIconVariant(String value) => _controller.setNodeIconVariant(value);
  set nodeIconSize(double value) => _controller.setNodeIconSize(value);
  set nodeIconIsEnabled(bool value) => _controller.setNodeIconIsEnabled(value);
  set nodeIconBrightness(String value) =>
      _controller.setNodeIconBrightness(value);
  set nodeBadgeKind(String value) => _controller.setNodeBadgeKind(value);
  set nodeBadgeSize(double value) => _controller.setNodeBadgeSize(value);
  set nodeBadgeOffset(double value) => _controller.setNodeBadgeOffset(value);
  set nodeBadgeBrightness(String value) =>
      _controller.setNodeBadgeBrightness(value);
  set nodeLabelTitle(String value) => _controller.setNodeLabelTitle(value);
  set nodeLabelSubtitle(String value) =>
      _controller.setNodeLabelSubtitle(value);
  set nodeLabelPlacement(String value) =>
      _controller.setNodeLabelPlacement(value);
  set nodeLabelEmphasis(String value) =>
      _controller.setNodeLabelEmphasis(value);
  set nodeLabelMaxWidth(double value) =>
      _controller.setNodeLabelMaxWidth(value);
  set nodeLabelIsVisible(bool value) =>
      _controller.setNodeLabelIsVisible(value);
  set nodeLabelBrightness(String value) =>
      _controller.setNodeLabelBrightness(value);
  set nodeProgressValue(double value) =>
      _controller.setNodeProgressValue(value);
  set nodeProgressState(String value) =>
      _controller.setNodeProgressState(value);
  set nodeProgressDiameter(double value) =>
      _controller.setNodeProgressDiameter(value);
  set nodeProgressStrokeWidth(double value) =>
      _controller.setNodeProgressStrokeWidth(value);
  set nodeProgressShowLabel(bool value) =>
      _controller.setNodeProgressShowLabel(value);
  set nodeProgressCompletedLabel(String value) =>
      _controller.setNodeProgressCompletedLabel(value);
  set nodeProgressBrightness(String value) =>
      _controller.setNodeProgressBrightness(value);
  set treeKind(String value) => _controller.setTreeKind(value);
  set treeScale(double value) => _controller.setTreeScale(value);
  set treeSway(bool value) => _controller.setTreeSway(value);
  set treeSwaySeed(int value) => _controller.setTreeSwaySeed(value);
  set treeBrightness(String value) => _controller.setTreeBrightness(value);
  set bushKind(String value) => _controller.setBushKind(value);
  set bushScale(double value) => _controller.setBushScale(value);
  set bushSway(bool value) => _controller.setBushSway(value);
  set bushSwaySeed(int value) => _controller.setBushSwaySeed(value);
  set bushBrightness(String value) => _controller.setBushBrightness(value);
  set cloudKind(String value) => _controller.setCloudKind(value);
  set cloudScale(double value) => _controller.setCloudScale(value);
  set cloudSeed(int value) => _controller.setCloudSeed(value);
  set cloudBrightness(String value) => _controller.setCloudBrightness(value);
  set mountainLayer(String value) => _controller.setMountainLayer(value);
  set mountainKind(String value) => _controller.setMountainKind(value);
  set mountainScale(double value) => _controller.setMountainScale(value);
  set mountainBrightness(String value) =>
      _controller.setMountainBrightness(value);
  set riverCurve(String value) => _controller.setRiverCurve(value);
  set riverHeight(double value) => _controller.setRiverHeight(value);
  set riverSeed(int value) => _controller.setRiverSeed(value);
  set riverBrightness(String value) => _controller.setRiverBrightness(value);
  set bridgeVariant(String value) => _controller.setBridgeVariant(value);
  set bridgeScale(double value) => _controller.setBridgeScale(value);
  set bridgeBrightness(String value) => _controller.setBridgeBrightness(value);
  set pathBrightness(String value) => _controller.setPathBrightness(value);
  set flagColor(String value) => _controller.setFlagColor(value);
  set flagScale(double value) => _controller.setFlagScale(value);
  set flagBrightness(String value) => _controller.setFlagBrightness(value);
  set particlesKind(String value) => _controller.setParticlesKind(value);
  set particlesCount(int value) => _controller.setParticlesCount(value);
  set particlesSeed(int value) => _controller.setParticlesSeed(value);
  set particlesBrightness(String value) =>
      _controller.setParticlesBrightness(value);
  set particleLayerCount(int value) => _controller.setParticleLayerCount(value);
  set particleLayerSeed(int value) => _controller.setParticleLayerSeed(value);
  set particleLayerBrightness(String value) =>
      _controller.setParticleLayerBrightness(value);
  set playgroundBuildingState(String value) =>
      _controller.setPlaygroundBuildingState(value);
  set playgroundBuildingTitle(String value) =>
      _controller.setPlaygroundBuildingTitle(value);
  set playgroundBuildingSubtitle(String value) =>
      _controller.setPlaygroundBuildingSubtitle(value);
  set playgroundBuildingProgress(double value) =>
      _controller.setPlaygroundBuildingProgress(value);
  set playgroundBuildingLevel(int value) =>
      _controller.setPlaygroundBuildingLevel(value);
  set playgroundBuildingIsInteractive(bool value) =>
      _controller.setPlaygroundBuildingIsInteractive(value);
  set playgroundBuildingShowLabel(bool value) =>
      _controller.setPlaygroundBuildingShowLabel(value);
  set playgroundBuildingShowProgress(bool value) =>
      _controller.setPlaygroundBuildingShowProgress(value);
  set playgroundBuildingLabelPlacement(String value) =>
      _controller.setPlaygroundBuildingLabelPlacement(value);
  set playgroundBuildingLabelEmphasis(String value) =>
      _controller.setPlaygroundBuildingLabelEmphasis(value);
  set playgroundBuildingProgressKind(String value) =>
      _controller.setPlaygroundBuildingProgressKind(value);
  set playgroundBuildingScale(double value) =>
      _controller.setPlaygroundBuildingScale(value);
  set playgroundBuildingBrightness(String value) =>
      _controller.setPlaygroundBuildingBrightness(value);
  set academyBuildingState(String value) =>
      _controller.setAcademyBuildingState(value);
  set academyBuildingProgress(double value) =>
      _controller.setAcademyBuildingProgress(value);
  set academyBuildingLevel(int value) =>
      _controller.setAcademyBuildingLevel(value);
  set academyBuildingShowLabel(bool value) =>
      _controller.setAcademyBuildingShowLabel(value);
  set academyBuildingShowProgress(bool value) =>
      _controller.setAcademyBuildingShowProgress(value);
  set academyBuildingLabelPlacement(String value) =>
      _controller.setAcademyBuildingLabelPlacement(value);
  set academyBuildingLabelEmphasis(String value) =>
      _controller.setAcademyBuildingLabelEmphasis(value);
  set academyBuildingProgressKind(String value) =>
      _controller.setAcademyBuildingProgressKind(value);
  set academyBuildingScale(double value) =>
      _controller.setAcademyBuildingScale(value);
  set academyBuildingBrightness(String value) =>
      _controller.setAcademyBuildingBrightness(value);
  set libraryBuildingState(String value) =>
      _controller.setLibraryBuildingState(value);
  set libraryBuildingProgress(double value) =>
      _controller.setLibraryBuildingProgress(value);
  set libraryBuildingLevel(int value) =>
      _controller.setLibraryBuildingLevel(value);
  set libraryBuildingShowLabel(bool value) =>
      _controller.setLibraryBuildingShowLabel(value);
  set libraryBuildingShowProgress(bool value) =>
      _controller.setLibraryBuildingShowProgress(value);
  set libraryBuildingLabelPlacement(String value) =>
      _controller.setLibraryBuildingLabelPlacement(value);
  set libraryBuildingLabelEmphasis(String value) =>
      _controller.setLibraryBuildingLabelEmphasis(value);
  set libraryBuildingProgressKind(String value) =>
      _controller.setLibraryBuildingProgressKind(value);
  set libraryBuildingScale(double value) =>
      _controller.setLibraryBuildingScale(value);
  set libraryBuildingBrightness(String value) =>
      _controller.setLibraryBuildingBrightness(value);
  set buildingLabelTitle(String value) =>
      _controller.setBuildingLabelTitle(value);
  set buildingLabelSubtitle(String value) =>
      _controller.setBuildingLabelSubtitle(value);
  set buildingLabelPlacement(String value) =>
      _controller.setBuildingLabelPlacement(value);
  set buildingLabelEmphasis(String value) =>
      _controller.setBuildingLabelEmphasis(value);
  set buildingLabelMaxWidth(double value) =>
      _controller.setBuildingLabelMaxWidth(value);
  set buildingLabelIsVisible(bool value) =>
      _controller.setBuildingLabelIsVisible(value);
  set buildingLabelBrightness(String value) =>
      _controller.setBuildingLabelBrightness(value);
  set buildingProgressValue(double value) =>
      _controller.setBuildingProgressValue(value);
  set buildingProgressKind(String value) =>
      _controller.setBuildingProgressKind(value);
  set buildingProgressLevel(int value) =>
      _controller.setBuildingProgressLevel(value);
  set buildingProgressSize(double value) =>
      _controller.setBuildingProgressSize(value);
  set buildingProgressBrightness(String value) =>
      _controller.setBuildingProgressBrightness(value);
  set playgroundProfileSummaryDisplayName(String value) =>
      _controller.setPlaygroundProfileSummaryDisplayName(value);
  set playgroundProfileSummaryLevel(int value) =>
      _controller.setPlaygroundProfileSummaryLevel(value);
  set playgroundProfileSummaryInitials(String value) =>
      _controller.setPlaygroundProfileSummaryInitials(value);
  set playgroundProfileSummaryIsOnline(bool value) =>
      _controller.setPlaygroundProfileSummaryIsOnline(value);
  set playgroundProfileSummaryIsPremium(bool value) =>
      _controller.setPlaygroundProfileSummaryIsPremium(value);
  set playgroundProfileSummaryNotificationCount(int value) =>
      _controller.setPlaygroundProfileSummaryNotificationCount(value);
  set playgroundProfileSummaryLeagueName(String value) =>
      _controller.setPlaygroundProfileSummaryLeagueName(value);
  set playgroundProfileSummaryBrightness(String value) =>
      _controller.setPlaygroundProfileSummaryBrightness(value);
  set playgroundXpIndicatorTotalXp(int value) =>
      _controller.setPlaygroundXpIndicatorTotalXp(value);
  set playgroundXpIndicatorUserLevel(int value) =>
      _controller.setPlaygroundXpIndicatorUserLevel(value);
  set playgroundXpIndicatorXpInLevel(int value) =>
      _controller.setPlaygroundXpIndicatorXpInLevel(value);
  set playgroundXpIndicatorXpForNextLevel(int value) =>
      _controller.setPlaygroundXpIndicatorXpForNextLevel(value);
  set playgroundXpIndicatorGainDelta(int value) =>
      _controller.setPlaygroundXpIndicatorGainDelta(value);
  set playgroundXpIndicatorIsAnimatingGain(bool value) =>
      _controller.setPlaygroundXpIndicatorIsAnimatingGain(value);
  set playgroundCoinCounterBalance(int value) =>
      _controller.setPlaygroundCoinCounterBalance(value);
  set playgroundCoinCounterGainDelta(int value) =>
      _controller.setPlaygroundCoinCounterGainDelta(value);
  set playgroundCoinCounterIsAnimatingGain(bool value) =>
      _controller.setPlaygroundCoinCounterIsAnimatingGain(value);
  set playgroundEnergyIndicatorRemaining(int value) =>
      _controller.setPlaygroundEnergyIndicatorRemaining(value);
  set playgroundEnergyIndicatorMax(int value) =>
      _controller.setPlaygroundEnergyIndicatorMax(value);
  set playgroundEnergyIndicatorRechargeSeconds(int value) =>
      _controller.setPlaygroundEnergyIndicatorRechargeSeconds(value);
  set playgroundEnergyIndicatorIsAnimatingRefill(bool value) =>
      _controller.setPlaygroundEnergyIndicatorIsAnimatingRefill(value);
  set playgroundStreakCardDays(int value) =>
      _controller.setPlaygroundStreakCardDays(value);
  set playgroundStreakCardIsAtRisk(bool value) =>
      _controller.setPlaygroundStreakCardIsAtRisk(value);
  set playgroundStreakCardMilestoneReached(bool value) =>
      _controller.setPlaygroundStreakCardMilestoneReached(value);
  set playgroundTopBarBrightness(String value) =>
      _controller.setPlaygroundTopBarBrightness(value);
  set playgroundLevelProgressCardLevel(int value) =>
      _controller.setPlaygroundLevelProgressCardLevel(value);
  set playgroundLevelProgressCardTotalStages(int value) =>
      _controller.setPlaygroundLevelProgressCardTotalStages(value);
  set playgroundLevelProgressCardCompletedStages(int value) =>
      _controller.setPlaygroundLevelProgressCardCompletedStages(value);
  set playgroundLevelProgressCardTotalStars(int value) =>
      _controller.setPlaygroundLevelProgressCardTotalStars(value);
  set playgroundLevelProgressCardEarnedStars(int value) =>
      _controller.setPlaygroundLevelProgressCardEarnedStars(value);
  set playgroundLevelProgressCardCurrentXP(int value) =>
      _controller.setPlaygroundLevelProgressCardCurrentXP(value);
  set playgroundLevelProgressCardRequiredXP(int value) =>
      _controller.setPlaygroundLevelProgressCardRequiredXP(value);
  set playgroundLevelProgressCardTitle(String value) =>
      _controller.setPlaygroundLevelProgressCardTitle(value);
  set playgroundLevelProgressCardSubtitle(String value) =>
      _controller.setPlaygroundLevelProgressCardSubtitle(value);
  set playgroundLevelProgressCardState(String value) =>
      _controller.setPlaygroundLevelProgressCardState(value);
  set playgroundLevelProgressCardRewardKind(String value) =>
      _controller.setPlaygroundLevelProgressCardRewardKind(value);
  set playgroundLevelProgressCardRewardAmount(int value) =>
      _controller.setPlaygroundLevelProgressCardRewardAmount(value);
  set playgroundLevelProgressCardBrightness(String value) =>
      _controller.setPlaygroundLevelProgressCardBrightness(value);
  set playgroundMissionCardTitle(String value) =>
      _controller.setPlaygroundMissionCardTitle(value);
  set playgroundMissionCardDescription(String value) =>
      _controller.setPlaygroundMissionCardDescription(value);
  set playgroundMissionCardRequired(int value) =>
      _controller.setPlaygroundMissionCardRequired(value);
  set playgroundMissionCardProgress(int value) =>
      _controller.setPlaygroundMissionCardProgress(value);
  set playgroundMissionCardState(String value) =>
      _controller.setPlaygroundMissionCardState(value);
  set playgroundMissionCardTag(String value) =>
      _controller.setPlaygroundMissionCardTag(value);
  set playgroundMissionCardRewardKind(String value) =>
      _controller.setPlaygroundMissionCardRewardKind(value);
  set playgroundMissionCardRewardAmount(int value) =>
      _controller.setPlaygroundMissionCardRewardAmount(value);
  set playgroundMissionCardTimerSeconds(int value) =>
      _controller.setPlaygroundMissionCardTimerSeconds(value);
  set playgroundMissionCardBrightness(String value) =>
      _controller.setPlaygroundMissionCardBrightness(value);
  set playgroundCoinRewardAmount(int value) =>
      _controller.setPlaygroundCoinRewardAmount(value);
  set playgroundCoinRewardSize(String value) =>
      _controller.setPlaygroundCoinRewardSize(value);
  set playgroundCoinRewardLayout(String value) =>
      _controller.setPlaygroundCoinRewardLayout(value);
  set playgroundCoinRewardLabel(String value) =>
      _controller.setPlaygroundCoinRewardLabel(value);
  set playgroundCoinRewardIsDark(bool value) =>
      _controller.setPlaygroundCoinRewardIsDark(value);
  set playgroundCoinRewardRarity(String value) =>
      _controller.setPlaygroundCoinRewardRarity(value);
  set playgroundCoinRewardShowGlow(bool value) =>
      _controller.setPlaygroundCoinRewardShowGlow(value);
  set playgroundCoinRewardShowSparkle(bool value) =>
      _controller.setPlaygroundCoinRewardShowSparkle(value);
  set playgroundCoinRewardIsAnimating(bool value) =>
      _controller.setPlaygroundCoinRewardIsAnimating(value);
  set playgroundCoinRewardBrightness(String value) =>
      _controller.setPlaygroundCoinRewardBrightness(value);
  set playgroundXpRewardAmount(int value) =>
      _controller.setPlaygroundXpRewardAmount(value);
  set playgroundXpRewardSize(String value) =>
      _controller.setPlaygroundXpRewardSize(value);
  set playgroundXpRewardLayout(String value) =>
      _controller.setPlaygroundXpRewardLayout(value);
  set playgroundXpRewardLabel(String value) =>
      _controller.setPlaygroundXpRewardLabel(value);
  set playgroundXpRewardIsDark(bool value) =>
      _controller.setPlaygroundXpRewardIsDark(value);
  set playgroundXpRewardRarity(String value) =>
      _controller.setPlaygroundXpRewardRarity(value);
  set playgroundXpRewardShowGlow(bool value) =>
      _controller.setPlaygroundXpRewardShowGlow(value);
  set playgroundXpRewardShowSparkle(bool value) =>
      _controller.setPlaygroundXpRewardShowSparkle(value);
  set playgroundXpRewardIsAnimating(bool value) =>
      _controller.setPlaygroundXpRewardIsAnimating(value);
  set playgroundXpRewardIsLevelUp(bool value) =>
      _controller.setPlaygroundXpRewardIsLevelUp(value);
  set playgroundXpRewardBrightness(String value) =>
      _controller.setPlaygroundXpRewardBrightness(value);
  set playgroundRewardChestState(String value) =>
      _controller.setPlaygroundRewardChestState(value);
  set playgroundRewardChestSize(String value) =>
      _controller.setPlaygroundRewardChestSize(value);
  set playgroundRewardChestIsDark(bool value) =>
      _controller.setPlaygroundRewardChestIsDark(value);
  set playgroundRewardChestRarity(String value) =>
      _controller.setPlaygroundRewardChestRarity(value);
  set playgroundRewardChestShowGlow(bool value) =>
      _controller.setPlaygroundRewardChestShowGlow(value);
  set playgroundRewardChestAutoOpen(bool value) =>
      _controller.setPlaygroundRewardChestAutoOpen(value);
  set playgroundRewardChestBrightness(String value) =>
      _controller.setPlaygroundRewardChestBrightness(value);
  set playgroundRewardPopupTitle(String value) =>
      _controller.setPlaygroundRewardPopupTitle(value);
  set playgroundRewardPopupSubtitle(String value) =>
      _controller.setPlaygroundRewardPopupSubtitle(value);
  set playgroundRewardPopupPrimaryLabel(String value) =>
      _controller.setPlaygroundRewardPopupPrimaryLabel(value);
  set playgroundRewardPopupSecondaryLabel(String value) =>
      _controller.setPlaygroundRewardPopupSecondaryLabel(value);
  set playgroundRewardPopupIsDark(bool value) =>
      _controller.setPlaygroundRewardPopupIsDark(value);
  set playgroundRewardPopupRarity(String value) =>
      _controller.setPlaygroundRewardPopupRarity(value);
  set playgroundRewardPopupChestState(String value) =>
      _controller.setPlaygroundRewardPopupChestState(value);
  set playgroundRewardPopupAutoOpenChest(bool value) =>
      _controller.setPlaygroundRewardPopupAutoOpenChest(value);
  set playgroundRewardPopupEntryCount(int value) =>
      _controller.setPlaygroundRewardPopupEntryCount(value);
  set playgroundRewardPopupBrightness(String value) =>
      _controller.setPlaygroundRewardPopupBrightness(value);
  set playgroundRewardPopupEntry1Kind(String value) =>
      _controller.setPlaygroundRewardPopupEntry1Kind(value);
  set playgroundRewardPopupEntry1Amount(int value) =>
      _controller.setPlaygroundRewardPopupEntry1Amount(value);
  set playgroundRewardPopupEntry1Label(String value) =>
      _controller.setPlaygroundRewardPopupEntry1Label(value);
  set playgroundRewardPopupEntry1Rarity(String value) =>
      _controller.setPlaygroundRewardPopupEntry1Rarity(value);
  set playgroundRewardPopupEntry2Kind(String value) =>
      _controller.setPlaygroundRewardPopupEntry2Kind(value);
  set playgroundRewardPopupEntry2Amount(int value) =>
      _controller.setPlaygroundRewardPopupEntry2Amount(value);
  set playgroundRewardPopupEntry2Label(String value) =>
      _controller.setPlaygroundRewardPopupEntry2Label(value);
  set playgroundRewardPopupEntry2Rarity(String value) =>
      _controller.setPlaygroundRewardPopupEntry2Rarity(value);
  set playgroundRewardPopupEntry3Kind(String value) =>
      _controller.setPlaygroundRewardPopupEntry3Kind(value);
  set playgroundRewardPopupEntry3Amount(int value) =>
      _controller.setPlaygroundRewardPopupEntry3Amount(value);
  set playgroundRewardPopupEntry3Label(String value) =>
      _controller.setPlaygroundRewardPopupEntry3Label(value);
  set playgroundRewardPopupEntry3Rarity(String value) =>
      _controller.setPlaygroundRewardPopupEntry3Rarity(value);
  set playgroundRewardPopupEntry4Kind(String value) =>
      _controller.setPlaygroundRewardPopupEntry4Kind(value);
  set playgroundRewardPopupEntry4Amount(int value) =>
      _controller.setPlaygroundRewardPopupEntry4Amount(value);
  set playgroundRewardPopupEntry4Label(String value) =>
      _controller.setPlaygroundRewardPopupEntry4Label(value);
  set playgroundRewardPopupEntry4Rarity(String value) =>
      _controller.setPlaygroundRewardPopupEntry4Rarity(value);
  set playgroundBackgroundBiome(String value) =>
      _controller.setPlaygroundBackgroundBiome(value);
  set playgroundBackgroundParallaxOffset(double value) =>
      _controller.setPlaygroundBackgroundParallaxOffset(value);
  set playgroundBackgroundBrightness(String value) =>
      _controller.setPlaygroundBackgroundBrightness(value);
  set playgroundCameraZoom(double value) =>
      _controller.setPlaygroundCameraZoom(value);
  set playgroundCameraFocusTarget(String value) =>
      _controller.setPlaygroundCameraFocusTarget(value);
  set playgroundCameraBrightness(String value) =>
      _controller.setPlaygroundCameraBrightness(value);
  set playgroundLegendTitle(String value) =>
      _controller.setPlaygroundLegendTitle(value);
  set playgroundLegendBrightness(String value) =>
      _controller.setPlaygroundLegendBrightness(value);
  set playgroundScrollViewZoom(double value) =>
      _controller.setPlaygroundScrollViewZoom(value);
  set playgroundScrollViewFocusTarget(String value) =>
      _controller.setPlaygroundScrollViewFocusTarget(value);
  set playgroundScrollViewBrightness(String value) =>
      _controller.setPlaygroundScrollViewBrightness(value);
  set playgroundMapBiome(String value) =>
      _controller.setPlaygroundMapBiome(value);
  set playgroundMapShowLegend(bool value) =>
      _controller.setPlaygroundMapShowLegend(value);
  set playgroundMapFocusTarget(String value) =>
      _controller.setPlaygroundMapFocusTarget(value);
  set playgroundMapBrightness(String value) =>
      _controller.setPlaygroundMapBrightness(value);
}
