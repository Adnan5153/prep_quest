import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/widget_builder_provider.dart';

/// Customization controls for the [AiChatBubble] preview inside the
/// Widget Builder.
///
/// Mirrors the AI Button controls (role / style / state dropdowns + switches)
/// and adds the bubble-specific toggles (header / footer / verified badge),
/// text inputs (timestamp / model label) and a quick switch for streaming
/// preview vs. static response.
class AiChatBubbleControls extends StatelessWidget {
  const AiChatBubbleControls({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.xl),
        Text('AI Chat Bubble Options', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiBubbleRole,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Role'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'ai', child: Text('AI')),
            DropdownMenuItem<String>(value: 'user', child: Text('User')),
            DropdownMenuItem<String>(value: 'system', child: Text('System')),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiBubbleRole(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiBubbleStyle,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Style'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'glass', child: Text('Glass')),
            DropdownMenuItem<String>(
              value: 'gradient',
              child: Text('Gradient'),
            ),
            DropdownMenuItem<String>(value: 'flat', child: Text('Flat')),
            DropdownMenuItem<String>(
              value: 'outlined',
              child: Text('Outlined'),
            ),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiBubbleStyle(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          initialValue: provider.state.aiBubbleState,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'State'),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              value: 'staticResponse',
              child: Text('Static response'),
            ),
            DropdownMenuItem<String>(
              value: 'streaming',
              child: Text('Streaming'),
            ),
            DropdownMenuItem<String>(
              value: 'thinking',
              child: Text('Thinking'),
            ),
            DropdownMenuItem<String>(value: 'typing', child: Text('Typing')),
            DropdownMenuItem<String>(value: 'error', child: Text('Error')),
          ],
          onChanged: (value) {
            if (value != null) provider.controller.setAiBubbleState(value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          key: const ValueKey<String>('aiBubbleMessageField'),
          initialValue: provider.state.aiBubbleMessage,
          maxLines: 3,
          minLines: 1,
          decoration: const InputDecoration(
            labelText: 'Bubble message preview',
          ),
          onChanged: provider.controller.setAiBubbleMessage,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Use long markdown sample'),
          subtitle: const Text(
            'Renders a rich response with headings, lists, and code block.',
          ),
          value: provider.state.aiBubbleLongMessage,
          onChanged: provider.controller.setAiBubbleLongMessage,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show header'),
          value: provider.state.aiBubbleShowHeader,
          onChanged: provider.controller.setAiBubbleShowHeader,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show footer actions'),
          value: provider.state.aiBubbleShowFooter,
          onChanged: provider.controller.setAiBubbleShowFooter,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Verified badge'),
          value: provider.state.aiBubbleShowVerified,
          onChanged: provider.controller.setAiBubbleShowVerified,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.state.aiBubbleModelLabel,
          decoration: const InputDecoration(labelText: 'Model label'),
          onChanged: provider.controller.setAiBubbleModelLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          initialValue: provider.state.aiBubbleTimestamp,
          decoration: const InputDecoration(labelText: 'Timestamp'),
          onChanged: provider.controller.setAiBubbleTimestamp,
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Force streaming animation'),
          subtitle: const Text('Overrides state — useful for previews.'),
          value: provider.state.aiBubbleStreaming,
          onChanged: provider.controller.setAiBubbleStreaming,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Force typing indicator'),
          value: provider.state.aiBubbleTyping,
          onChanged: provider.controller.setAiBubbleTyping,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Force error state'),
          value: provider.state.aiBubbleError,
          onChanged: provider.controller.setAiBubbleError,
        ),
      ],
    );
  }
}
