import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'ai_avatar_constants.dart';
import 'ai_avatar_status.dart';

/// The animated halo + glow layer rendered behind the orb core. Composed of:
///   * an outer radial "bloom"
///   * an inner colour-matched ring
///   * a soft glassmorphic veil
///
/// The widget is intentionally dumb about status — it just consumes the
/// [AiAvatarTuning] picked by the parent.
class AiAvatarGlow extends StatelessWidget {
  const AiAvatarGlow({
    super.key,
    required this.tuning,
    required this.size,
    required this.intensity,
  });

  final AiAvatarTuning tuning;
  final double size;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    if (!tuning.usesHalo) {
      return IgnorePointer(child: SizedBox.square(dimension: size));
    }

    final double halo = size * AiAvatarConstants.haloExtension;
    final double ringRadius = size / 2 + halo * 0.4;
    final double bloomRadius = size / 2 + halo * 0.9 * (0.8 + 0.2 * intensity);

    final double opacity =
        (tuning.activeGlowOpacity * (0.55 + 0.45 * intensity)).clamp(0.0, 1.0);

    return IgnorePointer(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: size + halo * 2,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _BloomCircle(
                radius: bloomRadius,
                color: tuning.accent,
                opacity: opacity,
              ),
              _RingHaze(
                radius: ringRadius,
                color: tuning.accent,
                opacity: opacity * 0.7,
              ),
              _FrostedVeil(size: size, opacity: opacity),
            ],
          ),
        ),
      ),
    );
  }
}

class _BloomCircle extends StatelessWidget {
  const _BloomCircle({
    required this.radius,
    required this.color,
    required this.opacity,
  });

  final double radius;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0.0),
          ],
          stops: const <double>[0.0, 1.0],
        ),
      ),
    );
  }
}

class _RingHaze extends StatelessWidget {
  const _RingHaze({
    required this.radius,
    required this.color,
    required this.opacity,
  });

  final double radius;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: opacity * 0.6),
          width: 1.5,
        ),
      ),
    );
  }
}

class _FrostedVeil extends StatelessWidget {
  const _FrostedVeil({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.4,
      height: size * 1.4,
      child: ClipOval(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: Colors.white.withValues(alpha: opacity * 0.05),
          ),
        ),
      ),
    );
  }
}
