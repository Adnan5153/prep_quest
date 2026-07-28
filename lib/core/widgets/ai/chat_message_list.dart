/// Public re-exports for the AI chat message list subsystem.
///
/// Consumers can import this single file to access the public API:
///
/// ```dart
/// import 'package:prep_quest/core/widgets/ai/chat_message_list.dart';
/// ```
///
/// The list widget is exported as [ChatMessageList]; the supporting
/// models and types live alongside it so callers don't have to
/// memorise the internal file layout under `chat_message_list/`.
library;

export 'chat_message_list/chat_message_list_constants.dart';
export 'chat_message_list/chat_message_list_models.dart';

import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import 'chat_message_list/chat_message_empty.dart';
import 'chat_message_list/chat_message_error.dart';
import 'chat_message_list/chat_message_item.dart';
import 'chat_message_list/chat_message_list_constants.dart';
import 'chat_message_list/chat_message_list_models.dart';
import 'chat_message_list/chat_message_utils.dart';
import 'chat_message_list/chat_typing_indicator.dart';

/// A production-ready, responsive, and highly reusable chat message
/// list for the Prep Quest AI module family.
///
/// `ChatMessageList` is the universal conversation surface used across
/// AI Chat, AI Tutor, AI Assistant, AI Summary, AI Question Solver,
/// AI Interview, AI Roadmap and any future conversational AI feature.
///
/// The widget is presentation-only — it never fetches data, never
/// talks to repositories, and never invokes AI services. The caller
/// supplies a list of immutable [ChatMessage] objects and the bar
/// streams them through [AiChatBubble] derivatives with built-in
/// support for:
///
/// - Loading skeleton row + AI typing indicator
/// - Empty / Error placeholder surfaces (delegated to [AiEmptyState] /
///   [AiErrorState])
/// - Reverse-scrolling, auto-scroll on new content, and pull-to-refresh
/// - Lazy rendering through `ListView.builder` for thousands of messages
/// - Per-message actions: copy / share / speak / edit / retry /
///   regenerate / helpful / not-helpful
/// - Per-message status pill (sent / delivered / read / failed)
/// - Per-message avatar override
/// - Markdown-light rendering through [AiChatBubble.markdownContent]
/// - Selectable text and rich-text
/// - Entrance (fade + slide) animation
/// - Mobile / tablet / desktop responsive max-width
///
/// Pass [ChatMessageListState.empty] / `.loading` / `.error` to render
/// the respective placeholder surfaces. Otherwise the widget renders
/// [messages] in order.
class ChatMessageList extends StatefulWidget {
  const ChatMessageList({
    super.key,
    this.messages = const <ChatMessage>[],
    this.state = ChatMessageListState.ready,
    this.callbacks = const ChatMessageListCallbacks(),
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyDescription,
    this.emptyIcon = Icons.forum_rounded,
    this.emptyPrimaryAction,
    this.emptySecondaryAction,
    this.loadingItemCount = 3,
    this.errorTitle,
    this.errorSubtitle,
    this.errorDescription,
    this.errorIcon = Icons.cloud_off_rounded,
    this.errorPrimaryAction,
    this.errorCode,
    this.retryAttempts,
    this.accent,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation = 0,
    this.maxBubbleWidth,
    this.controller,
    this.reverse = true,
    this.physics,
    this.shrinkWrap = false,
    this.semanticLabel,
    this.enableAutoScroll = true,
    this.enablePullToRefresh = false,
  });

  // ---------------------------------------------------------------------------
  // Data
  // ---------------------------------------------------------------------------

  /// Conversation messages. Rendered in the order received.
  final List<ChatMessage> messages;

  /// Top-level state of the list. When non-`.ready`, the list area is
  /// replaced by the corresponding placeholder.
  final ChatMessageListState state;

  /// Aggregate callbacks for the list (retry load, retry message, …).
  final ChatMessageListCallbacks callbacks;

  // ---------------------------------------------------------------------------
  // Empty state overrides
  // ---------------------------------------------------------------------------

  final String? emptyTitle;
  final String? emptySubtitle;
  final String? emptyDescription;
  final IconData emptyIcon;
  final Widget? emptyPrimaryAction;
  final Widget? emptySecondaryAction;

  // ---------------------------------------------------------------------------
  // Loading state
  // ---------------------------------------------------------------------------

  /// Number of skeleton message rows rendered while the conversation is
  /// loading. Defaults to 3.
  final int loadingItemCount;

  // ---------------------------------------------------------------------------
  // Error state overrides
  // ---------------------------------------------------------------------------

  final String? errorTitle;
  final String? errorSubtitle;
  final String? errorDescription;
  final IconData errorIcon;
  final Widget? errorPrimaryAction;
  final String? errorCode;
  final int? retryAttempts;

  // ---------------------------------------------------------------------------
  // Visual
  // ---------------------------------------------------------------------------

  /// Optional accent override forwarded to child renderers.
  final Color? accent;

  /// Optional inner padding override. Defaults to
  /// [ChatMessageListConstants.listPadding].
  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double elevation;

  /// Optional cap on each bubble's max-width. When omitted, the list
  /// switches automatically between mobile / tablet / desktop caps.
  final double? maxBubbleWidth;

  // ---------------------------------------------------------------------------
  // Scroll
  // ---------------------------------------------------------------------------

  final ScrollController? controller;
  final bool reverse;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// When `true` (the default), the list auto-scrolls to the bottom
  /// whenever a new message appears AND the user is already at the
  /// bottom. Disabling this lets the user scroll up freely.
  final bool enableAutoScroll;

