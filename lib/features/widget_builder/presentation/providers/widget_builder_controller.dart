import 'widget_builder_state.dart';
import 'widget_builder_selection.dart';

/// Controller for the Widget Builder state.
/// This class contains the logic for updating the state.
class WidgetBuilderController {
  WidgetBuilderController(this._updateState);

  final void Function(WidgetBuilderState Function(WidgetBuilderState))
  _updateState;

  void setSelection(WidgetBuilderSelection value) {
    _updateState((state) => state.copyWith(selection: value));
  }

  void setLabel(String value) {
    _updateState((state) => state.copyWith(label: value));
  }

  void setSubtitle(String value) {
    _updateState((state) => state.copyWith(subtitle: value));
  }

  void setShowLeading(bool value) {
    _updateState((state) => state.copyWith(showLeading: value));
  }

  void setShowAccentStripe(bool value) {
    _updateState((state) => state.copyWith(showAccentStripe: value));
  }

  void setLoadingTitle(String value) {
    _updateState((state) => state.copyWith(loadingTitle: value));
  }

  void setLoadingSubtitle(String value) {
    _updateState((state) => state.copyWith(loadingSubtitle: value));
  }

  void setShowLoadingProgress(bool value) {
    _updateState((state) => state.copyWith(showLoadingProgress: value));
  }

  void setLoadingProgressValue(double value) {
    _updateState((state) => state.copyWith(loadingProgressValue: value));
  }

  void setLoaderType(String value) {
    _updateState((state) => state.copyWith(loaderType: value));
  }

  void setBadgeLabel(String value) {
    _updateState((state) => state.copyWith(badgeLabel: value));
  }

  void setShowBadgeIcon(bool value) {
    _updateState((state) => state.copyWith(showBadgeIcon: value));
  }

  void setBadgeStyle(String value) {
    _updateState((state) => state.copyWith(badgeStyle: value));
  }

  void setEnableBadgeAnimation(bool value) {
    _updateState((state) => state.copyWith(enableBadgeAnimation: value));
  }

  void setButtonText(String value) {
    _updateState((state) => state.copyWith(buttonText: value));
  }

  void setIsButtonEnabled(bool value) {
    _updateState((state) => state.copyWith(isButtonEnabled: value));
  }

  void setIsButtonLoading(bool value) {
    _updateState((state) => state.copyWith(isButtonLoading: value));
  }

  void setButtonVariant(String value) {
    _updateState((state) => state.copyWith(buttonVariant: value));
  }

  void setButtonSize(String value) {
    _updateState((state) => state.copyWith(buttonSize: value));
  }

  void setButtonShape(String value) {
    _updateState((state) => state.copyWith(buttonShape: value));
  }

  void setShowButtonLeadingIcon(bool value) {
    _updateState((state) => state.copyWith(showButtonLeadingIcon: value));
  }

  void setShowButtonTrailingIcon(bool value) {
    _updateState((state) => state.copyWith(showButtonTrailingIcon: value));
  }

  void setIsButtonFullWidth(bool value) {
    _updateState((state) => state.copyWith(isButtonFullWidth: value));
  }

  void setAvatarSize(double value) {
    _updateState((state) => state.copyWith(avatarSize: value));
  }

  void setAvatarInitials(String value) {
    _updateState((state) => state.copyWith(avatarInitials: value));
  }

  void setIsAvatarOnline(bool value) {
    _updateState((state) => state.copyWith(isAvatarOnline: value));
  }

  void setShowAvatarPremium(bool value) {
    _updateState((state) => state.copyWith(showAvatarPremium: value));
  }

  void setShowAvatarVerified(bool value) {
    _updateState((state) => state.copyWith(showAvatarVerified: value));
  }

  void setShowAvatarEdit(bool value) {
    _updateState((state) => state.copyWith(showAvatarEdit: value));
  }

  void setSimulatedDevice(String value) {
    _updateState((state) => state.copyWith(simulatedDevice: value));
  }

  void setIsSimulatedLandscape(bool value) {
    _updateState((state) => state.copyWith(isSimulatedLandscape: value));
  }

  void setSecButtonText(String value) {
    _updateState((state) => state.copyWith(secButtonText: value));
  }

  void setIsSecButtonEnabled(bool value) {
    _updateState((state) => state.copyWith(isSecButtonEnabled: value));
  }

  void setIsSecButtonLoading(bool value) {
    _updateState((state) => state.copyWith(isSecButtonLoading: value));
  }

  void setSecButtonVariant(String value) {
    _updateState((state) => state.copyWith(secButtonVariant: value));
  }

  void setSecButtonSize(String value) {
    _updateState((state) => state.copyWith(secButtonSize: value));
  }

  void setSecButtonShape(String value) {
    _updateState((state) => state.copyWith(secButtonShape: value));
  }

  void setShowSecButtonLeadingIcon(bool value) {
    _updateState((state) => state.copyWith(showSecButtonLeadingIcon: value));
  }

  void setShowSecButtonTrailingIcon(bool value) {
    _updateState((state) => state.copyWith(showSecButtonTrailingIcon: value));
  }

  void setIsSecButtonFullWidth(bool value) {
    _updateState((state) => state.copyWith(isSecButtonFullWidth: value));
  }

  void setChipLabel(String value) {
    _updateState((state) => state.copyWith(chipLabel: value));
  }

  void setChipStatus(String value) {
    _updateState((state) => state.copyWith(chipStatus: value));
  }

  void setChipVariant(String value) {
    _updateState((state) => state.copyWith(chipVariant: value));
  }

  void setChipSize(String value) {
    _updateState((state) => state.copyWith(chipSize: value));
  }

  void setShowChipIcon(bool value) {
    _updateState((state) => state.copyWith(showChipIcon: value));
  }

  void setEnableChipAnimation(bool value) {
    _updateState((state) => state.copyWith(enableChipAnimation: value));
  }

  void setCurrentStreakValue(int value) {
    _updateState((state) => state.copyWith(currentStreakValue: value));
  }

  void setLongestStreakValue(int value) {
    _updateState((state) => state.copyWith(longestStreakValue: value));
  }

  void setStreakProgressValue(double value) {
    _updateState((state) => state.copyWith(streakProgressValue: value));
  }

  void setShowWeeklyStreak(bool value) {
    _updateState((state) => state.copyWith(showWeeklyStreak: value));
  }

  void setShowStreakReward(bool value) {
    _updateState((state) => state.copyWith(showStreakReward: value));
  }

  void setShowStreakMilestone(bool value) {
    _updateState((state) => state.copyWith(showStreakMilestone: value));
  }

  void setEnableStreakAnimation(bool value) {
    _updateState((state) => state.copyWith(enableStreakAnimation: value));
  }

  void setTagLabel(String value) {
    _updateState((state) => state.copyWith(tagLabel: value));
  }

  void setTagVariant(String value) {
    _updateState((state) => state.copyWith(tagVariant: value));
  }

  void setTagSize(String value) {
    _updateState((state) => state.copyWith(tagSize: value));
  }

  void setTagShape(String value) {
    _updateState((state) => state.copyWith(tagShape: value));
  }

  void setIsTagSelected(bool value) {
    _updateState((state) => state.copyWith(isTagSelected: value));
  }

  void setIsTagEnabled(bool value) {
    _updateState((state) => state.copyWith(isTagEnabled: value));
  }

