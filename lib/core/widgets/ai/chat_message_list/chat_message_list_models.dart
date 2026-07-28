import 'package:flutter/widgets.dart';

import 'chat_message_list_constants.dart';

/// The role of a single message in the conversation.
///
/// Drives alignment, bubble colour and the default avatar.
enum ChatMessageRole {
  /// AI-authored message — left aligned, glass capsule.
  ai,

  /// User-authored message — right aligned, gradient capsule.
  user,

  /// System notification — centred, low-emphasis.
  system,
}

/// The current rendering state of a single message.
///
/// - [staticMessage] — finalized content, rendered as markdown-light or plain.
/// - [streaming] — content is being streamed in (typing dots + shimmer).
/// - [thinking] — the AI is acknowledging the prompt and working on it.
/// - [typing] — three-dot indicator with no content yet.
/// - [failed] — error state, surfaces a retry button.
enum ChatMessageState { staticMessage, streaming, thinking, typing, failed }

/// Immutable data describing a single chat message.
///
/// The widget is presentation-only — every interactive element on the
/// row (copy / share / retry / regenerate / speak / helpful / not-helpful)
/// is exposed as an optional callback in [actions]. The caller owns the
/// underlying state (textual content, retry logic, streaming tokens, …).
@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    this.state = ChatMessageState.staticMessage,
    this.status = ChatMessageStatusFlag.none,
    this.authorName,
    this.modelLabel,
    this.timestamp,
    this.avatar,
    this.actions = const ChatMessageActions(),
    this.markdown = true,
    this.selectable = true,
    this.verified = true,
    this.enterAnimation = true,
  });

  /// Stable identifier used by `ListView.builder` as the [Key]. Must be
  /// unique within the conversation.
  final String id;

  /// Conversation role. Drives alignment and bubble styling.
  final ChatMessageRole role;

  /// Message body. Rendered as markdown-light when [markdown] is `true`.
  final String content;

  /// Rendering state of this message.
  final ChatMessageState state;

  /// Delivery status surfaced next to the bubble (read receipt, retry, etc.).
  final ChatMessageStatusFlag status;

  /// Optional override for the author label.
  final String? authorName;

  /// Optional model badge ("GPT-4o", "Gemini", …).
  final String? modelLabel;

  /// Optional human-readable timestamp ("just now", "09:14", …).
  final String? timestamp;

  /// Optional avatar override. Wins over the default role-aware
  /// avatar when supplied.
  final Widget? avatar;

  /// Optional actions bundle (copy / share / retry / …).
  final ChatMessageActions actions;

  /// When `true`, [content] is rendered through the markdown-light parser.
  final bool markdown;

  /// When `true`, the body is selectable so the user can copy a substring
  /// via long-press. Defaults to `true` because chat is copy-heavy.
  final bool selectable;

  /// When `true` the AI message shows a verified tick next to the
  /// author name. Ignored for non-[ChatMessageRole.ai] messages.
  final bool verified;

  /// When `true` the message plays an enter (fade + slide) animation
  /// on first build. Default `true`.
  final bool enterAnimation;

  /// Creates a copy with overridden fields. Callers usually do not need
  /// to use this directly — the list controllers use it to drive state
  /// transitions (e.g. sent → delivered → read).
  ChatMessage copyWith({
    String? id,
    ChatMessageRole? role,
    String? content,
    ChatMessageState? state,
    ChatMessageStatusFlag? status,
    String? authorName,
    String? modelLabel,
    String? timestamp,
    Widget? avatar,
    ChatMessageActions? actions,
    bool? markdown,
    bool? selectable,
    bool? verified,
    bool? enterAnimation,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      state: state ?? this.state,
      status: status ?? this.status,
      authorName: authorName ?? this.authorName,
      modelLabel: modelLabel ?? this.modelLabel,
      timestamp: timestamp ?? this.timestamp,
      avatar: avatar ?? this.avatar,
      actions: actions ?? this.actions,
      markdown: markdown ?? this.markdown,
      selectable: selectable ?? this.selectable,
      verified: verified ?? this.verified,
      enterAnimation: enterAnimation ?? this.enterAnimation,
    );
  }
}

/// Set of optional footer actions surfaced by [ChatMessage].
///
/// Every callback defaults to `null`; the footer is collapsed (renders a
/// [SizedBox.shrink]) when none are supplied. State flags drive the
/// visual treatment of individual tiles (e.g. [helpfulSelected] switches
/// the thumbs-up icon between outlined / filled).
@immutable
class ChatMessageActions {
  const ChatMessageActions({
    this.onCopy,
    this.onShare,
    this.onSpeak,
    this.onRetry,
    this.onRegenerate,
    this.onEdit,
    this.onHelpful,
    this.onNotHelpful,
    this.helpfulSelected,
    this.notHelpfulSelected,
  });

  final ValueChanged<String>? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onSpeak;
  final VoidCallback? onRetry;
  final VoidCallback? onRegenerate;
  final VoidCallback? onEdit;
  final VoidCallback? onHelpful;
  final VoidCallback? onNotHelpful;
  final bool? helpfulSelected;
  final bool? notHelpfulSelected;

  bool get hasAny =>
      onCopy != null ||
      onShare != null ||
      onSpeak != null ||
      onRetry != null ||
      onRegenerate != null ||
      onEdit != null ||
      onHelpful != null ||
      onNotHelpful != null;
}

/// Aggregate callbacks for the whole conversation list.
///
/// All callbacks are optional. The list is presentation-only — it
/// never fetches data or invokes AI services.
@immutable
class ChatMessageListCallbacks {
  const ChatMessageListCallbacks({
    this.onRetryLoad,
    this.onRetryMessage,
    this.onClearConversation,
    this.onRefreshConversation,
  });

  /// Retry the initial conversation load (used by the error state).
  final VoidCallback? onRetryLoad;

  /// Retry a specific failed message (delegated to the row).
  final ValueChanged<String>? onRetryMessage;

  /// Clear the conversation (used by the empty / error states when
  /// appropriate).
  final VoidCallback? onClearConversation;

  /// Refresh the conversation (pull-to-refresh handler).
  final VoidCallback? onRefreshConversation;
}
