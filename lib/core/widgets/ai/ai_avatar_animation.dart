import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import 'ai_avatar_constants.dart';
import 'ai_avatar_extensions.dart';
import 'ai_avatar_glow.dart';
import 'ai_avatar_particles.dart';
import 'ai_avatar_painter.dart';
import 'ai_avatar_status.dart';
import 'ai_avatar_styles.dart';

/// Speed multiplier applied to every animation in the avatar.
enum AiAvatarAnimationSpeed {
  /// Off — animations are paused (only static visuals remain).
  none,

  /// Reduced motion.
  slow,

  /// Default.
  normal,

  /// Fast / energetic.
  fast,
}

/// Visual intensity multiplier — scales glow strength + pulse amplitude.
enum AiAvatarAnimationIntensity {
  /// Minimalist.
  subtle,

  /// Default.
  normal,

  /// Heavy / marketing surfaces.
  bold,
}

/// A production-ready, theme-aware AI avatar for Prep Quest.
///
/// Renders a layered "Living AI Orb" composed of:
///   * an animated halo + glow ([AiAvatarGlow])
///   * a constellation of orbiting particles ([AiAvatarParticles])
///   * the orb body + energy ring ([AiAvatarOrbPainter])
///   * an optional content slot (typically a semantic icon)
///
/// The widget stays responsive across mobile / tablet / desktop / web by
/// clamping the requested [size] inside the global [AiAvatarConstants]
/// bounds, and respects [animationSpeed] / [animationIntensity] for
/// accessibility-friendly configurations.
class AiAvatarAnimation extends StatefulWidget {
  const AiAvatarAnimation({
    super.key,
    this.status = AiAvatarStatus.idle,
    this.size = AiAvatarConstants.defaultSize,
    this.primaryColor,
    this.secondaryColor,
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.animationSpeed = AiAvatarAnimationSpeed.normal,
    this.animationIntensity = AiAvatarAnimationIntensity.normal,
    this.glowEnabled = true,
    this.haloEnabled = true,
    this.particlesEnabled = true,
    this.shadowEnabled = true,
    this.semanticLabel,
    this.onTap,
  }) : assert(
         size >= AiAvatarConstants.minSize,
         'AiAvatarAnimation.size must be >= ${AiAvatarConstants.minSize}',
       ),
       assert(
         size <= AiAvatarConstants.maxSize,
         'AiAvatarAnimation.size must be <= ${AiAvatarConstants.maxSize}',
       ),
       assert(borderWidth == null || borderWidth >= 0);

  /// Semantic state — drives the motion + colour scheme.
  final AiAvatarStatus status;

  /// Diameter of the orb, clamped to the AI avatar size bounds.
  final double size;

  /// Primary colour override — typically the orb "head" colour.
  final Color? primaryColor;

  /// Secondary colour override — typically the gradient tail.
  final Color? secondaryColor;

  /// Full gradient override (wins over the per-status palette).
  final Gradient? gradient;

  /// Background "card" colour drawn behind the orb (rarely needed).
  final Color? backgroundColor;

  /// Border stroke colour override.
  final Color? borderColor;

  /// Border stroke width override. When `null`, uses the painter default.
  final double? borderWidth;

  /// Global speed multiplier.
  final AiAvatarAnimationSpeed animationSpeed;

  /// Global intensity multiplier.
  final AiAvatarAnimationIntensity animationIntensity;

  /// Toggles the glow layer entirely.
  final bool glowEnabled;

  /// Toggles the animated halo around the orb.
  final bool haloEnabled;

  /// Toggles the orbiting particles.
  final bool particlesEnabled;

  /// Toggles the drop shadow under the orb.
  final bool shadowEnabled;

  /// Optional screen-reader label override.
  final String? semanticLabel;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  State<AiAvatarAnimation> createState() => _AiAvatarAnimationState();
}

