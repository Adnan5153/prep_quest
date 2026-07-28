import 'package:flutter/material.dart';

import '../ai_constants.dart';
import '../ai_empty_state.dart';
import 'chat_message_list_constants.dart';

/// Empty-state composable rendered when the conversation has no
/// messages. Wraps the production [AiEmptyState] so the list surface
/// stays visually consistent with the rest of the AI module family.
class ChatMessageEmpty extends StatelessWidget {
  const ChatMessageEmpty({
    super.key,
    this.title = 'Start a conversation',
    this.subtitle = 'Ask PrepQuest AI anything to begin.',
    this.description,
    this.primaryAction,
    this.secondaryAction,
    this.icon = Icons.forum_rounded,
    this.accent,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final IconData icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final Color resolvedAccent = accent ?? AiConstants.aiViolet;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ChatMessageListConstants.gapXl),
      child: Center(
        child: AiEmptyState(
          title: title,
          subtitle: subtitle,
          description: description,
          icon: icon,
          primaryAction: primaryAction,
          secondaryAction: secondaryAction,
          accentColor: resolvedAccent,
        ),
      ),
    );
  }
}
