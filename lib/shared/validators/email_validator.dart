/// Lightweight email-format validator.
///
/// Uses a pragmatic regex that matches RFC 5322 in 99% of real-world
/// cases without trying to be perfectly exhaustive. For end-to-end
/// verification, the data layer still performs server-side validation.
class EmailValidator {
  const EmailValidator._();

  static final RegExp _pattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
    r'[a-zA-Z0-9]'
    r'(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
    r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  static bool isValid(String? input) {
    if (input == null) return false;
    final String trimmed = input.trim();
    if (trimmed.isEmpty || trimmed.length > 254) return false;
    return _pattern.hasMatch(trimmed);
  }
}