  /// When `true`, the list wraps its scroll view in a
  /// [RefreshIndicator] that fires [ChatMessageListCallbacks.onRefreshConversation].
  final bool enablePullToRefresh;

  // ---------------------------------------------------------------------------
  // Semantics
  // ---------------------------------------------------------------------------

  final String? semanticLabel;

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  late ScrollController _controller;
  late bool _ownsController;
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _ownsController = widget.controller == null;
    _previousMessageCount = widget.messages.length;
  }

  @override
  void didUpdateWidget(covariant ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int newCount = widget.messages.length;
    if (newCount > _previousMessageCount && widget.enableAutoScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (ChatMessageListUtils.isAtBottom(_controller)) {
          ChatMessageListUtils.scrollToBottom(_controller);
        }
      });
    }
    _previousMessageCount = newCount;
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  Color _resolveBorder(Color fallback) {
    return widget.borderColor ?? fallback;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Widget content = _buildContent(isDark);

    final Color resolvedBackground =
        widget.backgroundColor ??
        (isDark ? const Color(0xFF0B0F14) : const Color(0xFFFFFFFF));

    final Color border = _resolveBorder(
      isDark ? const Color(0xFF2A2D55) : const Color(0xFFE0E7FF),
    );

    return Semantics(
      container: true,
      label:
          widget.semanticLabel ?? ChatMessageListConstants.defaultSemanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: resolvedBackground,
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(ChatMessageListConstants.gapLg),
          border: Border.all(color: border, width: 1.0),
          boxShadow: widget.elevation > 0
              ? ChatMessageListConstants.listShadow(border, isDark)
              : null,
        ),
        child: ClipRRect(
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(ChatMessageListConstants.gapLg),
          child: content,
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    switch (widget.state) {
      case ChatMessageListState.empty:
        return _buildEmptyState();
      case ChatMessageListState.loading:
        return _buildLoadingState(isDark);
      case ChatMessageListState.error:
        return _buildErrorState();
      case ChatMessageListState.ready:
        return _buildReadyState(isDark);
    }
  }

  Widget _buildEmptyState() {
    return ChatMessageEmpty(
      title: widget.emptyTitle ?? 'Start a conversation',
      subtitle: widget.emptySubtitle ?? 'Ask PrepQuest AI anything to begin.',
      description: widget.emptyDescription,
      icon: widget.emptyIcon,
      primaryAction: widget.emptyPrimaryAction,
      secondaryAction: widget.emptySecondaryAction,
      accent: widget.accent,
    );
  }

  Widget _buildErrorState() {
    return ChatMessageError(
      title: widget.errorTitle ?? 'Something went wrong',
      subtitle: widget.errorSubtitle ?? 'We couldn’t load this conversation.',
      description:
          widget.errorDescription ?? 'Check your connection and try again.',
      icon: widget.errorIcon,
      primaryAction:
          widget.errorPrimaryAction ??
          (widget.callbacks.onRetryLoad == null
              ? null
              : _buildRetryAction(widget.callbacks.onRetryLoad!)),
      errorCode: widget.errorCode,
      retryAttempts: widget.retryAttempts,
      accent: widget.accent,
    );
  }

  Widget _buildRetryAction(VoidCallback onTap) {
    return Builder(
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        return FilledButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry'),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(bool isDark) {
    final int safeCount = widget.loadingItemCount.clamp(1, 10);
    final List<ChatMessage> skeletons = <ChatMessage>[
      for (int i = 0; i < safeCount; i++)
        ChatMessage(
          id: 'skeleton-$i',
          role: ChatMessageRole.ai,
          content: '',
          state: ChatMessageState.typing,
        ),
    ];
    return _buildScrollable(isDark, skeletons, includeTrailingTyping: false);
  }

  Widget _buildReadyState(bool isDark) {
    if (widget.messages.isEmpty) {
      return _buildEmptyState();
    }
    return _buildScrollable(
      isDark,
      widget.messages,
      includeTrailingTyping: _lastMessageRequestsTyping(),
    );
  }

  bool _lastMessageRequestsTyping() {
    if (widget.messages.isEmpty) return false;
    final ChatMessage last = widget.messages.last;
    if (last.state == ChatMessageState.typing) return false;
    if (last.role != ChatMessageRole.ai) return false;
    return last.state == ChatMessageState.streaming ||
        last.state == ChatMessageState.thinking;
  }

  Widget _buildScrollable(
    bool isDark,
    List<ChatMessage> messages, {
    required bool includeTrailingTyping,
  }) {
    final int itemCount = messages.length + (includeTrailingTyping ? 1 : 0);

    final ListView listView = ListView.builder(
      controller: _controller,
      reverse: widget.reverse,
      physics:
          widget.physics ??
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding ?? ChatMessageListConstants.listPadding,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        if (index >= messages.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[const ChatTypingIndicator()],
            ),
          );
        }
        final ChatMessage msg = messages[index];
        return ChatMessageItem(
          key: ValueKey<String>(msg.id),
          message: msg,
          isDark: isDark,
          maxWidth: widget.maxBubbleWidth,
        );
      },
    );

    if (!widget.enablePullToRefresh ||
        widget.callbacks.onRefreshConversation == null) {
      return listView;
    }

    return RefreshIndicator(
      onRefresh: () async {
        widget.callbacks.onRefreshConversation?.call();
      },
      child: listView,
    );
  }
}