  void setIsTagClosable(bool value) {
    _updateState((state) => state.copyWith(isTagClosable: value));
  }

  void setShowTagLeadingIcon(bool value) {
    _updateState((state) => state.copyWith(showTagLeadingIcon: value));
  }

  void setShowTagTrailingIcon(bool value) {
    _updateState((state) => state.copyWith(showTagTrailingIcon: value));
  }

  void setHeaderTitle(String value) {
    _updateState((state) => state.copyWith(headerTitle: value));
  }

  void setHeaderSubtitle(String value) {
    _updateState((state) => state.copyWith(headerSubtitle: value));
  }

  void setShowHeaderSubtitle(bool value) {
    _updateState((state) => state.copyWith(showHeaderSubtitle: value));
  }

  void setShowHeaderLeading(bool value) {
    _updateState((state) => state.copyWith(showHeaderLeading: value));
  }

  void setShowHeaderTrailing(bool value) {
    _updateState((state) => state.copyWith(showHeaderTrailing: value));
  }

  void setShowHeaderDivider(bool value) {
    _updateState((state) => state.copyWith(showHeaderDivider: value));
  }

  void setHeaderActionType(String value) {
    _updateState((state) => state.copyWith(headerActionType: value));
  }

  void setHeaderActionText(String value) {
    _updateState((state) => state.copyWith(headerActionText: value));
  }

  void setConstantsSearchQuery(String value) {
    _updateState((state) => state.copyWith(constantsSearchQuery: value));
  }

  void setCurrentXPValue(int value) {
    _updateState((state) => state.copyWith(currentXPValue: value));
  }

  void setRequiredXPValue(int value) {
    _updateState((state) => state.copyWith(requiredXPValue: value));
  }

  void setCurrentLevelValue(int value) {
    _updateState((state) => state.copyWith(currentLevelValue: value));
  }

  void setNextLevelValue(int value) {
    _updateState((state) => state.copyWith(nextLevelValue: value));
  }

  void setXpBarVariant(String value) {
    _updateState((state) => state.copyWith(xpBarVariant: value));
  }

  void setShowXPPercentage(bool value) {
    _updateState((state) => state.copyWith(showXPPercentage: value));
  }

  void setShowLevelBadge(bool value) {
    _updateState((state) => state.copyWith(showLevelBadge: value));
  }

  void setShowXPText(bool value) {
    _updateState((state) => state.copyWith(showXPText: value));
  }

  void setShowXPBarAnimation(bool value) {
    _updateState((state) => state.copyWith(showXPBarAnimation: value));
  }

  void setShowXPBarGlow(bool value) {
    _updateState((state) => state.copyWith(showXPBarGlow: value));
  }

  void setShowXPBarIcon(bool value) {
    _updateState((state) => state.copyWith(showXPBarIcon: value));
  }

  void setXpBarProgressValue(double value) {
    _updateState((state) => state.copyWith(xpBarProgressValue: value));
  }

  void setErrorType(String value) {
    _updateState((state) => state.copyWith(errorType: value));
  }

  void setShowErrorIllustration(bool value) {
    _updateState((state) => state.copyWith(showErrorIllustration: value));
  }

  void setShowErrorIcon(bool value) {
    _updateState((state) => state.copyWith(showErrorIcon: value));
  }

  void setShowErrorRetryButton(bool value) {
    _updateState((state) => state.copyWith(showErrorRetryButton: value));
  }

  void setIsErrorLoading(bool value) {
    _updateState((state) => state.copyWith(isErrorLoading: value));
  }

  void setErrorRetryText(String value) {
    _updateState((state) => state.copyWith(errorRetryText: value));
  }

  void setCardTitle(String value) {
    _updateState((state) => state.copyWith(cardTitle: value));
  }

  void setCardSubtitle(String value) {
    _updateState((state) => state.copyWith(cardSubtitle: value));
  }

  void setCardAnimationType(String value) {
    _updateState((state) => state.copyWith(cardAnimationType: value));
  }

  void setCardVariant(String value) {
    _updateState((state) => state.copyWith(cardVariant: value));
  }

  void setEnableCardHover(bool value) {
    _updateState((state) => state.copyWith(enableCardHover: value));
  }

  void setEnableCardGlow(bool value) {
    _updateState((state) => state.copyWith(enableCardGlow: value));
  }

  void setEnableCardGlass(bool value) {
    _updateState((state) => state.copyWith(enableCardGlass: value));
  }

  void setAiButtonVariant(String value) {
    _updateState((state) => state.copyWith(aiButtonVariant: value));
  }

  void setAiButtonSize(String value) {
    _updateState((state) => state.copyWith(aiButtonSize: value));
  }

  void setAiButtonState(String value) {
    _updateState((state) => state.copyWith(aiButtonState: value));
  }

  void setAiButtonAnimation(String value) {
    _updateState((state) => state.copyWith(aiButtonAnimation: value));
  }

  void setShowAiIcon(bool value) {
    _updateState((state) => state.copyWith(showAiIcon: value));
  }

  void setAiBubbleRole(String value) {
    _updateState((state) => state.copyWith(aiBubbleRole: value));
  }

  void setAiBubbleStyle(String value) {
    _updateState((state) => state.copyWith(aiBubbleStyle: value));
  }

  void setAiBubbleState(String value) {
    _updateState((state) => state.copyWith(aiBubbleState: value));
  }

  void setAiBubbleMessage(String value) {
    _updateState((state) => state.copyWith(aiBubbleMessage: value));
  }

  void setAiBubbleLongMessage(bool value) {
    _updateState((state) => state.copyWith(aiBubbleLongMessage: value));
  }

  void setAiBubbleShowHeader(bool value) {
    _updateState((state) => state.copyWith(aiBubbleShowHeader: value));
  }

  void setAiBubbleShowFooter(bool value) {
    _updateState((state) => state.copyWith(aiBubbleShowFooter: value));
  }

  void setAiBubbleShowVerified(bool value) {
    _updateState((state) => state.copyWith(aiBubbleShowVerified: value));
  }

  void setAiBubbleTimestamp(String value) {
    _updateState((state) => state.copyWith(aiBubbleTimestamp: value));
  }

  void setAiBubbleModelLabel(String value) {
    _updateState((state) => state.copyWith(aiBubbleModelLabel: value));
  }

  void setAiBubbleStreaming(bool value) {
    _updateState((state) => state.copyWith(aiBubbleStreaming: value));
  }

  void setAiBubbleError(bool value) {
    _updateState((state) => state.copyWith(aiBubbleError: value));
  }

  void setAiBubbleTyping(bool value) {
    _updateState((state) => state.copyWith(aiBubbleTyping: value));
  }

  void setAiAvatarStatus(String value) {
    _updateState((state) => state.copyWith(aiAvatarStatus: value));
  }

  void setAiAvatarSize(double value) {
    _updateState((state) => state.copyWith(aiAvatarSize: value));
  }

  void setAiAvatarSpeed(String value) {
    _updateState((state) => state.copyWith(aiAvatarSpeed: value));
  }

  void setAiAvatarIntensity(String value) {
    _updateState((state) => state.copyWith(aiAvatarIntensity: value));
  }

  void setAiAvatarGlowEnabled(bool value) {
    _updateState((state) => state.copyWith(aiAvatarGlowEnabled: value));
  }

