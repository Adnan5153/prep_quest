import 'package:flutter/material.dart';

import 'ai_summary_actions.dart';
import 'ai_summary_constants.dart';

class AiSummaryFooter extends StatelessWidget {
  const AiSummaryFooter({
    super.key,
    required this.actions,
    required this.accent,
    required this.canExpand,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  final AiSummaryActions actions;
  final Color accent;
  final bool canExpand;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color foreground = isDark ? Colors.white : const Color(0xFF1F2937);
    final Color muted = foreground.withValues(alpha: 0.55);

    final List<Widget> tiles = <Widget>[
      if (actions.onCopy != null)
        _ActionTile(
          icon: Icons.content_copy_rounded,
          label: 'Copy',
          onTap: actions.onCopy!,
          foreground: foreground,
          muted: muted,
        ),
      if (actions.onShare != null)
        _ActionTile(
          icon: Icons.ios_share_rounded,
          label: 'Share',
          onTap: actions.onShare!,
          foreground: foreground,
          muted: muted,
        ),
      if (actions.onBookmark != null)
        _ActionTile(
          icon: actions.isBookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          label: actions.isBookmarked ? 'Saved' : 'Save',
          onTap: actions.onBookmark!,
          foreground: actions.isBookmarked ? accent : foreground,
          muted: muted,
          emphasised: actions.isBookmarked,
        ),
      if (actions.onRegenerate != null)
        _ActionTile(
          icon: Icons.refresh_rounded,
          label: 'Regenerate',
          onTap: actions.onRegenerate!,
          foreground: foreground,
          muted: muted,
        ),
      if (actions.onReadAloud != null)
        _ActionTile(
          icon: actions.isReading
              ? Icons.stop_circle_rounded
              : Icons.volume_up_rounded,
          label: actions.isReading ? 'Stop' : 'Read aloud',
          onTap: actions.onReadAloud!,
          foreground: actions.isReading ? accent : foreground,
          muted: muted,
          emphasised: actions.isReading,
        ),
      if (actions.onLike != null)
        _ActionTile(
          icon: actions.isLiked
              ? Icons.thumb_up_rounded
              : Icons.thumb_up_outlined,
          label: 'Helpful',
          onTap: actions.onLike!,
          foreground: actions.isLiked ? accent : foreground,
          muted: muted,
          emphasised: actions.isLiked,
        ),
      if (actions.onDislike != null)
        _ActionTile(
          icon: actions.isDisliked
              ? Icons.thumb_down_rounded
              : Icons.thumb_down_outlined,
          label: 'Not helpful',
          onTap: actions.onDislike!,
          foreground: actions.isDisliked ? accent : foreground,
          muted: muted,
          emphasised: actions.isDisliked,
        ),
      if (canExpand && actions.onExpandToggle != null)
        _ActionTile(
          icon: isExpanded
              ? Icons.expand_less_rounded
              : Icons.expand_more_rounded,
          label: isExpanded ? 'Collapse' : 'Expand',
          onTap: onToggleExpand,
          foreground: foreground,
          muted: muted,
        ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact =
            constraints.maxWidth < AiSummaryConstants.compactBreakpoint;

        if (isCompact) {
          return Wrap(
            spacing: AiSummaryConstants.gapXs,
            runSpacing: AiSummaryConstants.gapXs,
            children: tiles,
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            for (int i = 0; i < tiles.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: AiSummaryConstants.gapXs),
              tiles[i],
            ],
          ],
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.foreground,
    required this.muted,
    this.emphasised = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color foreground;
  final Color muted;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AiSummaryConstants.pillRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AiSummaryConstants.gapSm,
              vertical: AiSummaryConstants.gapXs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  icon,
                  size: AiSummaryConstants.footerIconSize,
                  color: foreground,
                ),
                const SizedBox(width: AiSummaryConstants.gapXxs),
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: emphasised ? foreground : muted,
                    fontWeight: emphasised ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
