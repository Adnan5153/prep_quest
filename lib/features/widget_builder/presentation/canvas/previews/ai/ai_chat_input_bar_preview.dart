import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_constants.dart';
import '../../../../../../core/widgets/ai/chat_input_bar.dart';
import '../../../providers/widget_builder_provider.dart';

class AiChatInputBarPreview extends StatelessWidget {
  const AiChatInputBarPreview({super.key, required this.provider});

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
                  const _SectionLabel(text: 'Default — empty idle state'),
                  ChatInputBar(
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                      onMicrophoneTap: _noop,
                      onClear: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Typing — multi-line sample message',
                  ),
                  ChatInputBar(
                    controller: TextEditingController(text: _sampleMessage),
                    minLines: 2,
                    maxLines: 5,
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                      onMicrophoneTap: _noop,
                      onClear: _noop,
                      onChanged: _noopString,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Focused — input requests focus on mount',
                  ),
                  ChatInputBar(
                    autofocus: true,
                    actions: const ChatInputBarActions(onSend: _noopString),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Loading — sending in progress'),
                  ChatInputBar(
                    controller: TextEditingController(text: _sampleMessage),
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      isLoading: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Disabled — input cannot send'),
                  ChatInputBar(
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      canSend: false,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'With attachment — attachment button visible',
                  ),
                  ChatInputBar(
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                    ),
                    attachmentIcon: Icons.attachment_rounded,
                    attachmentTooltip: 'Attach file',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'With microphone — voice input affordance',
                  ),
                  ChatInputBar(
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onMicrophoneTap: _noop,
                    ),
                    microphoneTooltip: 'Hold to record',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Complete — all controls enabled'),
                  ChatInputBar(
                    controller: TextEditingController(text: _sampleMessage),
                    minLines: 1,
                    maxLines: 5,
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                      onMicrophoneTap: _noop,
                      onClear: _noop,
                      onChanged: _noopString,
                    ),
                    showCounter: true,
                    counter: const ChatInputBarCounter(maxLength: 280),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Recording — microphone active'),
                  ChatInputBar(
                    controller: TextEditingController(),
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onMicrophoneTap: _noop,
                      isRecording: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Outlined style — minimal flat'),
                  ChatInputBar(
                    style: ChatInputBarStyle.outlined,
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                      onMicrophoneTap: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Custom accent — brand orange'),
                  ChatInputBar(
                    accentColor: AppColors.accent,
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                      onMicrophoneTap: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Compact — single line, maxLines=1',
                  ),
                  ChatInputBar(
                    maxLines: 1,
                    actions: const ChatInputBarActions(onSend: _noopString),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Dark theme — automatic surface inversion',
                  ),
                  ChatInputBar(
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                      onMicrophoneTap: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Light theme — default surface'),
                  ChatInputBar(
                    style: ChatInputBarStyle.glass,
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                      onMicrophoneTap: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'AI violet accent — default theme'),
                  ChatInputBar(
                    accentColor: AiConstants.aiViolet,
                    actions: const ChatInputBarActions(
                      onSend: _noopString,
                      onAttachmentTap: _noop,
                      onMicrophoneTap: _noop,
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

const String _sampleMessage =
    'Explain Clean Architecture in Flutter with an example '
    'covering presentation, domain, and data layers.';

void _noop() {}
void _noopString(String _) {}
