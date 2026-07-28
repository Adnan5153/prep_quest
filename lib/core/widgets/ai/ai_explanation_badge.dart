import 'package:flutter/material.dart';

import 'ai_constants.dart';
import 'ai_explanation_constants.dart';

/// A compact "AI"-branded pill badge used in the explanation card header.
///
/// Tone controls the colour family; the gradient stays anchored on the AI
/// violet/indigo brand but is tinted according to the semantic tone.
class AiExplanationBadge extends StatelessWidget {
  const AiExplanationBadge({
    super.key,
    this.label = 'AI INSIGHT',
    this.icon = Icons.auto_awesome_rounded,
    this.tone = AiExplanationTone.insight,
    this.showIcon = true,
  });

  final String label;
  final IconData icon;
  final AiExplanationTone tone;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tones = _TonePalette.resolve(tone, isDark: isDark);

    return Semantics(
      label: 'AI $label',
      container: true,
      child: Container(
        height: AiExplanationConstants.badgeHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AiExplanationConstants.gapMd,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: tones.gradient,
          ),
          borderRadius: BorderRadius.circular(
            AiExplanationConstants.pillRadius,
          ),
          border: Border.all(color: tones.border, width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                icon,
                size: AiExplanationConstants.headerIconSize,
                color: tones.foreground,
              ),
              const SizedBox(width: AiExplanationConstants.gapXxs),
            ],
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: tones.foreground,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal palette for the badge — kept private to the badge file.
class _TonePalette {
  const _TonePalette({
    required this.gradient,
    required this.border,
    required this.foreground,
  });

  final List<Color> gradient;
  final Color border;
  final Color foreground;

  static _TonePalette resolve(AiExplanationTone tone, {required bool isDark}) {
    switch (tone) {
      case AiExplanationTone.insight:
        return _TonePalette(
          gradient: const <Color>[AiConstants.aiViolet, AiConstants.aiIndigo],
          border: AiConstants.aiViolet.withValues(alpha: 0.4),
          foreground: Colors.white,
        );
      case AiExplanationTone.hint:
        return _TonePalette(
          gradient: <Color>[
            AiConstants.aiCyan.withValues(alpha: isDark ? 0.6 : 0.85),
            AiConstants.aiViolet.withValues(alpha: isDark ? 0.5 : 0.7),
          ],
          border: AiConstants.aiCyan.withValues(alpha: 0.4),
          foreground: Colors.white,
        );
      case AiExplanationTone.tip:
        return _TonePalette(
          gradient: <Color>[
            AiConstants.aiPurple.withValues(alpha: 0.9),
            AiConstants.aiIndigo.withValues(alpha: 0.9),
          ],
          border: AiConstants.aiPurple.withValues(alpha: 0.4),
          foreground: Colors.white,
        );
      case AiExplanationTone.warning:
        return const _TonePalette(
          gradient: <Color>[Color(0xFFF59E0B), Color(0xFFD97706)],
          border: Color(0x33F59E0B),
          foreground: Colors.white,
        );
      case AiExplanationTone.error:
        return const _TonePalette(
          gradient: <Color>[Color(0xFFEF4444), Color(0xFFB91C1C)],
          border: Color(0x33EF4444),
          foreground: Colors.white,
        );
      case AiExplanationTone.success:
        return const _TonePalette(
          gradient: <Color>[Color(0xFF22C55E), Color(0xFF15803D)],
          border: Color(0x3322C55E),
          foreground: Colors.white,
        );
      case AiExplanationTone.info:
        return const _TonePalette(
          gradient: <Color>[Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          border: Color(0x333B82F6),
          foreground: Colors.white,
        );
    }
  }
}
