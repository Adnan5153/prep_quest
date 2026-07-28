import 'package:flutter/material.dart';

import '../ai_constants.dart';
import 'chat_message_list_constants.dart';

/// Three-dot typing indicator rendered while the AI is preparing or
/// streaming a response.
///
/// The dots bounce sequentially with a small stagger so the indicator
/// feels alive without being noisy.
class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({
    super.key,
    this.accent,
    this.foreground,
    this.label = 'AI is typing',
    this.dense = false,
  });

  /// Accent colour for the dots. Defaults to [AiConstants.aiViolet].
  final Color? accent;

  /// Foreground colour for the trailing label.
  final Color? foreground;

  /// Accessibility label for the indicator.
  final String label;

  /// When `true`, the indicator renders with smaller dot spacing — useful
  /// inside dense history surfaces.
  final bool dense;

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ChatMessageListConstants.typingDotDuration,
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color resolvedAccent =
        widget.accent ?? (isDark ? AiConstants.aiCyan : AiConstants.aiViolet);
    final Color resolvedForeground =
        widget.foreground ?? (isDark ? Colors.white : Colors.black87);

    final double dotSize = widget.dense ? 6.0 : 7.0;
    final double gap = widget.dense ? 3.0 : 4.0;

    return Semantics(
      label: widget.label,
      liveRegion: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            Padding(
              padding: EdgeInsets.only(right: i == 2 ? 0 : gap),
              child: _TypingDot(
                controller: _controller,
                accent: resolvedAccent,
                size: dotSize,
                delay: Duration(
                  milliseconds:
                      i *
                      ChatMessageListConstants.typingDotStagger.inMilliseconds,
                ),
              ),
            ),
          if (!widget.dense) ...<Widget>[
            const SizedBox(width: 8),
            Text(
              'AI is typing',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: resolvedForeground.withValues(alpha: 0.75),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  const _TypingDot({
    required this.controller,
    required this.accent,
    required this.size,
    required this.delay,
  });

  final AnimationController controller;
  final Color accent;
  final double size;
  final Duration delay;

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> {
  late double _phase;

  @override
  void initState() {
    super.initState();
    _phase =
        widget.delay.inMilliseconds /
        ChatMessageListConstants.typingDotDuration.inMilliseconds;
    widget.controller.addListener(_tick);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_tick);
    super.dispose();
  }

  void _tick() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double raw = widget.controller.value + _phase;
    final double wrapped = raw - raw.floor();
    final double t = Curves.easeInOut.transform(wrapped);
    final double clamped = t < 0.5 ? t * 2 : (1 - t) * 2;
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.accent.withValues(alpha: 0.55 + 0.45 * clamped),
      ),
    );
  }
}
