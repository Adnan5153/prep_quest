import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../router.dart';
import '../constants/ai_tutor_strings.dart';
import '../providers/ai_tutor_provider.dart';
import '../widgets/ai_chat_bubble.dart';
import '../widgets/ai_typing_indicator.dart';

/// Free-form chat with the AI tutor. Each conversation is keyed by
/// id; opening a fresh chat uses the [aiNewChatControllerProvider].
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key, this.conversationId});

  final String? conversationId;

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.conversationId != null && !_loaded) {
        await ref
            .read(aiChatControllerProvider(widget.conversationId!).notifier)
            .load(widget.conversationId!);
        _loaded = true;
      }
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AiChatState state = _resolveState();
    return Scaffold(
      appBar: CustomAppBar(
        title: state.conversation.title.isEmpty
            ? AiTutorStrings.chatTitle
            : state.conversation.title,
        subtitle: AiTutorStrings.chatSubtitle,
        onLeadingPressed: () => context.canPop()
            ? context.pop()
            : context.goNamed(AppRoutes.aiTutor),
        actions: <Widget>[
          IconButton(
            tooltip: 'History',
            onPressed: () => context.goNamed(AppRoutes.aiTutorHistory),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: state.conversation.messages.isEmpty
                  ? _EmptyChat(theme: theme)
                  : ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: state.conversation.messages.length +
                          (state.status == AiTutorLoadStatus.loading ? 1 : 0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == state.conversation.messages.length) {
                          return const AiTutorTypingIndicator();
                        }
                        return AiTutorChatBubble(
                          message: state.conversation.messages[index],
                          timestamp:
                              state.conversation.messages[index].createdAt,
                        );
                      },
                    ),
            ),
            if (state.errorMessage != null)
              Container(
                width: double.infinity,
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.4),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  state.errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            _ChatInput(
              controller: _input,
              onSend: _handleSend,
              onAttach: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Attach coming soon'),
                  ),
                );
              },
              onVoice: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voice input coming soon'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AiChatState _resolveState() {
    if (widget.conversationId != null) {
      return ref.watch(
        aiChatControllerProvider(widget.conversationId!),
      );
    }
    return ref.watch(aiNewChatControllerProvider);
  }

  Future<void> _handleSend(String text) async {
    if (text.trim().isEmpty) return;
    if (widget.conversationId != null) {
      await ref
          .read(aiChatControllerProvider(widget.conversationId!).notifier)
          .sendUserMessage(text);
    } else {
      await ref.read(aiNewChatControllerProvider.notifier).sendUserMessage(text);
    }
    _input.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.auto_awesome_rounded,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AiTutorStrings.chatEmptyTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AiTutorStrings.chatEmptySubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.onSend,
    required this.onAttach,
    required this.onVoice,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final VoidCallback onAttach;
  final VoidCallback onVoice;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: AiTutorStrings.chatAttachTooltip,
            onPressed: onAttach,
            icon: const Icon(Icons.attach_file_rounded),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: AiTutorStrings.chatInputHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              onSubmitted: onSend,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            tooltip: AiTutorStrings.chatVoice,
            onPressed: onVoice,
            icon: const Icon(Icons.mic_none_rounded),
          ),
          const SizedBox(width: AppSpacing.xs),
          FilledButton(
            onPressed: () => onSend(controller.text),
            child: const Text(AiTutorStrings.chatSend),
          ),
        ],
      ),
    );
  }
}