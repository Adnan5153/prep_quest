import 'package:flutter/material.dart';

import 'chat_input_bar_constants.dart';

/// Internal attachment affordance used by [ChatInputBar].
///
/// Tappable glass-pill button. Becomes a no-op while [enabled] is
/// `false`.
class ChatInputBarAttachmentButton extends StatefulWidget {
  const ChatInputBarAttachmentButton({
    super.key,
    required this.onTap,
    required this.enabled,
    required this.isDark,
    this.icon = Icons.add_rounded,
    this.tooltip = 'Attach',
    this.semanticLabel,
  });

  final VoidCallback? onTap;
  final bool enabled;
  final bool isDark;
  final IconData icon;
  final String tooltip;
  final String? semanticLabel;

  @override
  State<ChatInputBarAttachmentButton> createState() =>
      _ChatInputBarAttachmentButtonState();
}

class _ChatInputBarAttachmentButtonState
    extends State<ChatInputBarAttachmentButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;

    final Color restingBg = isDark
        ? ChatInputBarConstants.darkField
        : ChatInputBarConstants.lightField;

    final Color hoverBg = isDark
        ? ChatInputBarConstants.darkField.withValues(alpha: 0.85)
        : ChatInputBarConstants.lightField.withValues(alpha: 0.95);

    final Color border = isDark
        ? ChatInputBarConstants.darkBorder
        : ChatInputBarConstants.lightBorder;

    final Color foreground = widget.enabled
        ? (isDark ? Colors.white : Colors.black87)
        : (isDark
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.30));

    return Tooltip(
      message: widget.tooltip,
      child: Semantics(
        button: true,
        enabled: widget.enabled,
        label: widget.semanticLabel ?? widget.tooltip,
        child: MouseRegion(
          onEnter: (_) {
            if (widget.enabled) setState(() => _hovered = true);
          },
          onExit: (_) {
            if (widget.enabled) setState(() => _hovered = false);
          },
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: widget.enabled ? widget.onTap : null,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: ChatInputBarConstants.transitionDuration,
              curve: Curves.easeOut,
              width: ChatInputBarConstants.actionSize,
              height: ChatInputBarConstants.actionSize,
              decoration: BoxDecoration(
                color: _hovered ? hoverBg : restingBg,
                borderRadius: BorderRadius.circular(
                  ChatInputBarConstants.actionRadius,
                ),
                border: Border.all(color: border, width: 1.0),
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  size: ChatInputBarConstants.actionIconSize,
                  color: foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
