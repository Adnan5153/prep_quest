import 'package:flutter/material.dart';

import '../ai_chat_bubble.dart';
import 'chat_message_actions.dart';
import 'chat_message_avatar.dart';
import 'chat_message_list_constants.dart';
import 'chat_message_list_models.dart';
import 'chat_message_timestamp.dart';
import 'chat_typing_indicator.dart';

/// Renders a single AI-authored message in a [ChatMessageList].
///
/// Composition: leading avatar + left-aligned glass bubble (markdown
/// or plain) + optional action row + status pill. Renders the
/// [ChatTypingIndicator] when [ChatMessageState.typing] is active.
class ChatAiMessage extends StatelessWidget {
  const ChatAiMessage({
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
    final String title =
        message.authorName ?? ChatMessageListConstants.defaultAiTitle;

    if (message.state == ChatMessageState.typing) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: ChatMessageListConstants.gapXs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ChatMessageAvatar(
              role: ChatMessageRole.ai,
              isAi: true,
              authorName: title,
              overrideWidget: message.avatar,
            ),
            const SizedBox(width: ChatMessageListConstants.avatarGap),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ChatMessageListConstants.gapLg,
                  vertical: ChatMessageListConstants.gapMd,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF15171F)
                      : const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(
                    ChatMessageListConstants.gapXl,
                  ),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                    width: 1,
                  ),
                ),
                child: const ChatTypingIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    final AiBubbleState bubbleState = _resolveBubbleState(message);
    final Widget bubble = AiChatBubble.ai(
      message: bubbleState == AiBubbleState.thinking ? '' : message.content,
      markdownContent: message.markdown ? message.content : null,
      header: AiBubbleHeaderData(
        title: title,
        modelLabel: message.modelLabel,
        timestamp: message.timestamp,
        verified: message.verified,
      ),
      state: bubbleState,
      maxWidth: maxWidth ?? ChatMessageListConstants.maxBubbleWidth,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: ChatMessageListConstants.gapXs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ChatMessageAvatar(
                role: ChatMessageRole.ai,
                isAi: true,
                authorName: title,
                overrideWidget: message.avatar,
              ),
              const SizedBox(width: ChatMessageListConstants.avatarGap),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        maxWidth ?? ChatMessageListConstants.maxBubbleWidth,
                  ),
                  child: bubble,
                ),
              ),
            ],
          ),
          if (message.actions.hasAny)
            Padding(
              padding: const EdgeInsets.only(
                top: ChatMessageListConstants.actionsGap,
                left:
                    ChatMessageListConstants.avatarSize +
                    ChatMessageListConstants.avatarGap,
              ),
              child: ChatMessageActionsBar(
                actions: message.actions,
                isDark: isDark,
                payload: message.content,
              ),
            ),
          if (message.timestamp != null ||
              message.status != ChatMessageStatusFlag.none)
            Padding(
              padding: const EdgeInsets.only(
                top: ChatMessageListConstants.gapXs,
                left:
                    ChatMessageListConstants.avatarSize +
                    ChatMessageListConstants.avatarGap,
              ),
              child: ChatMessageTimestamp(
                timestamp: message.timestamp,
                status: message.status,
                role: message.role,
              ),
            ),
        ],
      ),
    );
  }

  AiBubbleState _resolveBubbleState(ChatMessage message) {
    switch (message.state) {
      case ChatMessageState.staticMessage:
        return AiBubbleState.staticResponse;
      case ChatMessageState.streaming:
        return AiBubbleState.streaming;
      case ChatMessageState.thinking:
        return AiBubbleState.thinking;
      case ChatMessageState.typing:
        return AiBubbleState.typing;
      case ChatMessageState.failed:
        return AiBubbleState.error;
    }
  }
}
