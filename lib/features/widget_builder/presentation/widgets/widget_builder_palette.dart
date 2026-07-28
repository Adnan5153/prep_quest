import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../providers/widget_builder_provider.dart';
import '../registry/widget_registry.dart';
import '../palette/controls/button_controls.dart';
import '../palette/controls/appbar_controls.dart';
import '../palette/controls/error_controls.dart';
import '../palette/controls/loading_controls.dart';
import '../palette/controls/chip_controls.dart';
import '../palette/controls/avatar_controls.dart';
import '../palette/controls/progress_controls.dart';
import '../palette/controls/animation_controls.dart';
import '../palette/controls/text_controls.dart';
import '../palette/controls/slider_controls.dart';
import '../palette/controls/card_controls.dart';
import '../palette/controls/switch_controls.dart';
import '../palette/controls/ai_button_controls.dart';
import '../palette/controls/ai_chat_bubble_controls.dart';
import '../palette/controls/ai_explanation_card_controls.dart';
import '../palette/controls/ai_hint_card_controls.dart';
import '../palette/controls/ai_history_section_controls.dart';
import '../palette/controls/ai_history_tile_controls.dart';
import '../palette/controls/ai_loading_card_controls.dart';
import '../palette/controls/ai_response_card_controls.dart';
import '../palette/controls/ai_avatar_animation_controls.dart';
import '../palette/controls/playground/playground_node_controls.dart';
import '../palette/controls/playground/node_ring_controls.dart';
import '../palette/controls/playground/node_icon_controls.dart';
import '../palette/controls/playground/node_badge_controls.dart';
import '../palette/controls/playground/node_label_controls.dart';
import '../palette/controls/playground/node_progress_indicator_controls.dart';
import '../palette/controls/playground/tree_controls.dart';
import '../palette/controls/playground/bush_controls.dart';
import '../palette/controls/playground/cloud_controls.dart';
import '../palette/controls/playground/mountain_controls.dart';
import '../palette/controls/playground/river_controls.dart';
import '../palette/controls/playground/bridge_controls.dart';
import '../palette/controls/playground/path_controls.dart';
import '../palette/controls/playground/flag_controls.dart';
import '../palette/controls/playground/particles_controls.dart';
import '../palette/controls/playground/playground_particle_layer_controls.dart';
import '../palette/controls/playground/playground_building_controls.dart';
import '../palette/controls/playground/academy_building_controls.dart';
import '../palette/controls/playground/library_building_controls.dart';
import '../palette/controls/playground/building_label_controls.dart';
import '../palette/controls/playground/building_progress_controls.dart';
import '../palette/controls/playground/profile_summary_controls.dart';
import '../palette/controls/playground/xp_indicator_controls.dart';
import '../palette/controls/playground/coin_counter_controls.dart';
import '../palette/controls/playground/energy_indicator_controls.dart';
import '../palette/controls/playground/streak_card_overlay_controls.dart';
import '../palette/controls/playground/playground_top_bar_controls.dart';
import '../palette/controls/playground/level_progress_card_controls.dart';
import '../palette/controls/playground/mission_card_controls.dart';
import '../palette/controls/playground/coin_reward_controls.dart';
import '../palette/controls/playground/xp_reward_controls.dart';
import '../palette/controls/playground/reward_chest_controls.dart';
import '../palette/controls/playground/reward_popup_controls.dart';
import '../palette/controls/playground/playground_background_controls.dart';
import '../palette/controls/playground/playground_camera_controls.dart';
import '../palette/controls/playground/playground_legend_controls.dart';
import '../palette/controls/playground/playground_scroll_view_controls.dart';
import '../palette/controls/playground/playground_map_controls.dart';

/// Side panel that lets the user pick which widget to preview and tweak
/// its options. Owns no state — everything is delegated to
/// [WidgetBuilderProvider].
class WidgetBuilderPalette extends StatelessWidget {
  const WidgetBuilderPalette({
    super.key,
    required this.provider,
    required this.onSelectionChanged,
    required this.onLabelChanged,
    this.onSubtitleChanged,
    this.onShowLeadingChanged,
    this.onShowAccentStripeChanged,
  });

