import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/responsive_builder.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/widget_constants.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import '../cards/mission_card.dart';
import 'shared/playground_sheet_container.dart';
import 'shared/playground_sheet_entrance.dart';
import 'shared/playground_sheet_layout.dart';
import 'shared/playground_sheet_sections.dart';

enum MissionBottomSheetResult { trackedMission, closed, dismissed }

class MissionSheetItemVisual {
  const MissionSheetItemVisual({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.goal,
    required this.reward,
    this.tag = MissionCardTag.none,
    this.state = MissionCardState.active,
    this.icon,
    this.timerSecondsRemaining,
    this.semanticLabel,
  });

  final String id;
  final String title;
  final String description;
  final int progress;
  final int goal;
  final MissionCardReward reward;
  final MissionCardTag tag;
  final MissionCardState state;
  final IconData? icon;
  final int? timerSecondsRemaining;
  final String? semanticLabel;
}

class MissionSheetVisual {
  const MissionSheetVisual({
    required this.id,
    required this.nodeTitle,
    required this.dailyMissions,
    this.subtitle,
    this.aggregateXp = 0,
    this.aggregateCoins = 0,
    this.streakBonusXp = 0,
    this.dailyResetText,
    this.selectedMissionId,
  });

  final String id;
  final String nodeTitle;
  final String? subtitle;
  final List<MissionSheetItemVisual> dailyMissions;
  final int aggregateXp;
  final int aggregateCoins;
  final int streakBonusXp;
  final String? dailyResetText;
  final String? selectedMissionId;
}

class MissionBottomSheet extends StatefulWidget {
  const MissionBottomSheet({
    super.key,
    required this.visual,
    this.onTrackMission,
    this.onClose,
  });

  final MissionSheetVisual visual;
  final ValueChanged<String>? onTrackMission;
  final VoidCallback? onClose;

  static Future<MissionBottomSheetResult?> show(
    BuildContext context, {
    required MissionSheetVisual visual,
    ValueChanged<String>? onTrackMission,
    VoidCallback? onClose,
  }) async {
    final layout = PlaygroundSheetLayout.resolve(context);
    return showModalBottomSheet<MissionBottomSheetResult>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: PlaygroundSheetOpacity.scrim,
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return _MissionSheetHost(
          layout: layout,
          visual: visual,
          onTrackMission: onTrackMission,
          onClose: onClose,
        );
      },
    );
  }

  @override
  State<MissionBottomSheet> createState() => _MissionBottomSheetState();
}

class _MissionBottomSheetState extends State<MissionBottomSheet> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.visual.selectedMissionId;
    if (_selectedId == null && widget.visual.dailyMissions.isNotEmpty) {
      _selectedId = widget.visual.dailyMissions.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = PlaygroundSheetLayout.resolve(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _MissionSheetHost(
      layout: layout,
      visual: widget.visual,
      selectedMissionId: _selectedId,
      onSelectMission: (id) {
        if (!mounted) return;
        setState(() => _selectedId = id);
      },
      onTrackMission: widget.onTrackMission,
      onClose: widget.onClose,
      isDark: isDark,
    );
  }
}

class _MissionSheetHost extends StatelessWidget {
  const _MissionSheetHost({
    required this.layout,
    required this.visual,
    this.selectedMissionId,
    this.onSelectMission,
    this.onTrackMission,
    this.onClose,
    this.isDark = false,
  });

  final PlaygroundSheetLayout layout;
  final MissionSheetVisual visual;
  final String? selectedMissionId;
  final ValueChanged<String>? onSelectMission;
  final ValueChanged<String>? onTrackMission;
  final VoidCallback? onClose;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDark = isDark || theme.brightness == Brightness.dark;
    final sheetHeight = _resolveSheetHeight(context);
    final container = PlaygroundSheetContainer(
      semanticLabel: PlaygroundStrings.missionSheetSemantic,
      layout: layout,
      height: sheetHeight,
      child: PlaygroundSheetFrame(
        layout: layout,
        semanticLabel: PlaygroundStrings.missionSheetSemantic,
        content: _MissionSheetBody(
          visual: visual,
          selectedMissionId: selectedMissionId,
          onSelectMission: onSelectMission,
          isDark: effectiveDark,
        ),
        actions: PlaygroundSheetActionRow(
          primaryLabel: PlaygroundStrings.missionSheetCtaTrack,
          onPrimary: () {
            if (selectedMissionId == null) return;
            final navigator = Navigator.of(context);
            onTrackMission?.call(selectedMissionId!);
            navigator.pop(MissionBottomSheetResult.trackedMission);
          },
          primarySemantic: PlaygroundStrings.missionSheetCtaTrack,
          primaryEnabled:
              selectedMissionId != null &&
              _isTrackable(selectedMissionId, visual.dailyMissions),
          secondaryLabel: PlaygroundStrings.missionSheetCtaClose,
          onSecondary: () {
            final navigator = Navigator.of(context);
            onClose?.call();
            navigator.pop(MissionBottomSheetResult.closed);
          },
          secondarySemantic: PlaygroundStrings.missionSheetCtaClose,
          alignment: _resolveActionAlignment(),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: PlaygroundSheetEntrance(height: sheetHeight, child: container),
    );
  }

  bool _isTrackable(String? id, List<MissionSheetItemVisual> missions) {
    if (id == null) return false;
    for (final mission in missions) {
      if (mission.id == id && mission.state != MissionCardState.locked) {
        return true;
      }
    }
    return false;
  }

  double _resolveSheetHeight(BuildContext context) {
    final missions = visual.dailyMissions;
    final aggregateRowHeight =
        (visual.aggregateXp > 0 || visual.aggregateCoins > 0)
        ? PlaygroundSizes.bottomSheetStatTileHeight + AppSpacing.md
        : 0.0;
    final streakHeight = visual.streakBonusXp > 0
        ? AppSizes.iconLg + AppSpacing.md
        : 0.0;
    final missionHeight = missions.isEmpty
        ? PlaygroundSizes.bottomSheetStatTileHeight
        : (missions.length * (PlaygroundSizes.cardMinHeight + AppSpacing.sm));
    final total =
        PlaygroundSizes.bottomSheetActionHeight +
        PlaygroundSizes.bottomSheetSectionGap +
        (PlaygroundSizes.bottomSheetPaddingVertical * 2) +
        aggregateRowHeight +
        streakHeight +
        missionHeight +
        PlaygroundSizes.bottomSheetHeaderGap;
    return layout.resolveIdealHeight(total);
  }

  PlaygroundSheetActionAlignment _resolveActionAlignment() {
    if (visual.dailyMissions.isEmpty) {
      return PlaygroundSheetActionAlignment.horizontal;
    }
    final device = layout.deviceType;
    if (device == DeviceType.mobile) {
      return PlaygroundSheetActionAlignment.stacked;
    }
    return PlaygroundSheetActionAlignment.horizontal;
  }
}

class _MissionSheetBody extends StatelessWidget {
  const _MissionSheetBody({
    required this.visual,
    required this.selectedMissionId,
    required this.onSelectMission,
    required this.isDark,
  });

