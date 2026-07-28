import 'package:flutter/material.dart';

import 'ai_response_actions.dart';
import 'ai_response_constants.dart';
import 'ai_response_models.dart';

/// Footer row for [AiResponseCard].
///
/// Renders copy / share / regenerate / favorite / like / dislike /
/// expand actions based on the callbacks supplied by the parent.
/// Renders nothing when all callbacks are null — keeps the card compact
/// for read-only contexts.
class AiResponseFooter extends StatelessWidget {
  const AiResponseFooter({super.key, required this.actions});

  final AiResponseActions actions;

  @override
  Widget build(BuildContext context) {
    if (!actions.hasAny) {
      return const SizedBox.shrink();
    }

    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color foreground = isDark ? Colors.white : const Color(0xFF1F2937);
    final Color muted = foreground.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.only(top: AiResponseConstants.gapMd),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isCompact =
              constraints.maxWidth < AiResponseConstants.compactBreakpoint;

          final List<Widget> tiles = <Widget>[
            if (actions.onCopy != null)
              AiResponseActionTile(
                icon: Icons.content_copy_rounded,
                label: 'Copy',
                onTap: actions.onCopy!,
                foreground: foreground,
                muted: muted,
                pending: actions.pending == AiResponsePendingAction.copy,
              ),
            if (actions.onShare != null)
              AiResponseActionTile(
                icon: Icons.ios_share_rounded,
                label: 'Share',
                onTap: actions.onShare!,
                foreground: foreground,
                muted: muted,
                pending: actions.pending == AiResponsePendingAction.share,
              ),
            if (actions.onRegenerate != null)
              AiResponseActionTile(
                icon: Icons.refresh_rounded,
                label: 'Regenerate',
                onTap: actions.onRegenerate!,
                foreground: foreground,
                muted: muted,
                pending: actions.pending == AiResponsePendingAction.regenerate,
              ),
            if (actions.onFavorite != null)
              AiResponseActionTile(
                icon: actions.isFavorite
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                label: actions.isFavorite ? 'Saved' : 'Save',
                onTap: actions.onFavorite!,
                foreground: const Color(0xFFF59E0B),
                muted: muted,
                emphasised: actions.isFavorite,
              ),
            if (actions.onLike != null)
              AiResponseActionTile(
                icon: actions.isLiked
                    ? Icons.thumb_up_rounded
                    : Icons.thumb_up_outlined,
                label: 'Like',
                onTap: actions.onLike!,
                foreground: const Color(0xFF22C55E),
                muted: muted,
                emphasised: actions.isLiked,
                pending: actions.pending == AiResponsePendingAction.like,
              ),
            if (actions.onDislike != null)
              AiResponseActionTile(
                icon: actions.isDisliked
                    ? Icons.thumb_down_rounded
                    : Icons.thumb_down_outlined,
                label: 'Dislike',
                onTap: actions.onDislike!,
                foreground: const Color(0xFFEF4444),
                muted: muted,
                emphasised: actions.isDisliked,
                pending: actions.pending == AiResponsePendingAction.dislike,
              ),
            if (actions.canExpand && actions.onExpandToggle != null)
              AiResponseActionTile(
                icon: actions.isExpanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                label: actions.isExpanded ? 'Collapse' : 'Expand',
                onTap: actions.onExpandToggle!,
                foreground: theme.colorScheme.primary,
                muted: muted,
              ),
          ];

          if (isCompact) {
            return Wrap(
              spacing: AiResponseConstants.gapXs,
              runSpacing: AiResponseConstants.gapXs,
              children: tiles,
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              for (int i = 0; i < tiles.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: AiResponseConstants.gapXs),
                tiles[i],
              ],
            ],
          );
        },
      ),
    );
  }
}
