import 'package:flutter/material.dart';

import 'chat_input_bar_constants.dart';

/// Internal send affordance used by [ChatInputBar].
///
/// Renders three visual states:
/// - **idle**: gradient capsule with paper-plane icon
/// - **loading**: gradient capsule with progress spinner
/// - **disabled**: muted flat surface with low-opacity icon
class ChatInputBarSendButton extends StatefulWidget {
  const ChatInputBarSendButton({
    super.key,
    required this.onTap,
    required this.enabled,
    required this.isLoading,
    required this.accent,
    required this.isDark,
    this.tooltip = 'Send',
    this.semanticLabel,
  });

  final VoidCallback? onTap;
  final bool enabled;
  final bool isLoading;
  final Color accent;
  final bool isDark;
  final String tooltip;
  final String? semanticLabel;

  @override
  State<ChatInputBarSendButton> createState() => _ChatInputBarSendButtonState();
}

class _ChatInputBarSendButtonState extends State<ChatInputBarSendButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ChatInputBarConstants.pressDuration,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _effectivelyEnabled =>
      widget.enabled && !widget.isLoading && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;

    final Color background = _effectivelyEnabled
        ? Colors.transparent
        : (isDark
              ? ChatInputBarConstants.darkField
              : ChatInputBarConstants.lightField);

    final Gradient? gradient = _effectivelyEnabled
        ? ChatInputBarConstants.sendGradient
        : null;

    final Color foreground = _effectivelyEnabled
        ? Colors.white
        : (isDark
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.30));

    final List<BoxShadow> shadows = _effectivelyEnabled
        ? ChatInputBarConstants.sendGlow(widget.accent)
        : <BoxShadow>[];

    final Widget core = AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double pressScale = 1.0 - (0.06 * _controller.value);
        return Transform.scale(scale: pressScale, child: child);
      },
      child: AnimatedContainer(
        duration: ChatInputBarConstants.transitionDuration,
        curve: Curves.easeOut,
        width: ChatInputBarConstants.sendSize,
        height: ChatInputBarConstants.sendSize,
        decoration: BoxDecoration(
          color: background,
          gradient: gradient,
          shape: BoxShape.circle,
          boxShadow: shadows,
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: ChatInputBarConstants.sendIconSize,
                  height: ChatInputBarConstants.sendIconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: ChatInputBarConstants.sendLoaderStroke,
                    valueColor: AlwaysStoppedAnimation<Color>(foreground),
                  ),
                )
              : Icon(
                  Icons.arrow_upward_rounded,
                  size: ChatInputBarConstants.sendIconSize,
                  color: foreground,
                ),
        ),
      ),
    );

    final Widget tappable = Listener(
      onPointerDown: (_) {
        if (_effectivelyEnabled) _controller.forward();
      },
      onPointerUp: (_) {
        if (_effectivelyEnabled) _controller.reverse();
      },
      onPointerCancel: (_) {
        if (_effectivelyEnabled) _controller.reverse();
      },
      child: MouseRegion(
        cursor: _effectivelyEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: _effectivelyEnabled ? widget.onTap : null,
          behavior: HitTestBehavior.opaque,
          child: core,
        ),
      ),
    );

    final Widget labelled = Semantics(
      button: true,
      enabled: _effectivelyEnabled,
      label: widget.semanticLabel ?? widget.tooltip,
      child: tappable,
    );

    return Tooltip(message: widget.tooltip, child: labelled);
  }
}
