import '../../../../shared/validators/email_validator.dart';
import '../../../../shared/validators/name_validator.dart';
import '../../../../shared/validators/password_validator.dart';
import '../../../../shared/validators/phone_validator.dart';

/// Auth-specific validation utilities used by the forms.
///
/// These wrap the shared validators and return `null` for valid input
/// or a user-facing error message otherwise. They never throw.
class AuthFormValidators {
  const AuthFormValidators._();

  static String? email(String? input) {
    if (input == null || input.trim().isEmpty) return 'Email is required.';
    if (!EmailValidator.isValid(input)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? input) {
    if (input == null || input.isEmpty) return 'Password is required.';
    if (!PasswordValidator.meetsLength(input)) {
      return 'Use at least 8 characters.';
    }
    if (!PasswordValidator.hasLetter(input)) {
      return 'Add at least one letter.';
    }
    if (!PasswordValidator.hasNumber(input)) {
      return 'Add at least one number.';
    }
    return null;
  }

  static String? confirmPassword(String? input, String original) {
    if (input == null || input.isEmpty) return 'Please re-enter your password.';
    if (input != original) return 'Passwords do not match.';
    return null;
  }

  static String? displayName(String? input) {
    if (input == null || input.trim().isEmpty) return 'Name is required.';
    if (!NameValidator.isValid(input)) {
      return 'Use 2–50 letters, spaces, or hyphens.';
    }
    return null;
  }

  static String? phone(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    if (!PhoneValidator.isValid(input)) {
      return 'Enter a valid Bangladeshi phone number.';
    }
    return null;
  }

  static String? district(String? input) {
    if (input == null) return null;
    final String trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length > 50) return 'District name is too long.';
    return null;
  }
}