class _AiAvatarAnimationState extends State<AiAvatarAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _breathingController;
  late final AnimationController _orbitController;
  late final AnimationController _particleController;

  late Animation<double> _breathing;
  late Animation<double> _orbit;
  late Animation<double> _particleProgress;

  AiAvatarStatus _renderedStatus = AiAvatarStatus.idle;
  late AiAvatarTuning _tuning = AiAvatarTuning.of(_renderedStatus);

  @override
  void initState() {
    super.initState();
    _renderedStatus = widget.status;
    _tuning = _resolveTuning();

    _breathingController = AnimationController(
      vsync: this,
      duration: AiAvatarConstants.breathingDuration,
    );
    _orbitController = AnimationController(
      vsync: this,
      duration: _tuning.orbitDuration,
    );
    _particleController = AnimationController(
      vsync: this,
      duration: _tuning.particleDuration,
    );

    _breathing = CurvedAnimation(
      parent: _breathingController,
      curve: _tuning.intensityCurve,
    );
    _orbit = CurvedAnimation(
      parent: _orbitController,
      curve: AiAvatarConstants.orbitCurve,
    );
    _particleProgress = CurvedAnimation(
      parent: _particleController,
      curve: AiAvatarConstants.orbitCurve,
    );

    _startOrPauseAnimations();
  }

  @override
  void didUpdateWidget(covariant AiAvatarAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.animationSpeed != widget.animationSpeed ||
        oldWidget.particlesEnabled != widget.particlesEnabled) {
      _renderedStatus = widget.status;
      _tuning = _resolveTuning();
      _orbitController.duration = _tuning.orbitDuration;
      _particleController.duration = _tuning.particleDuration;
      _breathing = CurvedAnimation(
        parent: _breathingController,
        curve: _tuning.intensityCurve,
      );
      _startOrPauseAnimations();
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _orbitController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Animation orchestration
  // ---------------------------------------------------------------------------

  AiAvatarTuning _resolveTuning() {
    AiAvatarTuning base = AiAvatarTuning.of(widget.status);
    // Apply enabled flags by stripping the relevant layers off the tuning.
    if (!widget.glowEnabled || !widget.haloEnabled) {
      base = _disableHalo(base);
    }
    if (!widget.particlesEnabled) {
      base = _disableParticles(base);
    }
    return base;
  }

  AiAvatarTuning _disableHalo(AiAvatarTuning t) {
    // Cheaper than rebuilding via copyWith — we just toggle the field.
    return AiAvatarTuning(
      status: t.status,
      orbGradient: t.orbGradient,
      accent: t.accent,
      activeGlowOpacity: 0,
      particleDensity: t.particleDensity,
      orbitDuration: t.orbitDuration,
      particleDuration: t.particleDuration,
      intensityCurve: t.intensityCurve,
      scalePulse: t.scalePulse,
      usesHalo: false,
      usesParticles: t.usesParticles,
      usesEnergyRing: t.usesEnergyRing,
      showCoreIcon: t.showCoreIcon,
    );
  }

  AiAvatarTuning _disableParticles(AiAvatarTuning t) {
    return AiAvatarTuning(
      status: t.status,
      orbGradient: t.orbGradient,
      accent: t.accent,
      activeGlowOpacity: t.activeGlowOpacity,
      particleDensity: 0,
      orbitDuration: t.orbitDuration,
      particleDuration: t.particleDuration,
      intensityCurve: t.intensityCurve,
      scalePulse: t.scalePulse,
      usesHalo: t.usesHalo,
      usesParticles: false,
      usesEnergyRing: t.usesEnergyRing,
      showCoreIcon: t.showCoreIcon,
    );
  }

  void _startOrPauseAnimations() {
    final double speed = _speedScalar();
    if (speed == 0.0) {
      _breathingController.stop();
      _orbitController.stop();
      _particleController.stop();
      return;
    }

    if (!_breathingController.isAnimating) {
      _breathingController.duration = Duration(
        milliseconds:
            (AiAvatarConstants.breathingDuration.inMilliseconds / speed)
                .round(),
      );
      _breathingController.repeat(reverse: true);
    }

    if (_tuning.usesEnergyRing && !_orbitController.isAnimating) {
      _orbitController.repeat();
    } else if (!_tuning.usesEnergyRing && _orbitController.isAnimating) {
      _orbitController.stop();
    }

    if (_tuning.usesParticles && !_particleController.isAnimating) {
      _particleController.repeat();
    } else if (!_tuning.usesParticles && _particleController.isAnimating) {
      _particleController.stop();
    }
  }

  double _speedScalar() {
    switch (widget.animationSpeed) {
      case AiAvatarAnimationSpeed.none:
        return 0.0;
      case AiAvatarAnimationSpeed.slow:
        return 0.65;
      case AiAvatarAnimationSpeed.normal:
        return 1.0;
      case AiAvatarAnimationSpeed.fast:
        return 1.45;
    }
  }

  double _intensityScalar() {
    switch (widget.animationIntensity) {
      case AiAvatarAnimationIntensity.subtle:
        return 0.7;
      case AiAvatarAnimationIntensity.normal:
        return 1.0;
      case AiAvatarAnimationIntensity.bold:
        return 1.25;
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = theme.brightness;
    final AiAvatarStyle style = AiAvatarStyles.resolve(
      widget.status,
      brightness,
    );
    final double intensity = _intensityScalar();

    final double clampedSize = widget.size.clamp(
      AiAvatarConstants.minSize,
      AiAvatarConstants.maxSize,
    );

    // Cross-fade opacity for status transitions is handled by the outer
    // AnimatedOpacity — it's cheap and avoids layered animation controllers.
    return Semantics(
      container: true,
      label: widget.semanticLabel ?? widget.status.semanticLabel,
      child: AnimatedOpacity(
        duration: AiAvatarConstants.statusTransitionDuration,
        opacity: style.outerOpacity,
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: SizedBox(
              width:
                  clampedSize +
                  clampedSize * AiAvatarConstants.haloExtension * 2,
              height:
                  clampedSize +
                  clampedSize * AiAvatarConstants.haloExtension * 2,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AiAvatarGlow(
                    tuning: _tuning,
                    size: clampedSize,
                    intensity: intensity,
                  ),
                  AiAvatarParticles(
                    tuning: _tuning,
                    size: clampedSize,
                    progress: _particleProgress.value,
                  ),
                  _OrbStack(
                    style: style,
                    size: clampedSize,
                    intensity: intensity,
                    breathing: _breathing.value,
                    orbitProgress: _orbit.value,
                    shakeOffset: _shakeOffsetForStatus(),
                    borderWidth: widget.borderWidth,
                    shadowEnabled: widget.shadowEnabled,
                    background: widget.backgroundColor,
                    breathController: _breathingController,
                  ),
                  if (widget.gradient != null || widget.primaryColor != null)
                    _CustomisedAccentHalo(
                      tuning: _tuning,
                      size: clampedSize,
                      gradient: widget.gradient,
                      primary: widget.primaryColor,
                      secondary: widget.secondaryColor,
                      intensity: intensity,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _shakeOffsetForStatus() {
    // Returns a small lateral scalar in [-1, 1] used to nudge the orb on
    // error. It piggy-backs on the breathing controller so no extra
    // controller is needed.
    if (widget.status != AiAvatarStatus.error) return 0.0;
    final double t = _breathingController.value;
    return math.sin(t * math.pi * 8) * (1 - t) * 0.04;
  }
}

// =============================================================================
// Layered orb — composed inside the main widget stack.
// =============================================================================

class _OrbStack extends StatelessWidget {
  const _OrbStack({
    required this.style,
    required this.size,
    required this.intensity,
    required this.breathing,
    required this.orbitProgress,
    required this.shakeOffset,
    required this.borderWidth,
    required this.shadowEnabled,
    required this.background,
    required this.breathController,
  });

  final AiAvatarStyle style;
  final double size;
  final double intensity;
  final double breathing;
  final double orbitProgress;
  final double shakeOffset;
  final double? borderWidth;
  final bool shadowEnabled;
  final Color? background;
  final AnimationController breathController;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: AnimatedBuilder(
        animation: breathController,
        builder: (BuildContext context, _) {
          final double current = _curvedBreath(breathController.value);
          final double scale = 0.94 + 0.06 * current;
          final double shake = shakeOffset;
          return Transform.translate(
            offset: Offset(shake * size, 0),
            child: Container(
              width: size,
              height: size,
              decoration: shadowEnabled
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: style.coreShadow,
                    )
                  : const BoxDecoration(shape: BoxShape.circle),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  if (background != null)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: background,
                      ),
                    ),
                  RepaintBoundary(
                    child: Transform.scale(
                      scale: scale,
                      child: CustomPaint(
                        size: Size.square(size),
                        painter: AiAvatarOrbPainter(
                          tuning: style.tuning,
                          brightness: style.brightness,
                          intensity: intensity,
                          orbitProgress: orbitProgress,
                          breathePhase: current,
                          shakeOffset: shake,
                        ),
                      ),
                    ),
                  ),
                  if (style.tuning.showCoreIcon)
                    _CoreIcon(
                      icon: style.tuning.status.coreIcon,
                      color: style.foregroundIconColor,
                      size: size,
                    ),
                  if (borderWidth != null)
                    _CustomBorder(
                      width: borderWidth!,
                      color: style.borderColor,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Mirror the configured intensity curve; defaults to linear if the
  // controller hasn't received one yet (it always has at this point but
  // we keep the guard defensive).
  double _curvedBreath(double t) {
    return Curves.easeInOut.transform(t.clamp(0.0, 1.0));
  }
}

class _CoreIcon extends StatelessWidget {
  const _CoreIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final double iconSize = size * 0.32;
    if (iconSize < AppSizes.iconXs) {
      return const SizedBox.shrink();
    }
    return SizedBox.square(
      dimension: size,
      child: Center(
        child: Icon(icon, size: iconSize, color: color),
      ),
    );
  }
}

class _CustomBorder extends StatelessWidget {
  const _CustomBorder({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.square(
        dimension: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: width),
          ),
        ),
      ),
    );
  }
}

/// Optional decorative halo tinted with user-supplied colours. Drawn under
/// the orb so it never competes with the painter glow.
class _CustomisedAccentHalo extends StatelessWidget {
  const _CustomisedAccentHalo({
    required this.tuning,
    required this.size,
    required this.gradient,
    required this.primary,
    required this.secondary,
    required this.intensity,
  });

  final AiAvatarTuning tuning;
  final double size;
  final Gradient? gradient;
  final Color? primary;
  final Color? secondary;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    if (gradient == null && (primary == null || secondary == null)) {
      return const SizedBox.shrink();
    }
    final Gradient halo =
        gradient ??
        LinearGradient(
          colors: <Color>[
            primary!.withValues(alpha: 0.25 * intensity),
            secondary!.withValues(alpha: 0.0),
          ],
        );
    return IgnorePointer(
      child: SizedBox(
        width: size * 1.6,
        height: size * 1.6,
        child: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: halo),
        ),
      ),
    );
  }
}
