import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/conversation.dart';
import '../extensions/ai_tutor_extensions.dart';

/// A reusable conversation bubble for the AI chat screen.
///
/// Renders a subtle glass surface, an avatar (auto/user icon), and the
/// message body. Aligns right for user messages, left for assistant
/// and system messages.
class AiTutorChatBubble extends StatelessWidget {
  const AiTutorChatBubble({
    super.key,
    required this.message,
    this.timestamp,
  });

  final ConversationMessage message;
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isUser = message.role == ConversationRole.user;
    final Color bubbleColor = isUser
        ? theme.colorScheme.primary.withValues(alpha: 0.16)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.85);
    final Color textColor = isUser
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;
    final AlignmentGeometry align =
        isUser ? Alignment.centerRight : Alignment.centerLeft;
    final BorderRadius radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.lg),
            topRight: Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(AppRadius.lg),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.lg),
            topRight: Radius.circular(AppRadius.lg),
            bottomRight: Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(4),
          );

    return Container(
      alignment: align,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (!isUser) _Avatar(role: message.role),
            if (!isUser) const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: radius,
                  border: Border.all(
                    color:
                        theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        height: 1.35,
                      ),
                    ),
                    if (timestamp != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _formatTime(timestamp!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: textColor.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isUser) const SizedBox(width: AppSpacing.sm),
            if (isUser) _Avatar(role: message.role),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    final String hh = value.hour.toString().padLeft(2, '0');
    final String mm = value.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.role});

  final ConversationRole role;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color bg = role == ConversationRole.user
        ? theme.colorScheme.primary.withValues(alpha: 0.22)
        : theme.colorScheme.tertiary.withValues(alpha: 0.22);
    final Color fg = role == ConversationRole.user
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onTertiaryContainer;
    return CircleAvatar(
      radius: 14,
      backgroundColor: bg,
      child: Icon(role.icon, size: 16, color: fg),
    );
  }
}