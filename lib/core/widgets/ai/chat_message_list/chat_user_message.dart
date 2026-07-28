import 'package:flutter/material.dart';

import '../ai_chat_bubble.dart';
import 'chat_message_actions.dart';
import 'chat_message_avatar.dart';
import 'chat_message_list_constants.dart';
import 'chat_message_list_models.dart';
import 'chat_message_timestamp.dart';

/// Renders a single user-authored message in a [ChatMessageList].
///
/// Composition: right-aligned gradient bubble + trailing avatar +
/// optional action row + status pill. Driven entirely by [message].
class ChatUserMessage extends StatelessWidget {
  const ChatUserMessage({
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
        message.authorName ?? ChatMessageListConstants.defaultUserTitle;

    final Widget bubble = AiChatBubble.user(
      message: message.content,
      markdownContent: message.markdown ? message.content : null,
      state: _resolveBubbleState(message),
      maxWidth: maxWidth ?? ChatMessageListConstants.maxBubbleWidth,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: ChatMessageListConstants.gapXs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        maxWidth ?? ChatMessageListConstants.maxBubbleWidth,
                  ),
                  child: bubble,
                ),
              ),
              const SizedBox(width: ChatMessageListConstants.avatarGap),
              ChatMessageAvatar(
                role: ChatMessageRole.user,
                isAi: false,
                authorName: title,
                overrideWidget: message.avatar,
              ),
            ],
          ),
          if (message.actions.hasAny)
            Padding(
              padding: const EdgeInsets.only(
                top: ChatMessageListConstants.actionsGap,
                right:
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
                right:
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
      case ChatMessageState.failed:
      case ChatMessageState.thinking:
      case ChatMessageState.typing:
      case ChatMessageState.streaming:
        return AiBubbleState.staticResponse;
    }
  }
}
