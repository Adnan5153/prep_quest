import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_chat_bubble.dart';
import '../../../providers/widget_builder_provider.dart';

/// Live preview for the [AiChatBubble] widget inside the Widget Builder.
class AiChatBubblePreview extends StatelessWidget {
  const AiChatBubblePreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  static const String _longMarkdown = '''
# Quantum Computing in 60 seconds
Here is a **concise summary** of how quantum computers differ from classical ones.

- Bits become *qubits* which can represent both 0 and 1 at the same time.
- Use `:spark:` quantum gates to manipulate probability amplitudes.
- Read the answer with a measurement that collapses to a single state.

## Key takeaways
1. Superposition lets you explore many possibilities in parallel.
2. Entanglement ties qubits together so changes ripple instantly.
3. Interference amplifies correct answers and cancels wrong ones.

```python
def bell_pair():
    q0, q1 = qubit(), qubit()
    H(q0)
    CNOT(q0, q1)
    return q0, q1
```

Visit [Prep Quest](https://prepquest.app) for a deeper lesson.
''';

  static const String _shortMarkdown =
      'Here is your tailored explanation with a neat summary, bullet points, and a quick code example.';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth < 480
            ? constraints.maxWidth
            : (constraints.maxWidth < 900 ? 600 : 760);

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AiChatBubble(
                    role: _resolveRole(provider.state.aiBubbleRole),
                    style: _resolveStyle(provider.state.aiBubbleStyle),
                    state: _resolveState(provider.state),
                    header: AiBubbleHeaderData(
                      title: 'Prep Quest AI',
                      timestamp: provider.state.aiBubbleTimestamp,
                      modelLabel: provider.state.aiBubbleModelLabel,
                      verified: provider.state.aiBubbleShowVerified,
                    ),
                    headerVisible: provider.state.aiBubbleShowHeader,
                    footerVisible: provider.state.aiBubbleShowFooter,
                    footer: AiBubbleFooterData(
                      onCopy: () {},
                      onShare: () {},
                      onSpeak: () {},
                      onRegenerate: () {},
                      onHelpful: () {},
                      onNotHelpful: () {},
                    ),
                    markdownContent: provider.state.aiBubbleLongMessage
                        ? _longMarkdown
                        : (provider.state.aiBubbleMessage.isEmpty
                              ? _shortMarkdown
                              : provider.state.aiBubbleMessage),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AiChatBubble.user(
                    message: 'Explain quantum computing like I am 12 :spark:',
                  ),
                  if (provider.state.aiBubbleRole == 'system')
                    const SizedBox(height: AppSpacing.lg),
                  if (provider.state.aiBubbleRole == 'system')
                    const AiChatBubble(
                      role: AiBubbleRole.system,
                      style: AiBubbleStyle.flat,
                      message:
                          'Tip — switch the role to AI to preview a tutor reply.',
                      headerVisible: false,
                      footerVisible: false,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AiBubbleRole _resolveRole(String role) {
    switch (role) {
      case 'user':
        return AiBubbleRole.user;
      case 'system':
        return AiBubbleRole.system;
      case 'ai':
      default:
        return AiBubbleRole.ai;
    }
  }

  AiBubbleStyle _resolveStyle(String style) {
    switch (style) {
      case 'gradient':
        return AiBubbleStyle.gradient;
      case 'flat':
        return AiBubbleStyle.flat;
      case 'outlined':
        return AiBubbleStyle.outlined;
      case 'glass':
      default:
        return AiBubbleStyle.glass;
    }
  }

  AiBubbleState _resolveState(WidgetBuilderState state) {
    if (state.aiBubbleTyping) return AiBubbleState.typing;
    if (state.aiBubbleError) return AiBubbleState.error;
    if (state.aiBubbleStreaming) return AiBubbleState.streaming;
    switch (state.aiBubbleState) {
      case 'streaming':
        return AiBubbleState.streaming;
      case 'thinking':
        return AiBubbleState.thinking;
      case 'typing':
        return AiBubbleState.typing;
      case 'error':
        return AiBubbleState.error;
      case 'staticResponse':
      default:
        return AiBubbleState.staticResponse;
    }
  }
}
