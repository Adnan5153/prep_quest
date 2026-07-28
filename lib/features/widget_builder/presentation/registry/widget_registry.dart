import '../models/widget_builder_item.dart';
import '../providers/widget_builder_selection.dart';

class WidgetRegistry {
  static const List<WidgetBuilderItem> items = [
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.primaryButton,
      name: 'Primary Button',
      category: WidgetCategory.buttons,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.secondaryButton,
      name: 'Secondary Button',
      category: WidgetCategory.buttons,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.outlinedButton,
      name: 'Outlined Button',
      category: WidgetCategory.buttons,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiActionButton,
      name: 'AI Action Button',
      category: WidgetCategory.buttons,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiChatBubble,
      name: 'AI Chat Bubble',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiExplanationCard,
      name: 'AI Explanation Card',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiHintCard,
      name: 'AI Hint Card',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiHistorySection,
      name: 'AI History Section',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiHistoryTile,
      name: 'AI History Tile',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiLoadingCard,
      name: 'AI Loading Card',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiResponseCard,
      name: 'AI Response Card',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiEmptyState,
      name: 'AI Empty State',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiErrorState,
      name: 'AI Error State',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiSummaryCard,
      name: 'AI Summary Card',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiChatInputBar,
      name: 'AI Chat Input Bar',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiChatMessageList,
      name: 'AI Chat Message List',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiShimmerLoadingText,
      name: 'AI Shimmer Loading Text',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiTypingIndicator,
      name: 'AI Typing Indicator',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.appSnackBar,
      name: 'App SnackBar',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.animatedCard,
      name: 'Animated Card',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.glassCard,
      name: 'Glass Card',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.glassContainer,
      name: 'Glass Container',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.streakCard,
      name: 'Streak Card',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customAppBar,
      name: 'Custom App Bar',
      category: WidgetCategory.appbars,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customSliverAppBar,
      name: 'Sliver App Bar',
      category: WidgetCategory.appbars,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.loadingWidget,
      name: 'Loading Widget',
      category: WidgetCategory.loading,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.loadingOverlay,
      name: 'Loading Overlay',
      category: WidgetCategory.loading,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.fullscreenLoader,
      name: 'Fullscreen Loader',
      category: WidgetCategory.loading,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.networkErrorWidget,
      name: 'Network Error',
      category: WidgetCategory.errors,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.profileAvatar,
      name: 'Profile Avatar',
      category: WidgetCategory.avatars,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.aiAvatarAnimation,
      name: 'AI Avatar Animation',
      category: WidgetCategory.avatars,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.statusChip,
      name: 'Status Chip',
      category: WidgetCategory.chips,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.premiumBadge,
      name: 'Premium Badge',
      category: WidgetCategory.chips,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.tagChip,
      name: 'Tag Chip',
      category: WidgetCategory.chips,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.categoryChip,
      name: 'Category Chip',
      category: WidgetCategory.chips,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.badgeChip,
      name: 'Badge Chip',
      category: WidgetCategory.chips,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.xpProgressBar,
      name: 'XP Progress Bar',
      category: WidgetCategory.progress,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.progressBar,
      name: 'Progress Bar',
      category: WidgetCategory.progress,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customBottomNavigation,
      name: 'Bottom Navigation',
      category: WidgetCategory.navigation,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customNavigationRail,
      name: 'Navigation Rail',
      category: WidgetCategory.navigation,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customDrawer,
      name: 'Custom Drawer',
      category: WidgetCategory.navigation,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customCheckbox,
      name: 'Checkbox',
      category: WidgetCategory.inputs,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customRadio,
      name: 'Radio Button',
      category: WidgetCategory.inputs,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customDropdown,
      name: 'Dropdown',
      category: WidgetCategory.inputs,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customSearchField,
      name: 'Search Field',
      category: WidgetCategory.inputs,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customSlider,
      name: 'Slider',
      category: WidgetCategory.inputs,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.responsiveBuilder,
      name: 'Responsive Builder',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.responsiveLayout,
      name: 'Responsive Layout',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.imagePlaceholder,
      name: 'Image Placeholder',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.titleWithAction,
      name: 'Title with Action',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.widgetConstants,
      name: 'Widget Constants',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.customDivider,
      name: 'Custom Divider',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.comingSoon,
      name: 'Coming Soon',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundNode,
      name: 'Playground Node',
      category: WidgetCategory.playgroundNodes,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.nodeRing,
      name: 'Node Ring',
      category: WidgetCategory.playgroundNodes,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.nodeIcon,
      name: 'Node Icon',
      category: WidgetCategory.playgroundNodes,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.nodeBadge,
      name: 'Node Badge',
      category: WidgetCategory.playgroundNodes,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.nodeLabel,
      name: 'Node Label',
      category: WidgetCategory.playgroundNodes,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.nodeProgressIndicator,
      name: 'Node Progress Indicator',
      category: WidgetCategory.playgroundNodes,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.tree,
      name: 'Tree',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.bush,
      name: 'Bush',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.cloud,
      name: 'Cloud',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.mountain,
      name: 'Mountain',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.river,
      name: 'River',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.bridge,
      name: 'Bridge',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.flag,
      name: 'Flag',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.particles,
      name: 'Pool Particles',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundParticleLayer,
      name: 'Particle Layer',
      category: WidgetCategory.playgroundDecorations,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundBuilding,
      name: 'Playground Building',
      category: WidgetCategory.playgroundBuildings,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.academyBuilding,
      name: 'Academy Building',
      category: WidgetCategory.playgroundBuildings,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.libraryBuilding,
      name: 'Library Building',
      category: WidgetCategory.playgroundBuildings,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.buildingLabel,
      name: 'Building Label',
      category: WidgetCategory.playgroundBuildings,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.buildingProgress,
      name: 'Building Progress',
      category: WidgetCategory.playgroundBuildings,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundProfileSummary,
      name: 'Profile Summary',
      category: WidgetCategory.playgroundOverlays,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundXpIndicator,
      name: 'XP Indicator',
      category: WidgetCategory.playgroundOverlays,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundCoinCounter,
      name: 'Coin Counter',
      category: WidgetCategory.playgroundOverlays,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundEnergyIndicator,
      name: 'Energy Indicator',
      category: WidgetCategory.playgroundOverlays,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundStreakCard,
      name: 'Streak Card Overlay',
      category: WidgetCategory.playgroundOverlays,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundTopBar,
      name: 'Playground Top Bar',
      category: WidgetCategory.playgroundOverlays,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundLevelProgressCard,
      name: 'Level Progress Card',
      category: WidgetCategory.playgroundCards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundMissionCard,
      name: 'Mission Card',
      category: WidgetCategory.playgroundCards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundCoinReward,
      name: 'Coin Reward',
      category: WidgetCategory.playgroundRewards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundXpReward,
      name: 'XP Reward',
      category: WidgetCategory.playgroundRewards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundRewardChest,
      name: 'Reward Chest',
      category: WidgetCategory.playgroundRewards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundRewardPopup,
      name: 'Reward Popup',
      category: WidgetCategory.playgroundRewards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundBackground,
      name: 'Map Background',
      category: WidgetCategory.playgroundMaps,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundCamera,
      name: 'Map Camera',
      category: WidgetCategory.playgroundMaps,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundLegend,
      name: 'Map Legend',
      category: WidgetCategory.playgroundMaps,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundScrollView,
      name: 'Map Scroll View',
      category: WidgetCategory.playgroundMaps,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.playgroundMap,
      name: 'Map Composition',
      category: WidgetCategory.playgroundMaps,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultHeroCard,
      name: 'Quiz Result Hero Card',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultStatsGrid,
      name: 'Quiz Result Stats Grid',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultAccuracyCard,
      name: 'Quiz Result Accuracy Card',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultTimeAnalysisCard,
      name: 'Quiz Result Time Analysis',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultRankProgressCard,
      name: 'Quiz Result Rank Progress',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultXpReward,
      name: 'Quiz Result XP Reward',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultCoinReward,
      name: 'Quiz Result Coin Reward',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultStarReward,
      name: 'Quiz Result Star Reward',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultWeakTopicsCard,
      name: 'Quiz Result Weak Topics',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultStrongTopicsCard,
      name: 'Quiz Result Strong Topics',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultPerformanceSummaryCard,
      name: 'Quiz Result Performance Summary',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultMotivationalBanner,
      name: 'Quiz Result Motivational Banner',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultShareDialog,
      name: 'Quiz Result Share Dialog',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quizResultConfettiAnimation,
      name: 'Quiz Result Confetti',
      category: WidgetCategory.misc,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardPodium,
      name: 'Leaderboard Podium',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardRankTile,
      name: 'Leaderboard Rank Tile',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardCard,
      name: 'Leaderboard Card',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardAvatar,
      name: 'Leaderboard Avatar',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardHeader,
      name: 'Leaderboard Header',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardFilterTabs,
      name: 'Leaderboard Filter Tabs',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardCurrentUserCard,
      name: 'Leaderboard Current User Card',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardEmptyState,
      name: 'Leaderboard Empty State',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardLoadingState,
      name: 'Leaderboard Loading State',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardErrorState,
      name: 'Leaderboard Error State',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardStatisticsCard,
      name: 'Leaderboard Statistics Card',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardRankBadge,
      name: 'Leaderboard Rank Badge',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardProgressIndicator,
      name: 'Leaderboard Progress Indicator',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardSearchBar,
      name: 'Leaderboard Search Bar',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.leaderboardSortSheet,
      name: 'Leaderboard Sort Sheet',
      category: WidgetCategory.leaderboard,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.notificationBadge,
      name: 'Notification Badge',
      category: WidgetCategory.chips,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quickActionsSheet,
      name: 'Quick Actions Sheet',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quickActionTile,
      name: 'Quick Action Tile',
      category: WidgetCategory.buttons,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quickActionGrid,
      name: 'Quick Action Grid',
      category: WidgetCategory.cards,
    ),
    WidgetBuilderItem(
      selection: WidgetBuilderSelection.quickActionsHeader,
      name: 'Quick Actions Header',
      category: WidgetCategory.appbars,
    ),
  ];

  static List<WidgetBuilderItem> getByCategory(WidgetCategory category) {
    return items.where((item) => item.category == category).toList();
  }
}
