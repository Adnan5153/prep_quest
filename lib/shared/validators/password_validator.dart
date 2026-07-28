/// Password-strength validator.
///
/// Enforces a minimum length plus at least one letter and one number
/// so registered users are nudged toward safer credentials without
/// being rejected for missing exotic character classes.
class PasswordValidator {
  const PasswordValidator._();

  static const int minLength = 8;
  static const int maxLength = 128;

  static bool meetsLength(String? input) {
    if (input == null) return false;
    final int length = input.length;
    return length >= minLength && length <= maxLength;
  }

  static bool hasLetter(String? input) {
    if (input == null) return false;
    return input.contains(RegExp(r'[A-Za-z]'));
  }

  static bool hasNumber(String? input) {
    if (input == null) return false;
    return input.contains(RegExp(r'[0-9]'));
  }

  static bool isValid(String? input) {
    return meetsLength(input) && hasLetter(input) && hasNumber(input);
  }

  static PasswordStrength strength(String? input) {
    if (input == null || input.isEmpty) return PasswordStrength.weak;
    int score = 0;
    if (input.length >= minLength) score++;
    if (input.length >= 12) score++;
    if (hasLetter(input) && hasNumber(input)) score++;
    if (input.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    if (score <= 1) return PasswordStrength.weak;
    if (score == 2) return PasswordStrength.fair;
    if (score == 3) return PasswordStrength.good;
    return PasswordStrength.strong;
  }
}

enum PasswordStrength { weak, fair, good, strong }