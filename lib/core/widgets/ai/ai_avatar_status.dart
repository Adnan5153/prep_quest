import 'package:flutter/material.dart';

import 'ai_avatar_constants.dart';

/// Semantic state of the AI assistant — drives the [AiAvatarAnimation].
enum AiAvatarStatus {
  /// Default ambient state. Soft breathing + idle glow.
  idle,

  /// Active listening — chrome records the user.
  listening,

  /// Awaiting model response before any tokens arrive.
  thinking,

  /// Mid-token generation.
  generating,

  /// Brief acknowledgement while a message is being typed back.
  typing,

  /// Voice / text-to-speech playback.
  speaking,

  /// Task completed cleanly.
  success,

  /// Soft alert — non-blocking.
  warning,

  /// Hard failure — something needs the user's attention.
  error,

  /// Not connected to model — animations slow and opacity drops.
  offline,
}

/// Per-status motion + visual tuning consumed by the avatar stack.
///
/// Keeping this in a dedicated class lets widgets query behaviour in
/// O(1) and stay focused on layout. Each field is documented so
/// future contributors can reason about UX rather than magic numbers.
@immutable
class AiAvatarTuning {
  const AiAvatarTuning({
    required this.status,
    required this.orbGradient,
    required this.accent,
    required this.activeGlowOpacity,
    required this.particleDensity,
    required this.orbitDuration,
    required this.particleDuration,
    required this.intensityCurve,
    required this.scalePulse,
    required this.usesHalo,
    required this.usesParticles,
    required this.usesEnergyRing,
    required this.showCoreIcon,
  });

  /// Status this tuning row describes.
  final AiAvatarStatus status;

  /// Gradient applied to the orb core.
  final Gradient orbGradient;

  /// Signature accent colour (used for shadow + particles).
  final Color accent;

  /// Peak halo / glow opacity for this status.
  final double activeGlowOpacity;

  /// 0..1 — drives particle alpha & density.
  final double particleDensity;

  /// Override for the orbit controller duration.
  final Duration orbitDuration;

  /// Override for the particle drift controller.
  final Duration particleDuration;

  /// Curve applied to the breathing intensity.
  final Curve intensityCurve;

  /// Multiplier applied to the orb scale during pulses.
  final double scalePulse;

  /// Whether the halo layer should render.
  final bool usesHalo;

  /// Whether the particle layer should render.
  final bool usesParticles;

  /// Whether the rotating energy ring should render.
  final bool usesEnergyRing;

  /// Whether the inner semantic icon should render.
  final bool showCoreIcon;

  // ---------------------------------------------------------------------------
  // Lookup table
  // ---------------------------------------------------------------------------

