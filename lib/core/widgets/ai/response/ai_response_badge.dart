import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../ai_constants.dart';
import 'ai_response_constants.dart';

/// Compact "AI"-branded pill badge displayed in [AiResponseCard]'s header.
///
/// The badge label and icon are derived from [AiResponseType]; the
/// gradient stays anchored on the AI violet/indigo brand but is tinted
/// according to the semantic type. Callers can override every aspect of
/// the badge (label, icon, gradient family) by passing explicit values.
class AiResponseBadge extends StatelessWidget {
  const AiResponseBadge({
    super.key,
    this.type = AiResponseType.generic,
    this.label,
    this.icon,
    this.accentColor,
    this.showIcon = true,
  });

  /// Response type — drives the default label, icon, and accent palette.
  final AiResponseType type;

  /// Optional override for the visible label.
  final String? label;

  /// Optional override for the leading icon.
  final IconData? icon;

  /// Optional override for the gradient family. When supplied, the badge
  /// uses a two-stop gradient built from this colour instead of the type
  /// palette.
  final Color? accentColor;

  /// When `false`, hides the leading icon and renders text only.
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final _BadgePalette palette = _resolvePalette(type, accentColor, isDark);
    final String resolvedLabel = label ?? _defaultLabel(type);
    final IconData resolvedIcon = icon ?? _defaultIcon(type);

    return Semantics(
      label: 'AI $resolvedLabel',
      container: true,
      child: Container(
        height: AiResponseConstants.badgeHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AiResponseConstants.gapMd,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.gradient,
          ),
          borderRadius: BorderRadius.circular(AiResponseConstants.pillRadius),
          border: Border.all(color: palette.border, width: AppSizes.borderThin),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (showIcon) ...<Widget>[
              Icon(
                resolvedIcon,
                size: AiResponseConstants.headerIconSize,
                color: palette.foreground,
              ),
              const SizedBox(width: AiResponseConstants.gapXxs),
            ],
            Text(
              resolvedLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: palette.foreground,
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

  String _defaultLabel(AiResponseType type) {
    switch (type) {
      case AiResponseType.generic:
        return 'AI RESPONSE';
      case AiResponseType.answer:
        return 'AI ANSWER';
      case AiResponseType.hint:
        return 'AI HINT';
      case AiResponseType.summary:
        return 'AI SUMMARY';
      case AiResponseType.recommendation:
        return 'AI RECOMMENDATION';
      case AiResponseType.analysis:
        return 'AI ANALYSIS';
      case AiResponseType.explanation:
        return 'AI INSIGHT';
    }
  }

  IconData _defaultIcon(AiResponseType type) {
    switch (type) {
      case AiResponseType.generic:
        return Icons.auto_awesome_rounded;
      case AiResponseType.answer:
        return Icons.question_answer_rounded;
      case AiResponseType.hint:
        return Icons.lightbulb_outline_rounded;
      case AiResponseType.summary:
        return Icons.summarize_rounded;
      case AiResponseType.recommendation:
        return Icons.recommend_rounded;
      case AiResponseType.analysis:
        return Icons.insights_rounded;
      case AiResponseType.explanation:
        return Icons.psychology_rounded;
    }
  }

  _BadgePalette _resolvePalette(
    AiResponseType type,
    Color? accent,
    bool isDark,
  ) {
    if (accent != null) {
      return _BadgePalette(
        gradient: <Color>[accent, accent.withValues(alpha: 0.7)],
        border: accent.withValues(alpha: 0.4),
        foreground: Colors.white,
      );
    }
    switch (type) {
      case AiResponseType.generic:
      case AiResponseType.explanation:
        return _BadgePalette(
          gradient: const <Color>[AiConstants.aiViolet, AiConstants.aiIndigo],
          border: AiConstants.aiViolet.withValues(alpha: 0.4),
          foreground: Colors.white,
        );
      case AiResponseType.answer:
        return _BadgePalette(
          gradient: const <Color>[AiConstants.aiIndigo, AiConstants.aiViolet],
          border: AiConstants.aiIndigo.withValues(alpha: 0.4),
          foreground: Colors.white,
        );
      case AiResponseType.hint:
        return _BadgePalette(
          gradient: <Color>[
            AiConstants.aiCyan.withValues(alpha: isDark ? 0.6 : 0.85),
            AiConstants.aiViolet.withValues(alpha: isDark ? 0.5 : 0.7),
          ],
          border: AiConstants.aiCyan.withValues(alpha: 0.4),
          foreground: Colors.white,
        );
      case AiResponseType.summary:
        return _BadgePalette(
          gradient: <Color>[
            AiConstants.aiPurple.withValues(alpha: 0.9),
            AiConstants.aiIndigo.withValues(alpha: 0.9),
          ],
          border: AiConstants.aiPurple.withValues(alpha: 0.4),
          foreground: Colors.white,
        );
      case AiResponseType.recommendation:
        return const _BadgePalette(
          gradient: <Color>[Color(0xFF22C55E), Color(0xFF15803D)],
          border: Color(0x3322C55E),
          foreground: Colors.white,
        );
      case AiResponseType.analysis:
        return const _BadgePalette(
          gradient: <Color>[Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          border: Color(0x333B82F6),
          foreground: Colors.white,
        );
    }
  }
}

class _BadgePalette {
  const _BadgePalette({
    required this.gradient,
    required this.border,
    required this.foreground,
  });

  final List<Color> gradient;
  final Color border;
  final Color foreground;
}
