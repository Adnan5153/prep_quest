import 'package:flutter/material.dart';

import 'chat_input_bar_attachment_button.dart';
import 'chat_input_bar_constants.dart';
import 'chat_input_bar_microphone_button.dart';
import 'chat_input_bar_models.dart';
import 'chat_input_bar_send_button.dart';

/// Internal action row composer for [ChatInputBar].
///
/// Renders the leading optional widget (if supplied), the trailing action
/// buttons (attachment + microphone) and the primary send affordance in a
/// responsive row that collapses on compact widths.
class ChatInputBarActionsRow extends StatelessWidget {
  const ChatInputBarActionsRow({
    super.key,
    required this.actions,
    required this.accent,
    required this.isDark,
    required this.leading,
    required this.trailing,
    this.attachmentIcon,
    this.sendTooltip,
    this.attachmentTooltip,
    this.microphoneTooltip,
    this.sendSemanticLabel,
    this.attachmentSemanticLabel,
    this.microphoneSemanticLabel,
  });

  final ChatInputBarActions actions;
  final Color accent;
  final bool isDark;

  final Widget? leading;
  final Widget? trailing;

  final IconData? attachmentIcon;
  final String? sendTooltip;
  final String? attachmentTooltip;
  final String? microphoneTooltip;
  final String? sendSemanticLabel;
  final String? attachmentSemanticLabel;
  final String? microphoneSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (leading != null) {
      children.add(leading!);
      children.add(const SizedBox(width: ChatInputBarConstants.leadingGap));
    }

    if (actions.onAttachmentTap != null) {
      children.add(
        ChatInputBarAttachmentButton(
          onTap: actions.onAttachmentTap,
          enabled: actions.canSend && !actions.isLoading,
          isDark: isDark,
          icon: attachmentIcon ?? Icons.add_rounded,
          tooltip: attachmentTooltip ?? 'Attach',
          semanticLabel: attachmentSemanticLabel,
        ),
      );
      children.add(const SizedBox(width: ChatInputBarConstants.actionsGap));
    }

    if (actions.onMicrophoneTap != null) {
      children.add(
        ChatInputBarMicrophoneButton(
          onTap: actions.onMicrophoneTap,
          enabled: actions.canSend && !actions.isLoading,
          isRecording: actions.isRecording,
          isDark: isDark,
          tooltip: microphoneTooltip ?? 'Voice input',
          semanticLabel: microphoneSemanticLabel,
        ),
      );
      children.add(const SizedBox(width: ChatInputBarConstants.actionsGap));
    }

    if (actions.onSend != null) {
      children.add(
        ChatInputBarSendButton(
          onTap: () => actions.onSend!(''), // value resolved by parent
          enabled: actions.canSend,
          isLoading: actions.isLoading,
          accent: accent,
          isDark: isDark,
          tooltip: sendTooltip ?? 'Send',
          semanticLabel: sendSemanticLabel,
        ),
      );
    }

    if (trailing != null) {
      children.add(const SizedBox(width: ChatInputBarConstants.actionsGap));
      children.add(trailing!);
    }

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }
}