  /// Static lookup so consumers don't allocate on every build.
  static final Map<AiAvatarStatus, AiAvatarTuning> table =
      <AiAvatarStatus, AiAvatarTuning>{
        AiAvatarStatus.idle: AiAvatarTuning(
          status: AiAvatarStatus.idle,
          orbGradient: AiAvatarConstants.orbGradient,
          accent: const Color(0xFF6366F1),
          activeGlowOpacity: AiAvatarConstants.idleHaloOpacity,
          particleDensity: 0.35,
          orbitDuration: AiAvatarConstants.orbitDuration,
          particleDuration: AiAvatarConstants.particleDuration,
          intensityCurve: AiAvatarConstants.idleCurve,
          scalePulse: 1.0,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: false,
          showCoreIcon: true,
        ),
        AiAvatarStatus.listening: AiAvatarTuning(
          status: AiAvatarStatus.listening,
          orbGradient: AiAvatarConstants.orbGradient,
          accent: const Color(0xFF06B6D4),
          activeGlowOpacity: AiAvatarConstants.activeHaloOpacity,
          particleDensity: 0.55,
          orbitDuration: const Duration(milliseconds: 2600),
          particleDuration: const Duration(milliseconds: 3600),
          intensityCurve: AiAvatarConstants.idleCurve,
          scalePulse: 1.06,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: false,
          showCoreIcon: true,
        ),
        AiAvatarStatus.thinking: AiAvatarTuning(
          status: AiAvatarStatus.thinking,
          orbGradient: AiAvatarConstants.orbGradient,
          accent: const Color(0xFF8B5CF6),
          activeGlowOpacity: AiAvatarConstants.activeHaloOpacity,
          particleDensity: 0.7,
          orbitDuration: const Duration(milliseconds: 2200),
          particleDuration: const Duration(milliseconds: 3200),
          intensityCurve: AiAvatarConstants.idleCurve,
          scalePulse: 1.04,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: true,
          showCoreIcon: false,
        ),
        AiAvatarStatus.generating: AiAvatarTuning(
          status: AiAvatarStatus.generating,
          orbGradient: AiAvatarConstants.orbGradient,
          accent: const Color(0xFF06B6D4),
          activeGlowOpacity: AiAvatarConstants.maxGlowOpacity,
          particleDensity: 0.95,
          orbitDuration: const Duration(milliseconds: 1400),
          particleDuration: const Duration(milliseconds: 2000),
          intensityCurve: AiAvatarConstants.pulseCurve,
          scalePulse: 1.08,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: true,
          showCoreIcon: false,
        ),
        AiAvatarStatus.typing: AiAvatarTuning(
          status: AiAvatarStatus.typing,
          orbGradient: AiAvatarConstants.orbGradient,
          accent: const Color(0xFF6366F1),
          activeGlowOpacity: 0.7,
          particleDensity: 0.45,
          orbitDuration: const Duration(milliseconds: 2800),
          particleDuration: const Duration(milliseconds: 4200),
          intensityCurve: AiAvatarConstants.idleCurve,
          scalePulse: 1.03,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: false,
          showCoreIcon: true,
        ),
        AiAvatarStatus.speaking: AiAvatarTuning(
          status: AiAvatarStatus.speaking,
          orbGradient: AiAvatarConstants.orbGradient,
          accent: const Color(0xFF8B5CF6),
          activeGlowOpacity: AiAvatarConstants.maxGlowOpacity,
          particleDensity: 0.5,
          orbitDuration: AiAvatarConstants.speakingDuration,
          particleDuration: const Duration(milliseconds: 2400),
          intensityCurve: AiAvatarConstants.waveCurve,
          scalePulse: 1.1,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: false,
          showCoreIcon: true,
        ),
        AiAvatarStatus.success: AiAvatarTuning(
          status: AiAvatarStatus.success,
          orbGradient: AiAvatarConstants.successGradient,
          accent: const Color(0xFF059669),
          activeGlowOpacity: 0.85,
          particleDensity: 0.6,
          orbitDuration: AiAvatarConstants.pulseDuration,
          particleDuration: const Duration(milliseconds: 2200),
          intensityCurve: AiAvatarConstants.pulseCurve,
          scalePulse: 1.12,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: false,
          showCoreIcon: true,
        ),
        AiAvatarStatus.warning: AiAvatarTuning(
          status: AiAvatarStatus.warning,
          orbGradient: AiAvatarConstants.warningGradient,
          accent: const Color(0xFFD97706),
          activeGlowOpacity: 0.85,
          particleDensity: 0.55,
          orbitDuration: const Duration(milliseconds: 1200),
          particleDuration: const Duration(milliseconds: 2000),
          intensityCurve: AiAvatarConstants.pulseCurve,
          scalePulse: 1.04,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: false,
          showCoreIcon: true,
        ),
        AiAvatarStatus.error: AiAvatarTuning(
          status: AiAvatarStatus.error,
          orbGradient: AiAvatarConstants.errorGradient,
          accent: const Color(0xFFDC2626),
          activeGlowOpacity: 0.95,
          particleDensity: 0.65,
          orbitDuration: const Duration(milliseconds: 900),
          particleDuration: const Duration(milliseconds: 2400),
          intensityCurve: AiAvatarConstants.shakeCurve,
          scalePulse: 1.05,
          usesHalo: true,
          usesParticles: true,
          usesEnergyRing: false,
          showCoreIcon: true,
        ),
        AiAvatarStatus.offline: AiAvatarTuning(
          status: AiAvatarStatus.offline,
          orbGradient: AiAvatarConstants.offlineGradient,
          accent: const Color(0xFF6B7280),
          activeGlowOpacity: AiAvatarConstants.baseGlowOpacity,
          particleDensity: 0.0,
          orbitDuration: const Duration(seconds: 8),
          particleDuration: const Duration(seconds: 8),
          intensityCurve: AiAvatarConstants.idleCurve,
          scalePulse: 0.98,
          usesHalo: true,
          usesParticles: false,
          usesEnergyRing: false,
          showCoreIcon: true,
        ),
      };

  /// Returns the tuning row for [status]. Falls back to [AiAvatarStatus.idle].
  static AiAvatarTuning of(AiAvatarStatus status) =>
      table[status] ?? table[AiAvatarStatus.idle]!;
}