  final WidgetBuilderProvider provider;
  final ValueChanged<WidgetBuilderSelection> onSelectionChanged;
  final ValueChanged<String> onLabelChanged;

  final ValueChanged<String>? onSubtitleChanged;
  final ValueChanged<bool>? onShowLeadingChanged;
  final ValueChanged<bool>? onShowAccentStripeChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Widget', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<WidgetBuilderSelection>(
                initialValue: provider.selection,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Select widget'),
                items: WidgetRegistry.items
                    .map(
                      (item) => DropdownMenuItem<WidgetBuilderSelection>(
                        value: item.selection,
                        child: Text(item.name, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (WidgetBuilderSelection? value) {
                  if (value != null) {
                    onSelectionChanged(value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Label', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                initialValue: provider.label,
                decoration: const InputDecoration(labelText: 'Preview label'),
                onChanged: onLabelChanged,
              ),
              _buildDynamicControls(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicControls(ThemeData theme) {
    switch (provider.selection) {
      case WidgetBuilderSelection.primaryButton:
        return PrimaryButtonControls(provider: provider);
      case WidgetBuilderSelection.secondaryButton:
        return SecondaryButtonControls(provider: provider);
      case WidgetBuilderSelection.customAppBar:
        return AppBarControls(provider: provider);
      case WidgetBuilderSelection.networkErrorWidget:
        return NetworkErrorControls(provider: provider);
      case WidgetBuilderSelection.loadingWidget:
        return LoadingControls(provider: provider);
      case WidgetBuilderSelection.premiumBadge:
        return PremiumBadgeControls(provider: provider);
      case WidgetBuilderSelection.statusChip:
        return StatusChipControls(provider: provider);
      case WidgetBuilderSelection.tagChip:
        return TagChipControls(provider: provider);
      case WidgetBuilderSelection.profileAvatar:
        return ProfileAvatarControls(provider: provider);
      case WidgetBuilderSelection.xpProgressBar:
        return XPProgressBarControls(provider: provider);
      case WidgetBuilderSelection.animatedCard:
        return AnimatedCardControls(provider: provider);
      case WidgetBuilderSelection.streakCard:
        return StreakCardControls(provider: provider);
      case WidgetBuilderSelection.titleWithAction:
        return TitleWithActionControls(provider: provider);
      case WidgetBuilderSelection.widgetConstants:
        return WidgetConstantsControls(provider: provider);
      case WidgetBuilderSelection.responsiveBuilder:
      case WidgetBuilderSelection.responsiveLayout:
        return SimulationControls(provider: provider);
      case WidgetBuilderSelection.aiActionButton:
        return AiActionButtonControls(provider: provider);
      case WidgetBuilderSelection.aiChatBubble:
        return AiChatBubbleControls(provider: provider);
      case WidgetBuilderSelection.aiAvatarAnimation:
        return AiAvatarAnimationControls(provider: provider);
      case WidgetBuilderSelection.aiExplanationCard:
        return AiExplanationCardControls(provider: provider);
      case WidgetBuilderSelection.aiHintCard:
        return AiHintCardControls(provider: provider);
      case WidgetBuilderSelection.aiHistorySection:
        return AiHistorySectionControls(provider: provider);
      case WidgetBuilderSelection.aiHistoryTile:
        return AiHistoryTileControls(provider: provider);
      case WidgetBuilderSelection.aiLoadingCard:
        return AiLoadingCardControls(provider: provider);
      case WidgetBuilderSelection.aiResponseCard:
        return AiResponseCardControls(provider: provider);
      case WidgetBuilderSelection.aiEmptyState:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.aiErrorState:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.aiSummaryCard:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.aiChatInputBar:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.aiChatMessageList:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.aiShimmerLoadingText:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.aiTypingIndicator:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.appSnackBar:
        return const SizedBox.shrink();
      case WidgetBuilderSelection.playgroundNode:
        return PlaygroundNodeControls(provider: provider);
      case WidgetBuilderSelection.nodeRing:
        return NodeRingControls(provider: provider);
      case WidgetBuilderSelection.nodeIcon:
        return NodeIconControls(provider: provider);
      case WidgetBuilderSelection.nodeBadge:
        return NodeBadgeControls(provider: provider);
      case WidgetBuilderSelection.nodeLabel:
        return NodeLabelControls(provider: provider);
      case WidgetBuilderSelection.nodeProgressIndicator:
        return NodeProgressIndicatorControls(provider: provider);
      case WidgetBuilderSelection.tree:
        return TreeControls(provider: provider);
      case WidgetBuilderSelection.bush:
        return BushControls(provider: provider);
      case WidgetBuilderSelection.cloud:
        return CloudControls(provider: provider);
      case WidgetBuilderSelection.mountain:
        return MountainControls(provider: provider);
      case WidgetBuilderSelection.river:
        return RiverControls(provider: provider);
      case WidgetBuilderSelection.bridge:
        return BridgeControls(provider: provider);
      case WidgetBuilderSelection.path:
        return PathControls(provider: provider);
      case WidgetBuilderSelection.flag:
        return FlagControls(provider: provider);
      case WidgetBuilderSelection.particles:
        return ParticlesControls(provider: provider);
      case WidgetBuilderSelection.playgroundParticleLayer:
        return PlaygroundParticleLayerControls(provider: provider);
      case WidgetBuilderSelection.playgroundBuilding:
        return PlaygroundBuildingControls(provider: provider);
      case WidgetBuilderSelection.academyBuilding:
        return AcademyBuildingControls(provider: provider);
      case WidgetBuilderSelection.libraryBuilding:
        return LibraryBuildingControls(provider: provider);
      case WidgetBuilderSelection.buildingLabel:
        return BuildingLabelControls(provider: provider);
      case WidgetBuilderSelection.buildingProgress:
        return BuildingProgressControls(provider: provider);
      case WidgetBuilderSelection.playgroundProfileSummary:
        return ProfileSummaryControls(provider: provider);
      case WidgetBuilderSelection.playgroundXpIndicator:
        return XpIndicatorControls(provider: provider);
      case WidgetBuilderSelection.playgroundCoinCounter:
        return CoinCounterControls(provider: provider);
      case WidgetBuilderSelection.playgroundEnergyIndicator:
        return EnergyIndicatorControls(provider: provider);
      case WidgetBuilderSelection.playgroundStreakCard:
        return StreakCardOverlayControls(provider: provider);
      case WidgetBuilderSelection.playgroundTopBar:
        return PlaygroundTopBarControls(provider: provider);
      case WidgetBuilderSelection.playgroundLevelProgressCard:
        return LevelProgressCardControls(provider: provider);
      case WidgetBuilderSelection.playgroundMissionCard:
        return MissionCardControls(provider: provider);
      case WidgetBuilderSelection.playgroundCoinReward:
        return CoinRewardControls(provider: provider);
      case WidgetBuilderSelection.playgroundXpReward:
        return XpRewardControls(provider: provider);
      case WidgetBuilderSelection.playgroundRewardChest:
        return RewardChestControls(provider: provider);
      case WidgetBuilderSelection.playgroundRewardPopup:
        return RewardPopupControls(provider: provider);
      case WidgetBuilderSelection.playgroundBackground:
        return PlaygroundBackgroundControls(provider: provider);
      case WidgetBuilderSelection.playgroundCamera:
        return PlaygroundCameraControls(provider: provider);
      case WidgetBuilderSelection.playgroundLegend:
        return PlaygroundLegendControls(provider: provider);
      case WidgetBuilderSelection.playgroundScrollView:
        return PlaygroundScrollViewControls(provider: provider);
      case WidgetBuilderSelection.playgroundMap:
        return PlaygroundMapControls(provider: provider);
      default:
        return const SizedBox.shrink();
    }
  }
}
