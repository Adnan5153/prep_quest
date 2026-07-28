import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import '../painters/academy_building_painter.dart';
import 'building_label.dart';
import 'building_progress.dart';
import 'playground_building.dart';

class AcademyBuilding extends StatelessWidget {
  const AcademyBuilding({
    super.key,
    this.state = BuildingState.unlocked,
    this.title = PlaygroundStrings.buildingAcademyTitle,
    this.subtitle = PlaygroundStrings.buildingAcademySubtitle,
    this.progress = 0.0,
    this.level = 1,
    this.isInteractive = true,
    this.showLabel = true,
    this.showProgress = true,
    this.labelPlacement = BuildingLabelPlacement.below,
    this.labelEmphasis = BuildingLabelEmphasis.normal,
    this.progressKind = BuildingProgressKind.percent,
    this.scale = 1.0,
    this.onTap,
    this.onLongPress,
    this.ambientParticles = true,
    this.wallColor,
    this.roofColor,
    this.flagColor,
  });

  final BuildingState state;
  final String title;
  final String subtitle;
  final double progress;
  final int level;
  final bool isInteractive;
  final bool showLabel;
  final bool showProgress;
  final BuildingLabelPlacement labelPlacement;
  final BuildingLabelEmphasis labelEmphasis;
  final BuildingProgressKind progressKind;
  final double scale;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool ambientParticles;
  final Color? wallColor;
  final Color? roofColor;
  final Color? flagColor;

  @override
  Widget build(BuildContext context) {
    final visual = BuildingVisual(
      state: state,
      title: title,
      subtitle: subtitle,
      progress: progress,
      level: level,
      isInteractive: isInteractive,
      showLabel: showLabel,
      showProgress: showProgress,
      labelPlacement: labelPlacement,
      labelEmphasis: labelEmphasis,
      progressKind: progressKind,
    );

    final sprite = _AcademySprite(
      state: state,
      scale: scale,
      ambientParticles: ambientParticles,
      wallColor: wallColor,
      roofColor: roofColor,
      flagColor: flagColor,
    );

    return PlaygroundBuilding(
      visual: visual,
      width: PlaygroundSizes.buildingAcademyWidth,
      height: PlaygroundSizes.buildingAcademyHeight,
      sprite: sprite,
      onTap: onTap,
      onLongPress: onLongPress,
      accentColor: AppColors.academyPrimary,
      progressBackgroundColor: AppColors.buildingGold,
      progressForegroundColor: AppColors.darkOnSurface,
    );
  }
}

class _AcademySprite extends StatefulWidget {
  const _AcademySprite({
    required this.state,
    required this.scale,
    required this.ambientParticles,
    this.wallColor,
    this.roofColor,
    this.flagColor,
  });

  final BuildingState state;
  final double scale;
  final bool ambientParticles;
  final Color? wallColor;
  final Color? roofColor;
  final Color? flagColor;

  @override
  State<_AcademySprite> createState() => _AcademySpriteState();
}

class _AcademySpriteState extends State<_AcademySprite>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _windowController;
  late final AnimationController _flagController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: PlaygroundBuildingDurations.floatCycle,
    );
    _windowController = AnimationController(
      vsync: this,
      duration: PlaygroundBuildingDurations.windowBlink,
    );
    _flagController = AnimationController(
      vsync: this,
      duration: PlaygroundBuildingDurations.flagWave,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (!reduceMotion) {
      if (!_floatController.isAnimating) {
        _floatController.repeat(reverse: true);
      }
      if (!_windowController.isAnimating) {
        _windowController.repeat(reverse: true);
      }
      if (!_flagController.isAnimating) {
        _flagController.repeat();
      }
    } else {
      _floatController.stop();
      _windowController.stop();
      _flagController.stop();
      _floatController.value = 0.5;
      _windowController.value = 0.7;
      _flagController.value = 0.3;
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _windowController.dispose();
    _flagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveScale = widget.scale;
    return SizedBox(
      width: PlaygroundSizes.buildingAcademyWidth * effectiveScale,
      height: PlaygroundSizes.buildingAcademyHeight * effectiveScale,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatController,
          _windowController,
          _flagController,
        ]),
        builder: (context, _) {
          return CustomPaint(
            painter: AcademyBuildingPainter(
              state: widget.state,
              scale: effectiveScale,
              floatPhase: _floatController.value,
              windowPhase: _windowController.value,
              flagPhase: _flagController.value,
              wallColor: widget.wallColor,
              roofColor: widget.roofColor,
              flagColor: widget.flagColor,
            ),
          );
        },
      ),
    );
  }
}
