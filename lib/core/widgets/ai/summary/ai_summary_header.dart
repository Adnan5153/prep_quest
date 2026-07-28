import 'package:flutter/material.dart';

import '../ai_constants.dart';
import 'ai_summary_constants.dart';

class AiSummaryHeader extends StatelessWidget {
  const AiSummaryHeader({
    super.key,
    required this.title,
    required this.tone,
    required this.accent,
    this.subtitle,
    this.icon = Icons.summarize_rounded,
    this.badgeLabel = 'AI SUMMARY',
    this.showBadge = true,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String badgeLabel;
  final AiSummaryTone tone;
  final Color accent;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color foreground = isDark ? Colors.white : const Color(0xFF1F2937);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact =
            constraints.maxWidth < AiSummaryConstants.compactBreakpoint;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _AvatarTile(icon: icon, accent: accent),
                const SizedBox(width: AiSummaryConstants.gapMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: foreground,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                          ),
                          if (showBadge) ...<Widget>[
                            const SizedBox(width: AiSummaryConstants.gapSm),
                            _Badge(
                              label: badgeLabel,
                              icon: icon,
                              tone: tone,
                              accent: accent,
                            ),
                          ],
                        ],
                      ),
                      if (subtitle != null) ...<Widget>[
                        const SizedBox(height: AiSummaryConstants.gapXxs),
                        Text(
                          subtitle!,
                          maxLines: isCompact ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: foreground.withValues(alpha: 0.65),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AiSummaryConstants.gapMd),
            _AccentStrip(accent: accent, isDark: isDark),
          ],
        );
      },
    );
  }
}

class _AvatarTile extends StatelessWidget {
  const _AvatarTile({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: AiSummaryConstants.headerAvatarSize,
      height: AiSummaryConstants.headerAvatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            accent.withValues(alpha: 0.18),
            accent.withValues(alpha: isDark ? 0.32 : 0.12),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Icon(icon, size: AiSummaryConstants.headerIconSize, color: accent),
    );
  }
}

class _AccentStrip extends StatelessWidget {
  const _AccentStrip({required this.accent, required this.isDark});

  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'AI accent',
      child: Container(
        height: 2.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              accent.withValues(alpha: isDark ? 0.85 : 1.0),
              accent.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(1.0),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.icon,
    required this.tone,
    required this.accent,
  });

  final String label;
  final IconData icon;
  final AiSummaryTone tone;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Color> gradientColors = _gradientFor(tone);

    return Semantics(
      label: 'AI $label',
      container: true,
      child: Container(
        height: AiSummaryConstants.badgeHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AiSummaryConstants.gapMd,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(AiSummaryConstants.pillRadius),
          border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: AiSummaryConstants.headerIconSize,
              color: Colors.white,
            ),
            const SizedBox(width: AiSummaryConstants.gapXxs),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
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

  List<Color> _gradientFor(AiSummaryTone tone) {
    switch (tone) {
      case AiSummaryTone.summary:
        return const <Color>[AiConstants.aiViolet, AiConstants.aiIndigo];
      case AiSummaryTone.brief:
        return const <Color>[AiConstants.aiCyan, AiConstants.aiViolet];
      case AiSummaryTone.deepDive:
        return const <Color>[AiConstants.aiIndigo, Color(0xFF1E1B4B)];
      case AiSummaryTone.tip:
        return const <Color>[AiConstants.aiPurple, AiConstants.aiViolet];
      case AiSummaryTone.warning:
        return const <Color>[Color(0xFFF59E0B), Color(0xFFD97706)];
    }
  }
}
