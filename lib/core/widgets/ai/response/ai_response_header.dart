import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../ai_constants.dart';
import 'ai_response_badge.dart';
import 'ai_response_constants.dart';

/// Header section for [AiResponseCard] — leading avatar tile, title,
/// optional subtitle, optional badge, and the optional metadata strip.
///
/// The header is read-only and stateless. It composes an avatar with a
/// tinted glow, a title row that accommodates the badge, and a flexible
/// subtitle that collapses gracefully on compact layouts.
class AiResponseHeader extends StatelessWidget {
  const AiResponseHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.icon = Icons.auto_awesome_rounded,
    this.badgeLabel,
    this.responseType = AiResponseType.generic,
    this.accentColor,
    this.showBadge = true,
  });

  /// Required card title (e.g. "AI Tutor", "Hint", "Analysis").
  final String title;

  /// Optional supporting line beneath the title.
  final String? subtitle;

  /// Optional leading widget — when supplied, replaces the default
  /// gradient avatar tile (e.g. an image avatar, a user-provided icon
  /// stack, or a status dot). The caller is responsible for sizing.
  final Widget? leading;

  /// Optional trailing widget placed at the far right of the header
  /// row — typically a chevron or status indicator.
  final Widget? trailing;

  /// Default icon for the avatar tile. Ignored when [leading] is set.
  final IconData icon;

  /// Optional override for the badge label.
  final String? badgeLabel;

  /// Response type — drives the default badge label and accent palette.
  final AiResponseType responseType;

  /// Optional accent override applied to both the badge and avatar tile.
  final Color? accentColor;

  /// When `false`, hides the badge entirely.
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color accent = accentColor ?? _defaultAccent(responseType);
    final Color foreground = isDark ? Colors.white : const Color(0xFF1F2937);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact =
            constraints.maxWidth < AiResponseConstants.compactBreakpoint;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                leading ?? _AvatarTile(icon: icon, accent: accent),
                const SizedBox(width: AiResponseConstants.gapMd),
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
                            const SizedBox(width: AiResponseConstants.gapSm),
                            AiResponseBadge(
                              type: responseType,
                              label: badgeLabel,
                              accentColor: accentColor,
                            ),
                          ],
                        ],
                      ),
                      if (subtitle != null) ...<Widget>[
                        const SizedBox(height: AiResponseConstants.gapXxs),
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
                if (trailing != null) ...<Widget>[
                  const SizedBox(width: AiResponseConstants.gapSm),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: AiResponseConstants.gapMd),
            _AccentStrip(accent: accent),
          ],
        );
      },
    );
  }

  Color _defaultAccent(AiResponseType type) {
    switch (type) {
      case AiResponseType.generic:
      case AiResponseType.explanation:
      case AiResponseType.answer:
        return AiConstants.aiViolet;
      case AiResponseType.hint:
        return AiConstants.aiCyan;
      case AiResponseType.summary:
        return AiConstants.aiPurple;
      case AiResponseType.recommendation:
        return const Color(0xFF22C55E);
      case AiResponseType.analysis:
        return const Color(0xFF3B82F6);
    }
  }
}

/// Rounded avatar with a glowing background — the visual anchor of the
/// card. Mirrors the pattern used in [AiExplanationHeader._AvatarTile].
class _AvatarTile extends StatelessWidget {
  const _AvatarTile({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'AI avatar',
      child: Container(
        width: AiResponseConstants.headerAvatarSize,
        height: AiResponseConstants.headerAvatarSize,
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
          border: Border.all(
            color: accent.withValues(alpha: 0.4),
            width: AppSizes.borderThin,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: accent.withValues(
                alpha: AiResponseConstants.avatarGlowOpacity,
              ),
              blurRadius: 16,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: AiResponseConstants.headerIconSize,
          color: accent,
        ),
      ),
    );
  }
}

/// Thin accent strip painted under the header row. Visually anchors the
/// card to the AI brand. Tints to the resolved accent; uses the brand
/// gradient when the caller hasn't supplied a custom colour.
class _AccentStrip extends StatelessWidget {
  const _AccentStrip({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'AI accent',
      child: Container(
        height: AppSizes.borderThick,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              accent,
              AiConstants.aiCyan.withValues(alpha: 0.7),
              accent.withValues(alpha: 0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(AppSizes.borderThin),
        ),
      ),
    );
  }
}
