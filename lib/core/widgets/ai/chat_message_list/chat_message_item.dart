import 'package:flutter/material.dart';

import 'chat_ai_message.dart';
import 'chat_message_list_constants.dart';
import 'chat_message_list_models.dart';
import 'chat_user_message.dart';

/// Single row dispatcher used by [ChatMessageList]'s `ListView.builder`.
///
/// Selects the appropriate message renderer based on [message.role]:
/// - [ChatMessageRole.user] → [ChatUserMessage]
/// - [ChatMessageRole.ai] → [ChatAiMessage]
/// - [ChatMessageRole.system] → a centred system notification strip
///
/// All visual tokens come from [ChatMessageListConstants]; no hardcoded
/// values.
class ChatMessageItem extends StatelessWidget {
  const ChatMessageItem({
    super.key,
    required this.message,
    required this.isDark,
    this.maxWidth,
  });

  final ChatMessage message;
  final bool isDark;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final Widget body = _buildBody();
    if (!message.enterAnimation) return body;
    return _ChatMessageEnter(
      key: ValueKey<String>('enter-${message.id}'),
      child: body,
    );
  }

  Widget _buildBody() {
    switch (message.role) {
      case ChatMessageRole.user:
        return ChatUserMessage(
          message: message,
          isDark: isDark,
          maxWidth: maxWidth,
        );
      case ChatMessageRole.ai:
        return ChatAiMessage(
          message: message,
          isDark: isDark,
          maxWidth: maxWidth,
        );
      case ChatMessageRole.system:
        return _SystemNotification(message: message, isDark: isDark);
    }
  }
}

class _SystemNotification extends StatelessWidget {
  const _SystemNotification({required this.message, required this.isDark});

  final ChatMessage message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isDark ? Colors.white : Colors.black87;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: ChatMessageListConstants.gapSm,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ChatMessageListConstants.gapLg,
            vertical: ChatMessageListConstants.gapXs,
          ),
          decoration: BoxDecoration(
            color: foreground.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(
              ChatMessageListConstants.timestampRadius,
            ),
          ),
          child: Text(
            message.content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tiny enter (fade + slide-up) wrapper applied to each newly inserted
/// message. Renders no animation when `enterAnimation` is `false`.
class _ChatMessageEnter extends StatefulWidget {
  const _ChatMessageEnter({super.key, required this.child});

  final Widget child;

  @override
  State<_ChatMessageEnter> createState() => _ChatMessageEnterState();
}

class _ChatMessageEnterState extends State<_ChatMessageEnter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ChatMessageListConstants.enterDuration,
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.06),
    end: Offset.zero,
  ).animate(_fade);

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _fade.value.clamp(0.0, 1.0),
          child: Transform.translate(offset: _slide.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}
