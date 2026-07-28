import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import 'chat_input_bar_constants.dart';

/// Internal microphone affordance used by [ChatInputBar].
///
/// Renders two visual states:
/// - **idle**: glass pill with mic-outlined icon
/// - **recording**: tinted red glow with filled mic icon and pulsing ring
class ChatInputBarMicrophoneButton extends StatefulWidget {
  const ChatInputBarMicrophoneButton({
    super.key,
    required this.onTap,
    required this.enabled,
    required this.isRecording,
    required this.isDark,
    this.tooltip = 'Voice input',
    this.semanticLabel,
  });

  final VoidCallback? onTap;
  final bool enabled;
  final bool isRecording;
  final bool isDark;
  final String tooltip;
  final String? semanticLabel;

  @override
  State<ChatInputBarMicrophoneButton> createState() =>
      _ChatInputBarMicrophoneButtonState();
}

class _ChatInputBarMicrophoneButtonState
    extends State<ChatInputBarMicrophoneButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    if (widget.isRecording) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ChatInputBarMicrophoneButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse.stop();
        _pulse.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

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

    final Color recordingBg = AppColors.error.withValues(alpha: 0.14);
    final Color recordingBorder = AppColors.error.withValues(alpha: 0.55);
    final Color recordingFg = AppColors.error;

    final Color foreground = widget.enabled
        ? (widget.isRecording
              ? recordingFg
              : (isDark ? Colors.white : Colors.black87))
        : (isDark
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.30));

    final List<BoxShadow> shadows = widget.isRecording
        ? <BoxShadow>[
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: -2,
            ),
          ]
        : <BoxShadow>[];

    final Color resolvedBg = widget.isRecording
        ? recordingBg
        : (_hovered ? hoverBg : restingBg);
    final Color resolvedBorder = widget.isRecording ? recordingBorder : border;

    return Tooltip(
      message: widget.isRecording ? 'Stop recording' : widget.tooltip,
      child: Semantics(
        button: true,
        enabled: widget.enabled,
        toggled: widget.isRecording,
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
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      ChatInputBarConstants.actionRadius,
                    ),
                    boxShadow: shadows,
                  ),
                  child: child,
                );
              },
              child: AnimatedContainer(
                duration: ChatInputBarConstants.transitionDuration,
                curve: Curves.easeOut,
                width: ChatInputBarConstants.actionSize,
                height: ChatInputBarConstants.actionSize,
                decoration: BoxDecoration(
                  color: resolvedBg,
                  borderRadius: BorderRadius.circular(
                    ChatInputBarConstants.actionRadius,
                  ),
                  border: Border.all(color: resolvedBorder, width: 1.0),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: ChatInputBarConstants.transitionDuration,
                    child: Icon(
                      widget.isRecording
                          ? Icons.stop_rounded
                          : Icons.mic_none_rounded,
                      key: ValueKey<bool>(widget.isRecording),
                      size: ChatInputBarConstants.actionIconSize,
                      color: foreground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
