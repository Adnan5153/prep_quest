import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../router.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../profile/presentation/states/profile_state.dart';
import '../../../profile/presentation/utils/profile_visual_mapper.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../constants/playground_constants.dart';
import '../constants/playground_sizes.dart';
import '../constants/playground_strings.dart';
import '../providers/playground_provider.dart';
import '../utils/world_layout.dart';
import '../widgets/buildings/academy_building.dart';
import '../widgets/buildings/library_building.dart';
import '../widgets/buildings/playground_building.dart';
import '../widgets/decorations/bridge.dart';
import '../widgets/decorations/bush.dart';
import '../widgets/decorations/cloud.dart';
import '../widgets/decorations/flag.dart';
import '../widgets/decorations/mountain.dart';
import '../widgets/decorations/playground_particle_layer.dart';
import '../widgets/decorations/river.dart';
import '../widgets/decorations/tree.dart';
import '../widgets/locked_level.dart';
import '../widgets/map/playground_camera.dart';
import '../widgets/map/playground_legend.dart';
import '../widgets/map/playground_map.dart';
import '../widgets/nodes/node_badge.dart';
import '../widgets/nodes/node_icon.dart';
import '../widgets/nodes/node_progress_indicator.dart';
import '../widgets/nodes/node_ring.dart';
import '../widgets/nodes/playground_node.dart';
import '../widgets/overlays/coin_counter.dart';
import '../widgets/overlays/energy_indicator.dart';
import '../widgets/overlays/playground_top_bar.dart';
import '../widgets/overlays/profile_summary.dart';
import '../widgets/overlays/streak_card.dart';
import '../widgets/overlays/xp_indicator.dart';
import '../widgets/sheets/library_bottom_sheet.dart';

class PlaygroundScreen extends ConsumerStatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  ConsumerState<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends ConsumerState<PlaygroundScreen> {
  late final PlaygroundCamera _camera = PlaygroundCamera();
  late final ValueNotifier<PlaygroundProgress> _progressNotifier =
      ValueNotifier<PlaygroundProgress>(PlaygroundProgress.seed);
  late final PlaygroundProvider _provider =
      PlaygroundProvider(initial: _progressNotifier.value);

  static const int _activeIndex = 2;
  static const int _playgroundTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ProfileState state = ref.read(profileControllerProvider);
      if (state.status == ProfileStatus.unknown) {
        ref.read(profileControllerProvider.notifier).load();
      }
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  void _openProfile() {
    context.goNamed(AppRoutes.profile);
  }

  void _openXp() {
    _showComingSoon('Experience');
  }

  void _openCoins() {
    _showComingSoon('Coin balance');
  }

  void _openEnergy() {
    _showComingSoon('Energy');
  }

