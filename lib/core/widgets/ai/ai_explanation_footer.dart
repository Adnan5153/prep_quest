import 'package:flutter/material.dart';

import 'ai_explanation_constants.dart';

/// Set of optional footer actions surfaced by the explanation card.
class AiExplanationFooterActions {
  const AiExplanationFooterActions({
    this.onCopy,
    this.onShare,
    this.onBookmark,
    this.onRegenerate,
    this.onReadAloud,
    this.onExpandToggle,
    this.isBookmarked = false,
    this.isExpanded = false,
    this.isReading = false,
    this.canExpand = false,
  });

  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onRegenerate;
  final VoidCallback? onReadAloud;
  final VoidCallback? onExpandToggle;
  final bool isBookmarked;
  final bool isExpanded;
  final bool isReading;
  final bool canExpand;

  bool get hasAny =>
      onCopy != null ||
      onShare != null ||
      onBookmark != null ||
      onRegenerate != null ||
      onReadAloud != null ||
      (canExpand && onExpandToggle != null);
}

/// Footer row for [AiExplanationCard].
///
/// Renders copy / share / bookmark / regenerate / read-aloud / expand actions
/// based on the callbacks supplied by the parent. Renders nothing when all
/// callbacks are null — keeps the card compact for read-only contexts.
class AiExplanationFooter extends StatelessWidget {
  const AiExplanationFooter({super.key, required this.actions});

  final AiExplanationFooterActions actions;

  @override
  Widget build(BuildContext context) {
    if (!actions.hasAny) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foreground = isDark ? Colors.white : const Color(0xFF1F2937);
    final muted = foreground.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.only(top: AiExplanationConstants.gapMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact =
              constraints.maxWidth < AiExplanationConstants.compactBreakpoint;

          final tiles = <Widget>[
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
                foreground: actions.isBookmarked
                    ? const Color(0xFFF59E0B)
                    : foreground,
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
                label: actions.isReading ? 'Stop' : 'Read',
                onTap: actions.onReadAloud!,
                foreground: actions.isReading
                    ? const Color(0xFF6366F1)
                    : foreground,
                muted: muted,
                emphasised: actions.isReading,
              ),
            if (actions.canExpand && actions.onExpandToggle != null)
              _ActionTile(
                icon: actions.isExpanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                label: actions.isExpanded ? 'Collapse' : 'Expand',
                onTap: actions.onExpandToggle!,
                foreground: foreground,
                muted: muted,
              ),
          ];

          if (isCompact) {
            return Wrap(
              spacing: AiExplanationConstants.gapXs,
              runSpacing: AiExplanationConstants.gapXs,
              children: tiles,
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) const SizedBox(width: AiExplanationConstants.gapXs),
                tiles[i],
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Single icon-button tile used inside [AiExplanationFooter].
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
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            AiExplanationConstants.pillRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AiExplanationConstants.gapSm,
              vertical: AiExplanationConstants.gapXs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: AiExplanationConstants.footerIconSize,
                  color: foreground,
                ),
                const SizedBox(width: AiExplanationConstants.gapXxs),
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
