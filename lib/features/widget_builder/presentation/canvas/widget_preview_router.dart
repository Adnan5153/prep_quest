import 'package:flutter/material.dart';
import '../providers/widget_builder_provider.dart';
import 'previews/buttons/primary_button_preview.dart';
import 'previews/buttons/secondary_button_preview.dart';
import 'previews/appbars/custom_appbar_preview.dart';
import 'previews/appbars/custom_sliver_appbar_preview.dart';
import 'previews/cards/animated_card_preview.dart';
import 'previews/cards/glass_card_preview.dart';
import 'previews/cards/glass_container_preview.dart';
import 'previews/cards/streak_card_preview.dart';
import 'previews/loading/loading_widget_preview.dart';
import 'previews/loading/loading_overlay_preview.dart';
import 'previews/loading/fullscreen_loader_preview.dart';
import 'previews/errors/network_error_preview.dart';
import 'previews/avatars/profile_avatar_preview.dart';
import 'previews/chips/status_chip_preview.dart';
import 'previews/chips/premium_badge_preview.dart';
import 'previews/chips/tag_chip_preview.dart';
import 'previews/progress/xp_progress_bar_preview.dart';
import 'previews/misc/image_placeholder_preview.dart';
import 'previews/misc/responsive_builder_preview.dart';
import 'previews/misc/responsive_layout_preview.dart';
import 'previews/misc/title_with_action_preview.dart';
import 'previews/misc/widget_constants_preview.dart';
import 'previews/misc/simple_previews.dart';
import 'previews/buttons/ai_action_button_preview.dart';
import 'previews/ai/ai_chat_bubble_preview.dart';
import 'previews/ai/ai_chat_input_bar_preview.dart';
import 'previews/ai/ai_chat_message_list_preview.dart';
import 'previews/ai/ai_explanation_card_preview.dart';
import 'previews/ai/ai_hint_card_preview.dart';
import 'previews/ai/ai_history_section_preview.dart';
import 'previews/ai/ai_history_tile_preview.dart';
import 'previews/ai/ai_loading_card_preview.dart';
import 'previews/ai/ai_response_card_preview.dart';
import 'previews/avatars/ai_avatar_animation_preview.dart';
import 'previews/misc/ai_empty_state_preview.dart';
import 'previews/misc/ai_error_state_preview.dart';
import 'previews/misc/ai_summary_card_preview.dart';
import 'previews/ai/ai_shimmer_loading_text_preview.dart';
import 'previews/ai/ai_typing_indicator_preview.dart';
import 'previews/misc/app_snackbar_preview.dart';
import 'previews/playground/playground_node_preview.dart';
import 'previews/playground/node_ring_preview.dart';
import 'previews/playground/node_icon_preview.dart';
import 'previews/playground/node_badge_preview.dart';
import 'previews/playground/node_label_preview.dart';
import 'previews/playground/node_progress_indicator_preview.dart';
import 'previews/playground/tree_preview.dart';
import 'previews/playground/bush_preview.dart';
import 'previews/playground/cloud_preview.dart';
import 'previews/playground/mountain_preview.dart';
import 'previews/playground/river_preview.dart';
import 'previews/playground/bridge_preview.dart';
import 'previews/playground/path_preview.dart';
import 'previews/playground/flag_preview.dart';
import 'previews/playground/particles_preview.dart';
import 'previews/playground/playground_particle_layer_preview.dart';
import 'previews/playground/playground_building_preview.dart';
import 'previews/playground/academy_building_preview.dart';
import 'previews/playground/library_building_preview.dart';
import 'previews/playground/building_label_preview.dart';
import 'previews/playground/building_progress_preview.dart';
import 'previews/playground/profile_summary_preview.dart';
import 'previews/playground/xp_indicator_preview.dart';
import 'previews/playground/coin_counter_preview.dart';
import 'previews/playground/energy_indicator_preview.dart';
import 'previews/playground/streak_card_overlay_preview.dart';
import 'previews/playground/playground_top_bar_preview.dart';
import 'previews/playground/level_progress_card_preview.dart';
import 'previews/playground/mission_card_preview.dart';
import 'previews/playground/coin_reward_preview.dart';
import 'previews/playground/xp_reward_preview.dart';
import 'previews/playground/reward_chest_preview.dart';
import 'previews/playground/reward_popup_preview.dart';
import 'previews/playground/playground_background_preview.dart';
import 'previews/playground/playground_camera_preview.dart';
import 'previews/playground/playground_legend_preview.dart';
import 'previews/playground/playground_scroll_view_preview.dart';
import 'previews/playground/playground_map_preview.dart';
import 'previews/quiz/quiz_result_previews.dart';
import 'previews/leaderboard/leaderboard_previews.dart';
import 'previews/notifications/notification_previews.dart';
import 'previews/quick_actions/quick_actions_previews.dart';

