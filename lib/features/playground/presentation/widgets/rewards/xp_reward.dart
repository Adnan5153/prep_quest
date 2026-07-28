import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/responsive_builder.dart';
import '../../constants/playground_constants.dart';
import '../../constants/playground_sizes.dart';
import '../../constants/playground_strings.dart';
import '../painters/xp_orb_painter.dart';

enum XpRewardSize { compact, standard, large }

enum XpRewardLayout { iconOnly, compact, detailed }

class XpReward extends StatefulWidget {
  const XpReward({
    super.key,
    required this.amount,
    this.size = XpRewardSize.standard,
    this.layout = XpRewardLayout.detailed,
    this.label,
    this.isDark = false,
    this.rarity = PlaygroundRarity.common,
    this.showGlow = true,
    this.showSparkle = true,
    this.isLevelUp = false,
    this.isAnimating = true,
    this.heroTag,
  });

  final int amount;
  final XpRewardSize size;
  final XpRewardLayout layout;
  final String? label;
  final bool isDark;
  final PlaygroundRarity rarity;
  final bool showGlow;
  final bool showSparkle;
  final bool isLevelUp;
  final bool isAnimating;
  final String? heroTag;

  @override
  State<XpReward> createState() => _XpRewardState();
}

class _XpRewardState extends State<XpReward>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: PlaygroundDurations.xpOrbPulse,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.of(context).disableAnimations || !widget.isAnimating;
    if (!reduceMotion) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat();
      }
    } else if (_pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void didUpdateWidget(covariant XpReward oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reduceMotion =
        MediaQuery.of(context).disableAnimations || !widget.isAnimating;
    if (!reduceMotion && !_pulseController.isAnimating) {
      _pulseController.repeat();
    } else if (reduceMotion && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double _resolveDiameter() {
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.cardTabletScale,
      desktop: PlaygroundSizes.cardDesktopScale,
    );
    final base = switch (widget.size) {
      XpRewardSize.compact => PlaygroundSizes.rewardXpOrbSizeCompact,
      XpRewardSize.standard => PlaygroundSizes.rewardXpOrbSizeStandard,
      XpRewardSize.large => PlaygroundSizes.rewardXpOrbSizeLarge,
    };
    return base * scale;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diameter = _resolveDiameter();
    final isIconOnly = widget.layout == XpRewardLayout.iconOnly;

    final core = _XpSurface(
      diameter: diameter,
      isDark: widget.isDark,
      rarity: widget.rarity,
      isLevelUp: widget.isLevelUp,
      showGlow: widget.showGlow,
      showSparkle: widget.showSparkle,
      pulse: _pulseController,
    );

    final framed = RepaintBoundary(
      child: Semantics(
        label:
            widget.label ??
            '${PlaygroundStrings.rewardXpSemanticTemplate}, '
                '${PlaygroundStrings.rewardXpLabelTemplate}${widget.amount}',
        image: true,
        container: true,
        child: widget.heroTag != null
            ? Hero(tag: widget.heroTag!, child: core)
            : core,
      ),
    );

    if (isIconOnly) return framed;

    return RepaintBoundary(
      child: Semantics(
        label:
            widget.label ??
            '${PlaygroundStrings.xpLabel} '
                '${PlaygroundStrings.rewardXpLabelTemplate}${widget.amount}',
        container: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            framed,
            SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.isLevelUp) ...<Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          AppIcons.crown,
                          size: AppSizes.iconXs,
                          color: PlaygroundColors.rarityLegendary,
                        ),
                        SizedBox(width: AppSpacing.xxs),
                        Text(
                          PlaygroundStrings.rewardLevelUp,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: PlaygroundColors.rarityLegendary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                  ],
                  Text(
                    PlaygroundStrings.xpLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: widget.isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '${PlaygroundStrings.rewardXpLabelTemplate}${widget.amount}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: widget.isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XpSurface extends StatelessWidget {
  const _XpSurface({
    required this.diameter,
    required this.isDark,
    required this.rarity,
    required this.isLevelUp,
    required this.showGlow,
    required this.showSparkle,
    required this.pulse,
  });

  final double diameter;
  final bool isDark;
  final PlaygroundRarity rarity;
  final bool isLevelUp;
  final bool showGlow;
  final bool showSparkle;
  final Animation<double> pulse;

  Color get _accentColor {
    switch (rarity) {
      case PlaygroundRarity.common:
        return PlaygroundColors.xpCore;
      case PlaygroundRarity.rare:
        return PlaygroundColors.rarityRare;
      case PlaygroundRarity.epic:
        return PlaygroundColors.rarityEpic;
      case PlaygroundRarity.legendary:
        return PlaygroundColors.rarityLegendary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, child) {
        final phase = pulse.value;
        final halo = showGlow ? 1.0 + (phase * 0.35) : 1.0;
        final lift = (phase - 0.5) * -2.0;
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            if (showGlow)
              Positioned.fill(
                child: IgnorePointer(
                  child: Transform.scale(
                    scale: halo,
                    child: _XpHalo(diameter: diameter, color: _accentColor),
                  ),
                ),
              ),
            Transform.translate(offset: Offset(0, lift), child: child),
          ],
        );
      },
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.2, -0.3),
                  radius: 0.95,
                  colors: <Color>[
                    _accentColor.withValues(alpha: 0.95),
                    PlaygroundColors.xpEdge,
                    AppColors.darkBackground.withValues(alpha: 0.85),
                  ],
                  stops: const <double>[0.0, 0.55, 1.0],
                ),
                border: Border.all(
                  color: _accentColor.withValues(alpha: 0.6),
                  width: PlaygroundSizes.rewardCoinBorderWidth,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: _accentColor.withValues(alpha: 0.55),
                    blurRadius: isLevelUp
                        ? PlaygroundSizes.rewardChestGlowBlur
                        : PlaygroundSizes.rewardCoinHighlightBlur,
                    spreadRadius: isLevelUp ? 2.0 : 0.5,
                  ),
                  BoxShadow(
                    color: AppColors.nodeDropShadow.withValues(alpha: 0.55),
                    blurRadius: diameter * 0.18,
                    offset: Offset(0, diameter * 0.10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: diameter * 0.12,
                    left: diameter * 0.20,
                    right: diameter * 0.20,
                    child: Container(
                      height: diameter * 0.16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            AppColors.nodeHighlight,
                            AppColors.nodeHighlight.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    AppIcons.xp,
                    size: diameter * 0.45,
                    color: AppColors.darkOnSurface,
                  ),
                ],
              ),
            ),
            if (showSparkle)
              _XpSparkle(diameter: diameter, color: _accentColor),
            if (isLevelUp)
              Positioned(
                right: -diameter * 0.12,
                top: -diameter * 0.08,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: PlaygroundColors.rarityLegendary,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: PlaygroundColors.rarityLegendary.withValues(
                          alpha: 0.45,
                        ),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        AppIcons.star,
                        size: AppSizes.iconXs - 2,
                        color: AppColors.darkOnSurface,
                      ),
                      SizedBox(width: AppSpacing.xxs),
                      Text(
                        PlaygroundStrings.rewardLevelUp,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.darkOnSurface,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          fontSize: PlaygroundSizes.rewardXpLevelBadgeFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _XpHalo extends StatelessWidget {
  const _XpHalo({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color.withValues(alpha: 0.45),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: SizedBox(
        width: diameter * PlaygroundSizes.rewardXpHaloExpand,
        height: diameter * PlaygroundSizes.rewardXpHaloExpand,
      ),
    );
  }
}

class _XpSparkle extends StatelessWidget {
  const _XpSparkle({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter * 1.6,
      height: diameter * 1.6,
      child: CustomPaint(painter: XpOrbPainter(color: color)),
    );
  }
}
