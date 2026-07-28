import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import 'auth_form_field.dart';

/// Password form field with a tap-to-toggle visibility eye.
class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autofocus = false,
    this.textInputAction,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final bool enabled;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return AuthFormField(
      label: widget.label,
      controller: widget.controller,
      hintText: widget.hintText,
      errorText: widget.errorText,
      obscureText: !_visible,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      prefixIcon: AppIcons.lockFilled,
      suffixIcon: IconButton(
        tooltip: _visible ? 'Hide password' : 'Show password',
        icon: Icon(
          _visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        ),
        onPressed: () => setState(() => _visible = !_visible),
      ),
    );
  }
}