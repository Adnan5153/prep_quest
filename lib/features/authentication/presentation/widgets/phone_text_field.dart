import 'package:flutter/material.dart';

import 'auth_form_field.dart';

/// Phone-number field pre-filled with the `+880` country code and
/// tailored for the Bangladesh-only Prep Quest audience.
class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
    this.label = 'Phone number',
    this.hintText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AuthFormField(
      label: label,
      controller: controller,
      hintText: hintText ?? '01XXXXXXXXX',
      errorText: errorText,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      prefixIcon: Icons.phone_iphone,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      autofocus: autofocus,
      enabled: enabled,
    );
  }
}