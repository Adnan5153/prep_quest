import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strokes.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../core/widgets/widget_constants.dart';
import '../constants/playground_constants.dart';
import '../constants/playground_sizes.dart';
import '../constants/playground_strings.dart';

enum BossGateState { locked, unlocking, open }

enum BossGateRarity { common, rare, epic, legendary }

class BossGateVisual {
  const BossGateVisual({
    required this.title,
    required this.requiredLevel,
    this.subtitle,
    this.rarity = BossGateRarity.rare,
    this.isShaking = false,
    this.animate = true,
  });

  final String title;
  final int requiredLevel;
  final String? subtitle;
  final BossGateRarity rarity;
  final bool isShaking;
  final bool animate;
}

class BossGate extends StatefulWidget {
  const BossGate({
    super.key,
    required this.visual,
    required this.state,
    this.onTap,
    this.onUnlocked,
  });

  final BossGateVisual visual;
  final BossGateState state;
  final VoidCallback? onTap;
  final VoidCallback? onUnlocked;

  @override
  State<BossGate> createState() => _BossGateState();
}

class _BossGateState extends State<BossGate> with TickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.bossGatePulse,
  );
  late final AnimationController _openingController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.bossGateOpening,
  );
  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: PlaygroundDurations.bossGateShake,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant BossGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state ||
        oldWidget.visual.isShaking != widget.visual.isShaking ||
        oldWidget.visual.animate != widget.visual.animate) {
      _syncControllers();
    }
  }

  void _syncControllers() {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    final enableAnims = widget.visual.animate && !reducedMotion;
    if (widget.state == BossGateState.locked && enableAnims) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
      _pulseController.value = 0.0;
    }
    if (widget.state == BossGateState.unlocking) {
      if (enableAnims) {
        _openingController.forward(from: _openingController.value);
      } else {
        _openingController.value = 1.0;
      }
      widget.onUnlocked?.call();
    } else if (widget.state == BossGateState.open) {
      _openingController.value = 1.0;
    } else {
      _openingController.value = 0.0;
    }
    if (widget.visual.isShaking && enableAnims) {
      _shakeController
        ..reset()
        ..forward();
    } else {
      _shakeController.stop();
      _shakeController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _openingController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = ResponsiveBuilder.value<double>(
      context,
      mobile: 1.0,
      tablet: PlaygroundSizes.bossGateTabletScale,
      desktop: PlaygroundSizes.bossGateDesktopScale,
    );
    final accent = _accentForRarity(widget.visual.rarity, isDark);
    final semantic = _semanticLabel();

    return RepaintBoundary(
      child: Semantics(
        label: semantic,
        button: widget.onTap != null,
        enabled: widget.state != BossGateState.locked || widget.onTap != null,
        container: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: Listenable.merge(<Listenable>[
              _pulseController,
              _openingController,
              _shakeController,
            ]),
            builder: (context, _) {
              final shakeOffset =
                  math.sin(_shakeController.value * math.pi * 6) *
                  PlaygroundSizes.bossGateShakeAmplitude;
              return Transform.translate(
                offset: Offset(shakeOffset, 0),
                child: _BossGateSurface(
                  visual: widget.visual,
                  state: widget.state,
                  isDark: isDark,
                  scale: scale,
                  accent: accent,
                  pulsePhase: _pulseController.value,
                  openProgress: _openingController.value,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _semanticLabel() {
    if (widget.state == BossGateState.locked) {
      return '${PlaygroundStrings.bossGateLockedSemantic}: '
          '${widget.visual.title}';
    }
    if (widget.state == BossGateState.open) {
      return '${PlaygroundStrings.bossGateUnlockedSemantic}: '
          '${widget.visual.title}';
    }
    return '${PlaygroundStrings.bossGateSemantic}: ${widget.visual.title}';
  }

  Color _accentForRarity(BossGateRarity rarity, bool isDark) {
    switch (rarity) {
      case BossGateRarity.common:
        return isDark
            ? PlaygroundColors.progressionGrayscale
            : AppColors.lightMuted;
      case BossGateRarity.rare:
        return PlaygroundColors.progressionUnlocked;
      case BossGateRarity.epic:
        return PlaygroundColors.progressionBoss;
      case BossGateRarity.legendary:
        return PlaygroundColors.progressionPremium;
    }
  }
}

class _BossGateSurface extends StatelessWidget {
  const _BossGateSurface({
    required this.visual,
    required this.state,
    required this.isDark,
    required this.scale,
    required this.accent,
    required this.pulsePhase,
    required this.openProgress,
  });

  final BossGateVisual visual;
  final BossGateState state;
  final bool isDark;
  final double scale;
  final Color accent;
  final double pulsePhase;
  final double openProgress;

  @override
  Widget build(BuildContext context) {
    final width = PlaygroundSizes.bossGateWidth * scale;
    final height = PlaygroundSizes.bossGateHeight * scale;
    final baseColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightBackground;
    final pillarColor = accent.withValues(
      alpha: state == BossGateState.locked
          ? PlaygroundAlpha.bossGateLockAlpha
          : 1.0,
    );
    final glowAlpha =
        PlaygroundAlpha.bossGatePulseFloor +
        pulsePhase * PlaygroundAlpha.bossGatePulseAmplitude;
    final glowScale = state == BossGateState.locked
        ? 0.8 + pulsePhase * 0.4
        : 1.0;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: height * 0.05,
            child: Container(
              width: width + PlaygroundSizes.bossGateGlowSpread * 24,
              height: height * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: accent.withValues(
                      alpha: state == BossGateState.locked
                          ? glowAlpha * 0.6
                          : PlaygroundAlpha.bossGateUnlockGlowAlpha,
                    ),
                    blurRadius: PlaygroundSizes.bossGateGlowBlur * glowScale,
                    spreadRadius: PlaygroundSizes.bossGateGlowSpread,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                PlaygroundSizes.cardCornerRadius,
              ),
              color: baseColor,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: AppColors.nodeDropShadow,
                  blurRadius: PlaygroundSizes.bossGateShadowBlur,
                  offset: PlaygroundSizes.bossGateShadowOffset,
                ),
              ],
            ),
          ),
          ClipRect(
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  _ArchPath(width: width, height: height, color: pillarColor),
                  Positioned(
                    top: height * 0.35,
                    child: _GateLock(
                      state: state,
                      accent: accent,
                      openProgress: openProgress,
                    ),
                  ),
                  Positioned(
                    bottom: height * 0.08,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _GateLabel(visual: visual, isDark: isDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchPath extends StatelessWidget {
  const _ArchPath({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _BossArchPainter(color: color, isDark: false),
        ),
      ),
    );
  }
}

class _BossArchPainter extends CustomPainter {
  _BossArchPainter({required this.color, required this.isDark});

  final Color color;
  final bool isDark;

  static final Paint _pillarPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  static final Paint _shadowPaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..maskFilter = const MaskFilter.blur(
      BlurStyle.normal,
      PlaygroundSizes.bossGateShadowBlur,
    );

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final pillarWidth = PlaygroundSizes.bossGatePillarWidth;
    final archRadius = width * 0.42;

    _shadowPaint.color = AppColors.nodeDropShadow;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, height - 16, width, 16),
        const Radius.circular(AppRadius.md),
      ),
      _shadowPaint,
    );

    _pillarPaint.color = color.withValues(alpha: 0.30);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, pillarWidth, height * 0.85),
      _pillarPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(width - pillarWidth, 0, pillarWidth, height * 0.85),
      _pillarPaint,
    );

    final archPath = Path()
      ..moveTo(pillarWidth, height * 0.55)
      ..lineTo(pillarWidth, height * 0.30)
      ..arcToPoint(
        Offset(width - pillarWidth, height * 0.30),
        radius: Radius.circular(archRadius),
        clockwise: true,
      )
      ..lineTo(width - pillarWidth, height * 0.55)
      ..close();
    _pillarPaint.color = color.withValues(alpha: 0.45);
    canvas.drawPath(archPath, _pillarPaint);

    _pillarPaint.color = color;
    final leftPillar = Path()
      ..moveTo(pillarWidth, height * 0.55)
      ..lineTo(pillarWidth, height * 0.85)
      ..lineTo(pillarWidth + AppStrokes.regular, height * 0.85)
      ..lineTo(pillarWidth + AppStrokes.regular, height * 0.30)
      ..arcToPoint(
        Offset(width - pillarWidth - AppStrokes.regular, height * 0.30),
        radius: Radius.circular(archRadius),
        clockwise: true,
      )
      ..lineTo(width - pillarWidth - AppStrokes.regular, height * 0.85)
      ..lineTo(width - pillarWidth, height * 0.85)
      ..lineTo(width - pillarWidth, height * 0.55)
      ..close();
    canvas.drawPath(leftPillar, _pillarPaint);

    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.18);
    final highlightPath = Path()
      ..moveTo(pillarWidth + 2, height * 0.85)
      ..lineTo(pillarWidth + 2, height * 0.32)
      ..arcToPoint(
        Offset(width - pillarWidth - 2, height * 0.32),
        radius: Radius.circular(archRadius - 2),
        clockwise: true,
      )
      ..lineTo(width - pillarWidth - 2, height * 0.85)
      ..lineTo(width - pillarWidth - 8, height * 0.85)
      ..lineTo(width - pillarWidth - 8, height * 0.32)
      ..arcToPoint(
        Offset(pillarWidth + 8, height * 0.32),
        radius: Radius.circular(archRadius - 8),
        clockwise: false,
      )
      ..lineTo(pillarWidth + 8, height * 0.85)
      ..close();
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _BossArchPainter old) {
    return old.color != color;
  }
}