  void setAiAvatarHaloEnabled(bool value) {
    _updateState((state) => state.copyWith(aiAvatarHaloEnabled: value));
  }

  void setAiAvatarParticlesEnabled(bool value) {
    _updateState((state) => state.copyWith(aiAvatarParticlesEnabled: value));
  }

  void setAiAvatarShadowEnabled(bool value) {
    _updateState((state) => state.copyWith(aiAvatarShadowEnabled: value));
  }

  void setAiAvatarBorderWidth(double value) {
    _updateState((state) => state.copyWith(aiAvatarBorderWidth: value));
  }

  void setAiExpTitle(String value) {
    _updateState((state) => state.copyWith(aiExpTitle: value));
  }

  void setAiExpSubtitle(String value) {
    _updateState((state) => state.copyWith(aiExpSubtitle: value));
  }

  void setAiExpBadgeLabel(String value) {
    _updateState((state) => state.copyWith(aiExpBadgeLabel: value));
  }

  void setAiExpTone(String value) {
    _updateState((state) => state.copyWith(aiExpTone: value));
  }

  void setAiExpShowBadge(bool value) {
    _updateState((state) => state.copyWith(aiExpShowBadge: value));
  }

  void setAiExpShowActions(bool value) {
    _updateState((state) => state.copyWith(aiExpShowActions: value));
  }

  void setAiExpExpanded(bool value) {
    _updateState((state) => state.copyWith(aiExpExpanded: value));
  }

  void setAiExpCanExpand(bool value) {
    _updateState((state) => state.copyWith(aiExpCanExpand: value));
  }

  void setAiExpLongContent(bool value) {
    _updateState((state) => state.copyWith(aiExpLongContent: value));
  }

  void setAiHintTitle(String value) {
    _updateState((state) => state.copyWith(aiHintTitle: value));
  }

  void setAiHintText(String value) {
    _updateState((state) => state.copyWith(aiHintText: value));
  }

  void setAiHintType(String value) {
    _updateState((state) => state.copyWith(aiHintType: value));
  }

  void setAiHintDifficulty(String value) {
    _updateState((state) => state.copyWith(aiHintDifficulty: value));
  }

  void setAiHintTopic(String? value) {
    _updateState((state) => state.copyWith(aiHintTopic: value));
  }

  void setAiHintQuickTip(String? value) {
    _updateState((state) => state.copyWith(aiHintQuickTip: value));
  }

  void setAiHintShowBadge(bool value) {
    _updateState((state) => state.copyWith(aiHintShowBadge: value));
  }

  void setAiHintShowActions(bool value) {
    _updateState((state) => state.copyWith(aiHintShowActions: value));
  }

  void setAiHintIsBookmarked(bool value) {
    _updateState((state) => state.copyWith(aiHintIsBookmarked: value));
  }

  void setAiHintBadgeText(String? value) {
    _updateState((state) => state.copyWith(aiHintBadgeText: value));
  }

  void setAiHistoryHeaderTitle(String value) {
    _updateState((state) => state.copyWith(aiHistoryHeaderTitle: value));
  }

  void setAiHistoryHeaderSubtitle(String value) {
    _updateState((state) => state.copyWith(aiHistoryHeaderSubtitle: value));
  }

  void setAiHistoryState(String value) {
    _updateState((state) => state.copyWith(aiHistoryState: value));
  }

  void setAiHistoryShowCategory(bool value) {
    _updateState((state) => state.copyWith(aiHistoryShowCategory: value));
  }

  void setAiHistoryShowTimestamp(bool value) {
    _updateState((state) => state.copyWith(aiHistoryShowTimestamp: value));
  }

  void setAiHistoryShowPremiumBadge(bool value) {
    _updateState((state) => state.copyWith(aiHistoryShowPremiumBadge: value));
  }

  void setAiHistoryShowFavorite(bool value) {
    _updateState((state) => state.copyWith(aiHistoryShowFavorite: value));
  }

  void setAiHistoryShowPinned(bool value) {
    _updateState((state) => state.copyWith(aiHistoryShowPinned: value));
  }

  void setAiHistoryShowLeadingChevron(bool value) {
    _updateState((state) => state.copyWith(aiHistoryShowLeadingChevron: value));
  }

  void setAiHistoryShowHeader(bool value) {
    _updateState((state) => state.copyWith(aiHistoryShowHeader: value));
  }

  void setAiHistoryShowViewAll(bool value) {
    _updateState((state) => state.copyWith(aiHistoryShowViewAll: value));
  }

  void setAiHistoryLoadingItemCount(int value) {
    _updateState((state) => state.copyWith(aiHistoryLoadingItemCount: value));
  }

  void setAiHistoryTileTitle(String value) {
    _updateState((state) => state.copyWith(aiHistoryTileTitle: value));
  }

  void setAiHistoryTilePreview(String value) {
    _updateState((state) => state.copyWith(aiHistoryTilePreview: value));
  }

  void setAiHistoryTileTimestamp(String value) {
    _updateState((state) => state.copyWith(aiHistoryTileTimestamp: value));
  }

  void setAiHistoryTileSubtitle(String? value) {
    _updateState((state) => state.copyWith(aiHistoryTileSubtitle: value));
  }

  void setAiHistoryTileCategory(String? value) {
    _updateState((state) => state.copyWith(aiHistoryTileCategory: value));
  }

  void setAiHistoryTileEntryType(String value) {
    _updateState((state) => state.copyWith(aiHistoryTileEntryType: value));
  }

  void setAiHistoryTileBrightness(String value) {
    _updateState((state) => state.copyWith(aiHistoryTileBrightness: value));
  }

