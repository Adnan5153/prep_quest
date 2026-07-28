import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/app_sizes.dart';
import '../ai_constants.dart';
import 'chat_message_list_constants.dart';
import 'chat_message_list_models.dart';

/// Footer action row rendered below a message bubble.
///
/// Renders only the affordances that have a corresponding callback on
/// [ChatMessageActions]. Collapses to a [SizedBox.shrink] when nothing
/// is configured.
class ChatMessageActionsBar extends StatefulWidget {
  const ChatMessageActionsBar({
    super.key,
    required this.actions,
    required this.isDark,
    required this.payload,
    this.accent,
  });

  final ChatMessageActions actions;
  final bool isDark;
  final String payload;

  /// Optional accent override. Defaults to [AiConstants.aiViolet].
  final Color? accent;

  @override
  State<ChatMessageActionsBar> createState() => _ChatMessageActionsBarState();
}

class _ChatMessageActionsBarState extends State<ChatMessageActionsBar> {
  @override
  Widget build(BuildContext context) {
    if (!widget.actions.hasAny) {
      return const SizedBox.shrink();
    }

    final Color accent =
        widget.accent ??
        (widget.isDark ? AiConstants.aiViolet : AiConstants.aiIndigo);
    final Color foreground = widget.isDark ? Colors.white : Colors.black87;

    final List<_FooterAction> entries = <_FooterAction>[];

    if (widget.actions.onCopy != null) {
      entries.add(
        _FooterAction(
          icon: Icons.copy_rounded,
          label: 'Copy',
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: widget.payload));
            HapticFeedback.selectionClick();
            widget.actions.onCopy?.call(widget.payload);
          },
        ),
      );
    }

    if (widget.actions.onShare != null) {
      entries.add(
        _FooterAction(
          icon: Icons.ios_share_rounded,
          label: 'Share',
          onTap: () {
            HapticFeedback.selectionClick();
            widget.actions.onShare?.call();
          },
        ),
      );
    }

    if (widget.actions.onSpeak != null) {
      entries.add(
        _FooterAction(
          icon: Icons.volume_up_rounded,
          label: 'Speak',
          onTap: () {
            HapticFeedback.selectionClick();
            widget.actions.onSpeak?.call();
          },
        ),
      );
    }

    if (widget.actions.onEdit != null) {
      entries.add(
        _FooterAction(
          icon: Icons.edit_rounded,
          label: 'Edit',
          onTap: () {
            HapticFeedback.selectionClick();
            widget.actions.onEdit?.call();
          },
        ),
      );
    }

    if (widget.actions.onRetry != null) {
      entries.add(
        _FooterAction(
          icon: Icons.refresh_rounded,
          label: 'Retry',
          onTap: () {
            HapticFeedback.selectionClick();
            widget.actions.onRetry?.call();
          },
        ),
      );
    }

    if (widget.actions.onRegenerate != null) {
      entries.add(
        _FooterAction(
          icon: Icons.auto_awesome_rounded,
          label: 'Regenerate',
          onTap: () {
            HapticFeedback.selectionClick();
            widget.actions.onRegenerate?.call();
          },
        ),
      );
    }

    if (widget.actions.onHelpful != null ||
        widget.actions.onNotHelpful != null) {
      entries.add(
        _FooterAction(
          icon: Icons.thumb_up_rounded,
          label: 'Helpful',
          onTap: () {
            HapticFeedback.selectionClick();
            widget.actions.onHelpful?.call();
          },
          selected: widget.actions.helpfulSelected,
        ),
      );
      entries.add(
        _FooterAction(
          icon: Icons.thumb_down_rounded,
          label: 'Not helpful',
          onTap: () {
            HapticFeedback.selectionClick();
            widget.actions.onNotHelpful?.call();
          },
          selected: widget.actions.notHelpfulSelected,
        ),
      );
    }

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: ChatMessageListConstants.gapSm),
      child: Wrap(
        spacing: ChatMessageListConstants.gapXs,
        runSpacing: ChatMessageListConstants.gapXs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: entries
            .map(
              (_FooterAction action) => _FooterPill(
                action: action,
                foreground: foreground,
                accent: accent,
                isDark: widget.isDark,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FooterAction {
  const _FooterAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool? selected;
}

class _FooterPill extends StatefulWidget {
  const _FooterPill({
    required this.action,
    required this.foreground,
    required this.accent,
    required this.isDark,
  });

  final _FooterAction action;
  final Color foreground;
  final Color accent;
  final bool isDark;

  @override
  State<_FooterPill> createState() => _FooterPillState();
}

class _FooterPillState extends State<_FooterPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.action.selected ?? false;
    final Color color = widget.foreground;

    final double tintAlpha = isSelected
        ? 0.4
        : (_hovered
              ? ChatMessageListConstants.hoverActionOpacity
              : ChatMessageListConstants.restingActionOpacity);

    final double borderAlpha = isSelected
        ? ChatMessageListConstants.selectedBorderOpacity
        : (_hovered
              ? ChatMessageListConstants.hoverBorderOpacity
              : ChatMessageListConstants.restingBorderOpacity);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.action.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: ChatMessageListConstants.enterDuration,
          padding: const EdgeInsets.symmetric(
            horizontal: ChatMessageListConstants.gapSm,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.accent.withValues(alpha: tintAlpha)
                : color.withValues(alpha: tintAlpha),
            borderRadius: BorderRadius.circular(
              ChatMessageListConstants.actionRadius,
            ),
            border: Border.all(
              color: color.withValues(alpha: borderAlpha),
              width: 0.6,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                widget.action.icon,
                size: AppSizes.iconSm - 4,
                color: color.withValues(alpha: isSelected ? 1.0 : 0.85),
              ),
              const SizedBox(width: ChatMessageListConstants.gapXs),
              Text(
                widget.action.label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: isSelected ? 1.0 : 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
