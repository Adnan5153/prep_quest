import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chat_input_bar_constants.dart';
import 'chat_input_bar_models.dart';

/// Internal multiline text field used by [ChatInputBar].
///
/// Wraps a stock [TextField] with:
/// - Auto-grow up to [maxLines]
/// - Enter-to-send semantics
/// - Shift+Enter for explicit newline
/// - Optional inline character counter
/// - Optional clear affordance
/// - Theme-aware decoration that pairs with the surrounding capsule
class ChatInputBarTextField extends StatelessWidget {
  const ChatInputBarTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.actions,
    required this.accent,
    required this.isDark,
    required this.hintText,
    required this.minLines,
    required this.maxLines,
    required this.showCounter,
    required this.counter,
    required this.showClearButton,
    required this.textStyle,
    required this.hintStyle,
    required this.fieldBackground,
    required this.fieldBorder,
    this.onSendRequested,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ChatInputBarActions actions;
  final Color accent;
  final bool isDark;
  final String hintText;
  final int minLines;
  final int maxLines;
  final bool showCounter;
  final ChatInputBarCounter? counter;
  final bool showClearButton;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color fieldBackground;
  final Color fieldBorder;
  final ValueChanged<String>? onSendRequested;

  bool get _hasText => controller != null && controller!.text.trim().isNotEmpty;

  bool get _canSend => actions.canSend && _hasText && !actions.isLoading;

  void _maybeSend() {
    if (!_canSend) return;
    final String value = controller?.text ?? '';
    actions.onSend?.call(value);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final bool isEnter =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter) return KeyEventResult.ignored;

    final bool shift = HardwareKeyboard.instance.isShiftPressed;
    if (shift) {
      // Shift+Enter — insert a real newline. The field handles the
      // actual insertion; we just let the event propagate.
      return KeyEventResult.ignored;
    }
    _maybeSend();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground = isDark ? Colors.white : Colors.black87;

    final TextStyle effectiveTextStyle =
        (textStyle ?? theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
          color: foreground,
          height: 1.4,
        );

    final TextStyle effectiveHintStyle =
        (hintStyle ?? theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
          color: foreground.withValues(alpha: 0.45),
          fontWeight: FontWeight.w500,
        );

    final int currentLength = controller?.text.length ?? 0;
    final int? maxLength = counter?.maxLength;
    final double warnAt = counter?.warnAt ?? 0.85;
    final bool overWarn =
        maxLength != null && currentLength >= (maxLength * warnAt).floor();

    final Color counterColor = overWarn
        ? theme.colorScheme.error
        : foreground.withValues(alpha: 0.55);

    return Focus(
      onKeyEvent: (FocusNode node, KeyEvent event) => _handleKey(node, event),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: actions.canSend,
        readOnly: actions.isLoading,
        minLines: minLines,
        maxLines: maxLines,
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        style: effectiveTextStyle,
        onChanged: (String value) {
          actions.onChanged?.call(value);
        },
        onSubmitted: (String value) {
          if (_canSend) {
            actions.onSend?.call(value);
          } else {
            actions.onSubmitted?.call(value);
          }
        },
        decoration: InputDecoration(
          isCollapsed: false,
          isDense: false,
          hintText: hintText,
          hintStyle: effectiveHintStyle,
          filled: true,
          fillColor: fieldBackground,
          contentPadding: ChatInputBarConstants.fieldPadding,
          border: _buildBorder(fieldBorder),
          enabledBorder: _buildBorder(fieldBorder),
          focusedBorder: _buildBorder(accent, width: 1.4),
          disabledBorder: _buildBorder(fieldBorder.withValues(alpha: 0.5)),
          suffixIcon: _buildSuffix(
            context,
            currentLength,
            maxLength,
            counterColor,
            foreground,
            theme,
          ),
          counterText: '',
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(ChatInputBarConstants.fieldRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget? _buildSuffix(
    BuildContext context,
    int currentLength,
    int? maxLength,
    Color counterColor,
    Color foreground,
    ThemeData theme,
  ) {
    final List<Widget> parts = <Widget>[];

    if (showCounter && maxLength != null) {
      parts.add(
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ChatInputBarConstants.gapXs,
          ),
          child: Text(
            '$currentLength/$maxLength',
            style: TextStyle(
              fontSize: ChatInputBarConstants.counterFontSize,
              fontWeight: FontWeight.w600,
              color: counterColor,
              letterSpacing: 0.2,
            ),
          ),
        ),
      );
    }

    if (showClearButton && _hasText && actions.onClear != null) {
      parts.add(
        _ClearButton(
          onTap: () {
            controller?.clear();
            actions.onClear?.call();
            actions.onChanged?.call('');
          },
          foreground: foreground.withValues(alpha: 0.7),
        ),
      );
    }

    if (parts.isEmpty) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: parts,
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onTap, required this.foreground});

  final VoidCallback onTap;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Clear input',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ChatInputBarConstants.gapXs,
              vertical: ChatInputBarConstants.gapXs,
            ),
            child: Icon(
              Icons.cancel_rounded,
              size: ChatInputBarConstants.actionIconSize - 2,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}