  void setAiHistoryTileShowCategory(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileShowCategory: value));
  }

  void setAiHistoryTileShowTimestamp(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileShowTimestamp: value));
  }

  void setAiHistoryTileShowPremiumBadge(bool value) {
    _updateState(
      (state) => state.copyWith(aiHistoryTileShowPremiumBadge: value),
    );
  }

  void setAiHistoryTileShowFavorite(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileShowFavorite: value));
  }

  void setAiHistoryTileShowPinned(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileShowPinned: value));
  }

  void setAiHistoryTileShowLeadingChevron(bool value) {
    _updateState(
      (state) => state.copyWith(aiHistoryTileShowLeadingChevron: value),
    );
  }

  void setAiHistoryTileDense(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileDense: value));
  }

  void setAiHistoryTileIsFavorite(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileIsFavorite: value));
  }

  void setAiHistoryTileIsPinned(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileIsPinned: value));
  }

  void setAiHistoryTileIsPremium(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileIsPremium: value));
  }

  void setAiHistoryTileIsUnread(bool value) {
    _updateState((state) => state.copyWith(aiHistoryTileIsUnread: value));
  }

  void setAiLoadingCardBrightness(String value) {
    _updateState((state) => state.copyWith(aiLoadingCardBrightness: value));
  }

  void setAiLoadingCardBodyLineCount(int value) {
    _updateState((state) => state.copyWith(aiLoadingCardBodyLineCount: value));
  }

  void setAiLoadingCardElevation(double value) {
    _updateState((state) => state.copyWith(aiLoadingCardElevation: value));
  }

  void setAiLoadingCardAnimationEnabled(bool value) {
    _updateState(
      (state) => state.copyWith(aiLoadingCardAnimationEnabled: value),
    );
  }

  void setAiLoadingCardShowAvatar(bool value) {
    _updateState((state) => state.copyWith(aiLoadingCardShowAvatar: value));
  }

  void setAiLoadingCardShowTitle(bool value) {
    _updateState((state) => state.copyWith(aiLoadingCardShowTitle: value));
  }

  void setAiLoadingCardShowSubtitle(bool value) {
    _updateState((state) => state.copyWith(aiLoadingCardShowSubtitle: value));
  }

  void setAiLoadingCardShowBody(bool value) {
    _updateState((state) => state.copyWith(aiLoadingCardShowBody: value));
  }

  void setAiLoadingCardShowFooter(bool value) {
    _updateState((state) => state.copyWith(aiLoadingCardShowFooter: value));
  }

  void setAiLoadingCardSemanticLabel(String? value) {
    _updateState((state) => state.copyWith(aiLoadingCardSemanticLabel: value));
  }

  void setAiResponseTitle(String value) {
    _updateState((state) => state.copyWith(aiResponseTitle: value));
  }

  void setAiResponseSubtitle(String value) {
    _updateState((state) => state.copyWith(aiResponseSubtitle: value));
  }

  void setAiResponseType(String value) {
    _updateState((state) => state.copyWith(aiResponseType: value));
  }

  void setAiResponseBadgeLabel(String value) {
    _updateState((state) => state.copyWith(aiResponseBadgeLabel: value));
  }

  void setAiResponseBody(String value) {
    _updateState((state) => state.copyWith(aiResponseBody: value));
  }

  void setAiResponseMarkdown(bool value) {
    _updateState((state) => state.copyWith(aiResponseMarkdown: value));
  }

  void setAiResponseSelectable(bool value) {
    _updateState((state) => state.copyWith(aiResponseSelectable: value));
  }

  void setAiResponseShowBadge(bool value) {
    _updateState((state) => state.copyWith(aiResponseShowBadge: value));
  }

  void setAiResponseShowMetadata(bool value) {
    _updateState((state) => state.copyWith(aiResponseShowMetadata: value));
  }

  void setAiResponseShowActions(bool value) {
    _updateState((state) => state.copyWith(aiResponseShowActions: value));
  }

  void setAiResponseMetadataModel(String value) {
    _updateState((state) => state.copyWith(aiResponseMetadataModel: value));
  }

  void setAiResponseMetadataTimestamp(String value) {
    _updateState((state) => state.copyWith(aiResponseMetadataTimestamp: value));
  }

  void setAiResponseMetadataCategory(String value) {
    _updateState((state) => state.copyWith(aiResponseMetadataCategory: value));
  }

  void setAiResponseMetadataConfidence(String value) {
    _updateState(
      (state) => state.copyWith(aiResponseMetadataConfidence: value),
    );
  }

  void setAiResponseMetadataStatus(String value) {
    _updateState((state) => state.copyWith(aiResponseMetadataStatus: value));
  }

  void setAiResponseActionCopy(bool value) {
    _updateState((state) => state.copyWith(aiResponseActionCopy: value));
  }

  void setAiResponseActionShare(bool value) {
    _updateState((state) => state.copyWith(aiResponseActionShare: value));
  }

  void setAiResponseActionRegenerate(bool value) {
    _updateState((state) => state.copyWith(aiResponseActionRegenerate: value));
  }

  void setAiResponseActionFavorite(bool value) {
    _updateState((state) => state.copyWith(aiResponseActionFavorite: value));
  }

  void setAiResponseActionLike(bool value) {
    _updateState((state) => state.copyWith(aiResponseActionLike: value));
  }

  void setAiResponseActionDislike(bool value) {
    _updateState((state) => state.copyWith(aiResponseActionDislike: value));
  }

  void setAiResponseActionFavoriteActive(bool value) {
    _updateState(
      (state) => state.copyWith(aiResponseActionFavoriteActive: value),
    );
  }

  void setAiResponseActionLikeActive(bool value) {
    _updateState((state) => state.copyWith(aiResponseActionLikeActive: value));
  }

  void setAiResponseActionDislikeActive(bool value) {
    _updateState(
      (state) => state.copyWith(aiResponseActionDislikeActive: value),
    );
  }

  void setAiResponseCanExpand(bool value) {
    _updateState((state) => state.copyWith(aiResponseCanExpand: value));
  }

  void setAiResponseExpanded(bool value) {
    _updateState((state) => state.copyWith(aiResponseExpanded: value));
  }

  void setPlaygroundNodeRingKind(String value) {
    _updateState((state) => state.copyWith(playgroundNodeRingKind: value));
  }

  void setPlaygroundNodeRingState(String value) {
    _updateState((state) => state.copyWith(playgroundNodeRingState: value));
  }

  void setPlaygroundNodeDiameter(double value) {
    _updateState((state) => state.copyWith(playgroundNodeDiameter: value));
  }

  void setPlaygroundNodeIconKind(String value) {
    _updateState((state) => state.copyWith(playgroundNodeIconKind: value));
  }

  void setPlaygroundNodeIconVariant(String value) {
    _updateState((state) => state.copyWith(playgroundNodeIconVariant: value));
  }

  void setPlaygroundNodeProgress(double value) {
    _updateState((state) => state.copyWith(playgroundNodeProgress: value));
  }

  void setPlaygroundNodeProgressState(String value) {
    _updateState((state) => state.copyWith(playgroundNodeProgressState: value));
  }

  void setPlaygroundNodeTitle(String value) {
    _updateState((state) => state.copyWith(playgroundNodeTitle: value));
  }

  void setPlaygroundNodeSubtitle(String value) {
    _updateState((state) => state.copyWith(playgroundNodeSubtitle: value));
  }

  void setPlaygroundNodeShowProgress(bool value) {
    _updateState((state) => state.copyWith(playgroundNodeShowProgress: value));
  }

  void setPlaygroundNodeShowLabel(bool value) {
    _updateState((state) => state.copyWith(playgroundNodeShowLabel: value));
  }

  void setPlaygroundNodeShowBadge(bool value) {
    _updateState((state) => state.copyWith(playgroundNodeShowBadge: value));
  }

  void setPlaygroundNodeBadgeKind(String value) {
    _updateState((state) => state.copyWith(playgroundNodeBadgeKind: value));
  }

  void setPlaygroundNodeLabelPlacement(String value) {
    _updateState(
      (state) => state.copyWith(playgroundNodeLabelPlacement: value),
    );
  }

  void setPlaygroundNodeLabelEmphasis(String value) {
    _updateState((state) => state.copyWith(playgroundNodeLabelEmphasis: value));
  }

  void setPlaygroundNodeIsInteractive(bool value) {
    _updateState((state) => state.copyWith(playgroundNodeIsInteractive: value));
  }

  void setPlaygroundNodeBrightness(String value) {
    _updateState((state) => state.copyWith(playgroundNodeBrightness: value));
  }

  void setNodeRingState(String value) {
    _updateState((state) => state.copyWith(nodeRingState: value));
  }

  void setNodeRingKind(String value) {
    _updateState((state) => state.copyWith(nodeRingKind: value));
  }

  void setNodeRingDiameter(double value) {
    _updateState((state) => state.copyWith(nodeRingDiameter: value));
  }

  void setNodeRingStrokeWidth(double value) {
    _updateState((state) => state.copyWith(nodeRingStrokeWidth: value));
  }

  void setNodeRingGlow(bool value) {
    _updateState((state) => state.copyWith(nodeRingGlow: value));
  }

  void setNodeRingIsAnimated(bool value) {
    _updateState((state) => state.copyWith(nodeRingIsAnimated: value));
  }

  void setNodeRingBrightness(String value) {
    _updateState((state) => state.copyWith(nodeRingBrightness: value));
  }

  void setNodeIconKind(String value) {
    _updateState((state) => state.copyWith(nodeIconKind: value));
  }

  void setNodeIconVariant(String value) {
    _updateState((state) => state.copyWith(nodeIconVariant: value));
  }

  void setNodeIconSize(double value) {
    _updateState((state) => state.copyWith(nodeIconSize: value));
  }

  void setNodeIconIsEnabled(bool value) {
    _updateState((state) => state.copyWith(nodeIconIsEnabled: value));
  }

  void setNodeIconBrightness(String value) {
    _updateState((state) => state.copyWith(nodeIconBrightness: value));
  }

  void setNodeBadgeKind(String value) {
    _updateState((state) => state.copyWith(nodeBadgeKind: value));
  }

  void setNodeBadgeSize(double value) {
    _updateState((state) => state.copyWith(nodeBadgeSize: value));
  }

  void setNodeBadgeOffset(double value) {
    _updateState((state) => state.copyWith(nodeBadgeOffset: value));
  }

  void setNodeBadgeBrightness(String value) {
    _updateState((state) => state.copyWith(nodeBadgeBrightness: value));
  }

  void setNodeLabelTitle(String value) {
    _updateState((state) => state.copyWith(nodeLabelTitle: value));
  }

  void setNodeLabelSubtitle(String value) {
    _updateState((state) => state.copyWith(nodeLabelSubtitle: value));
  }

  void setNodeLabelPlacement(String value) {
    _updateState((state) => state.copyWith(nodeLabelPlacement: value));
  }

  void setNodeLabelEmphasis(String value) {
    _updateState((state) => state.copyWith(nodeLabelEmphasis: value));
  }

  void setNodeLabelMaxWidth(double value) {
    _updateState((state) => state.copyWith(nodeLabelMaxWidth: value));
  }

  void setNodeLabelIsVisible(bool value) {
    _updateState((state) => state.copyWith(nodeLabelIsVisible: value));
  }

  void setNodeLabelBrightness(String value) {
    _updateState((state) => state.copyWith(nodeLabelBrightness: value));
  }

  void setNodeProgressValue(double value) {
    _updateState((state) => state.copyWith(nodeProgressValue: value));
  }

  void setNodeProgressState(String value) {
    _updateState((state) => state.copyWith(nodeProgressState: value));
  }

  void setNodeProgressDiameter(double value) {
    _updateState((state) => state.copyWith(nodeProgressDiameter: value));
  }

  void setNodeProgressStrokeWidth(double value) {
    _updateState((state) => state.copyWith(nodeProgressStrokeWidth: value));
  }

  void setNodeProgressShowLabel(bool value) {
    _updateState((state) => state.copyWith(nodeProgressShowLabel: value));
  }

  void setNodeProgressCompletedLabel(String value) {
    _updateState((state) => state.copyWith(nodeProgressCompletedLabel: value));
  }

  void setNodeProgressBrightness(String value) {
    _updateState((state) => state.copyWith(nodeProgressBrightness: value));
  }

  void setTreeKind(String value) {
    _updateState((state) => state.copyWith(treeKind: value));
  }

  void setTreeScale(double value) {
    _updateState((state) => state.copyWith(treeScale: value));
  }

  void setTreeSway(bool value) {
    _updateState((state) => state.copyWith(treeSway: value));
  }

  void setTreeSwaySeed(int value) {
    _updateState((state) => state.copyWith(treeSwaySeed: value));
  }

  void setTreeBrightness(String value) {
    _updateState((state) => state.copyWith(treeBrightness: value));
  }

  void setBushKind(String value) {
    _updateState((state) => state.copyWith(bushKind: value));
  }

  void setBushScale(double value) {
    _updateState((state) => state.copyWith(bushScale: value));
  }

  void setBushSway(bool value) {
    _updateState((state) => state.copyWith(bushSway: value));
  }

  void setBushSwaySeed(int value) {
    _updateState((state) => state.copyWith(bushSwaySeed: value));
  }

  void setBushBrightness(String value) {
    _updateState((state) => state.copyWith(bushBrightness: value));
  }

  void setCloudKind(String value) {
    _updateState((state) => state.copyWith(cloudKind: value));
  }

  void setCloudScale(double value) {
    _updateState((state) => state.copyWith(cloudScale: value));
  }

  void setCloudSeed(int value) {
    _updateState((state) => state.copyWith(cloudSeed: value));
  }

  void setCloudBrightness(String value) {
    _updateState((state) => state.copyWith(cloudBrightness: value));
  }

  void setMountainLayer(String value) {
    _updateState((state) => state.copyWith(mountainLayer: value));
  }

  void setMountainKind(String value) {
    _updateState((state) => state.copyWith(mountainKind: value));
  }

  void setMountainScale(double value) {
    _updateState((state) => state.copyWith(mountainScale: value));
  }

  void setMountainBrightness(String value) {
    _updateState((state) => state.copyWith(mountainBrightness: value));
  }

  void setRiverCurve(String value) {
    _updateState((state) => state.copyWith(riverCurve: value));
  }

  void setRiverHeight(double value) {
    _updateState((state) => state.copyWith(riverHeight: value));
  }

  void setRiverSeed(int value) {
    _updateState((state) => state.copyWith(riverSeed: value));
  }

  void setRiverBrightness(String value) {
    _updateState((state) => state.copyWith(riverBrightness: value));
  }

  void setBridgeVariant(String value) {
    _updateState((state) => state.copyWith(bridgeVariant: value));
  }

  void setBridgeScale(double value) {
    _updateState((state) => state.copyWith(bridgeScale: value));
  }

  void setBridgeBrightness(String value) {
    _updateState((state) => state.copyWith(bridgeBrightness: value));
  }

  void setPathBrightness(String value) {
    _updateState((state) => state.copyWith(pathBrightness: value));
  }

  void setFlagColor(String value) {
    _updateState((state) => state.copyWith(flagColor: value));
  }

  void setFlagScale(double value) {
    _updateState((state) => state.copyWith(flagScale: value));
  }

  void setFlagBrightness(String value) {
    _updateState((state) => state.copyWith(flagBrightness: value));
  }

  void setParticlesKind(String value) {
    _updateState((state) => state.copyWith(particlesKind: value));
  }

  void setParticlesCount(int value) {
    _updateState((state) => state.copyWith(particlesCount: value));
  }

  void setParticlesSeed(int value) {
    _updateState((state) => state.copyWith(particlesSeed: value));
  }

  void setParticlesBrightness(String value) {
    _updateState((state) => state.copyWith(particlesBrightness: value));
  }

  void setParticleLayerCount(int value) {
    _updateState((state) => state.copyWith(particleLayerCount: value));
  }

  void setParticleLayerSeed(int value) {
    _updateState((state) => state.copyWith(particleLayerSeed: value));
  }

  void setParticleLayerBrightness(String value) {
    _updateState((state) => state.copyWith(particleLayerBrightness: value));
  }

  void setPlaygroundBuildingState(String value) {
    _updateState((state) => state.copyWith(playgroundBuildingState: value));
  }

  void setPlaygroundBuildingTitle(String value) {
    _updateState((state) => state.copyWith(playgroundBuildingTitle: value));
  }

  void setPlaygroundBuildingSubtitle(String value) {
    _updateState((state) => state.copyWith(playgroundBuildingSubtitle: value));
  }

  void setPlaygroundBuildingProgress(double value) {
    _updateState((state) => state.copyWith(playgroundBuildingProgress: value));
  }

  void setPlaygroundBuildingLevel(int value) {
    _updateState((state) => state.copyWith(playgroundBuildingLevel: value));
  }

  void setPlaygroundBuildingIsInteractive(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundBuildingIsInteractive: value),
    );
  }

  void setPlaygroundBuildingShowLabel(bool value) {
    _updateState((state) => state.copyWith(playgroundBuildingShowLabel: value));
  }

  void setPlaygroundBuildingShowProgress(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundBuildingShowProgress: value),
    );
  }

  void setPlaygroundBuildingLabelPlacement(String value) {
    _updateState(
      (state) => state.copyWith(playgroundBuildingLabelPlacement: value),
    );
  }

  void setPlaygroundBuildingLabelEmphasis(String value) {
    _updateState(
      (state) => state.copyWith(playgroundBuildingLabelEmphasis: value),
    );
  }

  void setPlaygroundBuildingProgressKind(String value) {
    _updateState(
      (state) => state.copyWith(playgroundBuildingProgressKind: value),
    );
  }

  void setPlaygroundBuildingScale(double value) {
    _updateState((state) => state.copyWith(playgroundBuildingScale: value));
  }

  void setPlaygroundBuildingBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundBuildingBrightness: value),
    );
  }

  void setAcademyBuildingState(String value) {
    _updateState((state) => state.copyWith(academyBuildingState: value));
  }

  void setAcademyBuildingProgress(double value) {
    _updateState((state) => state.copyWith(academyBuildingProgress: value));
  }

  void setAcademyBuildingLevel(int value) {
    _updateState((state) => state.copyWith(academyBuildingLevel: value));
  }

  void setAcademyBuildingShowLabel(bool value) {
    _updateState((state) => state.copyWith(academyBuildingShowLabel: value));
  }

  void setAcademyBuildingShowProgress(bool value) {
    _updateState((state) => state.copyWith(academyBuildingShowProgress: value));
  }

  void setAcademyBuildingLabelPlacement(String value) {
    _updateState(
      (state) => state.copyWith(academyBuildingLabelPlacement: value),
    );
  }

  void setAcademyBuildingLabelEmphasis(String value) {
    _updateState(
      (state) => state.copyWith(academyBuildingLabelEmphasis: value),
    );
  }

  void setAcademyBuildingProgressKind(String value) {
    _updateState((state) => state.copyWith(academyBuildingProgressKind: value));
  }

  void setAcademyBuildingScale(double value) {
    _updateState((state) => state.copyWith(academyBuildingScale: value));
  }

  void setAcademyBuildingBrightness(String value) {
    _updateState((state) => state.copyWith(academyBuildingBrightness: value));
  }

  void setLibraryBuildingState(String value) {
    _updateState((state) => state.copyWith(libraryBuildingState: value));
  }

  void setLibraryBuildingProgress(double value) {
    _updateState((state) => state.copyWith(libraryBuildingProgress: value));
  }

  void setLibraryBuildingLevel(int value) {
    _updateState((state) => state.copyWith(libraryBuildingLevel: value));
  }

  void setLibraryBuildingShowLabel(bool value) {
    _updateState((state) => state.copyWith(libraryBuildingShowLabel: value));
  }

  void setLibraryBuildingShowProgress(bool value) {
    _updateState((state) => state.copyWith(libraryBuildingShowProgress: value));
  }

  void setLibraryBuildingLabelPlacement(String value) {
    _updateState(
      (state) => state.copyWith(libraryBuildingLabelPlacement: value),
    );
  }

  void setLibraryBuildingLabelEmphasis(String value) {
    _updateState(
      (state) => state.copyWith(libraryBuildingLabelEmphasis: value),
    );
  }

  void setLibraryBuildingProgressKind(String value) {
    _updateState((state) => state.copyWith(libraryBuildingProgressKind: value));
  }

  void setLibraryBuildingScale(double value) {
    _updateState((state) => state.copyWith(libraryBuildingScale: value));
  }

  void setLibraryBuildingBrightness(String value) {
    _updateState((state) => state.copyWith(libraryBuildingBrightness: value));
  }

  void setBuildingLabelTitle(String value) {
    _updateState((state) => state.copyWith(buildingLabelTitle: value));
  }

  void setBuildingLabelSubtitle(String value) {
    _updateState((state) => state.copyWith(buildingLabelSubtitle: value));
  }

  void setBuildingLabelPlacement(String value) {
    _updateState((state) => state.copyWith(buildingLabelPlacement: value));
  }

  void setBuildingLabelEmphasis(String value) {
    _updateState((state) => state.copyWith(buildingLabelEmphasis: value));
  }

  void setBuildingLabelMaxWidth(double value) {
    _updateState((state) => state.copyWith(buildingLabelMaxWidth: value));
  }

  void setBuildingLabelIsVisible(bool value) {
    _updateState((state) => state.copyWith(buildingLabelIsVisible: value));
  }

  void setBuildingLabelBrightness(String value) {
    _updateState((state) => state.copyWith(buildingLabelBrightness: value));
  }

  void setBuildingProgressValue(double value) {
    _updateState((state) => state.copyWith(buildingProgressValue: value));
  }

  void setBuildingProgressKind(String value) {
    _updateState((state) => state.copyWith(buildingProgressKind: value));
  }

  void setBuildingProgressLevel(int value) {
    _updateState((state) => state.copyWith(buildingProgressLevel: value));
  }

  void setBuildingProgressSize(double value) {
    _updateState((state) => state.copyWith(buildingProgressSize: value));
  }

  void setBuildingProgressBrightness(String value) {
    _updateState((state) => state.copyWith(buildingProgressBrightness: value));
  }

  void setPlaygroundProfileSummaryDisplayName(String value) {
    _updateState(
      (state) => state.copyWith(playgroundProfileSummaryDisplayName: value),
    );
  }

  void setPlaygroundProfileSummaryLevel(int value) {
    _updateState(
      (state) => state.copyWith(playgroundProfileSummaryLevel: value),
    );
  }

  void setPlaygroundProfileSummaryInitials(String value) {
    _updateState(
      (state) => state.copyWith(playgroundProfileSummaryInitials: value),
    );
  }

  void setPlaygroundProfileSummaryIsOnline(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundProfileSummaryIsOnline: value),
    );
  }

  void setPlaygroundProfileSummaryIsPremium(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundProfileSummaryIsPremium: value),
    );
  }

  void setPlaygroundProfileSummaryNotificationCount(int value) {
    _updateState(
      (state) =>
          state.copyWith(playgroundProfileSummaryNotificationCount: value),
    );
  }

  void setPlaygroundProfileSummaryLeagueName(String value) {
    _updateState(
      (state) => state.copyWith(playgroundProfileSummaryLeagueName: value),
    );
  }

  void setPlaygroundProfileSummaryBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundProfileSummaryBrightness: value),
    );
  }

  void setPlaygroundXpIndicatorTotalXp(int value) {
    _updateState(
      (state) => state.copyWith(playgroundXpIndicatorTotalXp: value),
    );
  }

  void setPlaygroundXpIndicatorUserLevel(int value) {
    _updateState(
      (state) => state.copyWith(playgroundXpIndicatorUserLevel: value),
    );
  }

  void setPlaygroundXpIndicatorXpInLevel(int value) {
    _updateState(
      (state) => state.copyWith(playgroundXpIndicatorXpInLevel: value),
    );
  }

  void setPlaygroundXpIndicatorXpForNextLevel(int value) {
    _updateState(
      (state) => state.copyWith(playgroundXpIndicatorXpForNextLevel: value),
    );
  }

  void setPlaygroundXpIndicatorGainDelta(int value) {
    _updateState(
      (state) => state.copyWith(playgroundXpIndicatorGainDelta: value),
    );
  }

  void setPlaygroundXpIndicatorIsAnimatingGain(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundXpIndicatorIsAnimatingGain: value),
    );
  }

  void setPlaygroundCoinCounterBalance(int value) {
    _updateState(
      (state) => state.copyWith(playgroundCoinCounterBalance: value),
    );
  }

  void setPlaygroundCoinCounterGainDelta(int value) {
    _updateState(
      (state) => state.copyWith(playgroundCoinCounterGainDelta: value),
    );
  }

  void setPlaygroundCoinCounterIsAnimatingGain(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundCoinCounterIsAnimatingGain: value),
    );
  }

  void setPlaygroundEnergyIndicatorRemaining(int value) {
    _updateState(
      (state) => state.copyWith(playgroundEnergyIndicatorRemaining: value),
    );
  }

  void setPlaygroundEnergyIndicatorMax(int value) {
    _updateState(
      (state) => state.copyWith(playgroundEnergyIndicatorMax: value),
    );
  }

  void setPlaygroundEnergyIndicatorRechargeSeconds(int value) {
    _updateState(
      (state) =>
          state.copyWith(playgroundEnergyIndicatorRechargeSeconds: value),
    );
  }

  void setPlaygroundEnergyIndicatorIsAnimatingRefill(bool value) {
    _updateState(
      (state) =>
          state.copyWith(playgroundEnergyIndicatorIsAnimatingRefill: value),
    );
  }

  void setPlaygroundStreakCardDays(int value) {
    _updateState((state) => state.copyWith(playgroundStreakCardDays: value));
  }

  void setPlaygroundStreakCardIsAtRisk(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundStreakCardIsAtRisk: value),
    );
  }

  void setPlaygroundStreakCardMilestoneReached(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundStreakCardMilestoneReached: value),
    );
  }

  void setPlaygroundTopBarBrightness(String value) {
    _updateState((state) => state.copyWith(playgroundTopBarBrightness: value));
  }

  void setPlaygroundLevelProgressCardLevel(int value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardLevel: value),
    );
  }

  void setPlaygroundLevelProgressCardTotalStages(int value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardTotalStages: value),
    );
  }

  void setPlaygroundLevelProgressCardCompletedStages(int value) {
    _updateState(
      (state) =>
          state.copyWith(playgroundLevelProgressCardCompletedStages: value),
    );
  }

  void setPlaygroundLevelProgressCardTotalStars(int value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardTotalStars: value),
    );
  }

  void setPlaygroundLevelProgressCardEarnedStars(int value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardEarnedStars: value),
    );
  }

  void setPlaygroundLevelProgressCardCurrentXP(int value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardCurrentXP: value),
    );
  }

  void setPlaygroundLevelProgressCardRequiredXP(int value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardRequiredXP: value),
    );
  }

  void setPlaygroundLevelProgressCardTitle(String value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardTitle: value),
    );
  }

  void setPlaygroundLevelProgressCardSubtitle(String value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardSubtitle: value),
    );
  }

  void setPlaygroundLevelProgressCardState(String value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardState: value),
    );
  }

  void setPlaygroundLevelProgressCardRewardKind(String value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardRewardKind: value),
    );
  }

  void setPlaygroundLevelProgressCardRewardAmount(int value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardRewardAmount: value),
    );
  }

  void setPlaygroundLevelProgressCardBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundLevelProgressCardBrightness: value),
    );
  }

  void setPlaygroundMissionCardTitle(String value) {
    _updateState((state) => state.copyWith(playgroundMissionCardTitle: value));
  }

  void setPlaygroundMissionCardDescription(String value) {
    _updateState(
      (state) => state.copyWith(playgroundMissionCardDescription: value),
    );
  }

  void setPlaygroundMissionCardRequired(int value) {
    _updateState(
      (state) => state.copyWith(playgroundMissionCardRequired: value),
    );
  }

  void setPlaygroundMissionCardProgress(int value) {
    _updateState(
      (state) => state.copyWith(playgroundMissionCardProgress: value),
    );
  }

  void setPlaygroundMissionCardState(String value) {
    _updateState((state) => state.copyWith(playgroundMissionCardState: value));
  }

  void setPlaygroundMissionCardTag(String value) {
    _updateState((state) => state.copyWith(playgroundMissionCardTag: value));
  }

  void setPlaygroundMissionCardRewardKind(String value) {
    _updateState(
      (state) => state.copyWith(playgroundMissionCardRewardKind: value),
    );
  }

  void setPlaygroundMissionCardRewardAmount(int value) {
    _updateState(
      (state) => state.copyWith(playgroundMissionCardRewardAmount: value),
    );
  }

  void setPlaygroundMissionCardTimerSeconds(int value) {
    _updateState(
      (state) => state.copyWith(playgroundMissionCardTimerSeconds: value),
    );
  }

  void setPlaygroundMissionCardBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundMissionCardBrightness: value),
    );
  }

  void setPlaygroundCoinRewardAmount(int value) {
    _updateState((state) => state.copyWith(playgroundCoinRewardAmount: value));
  }

  void setPlaygroundCoinRewardSize(String value) {
    _updateState((state) => state.copyWith(playgroundCoinRewardSize: value));
  }

  void setPlaygroundCoinRewardLayout(String value) {
    _updateState((state) => state.copyWith(playgroundCoinRewardLayout: value));
  }

  void setPlaygroundCoinRewardLabel(String value) {
    _updateState((state) => state.copyWith(playgroundCoinRewardLabel: value));
  }

  void setPlaygroundCoinRewardIsDark(bool value) {
    _updateState((state) => state.copyWith(playgroundCoinRewardIsDark: value));
  }

  void setPlaygroundCoinRewardRarity(String value) {
    _updateState((state) => state.copyWith(playgroundCoinRewardRarity: value));
  }

  void setPlaygroundCoinRewardShowGlow(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundCoinRewardShowGlow: value),
    );
  }

  void setPlaygroundCoinRewardShowSparkle(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundCoinRewardShowSparkle: value),
    );
  }

  void setPlaygroundCoinRewardIsAnimating(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundCoinRewardIsAnimating: value),
    );
  }

  void setPlaygroundCoinRewardBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundCoinRewardBrightness: value),
    );
  }

  void setPlaygroundXpRewardAmount(int value) {
    _updateState((state) => state.copyWith(playgroundXpRewardAmount: value));
  }

  void setPlaygroundXpRewardSize(String value) {
    _updateState((state) => state.copyWith(playgroundXpRewardSize: value));
  }

  void setPlaygroundXpRewardLayout(String value) {
    _updateState((state) => state.copyWith(playgroundXpRewardLayout: value));
  }

  void setPlaygroundXpRewardLabel(String value) {
    _updateState((state) => state.copyWith(playgroundXpRewardLabel: value));
  }

  void setPlaygroundXpRewardIsDark(bool value) {
    _updateState((state) => state.copyWith(playgroundXpRewardIsDark: value));
  }

  void setPlaygroundXpRewardRarity(String value) {
    _updateState((state) => state.copyWith(playgroundXpRewardRarity: value));
  }

  void setPlaygroundXpRewardShowGlow(bool value) {
    _updateState((state) => state.copyWith(playgroundXpRewardShowGlow: value));
  }

  void setPlaygroundXpRewardShowSparkle(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundXpRewardShowSparkle: value),
    );
  }

  void setPlaygroundXpRewardIsAnimating(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundXpRewardIsAnimating: value),
    );
  }

  void setPlaygroundXpRewardIsLevelUp(bool value) {
    _updateState((state) => state.copyWith(playgroundXpRewardIsLevelUp: value));
  }

  void setPlaygroundXpRewardBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundXpRewardBrightness: value),
    );
  }

  void setPlaygroundRewardChestState(String value) {
    _updateState((state) => state.copyWith(playgroundRewardChestState: value));
  }

  void setPlaygroundRewardChestSize(String value) {
    _updateState((state) => state.copyWith(playgroundRewardChestSize: value));
  }

  void setPlaygroundRewardChestIsDark(bool value) {
    _updateState((state) => state.copyWith(playgroundRewardChestIsDark: value));
  }

  void setPlaygroundRewardChestRarity(String value) {
    _updateState((state) => state.copyWith(playgroundRewardChestRarity: value));
  }

  void setPlaygroundRewardChestShowGlow(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardChestShowGlow: value),
    );
  }

  void setPlaygroundRewardChestAutoOpen(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardChestAutoOpen: value),
    );
  }

  void setPlaygroundRewardChestBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardChestBrightness: value),
    );
  }

  void setPlaygroundRewardPopupTitle(String value) {
    _updateState((state) => state.copyWith(playgroundRewardPopupTitle: value));
  }

  void setPlaygroundRewardPopupSubtitle(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupSubtitle: value),
    );
  }

  void setPlaygroundRewardPopupPrimaryLabel(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupPrimaryLabel: value),
    );
  }

  void setPlaygroundRewardPopupSecondaryLabel(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupSecondaryLabel: value),
    );
  }

  void setPlaygroundRewardPopupIsDark(bool value) {
    _updateState((state) => state.copyWith(playgroundRewardPopupIsDark: value));
  }

  void setPlaygroundRewardPopupRarity(String value) {
    _updateState((state) => state.copyWith(playgroundRewardPopupRarity: value));
  }

  void setPlaygroundRewardPopupChestState(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupChestState: value),
    );
  }

  void setPlaygroundRewardPopupAutoOpenChest(bool value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupAutoOpenChest: value),
    );
  }

  void setPlaygroundRewardPopupEntryCount(int value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntryCount: value),
    );
  }

  void setPlaygroundRewardPopupBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupBrightness: value),
    );
  }

  void setPlaygroundRewardPopupEntry1Kind(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry1Kind: value),
    );
  }

  void setPlaygroundRewardPopupEntry1Amount(int value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry1Amount: value),
    );
  }

  void setPlaygroundRewardPopupEntry1Label(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry1Label: value),
    );
  }

  void setPlaygroundRewardPopupEntry1Rarity(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry1Rarity: value),
    );
  }

  void setPlaygroundRewardPopupEntry2Kind(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry2Kind: value),
    );
  }

  void setPlaygroundRewardPopupEntry2Amount(int value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry2Amount: value),
    );
  }

  void setPlaygroundRewardPopupEntry2Label(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry2Label: value),
    );
  }

  void setPlaygroundRewardPopupEntry2Rarity(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry2Rarity: value),
    );
  }

  void setPlaygroundRewardPopupEntry3Kind(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry3Kind: value),
    );
  }

  void setPlaygroundRewardPopupEntry3Amount(int value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry3Amount: value),
    );
  }

  void setPlaygroundRewardPopupEntry3Label(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry3Label: value),
    );
  }

  void setPlaygroundRewardPopupEntry3Rarity(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry3Rarity: value),
    );
  }

  void setPlaygroundRewardPopupEntry4Kind(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry4Kind: value),
    );
  }

  void setPlaygroundRewardPopupEntry4Amount(int value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry4Amount: value),
    );
  }

  void setPlaygroundRewardPopupEntry4Label(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry4Label: value),
    );
  }

  void setPlaygroundRewardPopupEntry4Rarity(String value) {
    _updateState(
      (state) => state.copyWith(playgroundRewardPopupEntry4Rarity: value),
    );
  }

  void setPlaygroundBackgroundBiome(String value) {
    _updateState((state) => state.copyWith(playgroundBackgroundBiome: value));
  }

  void setPlaygroundBackgroundParallaxOffset(double value) {
    _updateState(
      (state) => state.copyWith(playgroundBackgroundParallaxOffset: value),
    );
  }

  void setPlaygroundBackgroundBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundBackgroundBrightness: value),
    );
  }

  void setPlaygroundCameraZoom(double value) {
    _updateState((state) => state.copyWith(playgroundCameraZoom: value));
  }

  void setPlaygroundCameraFocusTarget(String value) {
    _updateState((state) => state.copyWith(playgroundCameraFocusTarget: value));
  }

  void setPlaygroundCameraBrightness(String value) {
    _updateState((state) => state.copyWith(playgroundCameraBrightness: value));
  }

  void setPlaygroundLegendTitle(String value) {
    _updateState((state) => state.copyWith(playgroundLegendTitle: value));
  }

  void setPlaygroundLegendBrightness(String value) {
    _updateState((state) => state.copyWith(playgroundLegendBrightness: value));
  }

  void setPlaygroundScrollViewZoom(double value) {
    _updateState((state) => state.copyWith(playgroundScrollViewZoom: value));
  }

  void setPlaygroundScrollViewFocusTarget(String value) {
    _updateState(
      (state) => state.copyWith(playgroundScrollViewFocusTarget: value),
    );
  }

  void setPlaygroundScrollViewBrightness(String value) {
    _updateState(
      (state) => state.copyWith(playgroundScrollViewBrightness: value),
    );
  }

  void setPlaygroundMapBiome(String value) {
    _updateState((state) => state.copyWith(playgroundMapBiome: value));
  }

  void setPlaygroundMapShowLegend(bool value) {
    _updateState((state) => state.copyWith(playgroundMapShowLegend: value));
  }

  void setPlaygroundMapFocusTarget(String value) {
    _updateState((state) => state.copyWith(playgroundMapFocusTarget: value));
  }

  void setPlaygroundMapBrightness(String value) {
    _updateState((state) => state.copyWith(playgroundMapBrightness: value));
  }
}