  void _openStreak() {
    _showComingSoon('Daily streak');
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onTabSelected(int index) {
    if (index == _playgroundTabIndex) return;
    onDefaultBottomNavTap(context, index);
  }

  void _handleNodeTap(WorldNodePlacement node) {
    final progress = _provider.progress;
    final isLocked = !progress.isUnlocked(node.id);
    final isCompleted = progress.isCompleted(node.id);

    if (isLocked) {
      _showLockedDialog(node);
      return;
    }

    if (isCompleted) {
      _showRewardPopup(node);
      return;
    }

    if (node.step.kind == WorldStepKind.boss) {
      context.goNamed(
        AppRoutes.bossChallenge,
        queryParameters: <String, String>{'nodeId': node.id},
      );
      return;
    }

    if (node.step.kind == WorldStepKind.milestone) {
      context.goNamed(
        AppRoutes.lessons,
        queryParameters: <String, String>{'nodeId': node.id},
      );
      return;
    }

    // Regular (lesson practice / mock test) nodes route through the
    // Quiz Engine so learners can drill against quiz entities.
    context.goNamed(
      AppRoutes.quizOverview,
      queryParameters: <String, String>{'nodeId': node.id},
    );
  }

  void _showLockedDialog(WorldNodePlacement node) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: LockedLevel(
          visual: LockedLevelVisual(
            levelNumber: _nodeIndex(node.id) + 1,
            title: node.step.subtitle.isEmpty ? 'Locked' : node.step.subtitle,
            subtitle: 'Complete the previous node to unlock this one',
            requirements: const <LockedLevelRequirementSpec>[
              LockedLevelRequirementSpec(
                kind: LockedLevelRequirement.level,
                label: 'Reach the required level',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRewardPopup(WorldNodePlacement node) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${node.step.subtitle} already completed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openAcademy(WorldMilestonePlacement milestone) {
    context.goNamed(
      AppRoutes.lessons,
      queryParameters: <String, String>{'nodeId': milestone.id},
    );
  }

  void _openLibrary(WorldMilestonePlacement milestone) {
    LibraryBottomSheet.show(
      context,
      visual: LibrarySheetVisual(
        id: milestone.id,
        title: 'Library',
        topic: 'Reference materials',
        description: 'Open the library to read chapters and formulas.',
        chapterCount: 8,
        completedChapters: 3,
        unlockedLessonCount: 5,
        estimatedReadingMinutes: 12,
      ),
      onEnterLibrary: () => context.goNamed(
        AppRoutes.lessons,
        queryParameters: <String, String>{'nodeId': milestone.id},
      ),
    );
  }

  int _nodeIndex(String id) {
    const prefix = 'node-';
    if (!id.startsWith(prefix)) return 0;
    return int.tryParse(id.substring(prefix.length)) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final ProfileState state = ref.watch(profileControllerProvider);
    final UserProfile? profile = state.profile;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final worldWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : PlaygroundSizes.mapWorldWidth;
          final layout = _PlaygroundStageData.layout(
            activeIndex: _activeIndex,
            worldWidth: worldWidth,
          );

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: PlaygroundMap(
                  camera: _camera,
                  contentSize: layout.worldSize,
                  segments: layout.segments,
                  nodes: _PlaygroundStageData.mapNodes(
                    layout,
                    onNodeTap: _handleNodeTap,
                  ),
                  buildings: _PlaygroundStageData.mapBuildings(
                    layout,
                    onAcademyTap: _openAcademy,
                    onLibraryTap: _openLibrary,
                  ),
                  decorations: _PlaygroundStageData.mapDecorations(layout),
                  atmosphericDecorations:
                      _PlaygroundStageData.mapAtmosphericDecorations(layout),
                  legendItems: _PlaygroundStageData.legendItems,
                  focusTarget: layout.focusAnchor,
                  atmosphericOverlay: const _AtmosphericOverlay(),
                ),
              ),
              const Positioned.fill(
                child: IgnorePointer(child: PlaygroundParticleLayer()),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PlaygroundTopBar(
                  profile: profile != null
                      ? ProfileVisualMapper.toProfileVisual(profile)
                      : const ProfileVisual(
                          displayName: 'Guest',
                          level: 1,
                          initials: 'G',
                          isOnline: false,
                          leagueName: AppStrings.premium,
                        ),
                  xp: profile != null
                      ? ProfileVisualMapper.toXpVisual(profile)
                      : const XpVisual(
                          totalXp: 0,
                          userLevel: 1,
                          xpInLevel: 0,
                          xpForNextLevel: 100,
                        ),
                  coins: profile != null
                      ? ProfileVisualMapper.toCoinVisual(profile)
                      : const CoinVisual(balance: 0),
                  energy: profile != null
                      ? ProfileVisualMapper.toEnergyVisual(profile)
                      : const EnergyVisual(remaining: 5, max: 5),
                  streak: profile != null
                      ? ProfileVisualMapper.toStreakVisual(profile)
                      : const StreakVisual(days: 0),
                  onProfileTap: _openProfile,
                  onXpTap: _openXp,
                  onCoinsTap: _openCoins,
                  onEnergyTap: _openEnergy,
                  onStreakTap: _openStreak,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomBottomNavigation(
                  currentIndex: _playgroundTabIndex,
                  onTap: _onTabSelected,
                  notificationBadgeCount:
                      ref.watch(notificationUnreadCountProvider),
                  onNotificationTap: () => context.goNamed(AppRoutes.notifications),
                  items: kDefaultBottomNavItems,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlaygroundStageData {
  _PlaygroundStageData._();

  static const List<WorldStep> _steps = <WorldStep>[
    WorldStep(
      kind: WorldStepKind.regular,
      subtitle: 'Foundations',
      isCompleted: true,
    ),
    WorldStep(
      kind: WorldStepKind.regular,
      subtitle: 'Grammar',
      isCompleted: true,
    ),
    WorldStep(kind: WorldStepKind.regular, subtitle: 'Mathematics'),
    WorldStep(kind: WorldStepKind.milestone, subtitle: 'Library'),
    WorldStep(kind: WorldStepKind.reward, subtitle: 'Daily Reward'),
    WorldStep(kind: WorldStepKind.regular, subtitle: 'Mock Test'),
    WorldStep(kind: WorldStepKind.boss, subtitle: 'BCS Boss'),
  ];

  static WorldLayoutSpec layout({
    required int activeIndex,
    required double worldWidth,
  }) {
    return WorldLayout.build(
      steps: _steps,
      activeIndex: activeIndex,
      seed: 23,
      worldWidth: worldWidth,
    );
  }

  static List<PlaygroundMapNode> mapNodes(
    WorldLayoutSpec layout, {
    required ValueChanged<WorldNodePlacement> onNodeTap,
  }) {
    return layout.nodes
        .map((node) {
          return PlaygroundMapNode(
            id: node.id,
            position: node.position,
            builder: (_) => _buildNodeVisual(
              node,
              onTap: () => onNodeTap(node),
            ),
          );
        })
        .toList(growable: false);
  }

  static Widget _buildNodeVisual(
    WorldNodePlacement node, {
    required VoidCallback onTap,
  }) {
    final step = node.step;
    NodeRingState ringState;
    NodeIconKind iconKind;
    NodeIconVariant iconVariant = NodeIconVariant.filled;
    NodeProgressState progressState;
    double progress = 0.0;
    NodeBadgeKind? badgeKind;
    bool isInteractive;
    bool showBadge = false;

    switch (step.kind) {
      case WorldStepKind.regular:
        if (step.isCompleted) {
          ringState = NodeRingState.completed;
          iconKind = NodeIconKind.completed;
          progressState = NodeProgressState.completed;
          progress = 1.0;
          isInteractive = false;
          badgeKind = null;
          showBadge = false;
        } else if (node.isActive) {
          ringState = NodeRingState.inProgress;
          iconKind = NodeIconKind.regular;
          progressState = NodeProgressState.partial;
          progress = 0.65;
          isInteractive = true;
          badgeKind = NodeBadgeKind.daily;
          showBadge = true;
        } else {
          ringState = NodeRingState.locked;
          iconKind = NodeIconKind.locked;
          progressState = NodeProgressState.empty;
          isInteractive = false;
          badgeKind = null;
          showBadge = false;
        }
        break;
      case WorldStepKind.reward:
        ringState = node.isActive
            ? NodeRingState.unlocked
            : node.isLocked
            ? NodeRingState.locked
            : NodeRingState.completed;
        iconKind = node.isLocked ? NodeIconKind.locked : NodeIconKind.regular;
        progressState = node.isLocked
            ? NodeProgressState.empty
            : NodeProgressState.completed;
        progress = node.isLocked ? 0.0 : 1.0;
        isInteractive = !node.isLocked;
        badgeKind = node.isLocked ? null : NodeBadgeKind.xp;
        showBadge = !node.isLocked;
        break;
      case WorldStepKind.milestone:
        ringState = node.isActive
            ? NodeRingState.premium
            : node.isLocked
            ? NodeRingState.locked
            : NodeRingState.unlocked;
        iconKind = NodeIconKind.library;
        progressState = node.isLocked
            ? NodeProgressState.empty
            : NodeProgressState.completed;
        progress = node.isLocked ? 0.0 : 1.0;
        isInteractive = !node.isLocked;
        badgeKind = node.isLocked ? null : NodeBadgeKind.library;
        showBadge = !node.isLocked;
        break;
      case WorldStepKind.boss:
        ringState = node.isLocked ? NodeRingState.locked : NodeRingState.boss;
        iconKind = node.isLocked ? NodeIconKind.locked : NodeIconKind.boss;
        iconVariant = NodeIconVariant.glyph;
        progressState = node.isLocked
            ? NodeProgressState.empty
            : NodeProgressState.completed;
        progress = node.isLocked ? 0.0 : 1.0;
        isInteractive = !node.isLocked;
        badgeKind = node.isLocked ? null : NodeBadgeKind.boss;
        showBadge = !node.isLocked;
        break;
    }

    return PlaygroundNode(
      visual: NodeVisual(
        kind: iconKind,
        ringState: ringState,
        iconKind: iconKind,
        iconVariant: iconVariant,
        progress: progress,
        progressState: progressState,
        title: step.subtitle,
        subtitle: node.isLocked ? 'Locked' : step.subtitle,
        badgeKind: badgeKind,
        isInteractive: isInteractive,
        showLabel: true,
        showProgress: !node.isLocked && step.kind != WorldStepKind.boss,
        showBadge: showBadge,
      ),
      onTap: isInteractive ? onTap : null,
    );
  }

  static List<PlaygroundMapBuilding> mapBuildings(
    WorldLayoutSpec layout, {
    required ValueChanged<WorldMilestonePlacement> onAcademyTap,
    required ValueChanged<WorldMilestonePlacement> onLibraryTap,
  }) {
    return layout.milestones
        .map((milestone) {
          final bool isLibrary = milestone.kind != WorldStepKind.milestone;
          final Widget widget = isLibrary
              ? LibraryBuilding(
                  state: BuildingState.unlocked,
                  level: 2,
                  onTap: () => onLibraryTap(milestone),
                )
              : AcademyBuilding(
                  state: BuildingState.current,
                  level: 3,
                  progress: 0.65,
                  onTap: () => onAcademyTap(milestone),
                );
          return PlaygroundMapBuilding(
            id: milestone.id,
            position: milestone.position,
            builder: (_) => widget,
          );
        })
        .toList(growable: false);
  }

  static List<PlaygroundMapDecoration> mapDecorations(WorldLayoutSpec layout) {
    return layout.decorations
        .where((placement) => placement.kind != WorldDecorationKind.cloud)
        .map((placement) {
          return PlaygroundMapDecoration(
            position: placement.position,
            builder: (_) => _buildDecoration(placement),
          );
        })
        .toList(growable: false);
  }

  static List<PlaygroundMapAtmosphericDecoration> mapAtmosphericDecorations(
    WorldLayoutSpec layout,
  ) {
    return layout.decorations
        .where((placement) => placement.kind == WorldDecorationKind.cloud)
        .map((placement) {
          return PlaygroundMapAtmosphericDecoration(
            position: placement.position,
            builder: (_) => _buildDecoration(placement),
          );
        })
        .toList(growable: false);
  }

  static Widget _buildDecoration(WorldDecorationPlacement placement) {
    switch (placement.kind) {
      case WorldDecorationKind.tree:
        return Tree(
          kind: TreeKind.oak,
          scale: placement.scale,
          accentColor: null,
        );
      case WorldDecorationKind.pine:
        return Tree(
          kind: TreeKind.pine,
          scale: placement.scale,
          accentColor: null,
        );
      case WorldDecorationKind.bush:
        return Bush(kind: BushKind.round, scale: placement.scale);
      case WorldDecorationKind.floweringBush:
        return Bush(kind: BushKind.flowering, scale: placement.scale);
      case WorldDecorationKind.cloud:
        return Cloud(kind: CloudKind.fluffy, scale: placement.scale);
      case WorldDecorationKind.mountain:
        return const Mountain(layer: MountainLayer.back);
      case WorldDecorationKind.river:
        return River(curve: RiverCurve.meander);
      case WorldDecorationKind.bridge:
        return const Bridge();
      case WorldDecorationKind.flag:
        return const Flag(color: FlagColor.gold);
    }
  }

  static final List<LegendItem> legendItems = <LegendItem>[
    LegendItem(
      kind: LegendItemKind.node,
      label: PlaygroundStrings.mapLegendNodeCompleted,
      swatch: const LegendSwatch(
        kind: LegendSwatchKind.dot,
        color: PlaygroundColors.progressionCompleted,
      ),
    ),
    LegendItem(
      kind: LegendItemKind.node,
      label: PlaygroundStrings.mapLegendNodeInProgress,
      swatch: const LegendSwatch(
        kind: LegendSwatchKind.dot,
        color: PlaygroundColors.progressionInProgress,
      ),
    ),
    LegendItem(
      kind: LegendItemKind.node,
      label: PlaygroundStrings.mapLegendNodeLocked,
      swatch: const LegendSwatch(
        kind: LegendSwatchKind.dot,
        color: PlaygroundColors.progressionLocked,
      ),
    ),
    LegendItem(
      kind: LegendItemKind.path,
      label: PlaygroundStrings.mapLegendPathActive,
      swatch: const LegendSwatch(
        kind: LegendSwatchKind.dashed,
        color: PlaygroundColors.progressionInProgress,
      ),
    ),
  ];
}

class _AtmosphericOverlay extends StatelessWidget {
  const _AtmosphericOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportHeight = constraints.maxHeight;
          final viewportWidth = constraints.maxWidth;
          if (viewportHeight <= 0 || viewportWidth <= 0) {
            return const SizedBox.shrink();
          }
          final left = viewportWidth * 0.05;
          final top = viewportHeight * 0.40;
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                left: left,
                top: top,
                child: const FractionalTranslation(
                  translation: Offset(-0.20, -0.10),
                  child: Cloud(kind: CloudKind.fluffy),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}