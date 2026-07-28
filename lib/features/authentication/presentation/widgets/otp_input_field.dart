import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';

/// Compact OTP entry row.
///
/// Each digit is rendered in its own focusable cell. The widget owns
/// its own [TextEditingController] list and keeps the visual state
/// in sync with the string [value] the parent passes back via
/// [onChanged].
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.length,
    required this.onChanged,
    this.onCompleted,
    this.hasError = false,
    this.autofocus = true,
    this.enabled = true,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final VoidCallback? onCompleted;
  final bool hasError;
  final bool autofocus;
  final bool enabled;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (final FocusNode node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _value => _controllers.map((c) => c.text).join();

  void _handleChange(int index, String raw) {
    final String value = raw.trim();
    if (value.isEmpty) {
      _controllers[index].text = '';
      _emit();
      return;
    }
    final String digit = value.substring(value.length - 1);
    _controllers[index].text = digit;
    _controllers[index].selection = TextSelection.collapsed(
      offset: digit.length,
    );
    if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }
    _emit();
  }

  void _handlePaste(String value) {
    final String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return;
    final int count = digits.length < widget.length
        ? digits.length
        : widget.length;
    for (int i = 0; i < count; i++) {
      _controllers[i].text = digits[i];
    }
    if (count < widget.length) {
      _focusNodes[count].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
    _emit();
  }

  void _emit() {
    final String value = _value;
    widget.onChanged(value);
    if (value.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color border = widget.hasError
        ? AppColors.error
        : theme.colorScheme.outlineVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(widget.length, (int index) {
        return SizedBox(
          width: AppSizes.iconLg + AppSpacing.lg,
          child: KeyboardListener(
            focusNode: FocusNode(skipTraversal: true),
            onKeyEvent: (KeyEvent event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
            child: Focus(
              onKeyEvent: (FocusNode node, KeyEvent event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    _controllers[index].text.isEmpty &&
                    index > 0) {
                  _focusNodes[index - 1].requestFocus();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                enabled: widget.enabled,
                autofocus: widget.autofocus && index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: index == 0 ? widget.length : 1,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(
                      color: widget.hasError
                          ? AppColors.error
                          : theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (String value) {
                  if (value.length > 1) {
                    _handlePaste(value);
                  } else {
                    _handleChange(index, value);
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}