/// Display-name validator.
///
/// Accepts letters (Latin and Bangla), digits, spaces, hyphens,
/// apostrophes, and dots. Bangla characters are explicitly allowed
/// because Prep Quest is a Bangla-first application.
class NameValidator {
  const NameValidator._();

  static const int minLength = 2;
  static const int maxLength = 50;

  static final RegExp _allowedPattern = RegExp(
    r"^[A-Za-z\u0980-\u09FF0-9][A-Za-z\u0980-\u09FF0-9 .'\-]*$",
  );

  static bool isValid(String? input) {
    if (input == null) return false;
    final String trimmed = input.trim();
    if (trimmed.length < minLength || trimmed.length > maxLength) return false;
    return _allowedPattern.hasMatch(trimmed);
  }
}