  final MissionSheetVisual visual;
  final String? selectedMissionId;
  final ValueChanged<String>? onSelectMission;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final missions = visual.dailyMissions;
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: <Widget>[
        PlaygroundSheetHeader(
          title: PlaygroundStrings.missionSheetTitle,
          subtitle:
              visual.subtitle ??
              (visual.dailyResetText != null
                  ? '${visual.nodeTitle} • ${visual.dailyResetText}'
                  : visual.nodeTitle),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: PlaygroundColors.streak.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
              borderRadius: BorderRadius.circular(
                PlaygroundSizes.bottomSheetRarityBadgeRadius,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  AppIcons.fireFilled,
                  color: PlaygroundColors.streak,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '${visual.streakBonusXp}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: PlaygroundColors.streak,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.md),
        _AggregateRow(visual: visual, isDark: isDark),
        const SizedBox(height: AppSpacing.md),
        ..._buildMissionList(context, missions),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  List<Widget> _buildMissionList(
    BuildContext context,
    List<MissionSheetItemVisual> missions,
  ) {
    if (missions.isEmpty) {
      return <Widget>[
        Container(
          height: PlaygroundSizes.bottomSheetStatTileHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkMuted : AppColors.lightMuted)
                .withValues(alpha: PlaygroundSheetOpacity.handle),
            borderRadius: PlaygroundSheetBorder.statRadius,
          ),
          child: Text(
            PlaygroundStrings.missionSheetSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ];
    }
    return missions
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _MissionSheetItemTile(
              item: item,
              isSelected: item.id == selectedMissionId,
              onTap: item.state == MissionCardState.locked
                  ? null
                  : () => onSelectMission?.call(item.id),
            ),
          ),
        )
        .toList(growable: false);
  }
}

class _AggregateRow extends StatelessWidget {
  const _AggregateRow({required this.visual, required this.isDark});

  final MissionSheetVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showAggregate = visual.aggregateXp > 0 || visual.aggregateCoins > 0;
    final showStreak = visual.streakBonusXp > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (showAggregate)
          Row(
            children: <Widget>[
              Expanded(
                child: PlaygroundSheetStatTile(
                  icon: AppIcons.xp,
                  iconColor: PlaygroundColors.xp,
                  value: '${visual.aggregateXp}',
                  label: PlaygroundStrings.missionSheetAggregateXpLabel,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PlaygroundSheetStatTile(
                  icon: AppIcons.coinIcon,
                  iconColor: PlaygroundColors.coin,
                  value: '${visual.aggregateCoins}',
                  label: PlaygroundStrings.missionSheetAggregateCoinLabel,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        if (showAggregate && showStreak) const SizedBox(height: AppSpacing.sm),
        if (showStreak)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: PlaygroundColors.streak.withValues(
                alpha: PlaygroundSheetOpacity.accentSurface,
              ),
              borderRadius: PlaygroundSheetBorder.statRadius,
              border: Border.all(
                color: PlaygroundColors.streak.withValues(alpha: 0.4),
                width: PlaygroundSizes.bottomSheetBorderWidth,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  AppIcons.fireFilled,
                  color: PlaygroundColors.streak,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    PlaygroundStrings.missionSheetStreakBonusTemplate
                        .replaceAll('%d', '${visual.streakBonusXp}'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: PlaygroundColors.streak,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MissionSheetItemTile extends StatelessWidget {
  const _MissionSheetItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final MissionSheetItemVisual item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final visual = MissionVisual(
      id: item.id,
      title: item.title,
      description: item.description,
      required: item.goal,
      progress: item.progress,
      reward: item.reward,
      tag: item.tag,
      state: item.state,
      size: MissionCardSize.compact,
      icon: item.icon,
      timerSecondsRemaining: item.timerSecondsRemaining,
    );
    return Stack(
      children: <Widget>[
        MissionCard(visual: visual, onTap: onTap),
        if (isSelected)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: WidgetConstants.normalAnimationDuration,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    PlaygroundSizes.cardCornerRadius,
                  ),
                  border: Border.all(
                    color: PlaygroundColors.sheetAccent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: AnimatedOpacity(
            duration: WidgetConstants.fastAnimationDuration,
            opacity: isSelected ? 1 : 0,
            child: Icon(
              AppIcons.checkCircle,
              color: PlaygroundColors.sheetAccent,
              size: AppSizes.iconMd,
            ),
          ),
        ),
      ],
    );
  }
}