class WidgetPreviewRouter {
  static Widget getPreview(WidgetBuilderProvider provider, ThemeData theme) {
    switch (provider.selection) {
      case WidgetBuilderSelection.primaryButton:
        return PrimaryButtonPreview(provider: provider);
      case WidgetBuilderSelection.secondaryButton:
        return SecondaryButtonPreview(provider: provider);
      case WidgetBuilderSelection.outlinedButton:
        return SimplePreviews.outlinedButton(provider);
      case WidgetBuilderSelection.card:
        return SimplePreviews.card(provider, theme);
      case WidgetBuilderSelection.badgeChip:
        return SimplePreviews.badgeChip(provider);
      case WidgetBuilderSelection.progressBar:
        return SimplePreviews.progressBar(provider);
      case WidgetBuilderSelection.customAppBar:
        return CustomAppBarPreview(provider: provider);
      case WidgetBuilderSelection.customSliverAppBar:
        return CustomSliverAppBarPreview(provider: provider);
      case WidgetBuilderSelection.animatedCard:
        return AnimatedCardPreview(provider: provider);
      case WidgetBuilderSelection.glassCard:
        return GlassCardPreview(provider: provider);
      case WidgetBuilderSelection.glassContainer:
        return GlassContainerPreview(provider: provider);
      case WidgetBuilderSelection.streakCard:
        return StreakCardPreview(provider: provider);
      case WidgetBuilderSelection.loadingWidget:
        return LoadingWidgetPreview(provider: provider);
      case WidgetBuilderSelection.loadingOverlay:
        return LoadingOverlayPreview(provider: provider);
      case WidgetBuilderSelection.fullscreenLoader:
        return FullscreenLoaderPreview(provider: provider);
      case WidgetBuilderSelection.networkErrorWidget:
        return NetworkErrorPreview(provider: provider);
      case WidgetBuilderSelection.profileAvatar:
        return ProfileAvatarPreview(provider: provider);
      case WidgetBuilderSelection.statusChip:
        return StatusChipPreview(provider: provider);
      case WidgetBuilderSelection.premiumBadge:
        return PremiumBadgePreview(provider: provider);
      case WidgetBuilderSelection.tagChip:
        return TagChipPreview(provider: provider);
      case WidgetBuilderSelection.xpProgressBar:
        return XPProgressBarPreview(provider: provider);
      case WidgetBuilderSelection.imagePlaceholder:
        return ImagePlaceholderPreview(provider: provider);
      case WidgetBuilderSelection.responsiveBuilder:
        return ResponsiveBuilderPreview(provider: provider);
      case WidgetBuilderSelection.responsiveLayout:
        return ResponsiveLayoutPreview(provider: provider);
      case WidgetBuilderSelection.titleWithAction:
        return TitleWithActionPreview(provider: provider);
      case WidgetBuilderSelection.widgetConstants:
        return WidgetConstantsPreview(provider: provider);
      case WidgetBuilderSelection.customBottomNavigation:
        return const BottomNavigationPreview();
      case WidgetBuilderSelection.customCheckbox:
        return const CheckboxPreview();
      case WidgetBuilderSelection.comingSoon:
        return const ComingSoonPreview();
      case WidgetBuilderSelection.categoryChip:
        return const CategoryChipPreview();
      case WidgetBuilderSelection.customDivider:
        return const DividerPreview();
      case WidgetBuilderSelection.customDrawer:
        return const DrawerPreview();
      case WidgetBuilderSelection.customDropdown:
        return const DropdownPreview();
      case WidgetBuilderSelection.customNavigationRail:
        return const NavigationRailPreview();
      case WidgetBuilderSelection.customRadio:
        return const RadioPreview();
      case WidgetBuilderSelection.customSearchField:
        return const SearchFieldPreview();
      case WidgetBuilderSelection.customSlider:
        return const SliderPreview();
      case WidgetBuilderSelection.aiActionButton:
        return AiActionButtonPreview(provider: provider);
      case WidgetBuilderSelection.aiChatBubble:
        return AiChatBubblePreview(provider: provider);
      case WidgetBuilderSelection.aiAvatarAnimation:
        return AiAvatarAnimationPreview(provider: provider);
      case WidgetBuilderSelection.aiExplanationCard:
        return AiExplanationCardPreview(provider: provider);
      case WidgetBuilderSelection.aiHintCard:
        return AiHintCardPreview(provider: provider);
      case WidgetBuilderSelection.aiHistorySection:
        return AiHistorySectionPreview(provider: provider);
      case WidgetBuilderSelection.aiHistoryTile:
        return AiHistoryTilePreview(provider: provider);
      case WidgetBuilderSelection.aiLoadingCard:
        return AiLoadingCardPreview(provider: provider);
      case WidgetBuilderSelection.aiResponseCard:
        return AiResponseCardPreview(provider: provider);
      case WidgetBuilderSelection.aiEmptyState:
        return AiEmptyStatePreview(provider: provider);
      case WidgetBuilderSelection.aiErrorState:
        return AiErrorStatePreview(provider: provider);
      case WidgetBuilderSelection.aiSummaryCard:
        return AiSummaryCardPreview(provider: provider);
      case WidgetBuilderSelection.aiChatInputBar:
        return AiChatInputBarPreview(provider: provider);
      case WidgetBuilderSelection.aiChatMessageList:
        return AiChatMessageListPreview(provider: provider);
      case WidgetBuilderSelection.aiShimmerLoadingText:
        return AiShimmerLoadingTextPreview(provider: provider);
      case WidgetBuilderSelection.aiTypingIndicator:
        return AiTypingIndicatorPreview(provider: provider);
      case WidgetBuilderSelection.appSnackBar:
        return AppSnackBarPreview(provider: provider);
      case WidgetBuilderSelection.playgroundNode:
        return PlaygroundNodePreview(provider: provider);
      case WidgetBuilderSelection.nodeRing:
        return NodeRingPreview(provider: provider);
      case WidgetBuilderSelection.nodeIcon:
        return NodeIconPreview(provider: provider);
      case WidgetBuilderSelection.nodeBadge:
        return NodeBadgePreview(provider: provider);
      case WidgetBuilderSelection.nodeLabel:
        return NodeLabelPreview(provider: provider);
      case WidgetBuilderSelection.nodeProgressIndicator:
        return NodeProgressIndicatorPreview(provider: provider);
      case WidgetBuilderSelection.tree:
        return TreePreview(provider: provider);
      case WidgetBuilderSelection.bush:
        return BushPreview(provider: provider);
      case WidgetBuilderSelection.cloud:
        return CloudPreview(provider: provider);
      case WidgetBuilderSelection.mountain:
        return MountainPreview(provider: provider);
      case WidgetBuilderSelection.river:
        return RiverPreview(provider: provider);
      case WidgetBuilderSelection.bridge:
        return BridgePreview(provider: provider);
      case WidgetBuilderSelection.path:
        return PathPreview(provider: provider);
      case WidgetBuilderSelection.flag:
        return FlagPreview(provider: provider);
      case WidgetBuilderSelection.particles:
        return ParticlesPreview(provider: provider);
      case WidgetBuilderSelection.playgroundParticleLayer:
        return PlaygroundParticleLayerPreview(provider: provider);
      case WidgetBuilderSelection.playgroundBuilding:
        return PlaygroundBuildingPreview(provider: provider);
      case WidgetBuilderSelection.academyBuilding:
        return AcademyBuildingPreview(provider: provider);
      case WidgetBuilderSelection.libraryBuilding:
        return LibraryBuildingPreview(provider: provider);
      case WidgetBuilderSelection.buildingLabel:
        return BuildingLabelPreview(provider: provider);
      case WidgetBuilderSelection.buildingProgress:
        return BuildingProgressPreview(provider: provider);
      case WidgetBuilderSelection.playgroundProfileSummary:
        return ProfileSummaryPreview(provider: provider);
      case WidgetBuilderSelection.playgroundXpIndicator:
        return XpIndicatorPreview(provider: provider);
      case WidgetBuilderSelection.playgroundCoinCounter:
        return CoinCounterPreview(provider: provider);
      case WidgetBuilderSelection.playgroundEnergyIndicator:
        return EnergyIndicatorPreview(provider: provider);
      case WidgetBuilderSelection.playgroundStreakCard:
        return StreakCardOverlayPreview(provider: provider);
      case WidgetBuilderSelection.playgroundTopBar:
        return PlaygroundTopBarPreview(provider: provider);
      case WidgetBuilderSelection.playgroundLevelProgressCard:
        return LevelProgressCardPreview(provider: provider);
      case WidgetBuilderSelection.playgroundMissionCard:
        return MissionCardPreview(provider: provider);
      case WidgetBuilderSelection.playgroundCoinReward:
        return CoinRewardPreview(provider: provider);
      case WidgetBuilderSelection.playgroundXpReward:
        return XpRewardPreview(provider: provider);
      case WidgetBuilderSelection.playgroundRewardChest:
        return RewardChestPreview(provider: provider);
      case WidgetBuilderSelection.playgroundRewardPopup:
        return RewardPopupPreview(provider: provider);
      case WidgetBuilderSelection.playgroundBackground:
        return PlaygroundBackgroundPreview(provider: provider);
      case WidgetBuilderSelection.playgroundCamera:
        return PlaygroundCameraPreview(provider: provider);
      case WidgetBuilderSelection.playgroundLegend:
        return PlaygroundLegendPreview(provider: provider);
      case WidgetBuilderSelection.playgroundScrollView:
        return PlaygroundScrollViewPreview(provider: provider);
      case WidgetBuilderSelection.playgroundMap:
        return PlaygroundMapPreview(provider: provider);
      case WidgetBuilderSelection.quizResultHeroCard:
        return QuizResultHeroCardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultStatsGrid:
        return QuizResultStatsGridPreview(provider: provider);
      case WidgetBuilderSelection.quizResultAccuracyCard:
        return QuizResultAccuracyCardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultTimeAnalysisCard:
        return QuizResultTimeAnalysisCardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultRankProgressCard:
        return QuizResultRankProgressCardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultXpReward:
        return QuizResultXpRewardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultCoinReward:
        return QuizResultCoinRewardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultStarReward:
        return QuizResultStarRewardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultWeakTopicsCard:
        return QuizResultWeakTopicsCardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultStrongTopicsCard:
        return QuizResultStrongTopicsCardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultPerformanceSummaryCard:
        return QuizResultPerformanceSummaryCardPreview(provider: provider);
      case WidgetBuilderSelection.quizResultMotivationalBanner:
        return QuizResultMotivationalBannerPreview(provider: provider);
      case WidgetBuilderSelection.quizResultShareDialog:
        return QuizResultShareDialogPreview(provider: provider);
      case WidgetBuilderSelection.quizResultConfettiAnimation:
        return QuizResultConfettiAnimationPreview(provider: provider);
      case WidgetBuilderSelection.leaderboardPodium:
      case WidgetBuilderSelection.leaderboardRankTile:
      case WidgetBuilderSelection.leaderboardCard:
      case WidgetBuilderSelection.leaderboardAvatar:
      case WidgetBuilderSelection.leaderboardHeader:
      case WidgetBuilderSelection.leaderboardFilterTabs:
      case WidgetBuilderSelection.leaderboardCurrentUserCard:
      case WidgetBuilderSelection.leaderboardEmptyState:
      case WidgetBuilderSelection.leaderboardLoadingState:
      case WidgetBuilderSelection.leaderboardErrorState:
      case WidgetBuilderSelection.leaderboardStatisticsCard:
      case WidgetBuilderSelection.leaderboardRankBadge:
      case WidgetBuilderSelection.leaderboardProgressIndicator:
      case WidgetBuilderSelection.leaderboardSearchBar:
      case WidgetBuilderSelection.leaderboardSortSheet:
        return LeaderboardFocusedPreview(provider: provider);
      case WidgetBuilderSelection.notificationBadge:
        return NotificationBadgePreview(provider: provider);
      case WidgetBuilderSelection.quickActionsSheet:
      case WidgetBuilderSelection.quickActionTile:
      case WidgetBuilderSelection.quickActionGrid:
      case WidgetBuilderSelection.quickActionsHeader:
        return QuickActionsPreview(provider: provider);
    }
  }
}