class _GateLock extends StatelessWidget {
  const _GateLock({
    required this.state,
    required this.accent,
    required this.openProgress,
  });

  final BossGateState state;
  final Color accent;
  final double openProgress;

  @override
  Widget build(BuildContext context) {
    if (state == BossGateState.open) return const SizedBox.shrink();
    final size = PlaygroundSizes.bossGateLockSize;
    final opacity = state == BossGateState.locked ? 1.0 : 1.0 - openProgress;
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withValues(alpha: 0.9),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: accent.withValues(
                alpha: PlaygroundAlpha.bossGateUnlockGlowAlpha,
              ),
              blurRadius: PlaygroundSizes.bossGateGlowBlur * 0.6,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          state == BossGateState.locked ? Icons.lock : Icons.lock_open,
          color: Colors.white,
          size: size * 0.55,
        ),
      ),
    );
  }
}

class _GateLabel extends StatelessWidget {
  const _GateLabel({required this.visual, required this.isDark});

  final BossGateVisual visual;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;
    final muted = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final requirement = PlaygroundStrings.bossGateRequirementsTemplate
        .replaceFirst('%d', '${visual.requiredLevel}');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          WidgetConstants.outlineThickness * 6,
        ),
        color: (isDark ? AppColors.darkSurface : AppColors.lightBackground)
            .withValues(alpha: 0.85),
        border: Border.all(color: muted.withValues(alpha: 0.30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            visual.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (visual.subtitle != null && visual.subtitle!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxs),
              child: Text(
                visual.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: muted),
              ),
            ),
          if (visual.requiredLevel > 0)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                requirement,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PlaygroundColors.progressionInProgress,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
