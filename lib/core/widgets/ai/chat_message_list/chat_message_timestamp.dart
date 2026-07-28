import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../ai_constants.dart';
import 'chat_message_list_constants.dart';
import 'chat_message_list_models.dart';

/// Tiny pill that renders a timestamp + an optional status flag.
///
/// Renders nothing when both [timestamp] and [status] are absent. The
/// widget adapts to dark mode automatically.
class ChatMessageTimestamp extends StatelessWidget {
  const ChatMessageTimestamp({
    super.key,
    required this.timestamp,
    required this.status,
    required this.role,
  });

  final String? timestamp;
  final ChatMessageStatusFlag status;
  final ChatMessageRole role;

  bool get _hasStatus => status != ChatMessageStatusFlag.none;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color foreground = isDark ? Colors.white : Colors.black87;

    final String? statusLabel = _resolveStatusLabel();
    final Color? statusColor = _resolveStatusColor(isDark);

    final bool showTimestamp = timestamp != null && timestamp!.isNotEmpty;
    final bool showStatus = _hasStatus && statusLabel != null;

    if (!showTimestamp && !showStatus) {
      return const SizedBox.shrink();
    }

    final List<Widget> children = <Widget>[];

    if (showTimestamp) {
      children.add(
        Text(
          timestamp!,
          style: TextStyle(
            fontSize: ChatMessageListConstants.timestampFontSize,
            fontWeight: FontWeight.w600,
            color: foreground.withValues(alpha: 0.6),
            letterSpacing: 0.2,
          ),
        ),
      );
    }

    if (showStatus && showTimestamp) {
      children.add(const SizedBox(width: ChatMessageListConstants.gapXs));
    }

    if (showStatus) {
      children.add(
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: (statusColor ?? AiConstants.aiViolet).withValues(
              alpha: 0.16,
            ),
            borderRadius: BorderRadius.circular(
              ChatMessageListConstants.timestampRadius,
            ),
            border: Border.all(
              color: (statusColor ?? AiConstants.aiViolet).withValues(
                alpha: 0.4,
              ),
              width: 0.6,
            ),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              fontSize: ChatMessageListConstants.statusFontSize,
              fontWeight: FontWeight.w700,
              color: statusColor ?? AiConstants.aiViolet,
              letterSpacing: 0.3,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  String? _resolveStatusLabel() {
    switch (status) {
      case ChatMessageStatusFlag.none:
        return null;
      case ChatMessageStatusFlag.sent:
        return 'Sent';
      case ChatMessageStatusFlag.delivered:
        return 'Delivered';
      case ChatMessageStatusFlag.read:
        return 'Read';
      case ChatMessageStatusFlag.failed:
        return 'Failed';
    }
  }

  Color? _resolveStatusColor(bool isDark) {
    switch (status) {
      case ChatMessageStatusFlag.failed:
        return isDark ? AiConstants.aiRose : AiConstants.aiRose;
      case ChatMessageStatusFlag.read:
        return isDark ? AiConstants.aiCyan : AiConstants.aiIndigo;
      case ChatMessageStatusFlag.delivered:
      case ChatMessageStatusFlag.sent:
        return isDark ? AiConstants.aiPurple : AiConstants.aiViolet;
      case ChatMessageStatusFlag.none:
        return null;
    }
  }
}
