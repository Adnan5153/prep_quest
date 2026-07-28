import 'package:flutter/material.dart';

import '../ai_constants.dart';
import '../ai_error_state.dart';
import 'chat_message_list_constants.dart';

/// Error-state composable rendered when the conversation failed to
/// load. Wraps the production [AiErrorState] for visual consistency.
class ChatMessageError extends StatelessWidget {
  const ChatMessageError({
    super.key,
    this.title = 'Something went wrong',
    this.subtitle = 'We couldn’t load this conversation.',
    this.description = 'Check your connection and try again.',
    this.icon = Icons.cloud_off_rounded,
    this.primaryAction,
    this.errorCode,
    this.retryAttempts,
    this.accent,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final IconData icon;
  final Widget? primaryAction;
  final String? errorCode;
  final int? retryAttempts;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final Color resolvedAccent = accent ?? AiConstants.aiRose;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ChatMessageListConstants.gapXl),
      child: Center(
        child: AiErrorState(
          title: title,
          subtitle: subtitle,
          description: description,
          icon: icon,
          primaryAction: primaryAction,
          errorCode: errorCode,
          retryAttempts: retryAttempts,
          accentColor: resolvedAccent,
        ),
      ),
    );
  }
}
