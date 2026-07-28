import 'package:flutter/material.dart';

import 'ai_explanation_badge.dart';
import 'ai_explanation_constants.dart';

/// Header section for [AiExplanationCard] — title, badge, decorative
/// avatar/icon, and tone label.
///
/// The header is read-only; it animates a subtle scale on its avatar in
/// response to theme and selection state but doesn't own expansion logic.
class AiExplanationHeader extends StatelessWidget {
  const AiExplanationHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.auto_awesome_rounded,
    this.badgeLabel = 'AI INSIGHT',
    this.tone = AiExplanationTone.insight,
    this.showBadge = true,
    this.timestamp,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String badgeLabel;
  final AiExplanationTone tone;
  final bool showBadge;
  final String? timestamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = _accentFor(tone);
    final foreground = isDark ? Colors.white : const Color(0xFF1F2937);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.maxWidth < AiExplanationConstants.compactBreakpoint;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AvatarTile(icon: icon, accent: accentColor),
                const SizedBox(width: AiExplanationConstants.gapMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
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
                          if (showBadge) ...[
                            const SizedBox(width: AiExplanationConstants.gapSm),
                            AiExplanationBadge(
                              label: badgeLabel,
                              icon: icon,
                              tone: tone,
                            ),
                          ],
                        ],
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AiExplanationConstants.gapXxs),
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
                      if (timestamp != null) ...[
                        const SizedBox(height: AiExplanationConstants.gapXs),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: AiExplanationConstants.headerIconSize - 4,
                              color: foreground.withValues(alpha: 0.5),
                            ),
                            const SizedBox(
                              width: AiExplanationConstants.gapXxs,
                            ),
                            Text(
                              timestamp!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: foreground.withValues(alpha: 0.55),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AiExplanationConstants.gapMd),
            _AccentStrip(tone: tone),
          ],
        );
      },
    );
  }

  Color _accentFor(AiExplanationTone tone) {
    switch (tone) {
      case AiExplanationTone.insight:
        return const Color(0xFF6366F1);
      case AiExplanationTone.hint:
        return const Color(0xFF06B6D4);
      case AiExplanationTone.tip:
        return const Color(0xFF8B5CF6);
      case AiExplanationTone.warning:
        return const Color(0xFFF59E0B);
      case AiExplanationTone.error:
        return const Color(0xFFEF4444);
      case AiExplanationTone.success:
        return const Color(0xFF22C55E);
      case AiExplanationTone.info:
        return const Color(0xFF3B82F6);
    }
  }
}

/// Rounded avatar with a glowing background — the visual anchor of the card.
class _AvatarTile extends StatelessWidget {
  const _AvatarTile({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: AiExplanationConstants.headerAvatarSize,
      height: AiExplanationConstants.headerAvatarSize,
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
            color: accent.withValues(
              alpha: AiExplanationConstants.avatarGlowOpacity,
            ),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: AiExplanationConstants.headerIconSize,
        color: accent,
      ),
    );
  }
}

/// Thin gradient strip that visually anchors the card to the AI brand.
class _AccentStrip extends StatelessWidget {
  const _AccentStrip({required this.tone});

  final AiExplanationTone tone;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'AI accent',
      child: Container(
        height: 2.0,
        decoration: BoxDecoration(
          gradient: _stripGradient(tone, isDark: isDark),
          borderRadius: BorderRadius.circular(1.0),
        ),
      ),
    );
  }

  Gradient _stripGradient(AiExplanationTone tone, {required bool isDark}) {
    if (tone == AiExplanationTone.insight) {
      return AiExplanationConstants.accentStripGradient;
    }
    final base = _toneBase(tone);
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: <Color>[
        base.withValues(alpha: isDark ? 0.85 : 1.0),
        base.withValues(alpha: 0.2),
      ],
    );
  }

  Color _toneBase(AiExplanationTone tone) {
    switch (tone) {
      case AiExplanationTone.insight:
        return const Color(0xFF6366F1);
      case AiExplanationTone.hint:
        return const Color(0xFF06B6D4);
      case AiExplanationTone.tip:
        return const Color(0xFF8B5CF6);
      case AiExplanationTone.warning:
        return const Color(0xFFF59E0B);
      case AiExplanationTone.error:
        return const Color(0xFFEF4444);
      case AiExplanationTone.success:
        return const Color(0xFF22C55E);
      case AiExplanationTone.info:
        return const Color(0xFF3B82F6);
    }
  }
}
