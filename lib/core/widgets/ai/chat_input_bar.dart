/// Public re-exports for the AI chat input bar subsystem.
///
/// Consumers can import this single file to access the public API:
///
/// ```dart
/// import 'package:prep_quest/core/widgets/ai/chat_input_bar.dart';
/// ```
///
/// The bar itself is exported as [ChatInputBar]; the supporting models
/// and types live alongside it so callers don't have to memorise the
/// internal file layout under `chat_input_bar/`.
library;

export 'chat_input_bar/chat_input_bar_constants.dart';
export 'chat_input_bar/chat_input_bar_models.dart';

import 'package:flutter/material.dart';

import 'ai_constants.dart';
import 'chat_input_bar/chat_input_bar_actions_row.dart';
import 'chat_input_bar/chat_input_bar_constants.dart';
import 'chat_input_bar/chat_input_bar_models.dart';
import 'chat_input_bar/chat_input_bar_surface.dart';
import 'chat_input_bar/chat_input_bar_text_field.dart';

/// A production-ready, highly reusable chat input bar for the Prep Quest
/// AI module family.
///
/// `ChatInputBar` is the universal input surface used across AI Chat,
/// AI Tutor, AI Assistant, AI Summary, AI Question Solver, AI
/// Interview, AI Roadmap and any future conversational AI feature.
///
/// The widget is presentation-only — it never fetches data, never
/// talks to repositories, and never invokes AI services. Every
/// interactive element is parameterised through [actions]:
///
/// - [ChatInputBarActions.onSend] — primary send callback
/// - [ChatInputBarActions.onAttachmentTap] — optional attachment button
/// - [ChatInputBarActions.onMicrophoneTap] — optional microphone button
/// - [ChatInputBarActions.onClear] — optional clear affordance
/// - [ChatInputBarActions.onChanged] / [ChatInputBarActions.onSubmitted] —
///   live change and submit callbacks
///
/// Visual state is also driven from [actions]:
///
/// - [ChatInputBarActions.isLoading] — replaces the send icon with a
///   progress indicator
/// - [ChatInputBarActions.isRecording] — flips the microphone into
///   the recording treatment
/// - [ChatInputBarActions.canSend] — disables the entire bar
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    this.controller,
    this.focusNode,
    this.actions = const ChatInputBarActions(),
    this.style = ChatInputBarStyle.glass,
    this.hintText = 'Message Prep Quest AI…',
    this.minLines,
    this.maxLines,
    this.textInputAction = TextInputAction.send,
    this.leading,
    this.trailing,
    this.attachmentIcon,
    this.sendTooltip,
    this.attachmentTooltip,
    this.microphoneTooltip,
    this.sendSemanticLabel,
    this.attachmentSemanticLabel,
    this.microphoneSemanticLabel,
    this.semanticLabel,
    this.showCounter = false,
    this.counter,
    this.showClearButton = true,
    this.accentColor,
    this.backgroundColor,
    this.gradient,
    this.borderColor,
    this.borderRadius,
    this.elevation = 0,
    this.padding,
    this.margin,
    this.textStyle,
    this.hintStyle,
    this.autofocus = false,
  }) : assert(
         maxLines == null || minLines == null || maxLines >= minLines,
         'maxLines must be greater than or equal to minLines',
       );

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final ChatInputBarActions actions;
  final ChatInputBarStyle style;
  final String hintText;
  final int? minLines;
  final int? maxLines;
  final TextInputAction textInputAction;

  final Widget? leading;
  final Widget? trailing;
  final IconData? attachmentIcon;

  final String? sendTooltip;
  final String? attachmentTooltip;
  final String? microphoneTooltip;
  final String? sendSemanticLabel;
  final String? attachmentSemanticLabel;
  final String? microphoneSemanticLabel;
  final String? semanticLabel;

  final bool showCounter;
  final ChatInputBarCounter? counter;
  final bool showClearButton;

  final Color? accentColor;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  final bool autofocus;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late TextEditingController _internalController;
  late FocusNode _internalFocus;
  bool _ownsController = false;
  bool _ownsFocus = false;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  FocusNode get _focus => widget.focusNode ?? _internalFocus;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
      _ownsController = true;
    }
    if (widget.focusNode == null) {
      _internalFocus = FocusNode();
      _ownsFocus = true;
      if (widget.autofocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _internalFocus.requestFocus();
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.autofocus && widget.autofocus && _ownsFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _internalFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _internalController.dispose();
    }
    if (_ownsFocus) {
      _internalFocus.dispose();
    }
    super.dispose();
  }

  void _handleSend() {
    if (!widget.actions.canSend) return;
    if (widget.actions.isLoading) return;
    final String value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.actions.onSend?.call(value);
  }

  int get _resolvedMinLines =>
      widget.minLines ?? ChatInputBarConstants.defaultMinLines;

  int get _resolvedMaxLines =>
      widget.maxLines ?? ChatInputBarConstants.defaultMaxLines;

  EdgeInsetsGeometry _resolvePadding() {
    return widget.padding ?? ChatInputBarConstants.barPadding;
  }

  Color _resolveAccent(bool isDark) {
    if (widget.accentColor != null) return widget.accentColor!;
    return isDark ? AiConstants.aiViolet : AiConstants.aiIndigo;
  }

  Color _resolveFieldBackground(bool isDark) {
    return isDark
        ? ChatInputBarConstants.darkField
        : ChatInputBarConstants.lightField;
  }

  Color _resolveFieldBorder(bool isDark, Color accent) {
    return accent.withValues(alpha: isDark ? 0.40 : 0.35);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color accent = _resolveAccent(isDark);
    final Color fieldBg = _resolveFieldBackground(isDark);
    final Color fieldBorder = _resolveFieldBorder(isDark, accent);

    final Widget field = ChatInputBarTextField(
      controller: _controller,
      focusNode: _focus,
      actions: widget.actions,
      accent: accent,
      isDark: isDark,
      hintText: widget.hintText,
      minLines: _resolvedMinLines,
      maxLines: _resolvedMaxLines,
      showCounter: widget.showCounter,
      counter: widget.counter,
      showClearButton: widget.showClearButton,
      textStyle: widget.textStyle,
      hintStyle: widget.hintStyle,
      fieldBackground: fieldBg,
      fieldBorder: fieldBorder,
    );

    final Widget actionsRow = ChatInputBarActionsRow(
      actions: ChatInputBarActions(
        onSend: (String _) => _handleSend(),
        onAttachmentTap: widget.actions.onAttachmentTap,
        onMicrophoneTap: widget.actions.onMicrophoneTap,
        onClear: widget.actions.onClear,
        onChanged: widget.actions.onChanged,
        onSubmitted: widget.actions.onSubmitted,
        isLoading: widget.actions.isLoading,
        isRecording: widget.actions.isRecording,
        canSend: widget.actions.canSend,
      ),
      accent: accent,
      isDark: isDark,
      leading: widget.leading,
      trailing: widget.trailing,
      attachmentIcon: widget.attachmentIcon,
      sendTooltip: widget.sendTooltip,
      attachmentTooltip: widget.attachmentTooltip,
      microphoneTooltip: widget.microphoneTooltip,
      sendSemanticLabel: widget.sendSemanticLabel,
      attachmentSemanticLabel: widget.attachmentSemanticLabel,
      microphoneSemanticLabel: widget.microphoneSemanticLabel,
    );

    final Widget inputColumn = Expanded(
      child: Align(alignment: Alignment.centerLeft, child: field),
    );

    final Widget body = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final bool compact =
            width < ChatInputBarConstants.compactBreakpoint ||
            _resolvedMaxLines == 1;

        if (compact) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              inputColumn,
              const SizedBox(width: ChatInputBarConstants.fieldToActionsGap),
              actionsRow,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            inputColumn,
            const SizedBox(width: ChatInputBarConstants.fieldToActionsGap),
            actionsRow,
          ],
        );
      },
    );

    final Widget surface = ChatInputBarSurface(
      style: widget.style,
      isDark: isDark,
      padding: _resolvePadding(),
      backgroundColor: widget.backgroundColor,
      gradient: widget.gradient,
      borderColor: widget.borderColor,
      borderRadius: widget.borderRadius,
      elevation: widget.elevation,
      child: body,
    );

    final Widget constrained = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > ChatInputBarConstants.maxBarWidth) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ChatInputBarConstants.maxBarWidth,
              ),
              child: surface,
            ),
          );
        }
        return surface;
      },
    );

    final Widget content = Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: constrained,
    );

    return Semantics(
      container: true,
      label: widget.semanticLabel ?? 'Chat input',
      textField: true,
      child: content,
    );
  }
}
