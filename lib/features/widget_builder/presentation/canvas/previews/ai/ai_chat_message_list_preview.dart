import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/chat_message_list.dart';
import '../../../providers/widget_builder_provider.dart';

class AiChatMessageListPreview extends StatelessWidget {
  const AiChatMessageListPreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth < 480
            ? constraints.maxWidth
            : (constraints.maxWidth < 900 ? 600 : 760);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _SectionLabel(text: 'Empty conversation'),
                  SizedBox(
                    height: 420,
                    child: ChatMessageList(
                      state: ChatMessageListState.empty,
                      emptyTitle: 'Start a conversation',
                      emptySubtitle: 'Ask PrepQuest AI anything to begin.',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'User messages — only right-aligned',
                  ),
                  SizedBox(
                    height: 380,
                    child: ChatMessageList(
                      messages: const <ChatMessage>[
                        ChatMessage(
                          id: 'user-1',
                          role: ChatMessageRole.user,
                          content: 'Can you summarise today\u2019s BCS prep?',
                        ),
                        ChatMessage(
                          id: 'user-2',
                          role: ChatMessageRole.user,
                          content:
                              'Focus on the Bangladesh Constitution and the '
                              'fundamental rights articles.',
                          status: ChatMessageStatusFlag.read,
                          timestamp: '09:14',
                        ),
                        ChatMessage(
                          id: 'user-3',
                          role: ChatMessageRole.user,
                          content: 'Add some model test questions too.',
                          status: ChatMessageStatusFlag.delivered,
                          timestamp: '09:16',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'AI response — only left-aligned'),
                  SizedBox(
                    height: 380,
                    child: ChatMessageList(
                      messages: const <ChatMessage>[
                        ChatMessage(
                          id: 'ai-1',
                          role: ChatMessageRole.ai,
                          authorName: 'Prep Quest AI',
                          modelLabel: 'GPT-4o',
                          content:
                              '# Clean Architecture in Flutter\n\n'
                              'Flutter Clean Architecture separates '
                              '**presentation**, **domain**, **repository**, '
                              'and **data** layers to improve scalability, '
                              'maintainability, and testability.\n\n'
                              '- Presentation: widgets and BLoC/Cubit\n'
                              '- Domain: pure Dart entities and use cases\n'
                              '- Repository: contracts + implementations\n'
                              '- Data: remote & local data sources',
                          timestamp: 'Just now',
                          actions: ChatMessageActions(
                            onCopy: _noopStringV,
                            onShare: _noop,
                            onRegenerate: _noop,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Conversation — user + AI'),
                  SizedBox(
                    height: 520,
                    child: ChatMessageList(messages: _defaultConversation),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Long conversation — performance check',
                  ),
                  SizedBox(
                    height: 540,
                    child: ChatMessageList(messages: _longConversation),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Typing indicator — AI is preparing',
                  ),
                  SizedBox(
                    height: 220,
                    child: ChatMessageList(
                      messages: const <ChatMessage>[
                        ChatMessage(
                          id: 'user-pre-typing',
                          role: ChatMessageRole.user,
                          content:
                              'Translate the previous paragraph into Bangla.',
                          timestamp: 'Now',
                        ),
                        ChatMessage(
                          id: 'typing-1',
                          role: ChatMessageRole.ai,
                          content: '',
                          state: ChatMessageState.typing,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Streaming response — content arriving live',
                  ),
                  SizedBox(
                    height: 360,
                    child: ChatMessageList(
                      messages: const <ChatMessage>[
                        ChatMessage(
                          id: 'stream-1',
                          role: ChatMessageRole.ai,
                          authorName: 'Prep Quest AI',
                          modelLabel: 'Claude Sonnet',
                          content:
                              'Clean Architecture keeps your code **layered** '
                              'and easy to reason about. The domain layer '
                              'remains pure Dart and never imports Flutter — '
                              'it only knows about entities and use cases.',
                          state: ChatMessageState.streaming,
                          timestamp: 'Streaming…',
                          actions: ChatMessageActions(onCopy: _noopStringV),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Loading — initial conversation fetch',
                  ),
                  SizedBox(
                    height: 420,
                    child: const ChatMessageList(
                      state: ChatMessageListState.loading,
                      loadingItemCount: 4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Error state — retry affordance'),
                  SizedBox(
                    height: 420,
                    child: ChatMessageList(
                      state: ChatMessageListState.error,
                      errorTitle: 'We couldn\u2019t load the conversation',
                      errorSubtitle: 'Check your connection and try again.',
                      errorCode: 'CHAT-401',
                      retryAttempts: 2,
                      callbacks: ChatMessageListCallbacks(onRetryLoad: _noop),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Dark theme — automatic adaptation',
                  ),
                  SizedBox(
                    height: 520,
                    child: ChatMessageList(messages: _defaultConversation),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Light theme — automatic adaptation',
                  ),
                  SizedBox(
                    height: 520,
                    child: ChatMessageList(messages: _defaultConversation),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Custom accent — brand orange + system notification',
                  ),
                  SizedBox(
                    height: 520,
                    child: ChatMessageList(
                      accent: AppColors.accent,
                      messages: const <ChatMessage>[
                        ChatMessage(
                          id: 'sys-1',
                          role: ChatMessageRole.system,
                          content:
                              'Conversation resumed \u2014 2 hours of history restored.',
                        ),
                        ..._defaultConversation,
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'With actions — copy / share / regenerate / feedback',
                  ),
                  SizedBox(
                    height: 560,
                    child: ChatMessageList(
                      messages: <ChatMessage>[
                        for (final ChatMessage m in _defaultConversation)
                          ChatMessage(
                            id: m.id,
                            role: m.role,
                            content: m.content,
                            authorName: m.authorName,
                            modelLabel: m.modelLabel,
                            timestamp: m.timestamp,
                            markdown: m.markdown,
                            selectable: m.selectable,
                            verified: m.verified,
                            state: m.state,
                            status: m.status,
                            actions: m.role == ChatMessageRole.ai
                                ? const ChatMessageActions(
                                    onCopy: _noopStringV,
                                    onShare: _noop,
                                    onSpeak: _noop,
                                    onRegenerate: _noop,
                                    onHelpful: _noop,
                                    onNotHelpful: _noop,
                                  )
                                : const ChatMessageActions(
                                    onCopy: _noopStringV,
                                    onEdit: _noop,
                                  ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static const List<ChatMessage> _defaultConversation = <ChatMessage>[
    ChatMessage(
      id: 'd-user-1',
      role: ChatMessageRole.user,
      content: 'Explain Flutter Clean Architecture.',
      status: ChatMessageStatusFlag.read,
      timestamp: '09:12',
    ),
    ChatMessage(
      id: 'd-ai-1',
      role: ChatMessageRole.ai,
      authorName: 'Prep Quest AI',
      modelLabel: 'GPT-4o',
      content:
          'Flutter Clean Architecture separates Presentation, Application, '
          'Domain, Repository, and Data layers to improve scalability, '
          'maintainability, testing, and code organization.\n\n'
          '- **Presentation** owns widgets and state management.\n'
          '- **Domain** holds pure-Dart entities and use cases.\n'
          '- **Repository** is the contract between domain and data.\n'
          '- **Data** implements remote and local sources.',
      timestamp: '09:12',
      actions: ChatMessageActions(
        onCopy: _noopStringV,
        onShare: _noop,
        onRegenerate: _noop,
      ),
    ),
    ChatMessage(
      id: 'd-user-2',
      role: ChatMessageRole.user,
      content: 'Can you provide a simple example?',
      status: ChatMessageStatusFlag.read,
      timestamp: '09:13',
    ),
    ChatMessage(
      id: 'd-ai-2',
      role: ChatMessageRole.ai,
      authorName: 'Prep Quest AI',
      modelLabel: 'GPT-4o',
      content:
          'Certainly. A **feature-first** architecture organizes code into '
          '`presentation/`, `application/`, `domain/`, and `data/` folders '
          'inside each feature — for example `features/auth/`.\n\n'
          'This keeps the project easy to maintain as it grows, and lets '
          'teams own features independently.',
      timestamp: '09:13',
      actions: ChatMessageActions(
        onCopy: _noopStringV,
        onShare: _noop,
        onRegenerate: _noop,
      ),
    ),
  ];

  static List<ChatMessage> get _longConversation {
    final List<String> userLines = <String>[
      'What is dependency injection?',
      'How does BLoC compare to Riverpod?',
      'When should I use freezed?',
      'Explain the repository pattern.',
      'How do I structure my tests?',
      'Why use go_router?',
      'How do I handle offline mode?',
      'What are the benefits of code generation?',
      'How do I migrate from Provider to Riverpod?',
      'Explain sealed classes in Dart 3.',
    ];
    final List<String> aiLines = <String>[
      'Dependency injection decouples how an object is created from how it is used.',
      'BLoC favors explicit events; Riverpod favors compile-time safety and lazy providers.',
      'Use freezed for immutable data classes with copyWith, equality, and pattern matching.',
      'The repository pattern hides the data source behind a domain-friendly interface.',
      'Group tests by layer — unit (domain), widget (presentation), integration (full app).',
      'go_router gives you declarative navigation with deep-link support.',
      'For offline mode, queue writes locally and sync when the connection returns.',
      'Code generation removes boilerplate and gives you compile-time guarantees.',
      'Start by mapping providers to NotifierProvider, then move SharedPreferences into a service.',
      'Sealed classes give you exhaustive switch expressions with no fallthrough bugs.',
    ];
    final List<ChatMessage> out = <ChatMessage>[];
    for (int i = 0; i < userLines.length; i++) {
      out.add(
        ChatMessage(
          id: 'l-u-$i',
          role: ChatMessageRole.user,
          content: userLines[i],
          status: ChatMessageStatusFlag.read,
          timestamp: 'Turn ${i + 1}',
        ),
      );
      out.add(
        ChatMessage(
          id: 'l-a-$i',
          role: ChatMessageRole.ai,
          authorName: 'Prep Quest AI',
          modelLabel: i.isEven ? 'GPT-4o' : 'Claude Sonnet',
          content: aiLines[i],
          timestamp: 'Turn ${i + 1}',
          actions: const ChatMessageActions(
            onCopy: _noopStringV,
            onRegenerate: _noop,
          ),
        ),
      );
    }
    return out;
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

void _noop() {}
void _noopStringV(String _) {}
